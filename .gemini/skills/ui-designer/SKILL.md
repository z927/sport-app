---
name: ui-designer
description: specialized workflow for designing and implementing modern Flutter UIs using Material 3, with a focus on sports app aesthetics inspired by Pallacanestro Varese. Use when the user requests UI improvements, new screens, or visual refinements.
---

# UI Designer (Flutter & Material 3)

This skill provides procedural guidance for creating high-fidelity, modern Flutter interfaces that align with the Pallacanestro Varese brand and Material 3 standards.

## Design Philosophy
- **Modern & "Alive"**: Use smooth transitions, interactive feedback (ink ripples, hover states), and subtle animations.
- **Material 3**: Leverage `ColorScheme.fromSeed`, `Card` with elevated/filled styles, and `NavigationBar` / `NavigationDrawer`.
- **Sports Aesthetics**: High contrast, bold typography for scores and headlines, and high-quality imagery.

## Visual Identity (Inspiration: Pallacanestro Varese)
- **Colors**: Primary Red (#E30613), White, and Light Grey backgrounds. Use gradients sparingly but effectively for headers.
- **Typography**: Bold, uppercase titles for "Live" or "Match" headers. Clean sans-serif for body text.
- **Components**: 
    - **Cards**: Use `Card` with `RoundedRectangleBorder` (radius 12-16) for news and match results.
    - **Live Indicators**: Use glowing or pulsing dots for live games.
    - **Badges**: Use `Badge` for status or unread news.

## Workflow

### 1. Research & Inspiration
- Analyze the current screen in `lib/screens/`.
- Reference `lib/config/team_config.dart` for theme colors and branding.
- Visualize the target layout based on `https://www.pallacanestrovarese.it/it/`.

### 2. Layout Planning
- Use `Scaffold` as the base.
- Implement `CustomScrollView` with `SliverAppBar` for rich header experiences (collapsing headers with images).
- Use `Padding` consistently (standard: 16.0).

### 3. Implementation Patterns
- **News Tiles**: `ListTile` or custom `Column` with an `AspectRatio` image at the top.
- **Game Cards**: A `Row` with Team Logo, Score (Bold), and Team Logo. Subtitle with match date/time.
- **Empty States**: Use `Center` with an `Icon` and descriptive text.

## Quality Standards
- **Responsiveness**: Ensure layouts work on different screen sizes using `LayoutBuilder` or `Flexible`/`Expanded`.
- **Accessibility**: Use `Semantics` and ensure sufficient color contrast.
- **Performance**: Use `const` constructors and avoid heavy logic in `build` methods.

## Example Request
"Refine the Home page to make it look more like the official website using Material 3."
- **Action**: Update `lib/screens/home_page.dart` using `SliverAppBar`, modern `Card` designs, and the team's primary red color.
