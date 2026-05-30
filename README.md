# Sports Team App

[![Build Status](https://img.shields.io/github/actions/workflow/status/z927/sport-app/ci.yaml?style=for-the-badge&logo=github-actions&logoColor=white&color=2ecc71)](https://github.com/z927/sport-app/actions)
[![Latest Version](https://img.shields.io/github/v/release/z927/sport-app?style=for-the-badge&logo=semver&logoColor=white&color=3498db)](https://github.com/z927/sport-app/releases)
[![License](https://img.shields.io/github/license/z927/sport-app?style=for-the-badge&logo=opensourceinitiative&logoColor=white&color=f39c12)](./LICENSE)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg?style=for-the-badge&logo=git&logoColor=white&color=e74c3c)](https://conventionalcommits.org)

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

## Flutter fan API client layer

The app includes a Flutter-side `BasketballApiService` that calls the internal backend endpoints under `/api/basketball/*`. Configure `backendBaseUrl` in `TeamSiteConfig`.

### Backend server configuration

The app uses the `backendBaseUrl` defined in `lib/config/team_config.dart`.

It provides methods equivalent to:

- `getNews(limit)`
- `getNewsById(newsId)`
- `getVideos(limit)`
- `getPhotos(limit)`
- `getRoster()`
- `getPlayerById(playerId)`
- `getStaff()`
- `getMatches()`
- `getMatchById(matchId)`
- `getStandings()`
- `getTeamProfile()`

### Mock Server

## Run Mock server

dart run tool/mock_server.dart
