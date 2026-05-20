import 'package:flutter/material.dart';

import '../config/team_config.dart';
import '../screens/dashboard_shell.dart';

class SportsTeamApp extends StatelessWidget {
  const SportsTeamApp({required this.config, super.key});

  final TeamSiteConfig config;

  @override
  Widget build(BuildContext context) {
    const vareseRed = Color(0xFFE30613);
    const vareseDarkRed = Color(0xFF8B0008);
    const vareseWhite = Color(0xFFFFFFFF);
    const vareseBlack = Color(0xFF111111);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: vareseRed,
      brightness: Brightness.light,
    ).copyWith(
      primary: vareseRed,
      onPrimary: vareseWhite,
      secondary: vareseDarkRed,
      onSecondary: vareseWhite,
      surface: const Color(0xFFF8F8F9),
      onSurface: vareseBlack,
      outline: const Color(0xFFD8D8DC),
    );

    return MaterialApp(
      title: config.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: vareseWhite,
          foregroundColor: vareseBlack,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: vareseBlack,
            letterSpacing: -0.2,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFFE6E6EA)),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFFFDEBEC),
          side: const BorderSide(color: Color(0xFFF4C9CC)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: 72,
          indicatorColor: vareseRed.withValues(alpha: 0.12),
          backgroundColor: vareseWhite,
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
              color: states.contains(WidgetState.selected) ? vareseRed : const Color(0xFF6A6A70),
            ),
          ),
          iconTheme: WidgetStateProperty.resolveWith(
            (states) => IconThemeData(
              color: states.contains(WidgetState.selected) ? vareseRed : const Color(0xFF77777D),
            ),
          ),
        ),
      ),
      home: DashboardShell(config: config),
    );
  }
}
