---
name: flutter-mobile-ux-skill
description: Mobile UX fundamentals for Flutter — ergonomics, touch targets, gestures, haptics, motion choreography, and interaction patterns. Use this skill when building wireframes, prototypes, or interactive screens before visual design is applied.
---

# Flutter Mobile UX Skill

Use this skill to guide the creation of tactile, responsive, and ergonomic mobile interfaces. Focus is on **structure, interaction, and motion** — not colors, fonts, or branding. Your goal is to build screens that feel alive and physical under the user's thumb, even in wireframe form.

## 1. Mobile Ergonomics & Layout

Design for human thumbs and real devices, not abstract desktop windows.
- **The Thumb Zone**: Place primary navigation and critical actions at the bottom of the screen. Avoid top-left hamburger menus or critical buttons in the top header. Bottom sheets and floating panels out-perform top-heavy layouts.
- **Generous Touch Targets**: This is strictly enforced. Any tappable element must have a minimum hit area of **66x66 logical pixels** (prefer 72-80px for main actions). If an icon is visually small, use padding inside the `GestureDetector` or `InkWell` to expand the hit area.
- **Edge-to-Edge Canvas**: Content should bleed seamlessly under transparent system status and navigation bars. Only constrain interactive UI elements or readable text with `SafeArea`.
- **Responsive Geometry**: Use `LayoutBuilder` for all structural widget decisions based on available space. **NEVER use `MediaQuery` for layout decisions**, as it causes unnecessary rebuilds and breaks easily on keyboard popups. Limit `MediaQuery` only to reading system padding.

## 2. Kinesiology, Motion & Tactility

Mobile interfaces must feel physical, alive, and responsive to human touch. Static interfaces are unacceptable.
- **Haptic Feedback is Mandatory**: Digital touch must feel physical. 
  - `HapticFeedback.lightImpact()` for rapid selections or scrolling thresholds.
  - `HapticFeedback.mediumImpact()` for standard button presses and toggles.
  - `HapticFeedback.heavyImpact()` for destructive actions, major confirmations, or success states.
- **The "Squish" Effect**: Interactive elements must respond visually *immediately* upon touch. Buttons and cards should scale down slightly on press (e.g., `0.95` or `0.98`) and spring back on release. Never use a button that lacks a pressed state.
- **Choreography**: Elements should not just "appear". Use staggered reveals for lists (e.g., 50-100ms delays between items). Use smooth curves (`Curves.easeOutCubic` for entrances, `Curves.elasticOut` for playful bounces).
- **Transitions**: Treat the app as a spatial environment. Use `Hero` animations or custom page transitions to morph elements seamlessly between screens.

## 3. Action Hierarchy

Every screen (and every bottom sheet or dialog) must have exactly one visually dominant primary action.
- **One Clear CTA**: If no single primary action is obvious, reconsider the screen's purpose. The user must always know what the "next step" is.
- **Selected ≠ CTA**: Selected and active states on controls (chips, toggles, list items) are user feedback, not calls to action — they must be visually subordinate to the primary CTA. A selected chip must never look like a button.
- **Disabled CTA Stays Prominent**: When the primary CTA is disabled (e.g., form incomplete), it should still be the most visually prominent element — just dimmed. Never make it invisible.
- **Per-Surface Rule**: Bottom sheets and dialogs are their own hierarchy context. Each one gets its own single dominant action.

## 4. Form Inputs & Text Entry

Treat every `TextField` as a mobile interaction, not just a container for text. Configure `textCapitalization` intentionally whenever the field meaning is known; do not leave the default by accident.

- **Names & Proper Nouns**: Use `TextCapitalization.words` for first name, last name, full name, company name, city, and other proper-name fields.
- **Natural Language Inputs**: Use `TextCapitalization.sentences` for title, note, description, message, and other free-text inputs written as normal language.
- **Machine-Oriented Values**: Use `TextCapitalization.none` for email, username, URL, slug, password, code, and other case-sensitive or machine-oriented values.
- **All-Caps Codes Only**: Use `TextCapitalization.characters` only when the value is expected in all caps, such as promo codes or invite codes.
- **Full Input Setup**: Choose matching `keyboardType`, `textInputAction`, `autofillHints`, `autocorrect`, and `enableSuggestions` for each field instead of relying on defaults.

## Anti-Patterns

- **Default AppBar Without Intent**: Do not use the default `AppBar` with a solid color and centered text just because it is convenient. Prefer more intentional headers (like custom sliver headers, floating transparent headers, or typography-driven headers) when they improve the experience, but important: remember about handling **back navigation** when necessary.
- **Instant Snapping**: Reject any state change (like a tab switch or selection) that snaps instantly without a crossfade, size transition, or movement.
- **"Lorem Ipsum" & Placeholders**: Never leave generic placeholders. Generate realistic, context-appropriate mock data (names, dates, financial figures) that fits the design.
