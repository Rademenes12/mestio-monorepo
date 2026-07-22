# 🗺️ Blueprint wdrożeniowy: Ujednolicenie UX/UI FixFlow

Ten dokument zawiera kompletny zestaw instrukcji i szablonów kodu potrzebnych do wdrożenia ujednoliconego wyglądu aplikacji **FixFlow** dla wszystkich czterech ról: **Mieszkańca**, **Zarządcy**, **Serwisanta** i **Ochrony**. 

Głównym celem jest doprowadzenie wszystkich ekranów i dolnych pasków nawigacyjnych do perfekcyjnej spójności wizualnej z zatwierdzonym ekranem **Mieszkaniec - Home (Pulpit)**.

---

## 🎨 1. Ogólne Wytyczne Stylistyczne (Design System)

Wszystkie ekrany w aplikacji must bezwzględnie przestrzegać poniższych reguł wizualnych, aby zachować spójność:

1. **Tło Aplikacji (Canvas Background):**
   * Każda strona (Scaffold) musi mieć jasnoszary kolor tła: `Color(0xFFF5F7FA)` (lub `AppColors.lightCanvas` z motywu).
   * **Brak ciemnych banerów** (np. w portalu technika czy panelu zarządcy).

2. **Karty Kontenerów (Cards):**
   * Tło: czysta biel `Color(0xFFFFFFFF)` (`AppColors.lightCard`).
   * Rogi: zaokrąglone o promieniu `16.0` (`AppColors.radiusCard`).
   * Ramka: bardzo subtelna szara linia `Border.all(color: Color(0x14000000))` (`AppColors.lightBorder`).
   * Cień: brak lub minimalny rozproszony (np. `BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8)`).

3. **Pasek Nawigacyjny (Bottom Navigation Bar):**
   * Tło: `#FFFFFF` (`AppColors.lightCard`), krawędź górna: cienka linia `#E4E7EC`.
   * Kolor aktywny (Selected): Royal Blue/Indigo `Color(0xFF5E5CE6)` (`AppColors.electricIndigo`).
   * Kolor nieaktywny: stonowany szary `Color(0xFF636375)` (`AppColors.lightTextSecondary`).
   * **Zabronione** są wszelkie dodatkowe kształty tła, kapsułek (Material 3 pill indicators) czy niestandardowe ikony. Etykiety pod ikonami muszą być zawsze widoczne.
   * Centralny, okrągły, wystający przycisk `+` (Royal Blue z białym plusem) jest wyświetlany **wyłącznie w układzie Mieszkańca i Ochrony** (zgodnie z logiką aplikacji).

4. **Typografia (Typography):**
   * Tytuły główne: duża, pogrubiona czcionka Inter, kolor `#1A1A24`.
   * Nagłówki sekcji: małe litery, pogrubione, z odstępem między literami (np. `letterSpacing: 1.1`, kolor `#636375`).

---

## 🎛️ 2. Zakładki i Nawigacja (Zgodnie z kodem)

Nie usuwamy żadnych tabów ani przycisków z kodu. Nawigacja dolna dla poszczególnych ról zostaje ujednolicona stylistycznie:

* **Zarządca / Administrator (6 tabów):**
  1. Home (Pulpit Zarządu/KPI)
  2. Komunikaty (Narzędzie wysyłania ogłoszeń)
  3. Osiedle (Struktura budynków i klatki)
  4. Mieszkańcy (Weryfikacja kont mieszkańców)
  5. Telefony (Spis kontaktów dla Zarządu)
  6. Profil (Dane admina + Trello)

* **Mieszkaniec & Ochrona (5 tabów):**
  1. Home (Status budynku / Obchód dla ochrony)
  2. Zgłoszenia (Lista zgłoszeń)
  3. **+** (Środkowy przycisk dodawania usterki)
  4. Telefony (Spis telefonów administracyjnych/awaryjnych)
  5. Profil (Dane profilowe, GPS, pomoc)

* **Serwisant (2 taby):**
  1. Home (Lista przypisanych zadań)
  2. Profil (Dane serwisanta, wylogowanie)

---

## 🛠️ 3. Podział `dashboard_screen.dart` na pliki

Wydziel poszczególne widoki tabów do dedykowanych plików w nowym katalogu `lib/features/reports/presentation/ui/tabs/`:

### A. Mieszkaniec - Home (`resident_home_tab.dart`)
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../profiles/models/resident_profile_model.dart';
import '../../../../announcements/presentation/cubit/announcements_cubit.dart';
import '../../../../announcements/models/announcement_model.dart';
import '../../../models/report_model.dart';
import '../widgets/report_tile_widget.dart';

class ResidentHomeTab extends StatelessWidget {
  final List<ReportModel> reports;
  final ResidentProfileModel? profile;
  final VoidCallback onNavigateToReports;
  final VoidCallback onNavigateToProfile;

  const ResidentHomeTab({
    super.key,
    required this.reports,
    required this.profile,
    required this.onNavigateToReports,
    required this.onNavigateToProfile,
  });

  @override
  Widget build(BuildContext context) {
    final activeReports = reports.where((r) => !r.resolvedStatus.isTerminal).toList();
    final l10n = context.l10n;

    return ListView(
      padding: const EdgeInsets.all(AppColors.spacingSm),
      children: [
        // Powitanie z inicjałami w avatarze
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.residentGreetingMorning, style: const TextStyle(color: AppColors.lightTextSecondary, fontSize: 14)),
                Text(profile?.name ?? l10n.residentGreetingFallback, style: const TextStyle(color: AppColors.lightTextPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            GestureDetector(
              onTap: onNavigateToProfile,
              child: CircleAvatar(
                backgroundColor: AppColors.electricIndigo.withOpacity(0.1),
                child: Text(
                  profile?.name.isNotEmpty == true ? profile!.name[0].toUpperCase() : '👤', 
                  style: const TextStyle(color: AppColors.electricIndigo, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppColors.spacingMd),

        // Status Budynku (Biała karta)
        Container(
          padding: const EdgeInsets.all(AppColors.spacingSm),
          decoration: BoxDecoration(
            color: AppColors.lightCard,
            borderRadius: BorderRadius.circular(AppColors.radiusCard),
            border: Border.all(color: AppColors.lightBorder),
          ),
          child: Row(
            children: [
              Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.neonMint, shape: BoxShape.circle)),
              const SizedBox(width: AppColors.spacingXs),
              Expanded(
                child: Text(
                  profile != null ? '${profile!.building} · ${profile!.footbridge} · ${profile!.apartment}' : l10n.residentAddressUnknown,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.lightTextPrimary),
                ),
              ),
              Text(l10n.residentSystemsOK, style: const TextStyle(fontSize: 10, color: AppColors.neonMint, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: AppColors.spacingSm),

        // Najnowszy komunikat
        BlocBuilder<AnnouncementsCubit, AnnouncementsState>(
          builder: (context, state) {
            if (state is! AnnouncementsLoaded || state.announcements.isEmpty) return const SizedBox.shrink();
            final latest = state.announcements.firstWhere((a) => !a.isExpired, orElse: () => state.announcements.first);
            return Card(
              color: AppColors.lightCard,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppColors.radiusCard),
                side: BorderSide(color: AppColors.crimsonCoral.withOpacity(0.2)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.campaign, color: AppColors.crimsonCoral),
                        const SizedBox(width: 8),
                        Text(latest.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.crimsonCoral)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(latest.content, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppColors.spacingMd),

        // Ostatnia aktywność / Aktywne Zgłoszenia
        Text(l10n.activeReportsHeader, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        if (activeReports.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(l10n.noActiveReports, style: const TextStyle(color: Colors.grey)),
            ),
          )
        else
          ...activeReports.take(2).map((report) => ReportTileWidget(report: report)),

        if (activeReports.length > 2)
          TextButton(
            onPressed: onNavigateToReports,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n.seeAllReports),
                const Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
      ],
    );
  }
}
```

### B. Zarządca - Home (`manager_home_tab.dart`)
```dart
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../models/report_model.dart';
import '../../../models/report_status.dart';
import '../widgets/manager_report_card.dart';

class ManagerHomeTab extends StatefulWidget {
  final List<ReportModel> reports;
  final String role;
  final String userName;

  const ManagerHomeTab({
    super.key,
    required this.reports,
    required this.role,
    required this.userName,
  });

  @override
  State<ManagerHomeTab> createState() => _ManagerHomeTabState();
}

class _ManagerHomeTabState extends State<ManagerHomeTab> {
  String? _statusFilter;

  @override
  Widget build(BuildContext context) {
    final newCount = widget.reports.where((r) => r.resolvedStatus == ReportStatus.newReport).length;
    final inProgressCount = widget.reports.where((r) => r.resolvedStatus == ReportStatus.inProgress).length;
    final closedCount = widget.reports.where((r) => r.resolvedStatus == ReportStatus.closed).length;
    final rejectedCount = widget.reports.where((r) => r.resolvedStatus == ReportStatus.rejected).length;

    final filtered = widget.reports.where((r) {
      if (_statusFilter == null) return true;
      if (_statusFilter == 'nowe') return r.resolvedStatus == ReportStatus.newReport;
      if (_statusFilter == 'w_realizacji') return r.resolvedStatus == ReportStatus.inProgress;
      if (_statusFilter == 'zamkniete') return r.resolvedStatus == ReportStatus.closed;
      if (_statusFilter == 'odrzucone') return r.resolvedStatus == ReportStatus.rejected;
      return true;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(AppColors.spacingSm),
      children: [
        // Spójny nagłówek z inicjałami (BEZ stockowego zdjęcia z Unsplash)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Zalogowany: ${widget.userName}', style: const TextStyle(color: AppColors.lightTextSecondary, fontSize: 12)),
                Text(widget.role == 'Administrator' ? 'Pulpit Administratora' : 'Pulpit Zarządu', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            CircleAvatar(
              backgroundColor: AppColors.electricIndigo.withOpacity(0.1),
              child: Text(
                widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : 'A', 
                style: const TextStyle(color: AppColors.electricIndigo, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppColors.spacingMd),

        // Kafelki KPI w ujednoliconym stylu kart
        Row(
          children: [
            Expanded(child: _buildKpiCard('NOWE', '$newCount', AppColors.cyanGlow, 'nowe')),
            const SizedBox(width: 8),
            Expanded(child: _buildKpiCard('W TOKU', '$inProgressCount', AppColors.amberAlert, 'w_realizacji')),
            const SizedBox(width: 8),
            Expanded(child: _buildKpiCard('ZAMKNIĘTE', '$closedCount', AppColors.neonMint, 'zamkniete')),
          ],
        ),
        const SizedBox(height: 8),
        _buildKpiWideCard('ODRZUCONE', '$rejectedCount', AppColors.crimsonCoral, 'odrzucone'),
        const SizedBox(height: AppColors.spacingMd),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('LISTA ZGŁOSZEŃ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.1, color: AppColors.lightTextSecondary)),
            if (_statusFilter != null)
              IconButton(
                icon: const Icon(Icons.clear_all, size: 18),
                onPressed: () => setState(() => _statusFilter = null),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (filtered.isEmpty)
          const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 32), child: Text('Brak zgłoszeń.')))
        else
          ...filtered.map((report) => ManagerReportCard(report: report, role: widget.role)),
      ],
    );
  }

  Widget _buildKpiCard(String label, String value, Color color, String filterKey) {
    final isSelected = _statusFilter == filterKey;
    return GestureDetector(
      onTap: () => setState(() => _statusFilter = isSelected ? null : filterKey),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppColors.radiusCard),
          border: Border.all(color: isSelected ? color : AppColors.lightBorder, width: isSelected ? 2 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.lightTextSecondary)),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiWideCard(String label, String value, Color color, String filterKey) {
    final isSelected = _statusFilter == filterKey;
    return GestureDetector(
      onTap: () => setState(() => _statusFilter = isSelected ? null : filterKey),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppColors.radiusCard),
          border: Border.all(color: isSelected ? color : AppColors.lightBorder, width: isSelected ? 2 : 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.lightTextSecondary)),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}
```

### C. Ochrona - Home (`security_dashboard_tab.dart`)
```dart
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class SecurityDashboardTab extends StatelessWidget {
  final VoidCallback onReportToManager;
  final VoidCallback onTriggerEmergency;
  final List<dynamic> securityReports;

  const SecurityDashboardTab({
    super.key,
    required this.onReportToManager,
    required this.onTriggerEmergency,
    required this.securityReports,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppColors.spacingSm),
      children: [
        // Nagłówek obchodu
        const Row(
          children: [
            Icon(Icons.security, color: AppColors.electricIndigo, size: 28),
            const SizedBox(width: 8),
            Text('Obchód: Ochrona', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: AppColors.spacingLg),

        // Szybkie zgłoszenie usterki (Biała karta spójna z resztą aplikacji)
        GestureDetector(
          onTap: onReportToManager,
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.lightCard,
              borderRadius: BorderRadius.circular(AppColors.radiusCard),
              border: Border.all(color: AppColors.lightBorder),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_late_outlined, size: 32, color: AppColors.electricIndigo),
                SizedBox(width: 12),
                Text('⚠️ ZGŁOŚ DLA ZARZĄDU', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.lightTextPrimary)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ALERT EMERGENCY (Duży, czerwony przycisk ostrzegawczy)
        GestureDetector(
          onTap: onTriggerEmergency,
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFF5252), Color(0xFFFF1744)]),
              borderRadius: BorderRadius.circular(AppColors.radiusCard),
              boxShadow: [
                BoxShadow(color: Colors.red.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.campaign, size: 36, color: Colors.white),
                SizedBox(width: 12),
                Text('🚨 ALARM DLA WSZYSTKICH', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppColors.spacingLg),

        // Historia ostatnich patroli
        const Text('OSTATNIE RAPORTY Z OBCHODÓW', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.lightTextSecondary)),
        const SizedBox(height: 8),
        if (securityReports.isEmpty)
          const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Text('Brak dzisiejszych wpisów.', style: TextStyle(color: Colors.grey))))
        else
          ...securityReports.map((report) => Card(
            color: AppColors.lightCard,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppColors.radiusCard),
              side: const BorderSide(color: AppColors.lightBorder),
            ),
            child: ListTile(
              leading: const Icon(Icons.lock_open, color: AppColors.electricIndigo),
              title: Text(report.title),
              subtitle: Text(report.timestampLabel),
            ),
          )),
      ],
    );
  }
}
```

---

## 🎛️ 4. Formularze i Ekrany Profilowe (Warunkowość)

### A. Warunkowy Stepper Rejestracji (`lock_screen.dart`)
Wprowadź stepper 3-krokowy, aby nie przytłaczać użytkownika formularzem złożonym z 9 pól. Pomiń krok lokalizacji dla personelu:

- **Krok 1 (Dane podstawowe + Rola):** Imię, E-mail, Telefon oraz Rola wybrana z Dropdowna (pobrana z kodu).
- **Krok 2 (Lokalizacja - WARUNKOWY):** Wybór Budynku, Klatki, Piętra i Mieszkania. Wyświetlany **wyłącznie** jeśli wybrana Rola to `Mieszkaniec`. Jeśli rola to Zarząd, Serwis lub Ochrona – ten krok jest całkowicie ignorowany.
- **Krok 3 (Weryfikacja osiedla):** Pole "Kod zaproszenia". Wymagane dla ról Zarządu, Serwisu i Ochrony.

### B. Ukrywanie Trello w Profilu (`dashboard_screen.dart`)
W sekcji budowania zakładki profilu zmodyfikuj kod tak, aby sekcja ustawień Trello (API Key, Token, List ID) renderowała się wyłącznie dla uprawnionego personelu:

```dart
// Wewnątrz metody _buildProfileTab
if (profile?.role == 'Zarząd' || profile?.role == 'Administrator') ...[
  const SizedBox(height: AppColors.spacingSm),
  _buildTrelloSettingsCard(theme), // Trello widoczne tylko dla Zarządu/Admina
],
```

Dzięki temu mieszkańcy, ochrona oraz technicy otrzymają czysty i czytelny panel profilowy, pozbawiony niepotrzebnych pól technicznych.

---

## 💅 5. Polerowanie Detali (UX Polish)

1. **Nazewnictwo statusów:** Ujednolic we wszystkich widokach polskie nazwy statusów:
   * **Nowe** (Niebieski badge)
   - **W realizacji** (Pomarańczowy badge)
   - **Zamknięte** (Zielony badge)
   - **Odrzucone** (Szary badge)
2. **Dynamiczny Avatar:** Zastąp stockowy link sieciowy do avatara w `dashboard_screen.dart` oraz `technician_portal_screen.dart` za pomocą:
   ```dart
   CircleAvatar(
     backgroundColor: AppColors.electricIndigo.withOpacity(0.1),
     child: Text(
       profile?.name.isNotEmpty == true ? profile!.name[0].toUpperCase() : '👤',
       style: const TextStyle(color: AppColors.electricIndigo, fontWeight: FontWeight.bold),
     ),
   )
   ```
3. **Lokalizacja językowa:** Wszystkie teksty w nowych widgetach umieść w pliku `lib/l10n/app_pl.arb` i wygeneruj na nowo powiązania:
   `flutter gen-l10n`
4. **Analiza statyczna:** Po wdrożeniu zmian uruchom analyzer i upewnij się, że nie ma ostrzeżeń:
   `flutter analyze`
