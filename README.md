# Sports Team App

Configurable Flutter mobile application prototype for a sports team. The default
configuration currently points to Pallacanestro Varese public content, but the
application code is structured around a generic `TeamSiteConfig` so another team
can be wired by changing the configuration instead of rewriting screens or
services.

## Pages

- **Home**: next match, latest news, and club trophies.
- **News**: configured team news links.
- **Live**: scheduled and completed games filtered by the configured team keyword.
- **Team**: configured team roster.
- **Più**: club contacts, official website, and ticketing links.

## Data source

The default configuration reads public data from:

- `https://www.pallacanestrovarese.it/it/`
- `https://www.pallacanestrovarese.it/squadra`

A seed dataset is included in `lib/config/team_config.dart` so the app remains
usable if the configured site is temporarily unavailable.

## Project structure

- `lib/main.dart`: app entry point.
- `lib/app/`: top-level app widget and theme.
- `lib/config/`: team-specific configuration and seed data.
- `lib/models/`: reusable content models.
- `lib/screens/`: one file per app page.
- `lib/services/`: data loading and parsing.
- `lib/widgets/`: shared UI components.

## Development

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```
