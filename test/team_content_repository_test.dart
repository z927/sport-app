import 'package:flutter_test/flutter_test.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:sports_team_app/models/team_content.dart';
import 'package:sports_team_app/services/team_content_repository.dart';

void main() {
  group('TeamContentRepository parsers', () {
    test('extracts roster players from team markup', () {
      final document = html_parser.parse('''
        <html><body>
          <h1>Roster</h1>
          <a href="/player/one">#1 PLAYER ONE</a>
          <a href="/player/two">#2 PLAYER TWO</a>
        </body></html>
      ''');

      final players = TeamContentRepository.parsePlayers(
        document,
        Uri.https('www.example.com', '/team'),
        _fallbackPlayers,
      );

      expect(players, hasLength(2));
      expect(players.first.number, '1');
      expect(players.first.name, 'PLAYER ONE');
      expect(
        players.first.profileUrl.toString(),
        'https://www.example.com/player/one',
      );
    });

    test('extracts news cards and resolves configured links', () {
      final document = html_parser.parse('''
        <section>
          <article>
            <time>01/04/2026</time>
            <h3><a href="/news/ticket-sale">MATCH TICKETS ARE NOW AVAILABLE</a></h3>
          </article>
        </section>
      ''');

      final news = TeamContentRepository.parseNews(
        document,
        Uri.https('www.example.com', '/home'),
        _fallbackNews,
      );

      expect(news, hasLength(1));
      expect(news.single.dateLabel, '01/04/2026');
      expect(
        news.single.url.toString(),
        'https://www.example.com/news/ticket-sale',
      );
    });

    test('filters games by configured team keyword', () {
      final document = html_parser.parse('''
        <body>
          Campionato 04.04.2026 / 19:00 0 - 0 City Club VS Target Team Diretta TV
          Campionato 28.03.2026 / 18:30 97 - 87 Other Club VS Rival Team Tabellino
          Campionato 12.04.2026 / 17:30 90 - 88 Target Team VS Coast Club Tabellino
        </body>
      ''');

      final games = TeamContentRepository.parseGames(
        document,
        Uri.https('www.example.com', '/home'),
        'Target',
        _fallbackGames,
      );

      expect(games, hasLength(2));
      expect(games.first.status, GameStatus.scheduled);
      expect(games.last.status, GameStatus.completed);
      expect(games.last.homeScore, 90);
      expect(games.last.awayScore, 88);
    });
  });
}

final _fallbackNews = [
  NewsItem(
    title: 'Fallback news',
    dateLabel: '01/01/2026',
    url: Uri.https('www.example.com', '/news'),
  ),
];

final _fallbackPlayers = [
  Player(
    number: '0',
    name: 'Fallback Player',
    profileUrl: Uri.https('www.example.com', '/team'),
  ),
];

final _fallbackGames = [
  const Game(
    competition: 'Campionato',
    dateLabel: '01.01.2026 / 20:00',
    homeTeam: 'Fallback Team',
    awayTeam: 'Fallback Opponent',
    homeScore: 0,
    awayScore: 0,
    status: GameStatus.scheduled,
  ),
];
