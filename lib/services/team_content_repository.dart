import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

import '../config/team_config.dart';
import '../models/team_content.dart';

class TeamContentRepository {
  TeamContentRepository({
    required TeamSiteConfig config,
    http.Client? client,
  })  : _config = config,
        _client = client ?? http.Client();

  final TeamSiteConfig _config;
  final http.Client _client;

  Future<TeamDashboard> loadDashboard() async {
    try {
      final responses = await Future.wait([
        _client.get(_config.homeUrl),
        _client.get(_config.teamUrl),
      ]);

      for (final response in responses) {
        if (response.statusCode >= 400) {
          throw TeamContentRepositoryException(
            'Configured site returned HTTP ${response.statusCode}.',
          );
        }
      }

      final home = html_parser.parse(responses[0].body);
      final team = html_parser.parse(responses[1].body);

      return TeamDashboard(
        news: parseNews(home, _config.homeUrl, _config.seedDashboard.news),
        games: parseGames(
          home,
          _config.homeUrl,
          _config.teamKeyword,
          _config.seedDashboard.games,
        ),
        players: parsePlayers(team, _config.teamUrl, _config.seedDashboard.players),
        clubInfo: parseClubInfo(home, _config.seedDashboard.clubInfo),
        sourceUrl: _config.homeUrl,
        updatedAt: DateTime.now(),
      );
    } on Exception {
      return _config.seedDashboard;
    }
  }

  static List<NewsItem> parseNews(
    dom.Document document,
    Uri baseUrl,
    List<NewsItem> fallbackNews,
  ) {
    final anchors = document.querySelectorAll('a');
    final items = <NewsItem>[];

    for (final anchor in anchors) {
      final title = _clean(anchor.text);
      if (title.length < 12 || title == 'Read ⟶') {
        continue;
      }

      final href = anchor.attributes['href'];
      if (href == null || !href.contains('/news/')) {
        continue;
      }

      final date = _nearestDate(anchor) ?? '';
      if (items.any((item) => item.title == title)) {
        continue;
      }

      items.add(
        NewsItem(
          title: title,
          dateLabel: date,
          url: baseUrl.resolve(href),
        ),
      );

      if (items.length == 12) {
        break;
      }
    }

    return items.isEmpty ? fallbackNews : items;
  }

  static List<Player> parsePlayers(
    dom.Document document,
    Uri baseUrl,
    List<Player> fallbackPlayers,
  ) {
    final rosterLinks = document.querySelectorAll('a').where((anchor) {
      final text = _clean(anchor.text);
      return RegExp(r'^#\d+\s+').hasMatch(text);
    });

    final players = rosterLinks.map((anchor) {
      final text = _clean(anchor.text);
      final match = RegExp(r'^#(\d+)\s+(.+)$').firstMatch(text);
      final href = anchor.attributes['href'] ?? '';

      return Player(
        number: match?.group(1) ?? '',
        name: match?.group(2) ?? text.replaceFirst(RegExp(r'^#\d+\s*'), ''),
        profileUrl: baseUrl.resolve(href),
      );
    }).toList();

    return players.isEmpty ? fallbackPlayers : players;
  }

  static List<Game> parseGames(
    dom.Document document,
    Uri baseUrl,
    String teamKeyword,
    List<Game> fallbackGames,
  ) {
    final bodyText = _clean(document.body?.text ?? '');
    final gamePattern = RegExp(
      r'(Campionato)\s+(\d{2}\.\d{2}\.\d{4}\s*/\s*\d{2}:\d{2})\s+(\d+)\s*-\s*(\d+)\s+([A-Za-zÀ-ÿ\s]+?)\s+VS\s+([A-Za-zÀ-ÿ\s]+?)(?=\s+(?:Campionato|# Notizie|Diretta|Tabellino|Highlights|Fotogallery|$))',
      caseSensitive: false,
    );

    final games = gamePattern.allMatches(bodyText).map((match) {
      final homeScore = int.tryParse(match.group(3) ?? '');
      final awayScore = int.tryParse(match.group(4) ?? '');
      final isScheduled = homeScore == 0 && awayScore == 0;

      return Game(
        competition: match.group(1) ?? 'Campionato',
        dateLabel: match.group(2)?.replaceAll(' ', '') ?? '',
        homeTeam: _clean(match.group(5) ?? ''),
        awayTeam: _clean(match.group(6) ?? ''),
        homeScore: homeScore,
        awayScore: awayScore,
        status: isScheduled ? GameStatus.scheduled : GameStatus.completed,
        streamUrl: _findUrlByLabel(document, baseUrl, 'Diretta'),
        venueUrl: _findUrlByLabel(document, baseUrl, 'Pala'),
        boxScoreUrl: _findUrlByLabel(document, baseUrl, 'Tabellino'),
        highlightsUrl: _findUrlByLabel(document, baseUrl, 'Highlights'),
      );
    }).where((game) => game.involves(teamKeyword)).toList();

    return games.isEmpty ? fallbackGames : games;
  }

  static ClubInfo parseClubInfo(dom.Document document, ClubInfo fallbackInfo) {
    final text = _clean(document.body?.text ?? '');
    final palmares = <String>[];
    for (final label in fallbackInfo.palmares) {
      if (text.contains(label)) {
        palmares.add(label);
      }
    }

    return ClubInfo(
      name: fallbackInfo.name,
      arena: fallbackInfo.arena,
      email: RegExp(r'[\w.%-]+@[\w.-]+\.[A-Za-z]{2,}')
              .firstMatch(text)
              ?.group(0) ??
          fallbackInfo.email,
      phone: RegExp(r'T\.\s*([\d\s]+)').firstMatch(text)?.group(1)?.trim() ??
          fallbackInfo.phone,
      palmares: palmares.isEmpty ? fallbackInfo.palmares : palmares,
    );
  }

  void dispose() => _client.close();

  static Uri? _findUrlByLabel(dom.Document document, Uri baseUrl, String label) {
    for (final anchor in document.querySelectorAll('a')) {
      if (_clean(anchor.text).toLowerCase().contains(label.toLowerCase())) {
        final href = anchor.attributes['href'];
        if (href != null) {
          return baseUrl.resolve(href);
        }
      }
    }
    return null;
  }

  static String? _nearestDate(dom.Element anchor) {
    dom.Node? cursor = anchor.parentNode;
    for (var depth = 0; depth < 4 && cursor != null; depth += 1) {
      final text = _clean(cursor.text ?? '');
      final match = RegExp(r'\d{2}/\d{2}/\d{4}').firstMatch(text);
      if (match != null) {
        return match.group(0);
      }
      cursor = cursor.parentNode;
    }
    return null;
  }

  static String _clean(String value) => value.replaceAll(RegExp(r'\s+'), ' ').trim();
}

class TeamContentRepositoryException implements Exception {
  const TeamContentRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}
