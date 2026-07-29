import { chromium } from 'playwright';
import { spawn } from 'child_process';
import * as fs from 'fs';

async function main() {
  const envContent = fs.readFileSync('.env', 'utf-8');
  const viteUrl = envContent.match(/VITE_SUPABASE_URL=(.+)/)?.[1]?.trim();
  const viteKey = envContent.match(/VITE_SUPABASE_ANON_KEY=(.+)/)?.[1]?.trim();

  const env: Record<string, string> = {
    ...process.env as Record<string, string>,
    NEXT_PUBLIC_SUPABASE_URL: viteUrl || 'https://placeholder.supabase.co',
    NEXT_PUBLIC_SUPABASE_ANON_KEY: viteKey || 'placeholder-anon-key',
  };

  // Start production server on port 3999
  const server = spawn('npx', ['next', 'start', '--port', '3999'], {
    cwd: 'apps/web',
    stdio: ['pipe', 'pipe', 'pipe'],
    shell: true,
    env,
  });

  server.stdout?.on('data', (d: Buffer) => process.stdout.write(`[next] ${d}`));
  server.stderr?.on('data', (d: Buffer) => process.stderr.write(`[next] ${d}`));

  // Wait for server
  const maxWait = 60000;
  const start = Date.now();
  let ready = false;
  while (Date.now() - start < maxWait) {
    await new Promise((r) => setTimeout(r, 2000));
    try {
      const res = await fetch('http://localhost:3999');
      if (res.status === 200 || res.status === 404) {
        ready = true;
        break;
      }
    } catch {
      // not ready
    }
  }

  if (!ready) {
    console.error('Server did not respond in time');
    server.kill('SIGKILL');
    process.exit(1);
  }

  console.log('Server ready! Taking screenshots...');

  const browser = await chromium.launch({
    executablePath: '/usr/bin/chromium',
    args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-gpu', '--disable-dev-shm-usage'],
  });
  const page = await browser.newPage({ viewport: { width: 1440, height: 900 } });

  await page.goto('http://localhost:3999', { waitUntil: 'domcontentloaded', timeout: 30000 });
  await page.waitForTimeout(5000);

  // Take viewport screenshots at different scroll positions
  const totalHeight = await page.evaluate(() => document.body.scrollHeight);
  console.log(`Page height: ${totalHeight}px`);

  const stepCount = Math.ceil(totalHeight / 700);
  for (let i = 0; i < stepCount; i++) {
    const y = Math.min(i * 700, Math.max(0, totalHeight - 900));
    await page.evaluate((scrollY) => window.scrollTo(0, scrollY), y);
    await page.waitForTimeout(1500);
    try {
      await page.screenshot({
        path: `test-results/landing-${String(i).padStart(2, '0')}.png`,
        fullPage: false,
        timeout: 15000,
      });
      console.log(`Saved screenshot ${i + 1}/${stepCount} at scroll ${y}px`);
    } catch (e) {
      console.log(`Screenshot ${i} failed: ${e}`);
    }
  }

  await browser.close();
  server.kill('SIGTERM');
  console.log('Done!');
}

main().catch((e) => {
  console.error('Fatal:', e);
  process.exit(1);
});
