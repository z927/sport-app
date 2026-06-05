import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sports_team_app/config/team_config.dart';
import 'package:sports_team_app/models/team_content.dart';
import 'package:sports_team_app/screens/home_page.dart';
import 'package:sports_team_app/widgets/recent_games_carousel.dart';

void main() {
  testWidgets('home page shows last three completed games newest first',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomePage(
            config: defaultTeamConfig,
            onRefresh: () {},
            dashboard: TeamDashboard(
              news: const [],
              games: const [
                Game(
                  competition: 'Campionato',
                  dateLabel: '01.04.2026 / 20:00',
                  homeTeam: 'Varese',
                  awayTeam: 'Milano',
                  homeScore: 70,
                  awayScore: 68,
                  status: GameStatus.completed,
                ),
                Game(
                  competition: 'Campionato',
                  dateLabel: '26.04.2026 / 17:00',
                  homeTeam: 'Varese',
                  awayTeam: 'Cremona',
                  homeScore: 84,
                  awayScore: 75,
                  status: GameStatus.completed,
                ),
                Game(
                  competition: 'Campionato',
                  dateLabel: '18.04.2026 / 19:30',
                  homeTeam: 'Napoli',
                  awayTeam: 'Varese',
                  homeScore: 79,
                  awayScore: 82,
                  status: GameStatus.completed,
                ),
                Game(
                  competition: 'Campionato',
                  dateLabel: '30.03.2026 / 18:00',
                  homeTeam: 'Varese',
                  awayTeam: 'Trento',
                  homeScore: 88,
                  awayScore: 80,
                  status: GameStatus.completed,
                ),
                Game(
                  competition: 'Campionato',
                  dateLabel: '10.05.2026 / 17:00',
                  homeTeam: 'Bologna',
                  awayTeam: 'Varese',
                  homeScore: null,
                  awayScore: null,
                  status: GameStatus.scheduled,
                ),
              ],
              players: const [],
              clubInfo: const ClubInfo(name: 'Pallacanestro Varese', arena: ''),
              sourceUrl: '',
              updatedAt: DateTime(2026, 4, 27),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Ultime partite'.toUpperCase()), findsOneWidget);
    expect(find.byType(RecentGamesCarousel), findsOneWidget);
    expect(find.text('26.04.2026 / 17:00'), findsOneWidget);
    expect(find.text('84 - 75'), findsOneWidget);
    expect(find.text('VARESE  VS  CREMONA'), findsOneWidget);
    expect(find.text('01.04.2026 / 20:00'), findsNothing);
  });
}
