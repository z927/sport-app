import 'package:flutter/material.dart';

import 'app/sports_team_app.dart';
import 'app/theme_controller.dart';
import 'config/team_config.dart';

void main() {
  final themeController = ThemeController();
  
  runApp(
    SportsTeamApp(
      config: defaultTeamConfig,
      themeController: themeController,
    ),
  );
}
