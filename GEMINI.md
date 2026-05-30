# Sports Team App

## Project Overview

This project is a configurable Flutter application prototype for sports teams. It's designed to be data-driven, where a single `TeamSiteConfig` can be updated to point the app at a different team's data source without requiring a rewrite of the core logic or UI.

## Tech Stack

- **Framework**: Flutter (Dart SDK `>=3.4.0 <4.0.0`)
- **State Management**: Repository pattern with basic Flutter state management.
- **Networking**: `http` package for API calls.
- **Parsing**: `html` package for scraping/parsing legacy content if needed.
- **Testing**: `flutter_test` for unit and widget tests.
- **CI/CD**: GitHub Actions, Semantic Release, Conventional Commits.

## Architecture & Directory Structure

- `lib/app/`: Root application widget and global theme configuration.
- `lib/config/`: **Critical.** Contains `team_config.dart` which defines the team identity, colors, and API endpoints.
- `lib/mappers/`: Pure functions to transform raw API/JSON data into domain models.
- `lib/models/`: Plain Data Objects (POJOs/Entities) representing the domain (Game, News, Player, etc.).
- `lib/services/`:
  - `basketball_api_service.dart`: Low-level API client handling HTTP requests and auth.
  - `team_content_repository.dart`: Higher-level abstraction used by screens to fetch data.
- `lib/screens/`: High-level page widgets (Home, News, Live, Team, More).
- `lib/widgets/`: Reusable UI components (GameCard, NewsTile, etc.).
- `tool/`: Contains `mock_server.dart` for local development.

## Development Workflow

1.  **Environment Setup**: `flutter pub get`
2.  **Local Backend**: Run the mock server with `dart run tool/mock_server.dart` (defaults to port 3000).
3.  **Running the App**:
    - Default: `flutter run`
4.  **Quality Checks**:
    - Linting: `flutter analyze`
    - Testing: `flutter test`

## Key Conventions

- **Coding Style**: Strictly follow `analysis_options.yaml`. Use **single quotes** for strings.
- **UI Design**: Use **Material 3** for all components. Aim for a modern, "alive" UI with rich aesthetics, consistent spacing, and interactive feedback.
- **Design Inspiration**: Take visual cues (colors, typography, layout) from the official [Pallacanestro Varese website](https://www.pallacanestrovarese.it/it/).
- **Commits**: Follow **Conventional Commits** (e.g., `feat:`, `fix:`, `chore:`).

- **API Interaction**: All API calls must go through `BasketballApiService`. Ensure JWT tokens are handled if required by the endpoint.
- **Modularity**: When adding new features, ensure they are generic enough to work for any team by abstracting configurations into `TeamSiteConfig`.

## Common Tasks

- **Adding a new data field**: Update the model in `lib/models/`, the mapper in `lib/mappers/`, and ensure it's handled in the relevant service.
- **Changing Team**: Modify `lib/config/team_config.dart`.
- **Mocking Data**: Update `tool/mock_server.dart` to simulate different API responses.
