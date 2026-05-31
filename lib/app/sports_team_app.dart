import 'package:flutter/material.dart';

import '../config/team_config.dart';
import '../screens/dashboard_shell.dart';
import 'theme_controller.dart';

class SportsTeamApp extends StatelessWidget {
  const SportsTeamApp({
    required this.config,
    required this.themeController,
    super.key,
  });

  final TeamSiteConfig config;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(config.primaryColor);
    final secondaryColor = Color(config.secondaryColor);
    const vareseWhite = Color(0xFFFFFFFF);
    const vareseBlack = Color(0xFF111111);

    final lightColorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ).copyWith(
      primary: primaryColor,
      onPrimary: vareseWhite,
      secondary: secondaryColor,
      onSecondary: vareseWhite,
      surface: const Color(0xFFF8F8F9),
      onSurface: vareseBlack,
      outline: const Color(0xFFD8D8DC),
    );

    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ).copyWith(
      primary: primaryColor,
      onPrimary: vareseWhite,
      secondary: secondaryColor,
      onSecondary: vareseWhite,
      surface: const Color(0xFF1A1A1A),
      onSurface: vareseWhite,
      outline: const Color(0xFF333333),
    );

    ThemeData buildTheme(ColorScheme colorScheme) {
      final isDark = colorScheme.brightness == Brightness.dark;
      final surfaceColor = isDark ? const Color(0xFF121212) : vareseWhite;
      final scaffoldBg =
          isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF3F4F6);
      final textColor = isDark ? vareseWhite : vareseBlack;
      final borderColor =
          isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE6E6EA);

      return ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: scaffoldBg,
        appBarTheme: AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: surfaceColor,
          foregroundColor: textColor,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: textColor,
            letterSpacing: -0.2,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: isDark ? const Color(0xFF1C1C1E) : vareseWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: borderColor),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: primaryColor.withValues(alpha: 0.08),
          side: BorderSide(color: primaryColor.withValues(alpha: 0.15)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? vareseWhite : vareseBlack,
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: 72,
          indicatorColor: primaryColor.withValues(alpha: 0.12),
          backgroundColor: surfaceColor,
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: states.contains(WidgetState.selected)
                  ? primaryColor
                  : (isDark
                      ? const Color(0xFF8E8E93)
                      : const Color(0xFF6A6A70)),
            ),
          ),
          iconTheme: WidgetStateProperty.resolveWith(
            (states) => IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? primaryColor
                  : (isDark
                      ? const Color(0xFF8E8E93)
                      : const Color(0xFF77777D)),
            ),
          ),
        ),
      );
    }

    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: config.appTitle,
          debugShowCheckedModeBanner: false,
          theme: buildTheme(lightColorScheme),
          darkTheme: buildTheme(darkColorScheme),
          themeMode: themeController.themeMode,
          home: DashboardShell(
            config: config,
            themeController: themeController,
          ),
        );
      },
    );
  }
}
