---
name: mobile-ai-assets-prompting
description: Generate production-grade, highly precise JSON prompts AI Image Generators to create exceptional mobile app assets (icons, UI elements, backgrounds, marketing). Avoids generic AI aesthetics through surgical JSON control.
license: Complete terms in LICENSE.txt
---

This skill guides the creation of distinctive, production-grade image generation prompts specifically optimized for top-tier AI models. It relies entirely on the **JSON Workflow** to enforce surgical precision, consistency, and flawless aesthetic execution for mobile application assets.

The user provides the context: an app concept, a specific asset needed (icon, UI element, background, marketing material), and general vibe. Your goal is to construct the ultimate JSON prompt that the user can directly feed into the image generators.

## Design Thinking & Asset Strategy

Before structuring the JSON prompt, understand the context and commit to a BOLD aesthetic direction:
- **Purpose & Context**: What is the app's core function? Who is the target audience? 
- **Asset Type**: Determine exact technical constraints based on the requested asset:
  - **App Icons**: Must be highly recognizable, scalable, and metaphor-driven. Avoid text. Focus on lighting, central framing, and a cohesive silhouette.
  - **UI Elements (Avatars, Badges, Illustrations, Items)**: **CRITICAL:** Must ALWAYS specify a `transparent` background. Needs to be easily extractable and visually flat or uniformly isometric to fit within UI layouts.
  - **Backgrounds**: Must provide adequate contrast for foreground UI elements. Focus on atmospheric depth, negative space, noise textures, or controlled abstraction. Avoid overly busy focal points.
  - **Marketing Materials (Banners, App Store Previews)**: High-fidelity, emotional impact. Requires complex lighting, clear subject matter, and cohesive branding.
- **Tone & Style**: Pick a distinct flavor: hyper-minimalist flat design, brutalist neomorphism, tactile claymorphism, ethereal frosted glass (glassmorphism), high-fashion editorial, tech-noir, or playful 3D. 
- **Differentiation**: Avoid the generic "AI 3D glossy" or "corporate vector" slop. Be intentional. Specify unique textures (e.g., film grain, matte finish, risograph, iridescent reflections).

## The JSON Prompting Framework

Modern models perform exceptionally well when natural language ambiguity is eliminated. You must output the prompt as a strict, highly detailed JSON object. 

When generating the prompt, use the following structure (adapt keys as necessary for the specific asset):

```json
{
  "asset_type": "[App Icon | UI Element | Background | Marketing]",
  "subject": "[Surgical, highly detailed description of the main object/scene]",
  "aesthetic_direction": "[Bold, specific style, e.g., 'Tactile matte claymorphism' or 'Swiss minimalist vector']",
  "lighting": "[Specific lighting conditions, e.g., 'Studio rim lighting, soft box from top left, 5500K']",
  "color_palette": "[Specific hex codes or color descriptions, e.g., 'Monochrome deep navy with neon coral accents']",
  "background": "[CRITICAL: Use 'transparent' for UI elements. Use specific environmental descriptors for others]",
  "camera_and_composition": "[Framing, perspective, e.g., 'Direct top-down orthographic', 'dead-center macro']",
  "texture_and_details": "[e.g., 'Subtle digital grain', 'smooth frosted glass edges', 'matte surface']",
  "avoid_elements": "[Strict negative prompts, e.g., 'text, letters, watermarks, busy backgrounds, glossy plastic finish']"
}
```

## AI Asset Guidelines

Focus on:
- **Transparency for UI**: When generating items, icons, or floating elements meant for inside the app, the `"background"` key MUST be explicitly set to `"transparent", "pure alpha channel", or "pure white background for easy magic-wand removal"`.
- **Lighting & Materials**: Elevate the design by specifying real-world materials and rendering engines (e.g., "anodized aluminum", "translucent silicone", "Octane render style raytracing", "soft ambient occlusion").
- **Consistency**: If the user asks for a set of UI elements, ensure the `"lighting"`, `"color_palette"`, and `"aesthetic_direction"` keys remain identical across all JSON prompts, changing only the `"subject"`.
- **Simplicity vs. Complexity**: Match the detail level to the asset. An app icon needs bold simplicity and a strong silhouette. A marketing background needs elaborate atmosphere and depth.

NEVER generate natural-language paragraph prompts. NEVER allow generic "sleek modern" descriptions. Do not default to predictable blue/purple gradients unless explicitly requested. 

**IMPORTANT**: Your output must include the design thinking process (briefly explaining the creative choices) followed by the raw JSON code block containing the prompt. The JSON should be so precise that an AI Image Generator will treat it as exact machine code for generating a masterpiece.
