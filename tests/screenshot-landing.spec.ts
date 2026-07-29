import { test, expect } from '@playwright/test';

test('screenshot landing page sections', async ({ page }) => {
  // Go to homepage
  await page.goto('http://localhost:3000', { waitUntil: 'networkidle', timeout: 60000 });
  await page.waitForTimeout(3000);

  // Full page screenshot
  await page.screenshot({ path: 'test-results/landing-full.png', fullPage: true });

  // Screenshot each section by scrolling
  const sections = [
    { name: 'hero', selector: 'section' },
  ];

  // Just take full page screenshot for now
  // Also take viewport screenshots at different scroll positions
  for (let i = 0; i < 12; i++) {
    await page.evaluate((idx) => window.scrollTo(0, idx * window.innerHeight * 0.8), i);
    await page.waitForTimeout(800);
    await page.screenshot({ path: `test-results/landing-scroll-${String(i).padStart(2, '0')}.png`, fullPage: false });
  }
});
