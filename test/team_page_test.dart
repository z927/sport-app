import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sports_team_app/models/team_content.dart';
import 'package:sports_team_app/screens/team_page.dart';

void main() {
  testWidgets('player details shows biography loaded from details endpoint', (tester) async {
    const rosterPlayer = Player(
      id: 'davide-alviti',
      number: '2',
      name: 'DAVIDE ALVITI',
      profileUrl: 'http://localhost:3000/p2',
      imageUrl: '',
      role: 'Ala',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TeamPage(
            players: const [rosterPlayer],
            loadPlayerDetails: (playerId) async {
              expect(playerId, 'davide-alviti');
              return const Player(
                id: 'davide-alviti',
                number: '2',
                name: 'DAVIDE ALVITI',
                profileUrl: 'http://localhost:3000/p2',
                imageUrl: '',
                role: 'Ala',
                biography: 'Davide Alviti nasce ad Alatri il 5 novembre 1996.',
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(InkWell).first);
    await tester.pump();

    expect(find.text('BIOGRAFIA'), findsOneWidget);
    expect(find.text('Caricamento della biografia in corso...'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Davide Alviti nasce ad Alatri il 5 novembre 1996.'), findsOneWidget);
  });
}
