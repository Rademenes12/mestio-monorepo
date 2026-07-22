# ZADANIE: 20_publish_screenshots_resize

## CEL
Przyciąć i przeskalować 5 obrazów wygenerowanych z poprzedniego kroku `19_publish-screenshots-ai-prompts.md` do technicznie poprawnych screenshotów dla iOS i Android.

Wejście:

```text
assets/images/store/screenshots/raw/01.*
assets/images/store/screenshots/raw/02.*
assets/images/store/screenshots/raw/03.*
assets/images/store/screenshots/raw/04.*
assets/images/store/screenshots/raw/05.*
```

Wyjście:

```text
assets/images/store/screenshots/ios/01.jpg ... 05.jpg      # 1242x2688, JPG, bez alpha
assets/images/store/screenshots/android/01.jpg ... 05.jpg  # 1080x1920, JPG, bez alpha
```

## KONTEKST
- Apple App Store Connect dla iPhone 6.5" akceptuje m.in. `1242 x 2688 px` oraz `1284 x 2778 px` w portrait. Używamy `1242 x 2688`, bo jest standardowym rozmiarem 6.5" i spełnia wymagania. Źródło: https://developer.apple.com/help/app-store-connect/reference/screenshot-specifications/
- Google Play dla screenshotów telefonu akceptuje JPEG albo 24-bit PNG bez alpha, min 320 px, max 3840 px, a dla rekomendowanych screenshotów portretowych oczekuje 9:16 i minimum 1080 x 1920. Używamy `1080 x 1920`. Źródło: https://support.google.com/googleplay/android-developer/answer/9866151
- Zapisujemy JPG, żeby automatycznie pozbyć się kanału alpha.
- Resize ma być **cover, bez stretcha**: zachowaj proporcje zawartości, przeskaluj tak, żeby obraz przykrył target, potem przytnij.
- Crop jest **top-preserving**: góra zostaje zachowana, bo tam zwykle jest headline. Jeśli trzeba ciąć szerokość, tniemy równo lewy i prawy bok. Jeśli trzeba ciąć wysokość, tniemy dół.

## KROKI DO WYKONANIA

1. Sprawdź, czy istnieje folder `assets/images/store/screenshots/raw/` i czy zawiera dokładnie nazwane pliki `01.*`, `02.*`, `03.*`, `04.*`, `05.*` (`.png`, `.jpg` lub `.jpeg`).

2. Jeśli brakuje któregoś numeru, zatrzymaj się i powiedz mi, żebym wrócił do kroku 19 i zapisał 5 obrazów jako `assets/images/store/screenshots/raw/01...05`.

3. Rozpoznaj system operacyjny:
   - macOS: `uname` zwraca `Darwin`.
   - Windows: użyj PowerShell.
   - Inny system: zatrzymaj się i zapytaj mnie o zgodę na alternatywną metodę. Nie instaluj automatycznie zewnętrznych narzędzi.

4. Na macOS uruchom:

   ```bash
   INPUT_DIR="assets/images/store/screenshots/raw"
   IOS_DIR="assets/images/store/screenshots/ios"
   ANDROID_DIR="assets/images/store/screenshots/android"

   mkdir -p "$IOS_DIR" "$ANDROID_DIR"

   process_dir() {
     local OUTPUT_DIR="$1"
     local TARGET_W="$2"
     local TARGET_H="$3"

    for BASENAME in 01 02 03 04 05; do
      local INPUT
      INPUT=$(find "$INPUT_DIR" -maxdepth 1 -type f \( -iname "$BASENAME.png" -o -iname "$BASENAME.jpg" -o -iname "$BASENAME.jpeg" \) | sort | head -n 1)
      if [ -z "$INPUT" ]; then
        echo "Missing $INPUT_DIR/$BASENAME.(png|jpg|jpeg)" >&2
        exit 1
      fi

      local EXT="${INPUT##*.}"
      local TMP="$OUTPUT_DIR/$BASENAME.tmp.$EXT"
      local OUT="$OUTPUT_DIR/$BASENAME.jpg"

       cp "$INPUT" "$TMP"

       local W H
       W=$(sips -g pixelWidth "$TMP" | awk '/pixelWidth/ {print $2}')
       H=$(sips -g pixelHeight "$TMP" | awk '/pixelHeight/ {print $2}')

       local SCALE_MODE
       SCALE_MODE=$(awk -v w="$W" -v h="$H" -v tw="$TARGET_W" -v th="$TARGET_H" 'BEGIN {
         sw = tw / w
         sh = th / h
         print (sw > sh) ? "width" : "height"
       }')

       if [ "$SCALE_MODE" = "width" ]; then
         sips --resampleWidth "$TARGET_W" "$TMP" >/dev/null
       else
         sips --resampleHeight "$TARGET_H" "$TMP" >/dev/null
       fi

       W=$(sips -g pixelWidth "$TMP" | awk '/pixelWidth/ {print $2}')
       H=$(sips -g pixelHeight "$TMP" | awk '/pixelHeight/ {print $2}')

       if [ "$W" -lt "$TARGET_W" ]; then
         sips --resampleWidth "$TARGET_W" "$TMP" >/dev/null
       fi
       if [ "$H" -lt "$TARGET_H" ]; then
         sips --resampleHeight "$TARGET_H" "$TMP" >/dev/null
       fi

       W=$(sips -g pixelWidth "$TMP" | awk '/pixelWidth/ {print $2}')
       H=$(sips -g pixelHeight "$TMP" | awk '/pixelHeight/ {print $2}')

       local OFFSET_X OFFSET_Y
       OFFSET_X=$(awk -v w="$W" -v tw="$TARGET_W" 'BEGIN { x = int((w - tw) / 2); print (x > 0) ? x : 0 }')
       OFFSET_Y=0

       sips --cropOffset "$OFFSET_Y" "$OFFSET_X" --cropToHeightWidth "$TARGET_H" "$TARGET_W" "$TMP" >/dev/null
       sips -s format jpeg -s formatOptions 100 "$TMP" --out "$OUT" >/dev/null
       rm "$TMP"

      echo "Created $OUT"
    done
  }

   process_dir "$IOS_DIR" 1242 2688
   process_dir "$ANDROID_DIR" 1080 1920

   echo ""
   echo "iOS:"
   sips -g pixelWidth -g pixelHeight "$IOS_DIR"/*.jpg
   echo ""
   echo "Android:"
   sips -g pixelWidth -g pixelHeight "$ANDROID_DIR"/*.jpg
   ```

5. Na Windows uruchom w PowerShell:

   ```powershell
   $InputDir = "assets/images/store/screenshots/raw"
   $IosDir = "assets/images/store/screenshots/ios"
   $AndroidDir = "assets/images/store/screenshots/android"

   New-Item -ItemType Directory -Force $IosDir | Out-Null
   New-Item -ItemType Directory -Force $AndroidDir | Out-Null

   Add-Type -AssemblyName System.Drawing

   function Export-StoreScreenshots {
     param(
       [string]$OutputDir,
       [int]$TargetW,
       [int]$TargetH
     )

    foreach ($index in 1..5) {
      $baseName = "{0:D2}" -f $index
      $file = Get-ChildItem $InputDir -File |
        Where-Object { $_.BaseName -eq $baseName -and $_.Extension -match '^\.(png|jpg|jpeg)$' } |
        Sort-Object Name |
        Select-Object -First 1

      if ($null -eq $file) {
        throw "Missing $InputDir/$baseName.(png|jpg|jpeg)"
      }

      $img = [System.Drawing.Image]::FromFile($file.FullName)

       $scale = [math]::Max($TargetW / $img.Width, $TargetH / $img.Height)
       $coverW = [float]($img.Width * $scale)
       $coverH = [float]($img.Height * $scale)
       $offsetX = [float](($TargetW - $coverW) / 2.0)
       $offsetY = [float]0

       $bmp = New-Object System.Drawing.Bitmap $TargetW, $TargetH, ([System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
       $g = [System.Drawing.Graphics]::FromImage($bmp)
       $g.Clear([System.Drawing.Color]::White)
       $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
       $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
       $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

       $destRect = New-Object System.Drawing.RectangleF $offsetX, $offsetY, $coverW, $coverH
       $g.DrawImage($img, $destRect)

      $name = "$baseName.jpg"
      $out = Join-Path $OutputDir $name
      $bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Jpeg)

       $g.Dispose()
       $bmp.Dispose()
       $img.Dispose()

      Write-Host "Created $out"
    }
  }

   Export-StoreScreenshots -OutputDir $IosDir -TargetW 1242 -TargetH 2688
   Export-StoreScreenshots -OutputDir $AndroidDir -TargetW 1080 -TargetH 1920

   Write-Host ""
   Write-Host "iOS:"
   Get-ChildItem $IosDir -Filter *.jpg | Sort-Object Name | ForEach-Object {
     $img = [System.Drawing.Image]::FromFile($_.FullName)
     Write-Host "$($_.Name): $($img.Width)x$($img.Height)"
     $img.Dispose()
   }

   Write-Host ""
   Write-Host "Android:"
   Get-ChildItem $AndroidDir -Filter *.jpg | Sort-Object Name | ForEach-Object {
     $img = [System.Drawing.Image]::FromFile($_.FullName)
     Write-Host "$($_.Name): $($img.Width)x$($img.Height)"
     $img.Dispose()
   }
   ```

6. Po wykonaniu komendy sprawdź, czy powstały:
   - `assets/images/store/screenshots/ios/01.jpg` ... `assets/images/store/screenshots/ios/05.jpg`,
   - `assets/images/store/screenshots/android/01.jpg` ... `assets/images/store/screenshots/android/05.jpg`.

7. Powiedz mi, że:
   - zestaw iOS z `assets/images/store/screenshots/ios/` wgramy w kroku 21 do App Store Connect,
   - zestaw Android z `assets/images/store/screenshots/android/` wgramy w kroku 22 do Google Play Console,
   - folder `assets/images/store/screenshots/` zawiera screenshotowe artefakty publikacyjne.

8. Sprawdź `git status --short assets/images/store/screenshots/`. Jeśli są tam zmiany, dodaj i zacommituj wszystkie screenshoty z tego folderu, także moje pliki z poprzednich kroków:

```bash
git add assets/images/store/screenshots/
git commit -m "chore(publish): add store screenshots"
```

## FINISH
Gdy oba foldery z JPG są gotowe, zasugeruj napisanie `next`. Kolejny krok: `21_publish-appstoreconnect-fill.md`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/07_publish/21_publish-appstoreconnect-fill.md`.
