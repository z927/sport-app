import 'package:flutter/material.dart';

import '../config/team_config.dart';
import '../screens/dashboard_shell.dart';

class SportsTeamApp extends StatelessWidget {
  const SportsTeamApp({required this.config, super.key});

  final TeamSiteConfig config;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: config.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(config.primaryColor),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: false),
      ),
      home: DashboardShell(config: config),
    );
  }
}
