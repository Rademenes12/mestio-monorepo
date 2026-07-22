---
name: flutter-mobile-design-skill
description: Visual design system for Flutter mobile apps — color architecture, typography, dark mode, and aesthetic direction. Use this skill when applying visual identity, branding, and styling to existing wireframes or screens.
---

# Flutter Mobile Design Skill

Use this skill to guide the visual styling of mobile interfaces. Your goal is to escape the generic "Flutter slop" (default Material colors, predictable blue/purple palettes, lifeless surfaces) and act as a world-class product designer. Focus is on **aesthetics, color, typography, and theming** — the interaction structure should already be in place.

Do not rely on pre-existing templates. Invent a cohesive, custom visual language tailored perfectly to the app's context, and execute it with absolute precision.

Do not sacrifice usability for style. If a screen needs clear system affordances such as back navigation, title context, or standard top-level actions, keep them visible. A well-designed `AppBar` or custom header is better than a visually clever screen with broken navigation.

## 1. Aesthetic Independence & Design Thinking

Before writing UI code, invent a BOLD aesthetic direction based on the app's purpose.
- **Determine the mood**: Is it raw and utilitarian? Soft and organic? Hyper-futuristic? Minimal and editorial? 
- **Commit fully**: Once you choose a vibe, apply it consistently across borders, typography, shadows, and spacing. Half-measures create forgettable interfaces.
- **Avoid Defaults**: Never use a generic `Card` with default elevation and grey background. Build custom containers using spacing, subtle surface color shifts, or custom border treatments to separate content.

## 2. Typography & Extreme Hierarchy

Typography defines the app's personality and structure.
- **No System Defaults**: Never use the default Roboto or basic sans-serifs without character. Always integrate the `google_fonts` package (or explicitly defined custom fonts) to give the app a distinct voice.
- **Two-Font Rule**: Pair one highly distinctive display/header font with one highly readable, clean body font. 
- **Extreme Contrast**: Build hierarchy through massive leaps in scale and weight, not timid increments. Pair a `32px` weight `800` header with a `14px` weight `400` subtitle. If you squint, the most important element must still be obvious.

## 3. Dark Mode Mastery & Color Architecture

Build a complete, custom `ThemeData` from scratch.
- **No Pure Black**: Never use pure black (`#000000`) for dark mode backgrounds. Use rich, deep grays (e.g., `#121212` to `#1A1A1A`). 
- **Elevation via Lightness, Not Shadows**: In dark mode, do not use drop shadows to indicate depth. Instead, elevate surfaces by making them lighter (`#121212` base -> `#1E1E1E` card -> `#2C2C2C` floating element).
- **Text Contrast**: Use opacity for text hierarchy. Primary text at 87-100% opacity, secondary text at 60%, disabled at 38%.
- **Desaturated Accents**: Bright, saturated brand colors vibrate unpleasantly on dark backgrounds. Automatically desaturate or lighten accent colors by 10-20% when in dark mode to ensure comfortable readability.

## 4. Motion Styling

When the interaction choreography is already defined (what moves, when, why), refine how it looks:
- **Curve Selection**: Match animation curves to the brand feel — snappy and precise for professional apps, bouncy and elastic for playful ones.
- **Color Transitions**: Animate color shifts smoothly during state changes rather than instant swaps.
- **Branded Entrances**: Style staggered reveals and page transitions to match the visual language (e.g., fade + slide for editorial, scale + bounce for playful).

## 5. Visual Weight Ladder

Enforce a strict visual weight hierarchy across all interactive elements:
1. **Primary CTA** — full fill + brand color, largest touch target on screen.
2. **Secondary action** — outline or text-only, same or muted color.
3. **Selected/active state** — subtle tint or thin outline, never full fill in brand color. Chips and segmented controls are the most common offenders.
4. **Destructive action** — outline-red or text-red, never full-fill unless it is the sole action in a confirmation dialog.

## Anti-Patterns

- **"The AI Gradient"**: Reject predictable purple-to-pink or blue-to-purple linear gradients.
- **Default Material Surfaces**: Never rely on default Card elevation or grey backgrounds. Every surface should be intentionally styled.
- **Timid Typography**: If you can't tell the hierarchy by squinting, the contrast is insufficient.

Remember: The Flutter framework imposes no style — only generic defaults. Your job is to override every default intentionally, creating a high-end interface that feels expensive, thoughtful, and entirely unique to the user's prompt.
