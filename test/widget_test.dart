import 'package:flutter_test/flutter_test.dart';
import 'package:sports_team_app/app/sports_team_app.dart';
import 'package:sports_team_app/app/theme_controller.dart';
import 'package:sports_team_app/config/team_config.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      SportsTeamApp(
        config: defaultTeamConfig,
        themeController: ThemeController(),
      ),
    );
    expect(find.byType(SportsTeamApp), findsOneWidget);
  });
}
