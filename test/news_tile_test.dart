import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sports_team_app/models/team_content.dart';
import 'package:sports_team_app/widgets/news_tile.dart';

void main() {
  testWidgets(
    'news details shows readable date, summary, and full content from details endpoint',
    (tester) async {
      const preview = NewsItem(
        id: 'max-ladurner-biancorosso-anche-nella-prossima-stagione-sportiva',
        title:
            'MAX LADURNER IN BIANCOROSSO ANCHE NELLA PROSSIMA STAGIONE SPORTIVA',
        dateLabel: '3 giugno 2026',
        url:
            'https://www.pallacanestrovarese.it/it/news/max-ladurner-biancorosso-anche-nella-prossima-stagione-sportiva',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: NewsDetailsPage(
            item: preview,
            loadDetails: (newsId) async {
              expect(
                newsId,
                'max-ladurner-biancorosso-anche-nella-prossima-stagione-sportiva',
              );
              return const NewsItem(
                id:
                    'max-ladurner-biancorosso-anche-nella-prossima-stagione-sportiva',
                title:
                    'MAX LADURNER IN BIANCOROSSO ANCHE NELLA PROSSIMA STAGIONE SPORTIVA',
                dateLabel: '3 giugno 2026',
                summary:
                    'Max Ladurner continuerà a vestire la maglia biancorossa.',
                content:
                    'Primo paragrafo della notizia.\n\nSecondo paragrafo della notizia.',
                url:
                    'https://www.pallacanestrovarese.it/it/news/max-ladurner-biancorosso-anche-nella-prossima-stagione-sportiva',
              );
            },
          ),
        ),
      );

      expect(find.text('3 GIUGNO 2026'), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.text('SOMMARIO'), findsOneWidget);
      expect(
        find.text('Max Ladurner continuerà a vestire la maglia biancorossa.'),
        findsOneWidget,
      );
      expect(find.text('ARTICOLO'), findsOneWidget);
      expect(find.text('Primo paragrafo della notizia.'), findsOneWidget);
      expect(find.text('Secondo paragrafo della notizia.'), findsOneWidget);
    },
  );

  testWidgets('standard news button is red with white text in dark theme',
      (tester) async {
    const primary = Color(0xFFE30613);

    await _pumpNewsTile(tester, isAlternate: false, primary: primary);

    final button = tester.widget<TextButton>(find.byType(TextButton));

    expect(button.style?.backgroundColor?.resolve(<WidgetState>{}), primary);
    expect(
      button.style?.foregroundColor?.resolve(<WidgetState>{}),
      Colors.white,
    );
    expect(button.style?.side?.resolve(<WidgetState>{}), BorderSide.none);
  });

  testWidgets('standard news button label is white in light theme',
      (tester) async {
    const primary = Color(0xFFE30613);

    await _pumpNewsTile(
      tester,
      isAlternate: false,
      primary: primary,
      brightness: Brightness.light,
    );

    final label = tester.widget<Text>(find.text('LEGGI'));

    expect(label.style?.color, Colors.white);
  });

  testWidgets('alternate news button is outlined with white text in dark theme',
      (tester) async {
    const primary = Color(0xFFE30613);

    await _pumpNewsTile(tester, isAlternate: true, primary: primary);

    final button = tester.widget<TextButton>(find.byType(TextButton));
    final side = button.style?.side?.resolve(<WidgetState>{});

    expect(
      button.style?.backgroundColor?.resolve(<WidgetState>{}),
      Colors.transparent,
    );
    expect(
      button.style?.foregroundColor?.resolve(<WidgetState>{}),
      Colors.white,
    );
    expect(side?.color, Colors.white.withValues(alpha: 0.92));
    expect(side?.style, BorderStyle.solid);
  });
}

Future<void> _pumpNewsTile(
  WidgetTester tester, {
  required bool isAlternate,
  required Color primary,
  Brightness brightness = Brightness.dark,
}) async {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: primary,
    brightness: brightness,
  ).copyWith(
    primary: primary,
    onPrimary: Colors.white,
  );

  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
      ),
      home: Scaffold(
        body: NewsTile(
          item: const NewsItem(
            id: 'news-1',
            title: 'Titolo della notizia',
            dateLabel: '3 giugno 2026',
            url: 'https://www.pallacanestrovarese.it/it/news/news-1',
          ),
          isAlternate: isAlternate,
        ),
      ),
    ),
  );
}
