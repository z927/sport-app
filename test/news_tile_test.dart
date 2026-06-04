import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sports_team_app/models/team_content.dart';
import 'package:sports_team_app/widgets/news_tile.dart';

void main() {
  testWidgets('news details shows readable date, summary, and full content from details endpoint', (tester) async {
    const preview = NewsItem(
      id: 'max-ladurner-biancorosso-anche-nella-prossima-stagione-sportiva',
      title: 'MAX LADURNER IN BIANCOROSSO ANCHE NELLA PROSSIMA STAGIONE SPORTIVA',
      dateLabel: '3 giugno 2026',
      url: 'https://www.pallacanestrovarese.it/it/news/max-ladurner-biancorosso-anche-nella-prossima-stagione-sportiva',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: NewsDetailsPage(
          item: preview,
          loadDetails: (newsId) async {
            expect(newsId, 'max-ladurner-biancorosso-anche-nella-prossima-stagione-sportiva');
            return const NewsItem(
              id: 'max-ladurner-biancorosso-anche-nella-prossima-stagione-sportiva',
              title: 'MAX LADURNER IN BIANCOROSSO ANCHE NELLA PROSSIMA STAGIONE SPORTIVA',
              dateLabel: '3 giugno 2026',
              summary: 'Max Ladurner continuerà a vestire la maglia biancorossa.',
              content: 'Primo paragrafo della notizia.\n\nSecondo paragrafo della notizia.',
              url: 'https://www.pallacanestrovarese.it/it/news/max-ladurner-biancorosso-anche-nella-prossima-stagione-sportiva',
            );
          },
        ),
      ),
    );

    expect(find.text('3 GIUGNO 2026'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('SOMMARIO'), findsOneWidget);
    expect(find.text('Max Ladurner continuerà a vestire la maglia biancorossa.'), findsOneWidget);
    expect(find.text('ARTICOLO'), findsOneWidget);
    expect(find.text('Primo paragrafo della notizia.'), findsOneWidget);
    expect(find.text('Secondo paragrafo della notizia.'), findsOneWidget);
  });
}
