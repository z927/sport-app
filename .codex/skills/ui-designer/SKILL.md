---
name: ui-designer
description: Use when designing or implementing modern Flutter UI improvements, new screens, or visual refinements using Material 3 for this sports app, especially Pallacanestro Varese-inspired layouts, colors, cards, live indicators, responsive behavior, and accessibility.
metadata:
  short-description: Flutter Material 3 sports UI workflow
---

# UI Designer (Flutter & Material 3)

This skill provides procedural guidance for creating high-fidelity, modern Flutter interfaces that align with the Pallacanestro Varese brand and Material 3 standards.

## Design Philosophy

- **Modern & Alive**: Use smooth transitions, interactive feedback such as ink ripples and hover states, and subtle animations.
- **Material 3**: Leverage `ColorScheme.fromSeed`, elevated or filled `Card` styles, and `NavigationBar` / `NavigationDrawer`.
- **Sports Aesthetics**: Use high contrast, bold typography for scores and headlines, and high-quality imagery.

## Visual Identity (Inspiration: Pallacanestro Varese)

- **Colors**: Primary red `#E30613`, white, and light grey backgrounds. Use gradients sparingly and effectively for headers.
- **Typography**: Bold, uppercase titles for live or match headers. Use clean sans-serif text for body copy.
- **Components**:
  - **Cards**: Use `Card` with `RoundedRectangleBorder` radius `12-16` for news and match results.
  - **Live Indicators**: Use glowing or pulsing dots for live games.
  - **Badges**: Use `Badge` for status or unread news.

## Workflow

### 1. Research & Inspiration

- Analyze the current screen in `lib/screens/`.
- Reference `lib/config/team_config.dart` for theme colors and branding.
- Visualize the target layout based on `https://www.pallacanestrovarese.it/it/`.

### 2. Layout Planning

- Use `Scaffold` as the base.
- Implement `CustomScrollView` with `SliverAppBar` for rich header experiences, including collapsing headers with images when appropriate.
- Use consistent padding. Standard screen padding is `16.0`.

### 3. Implementation Patterns

- **News Tiles**: Use `ListTile` or a custom `Column` with an `AspectRatio` image at the top.
- **Game Cards**: Use a `Row` with team logo, bold score, and team logo. Add a subtitle with match date/time.
- **Empty States**: Use `Center` with an `Icon` and descriptive text.

## Quality Standards

- **Responsiveness**: Ensure layouts work on different screen sizes using `LayoutBuilder`, `Flexible`, or `Expanded`.
- **Accessibility**: Use `Semantics` and ensure sufficient color contrast.
- **Performance**: Use `const` constructors and avoid heavy logic in `build` methods.

## Example Request

"Refine the Home page to make it look more like the official website using Material 3."

**Action**: Update `lib/screens/home_page.dart` using `SliverAppBar`, modern `Card` designs, and the team's primary red color.
