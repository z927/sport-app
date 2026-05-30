import 'package:flutter/material.dart';

import 'app/sports_team_app.dart';
import 'config/team_config.dart';

void main() {
  const backendBaseUrl = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );
  print(backendBaseUrl);

  runApp(
    SportsTeamApp(
      config: defaultTeamConfig.copyWith(
        backendBaseUrl: backendBaseUrl,
      ),
    ),
  );
}
