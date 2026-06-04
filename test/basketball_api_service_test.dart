import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sports_team_app/config/team_config.dart';
import 'package:sports_team_app/services/basketball_api_service.dart';

void main() {
  group('BasketballApiService backend integration contract', () {
    test('calls news endpoint with limit and maps response', () async {
      final client = MockClient((request) async {
        if (request.url.path == '/auth/token') {
          return http.Response(jsonEncode({'token': 'fake-jwt'}), 200, headers: {'content-type': 'application/json'});
        }
        expect(request.url.path, '/api/basketball/news');
        expect(request.url.queryParameters['limit'], '1');
        expect(request.headers['Authorization'], 'Bearer fake-jwt');
        return http.Response(
          jsonEncode([
            {
              'id': 'n1',
              'title': '<strong>News title</strong>',
              'summary': 'Short <em>preview</em>',
              'content': '<p>First paragraph.</p><p>Second paragraph.</p>',
              'publishedAt': '2026-05-20',
              'url': 'https://www.pallacanestrovarese.it/it/news/n1'
            }
          ]),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = BasketballApiService(config: defaultTeamConfig, client: client);
      final news = await service.getNews(limit: 1);

      expect(news, hasLength(1));
      expect(news.first.id, 'n1');
      expect(news.first.title, 'News title');
      expect(news.first.summary, 'Short preview');
      expect(news.first.content, 'First paragraph.\n\nSecond paragraph.');
      expect(news.first.dateLabel, '2026-05-20');
    });


    test('calls news detail endpoint and maps full article content', () async {
      final client = MockClient((request) async {
        if (request.url.path == '/auth/token') {
          return http.Response(jsonEncode({'token': 'fake-jwt'}), 200, headers: {'content-type': 'application/json'});
        }
        expect(request.url.path, '/api/basketball/news/n1');
        expect(request.headers['Authorization'], 'Bearer fake-jwt');
        return http.Response(
          jsonEncode({
            'id': 'n1',
            'title': 'Detail title',
            'summary': 'Detail summary',
            'content': '<p>Full article content.</p><p>Post game quotes.</p>',
            'publishedAt': '2026-05-20',
            'coverImage': 'https://example.com/news.jpg',
            'url': 'https://www.pallacanestrovarese.it/it/news/n1'
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = BasketballApiService(config: defaultTeamConfig, client: client);
      final news = await service.getNewsById('n1');

      expect(news, isNotNull);
      expect(news!.id, 'n1');
      expect(news.content, 'Full article content.\n\nPost game quotes.');
      expect(news.hasDetails, isTrue);
    });

    test('uses configured localhost backend for basketball endpoints', () async {
      final requestedUris = <Uri>[];
      final client = MockClient((request) async {
        if (request.url.path == '/auth/token') {
          return http.Response(jsonEncode({'token': 'fake-jwt'}), 200, headers: {'content-type': 'application/json'});
        }
        requestedUris.add(request.url);
        return http.Response('[]', 200, headers: {'content-type': 'application/json'});
      });

      final service = BasketballApiService(config: defaultTeamConfig, client: client);
      await service.getNews();
      await service.getRoster();
      await service.getMatches();
      await service.getStandings();

      expect(requestedUris, isNotEmpty);
      final expectedBaseUri = Uri.parse(defaultTeamConfig.backendBaseUrl);
      for (final uri in requestedUris) {
        expect(uri.scheme, expectedBaseUri.scheme);
        expect(uri.host, expectedBaseUri.host);
        expect(uri.port, expectedBaseUri.port);
      }
    });

    test('returns null on 404 resource endpoint', () async {
      final client = MockClient((request) async {
        if (request.url.path == '/auth/token') {
          return http.Response(jsonEncode({'token': 'fake-jwt'}), 200, headers: {'content-type': 'application/json'});
        }
        return http.Response('{"error":"not found"}', 404);
      });

      final service = BasketballApiService(config: defaultTeamConfig, client: client);
      final player = await service.getPlayerById('missing');
      expect(player, isNull);
    });


    test('maps player biography from backend payload', () async {
      final client = MockClient((request) async {
        if (request.url.path == '/auth/token') {
          return http.Response(jsonEncode({'token': 'fake-jwt'}), 200, headers: {'content-type': 'application/json'});
        }
        expect(request.url.path, '/api/basketball/team/players/davide-alviti');
        return http.Response(
          jsonEncode({
            'id': 'davide-alviti',
            'name': 'DAVIDE ALVITI',
            'number': '2',
            'role': 'Ala',
            'photo': 'http://localhost:3000/p2.png',
            'bio': 'Davide Alviti nasce ad Alatri il 5 novembre 1996.',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = BasketballApiService(config: defaultTeamConfig, client: client);
      final player = await service.getPlayerById('davide-alviti');

      expect(player?.id, 'davide-alviti');
      expect(player?.biography, 'Davide Alviti nasce ad Alatri il 5 novembre 1996.');
    });

    test('maps standings and profile from backend payload', () async {
      final client = MockClient((request) async {
        if (request.url.path == '/auth/token') {
          return http.Response(jsonEncode({'token': 'fake-jwt'}), 200, headers: {'content-type': 'application/json'});
        }
        if (request.url.path == '/api/basketball/standings') {
          return http.Response(jsonEncode([
            {'team': 'Varese', 'points': 32, 'played': 22}
          ]), 200, headers: {'content-type': 'application/json'});
        }

        if (request.url.path == '/api/basketball/team/profile') {
          return http.Response(
            jsonEncode({'name': 'Pallacanestro Varese', 'city': 'Varese', 'venue': 'Itelyum Arena'}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }

        return http.Response('[]', 200, headers: {'content-type': 'application/json'});
      });

      final service = BasketballApiService(config: defaultTeamConfig, client: client);
      final standings = await service.getStandings();
      final profile = await service.getTeamProfile();

      expect(standings.single.points, 32);
      expect(profile?.arena, 'Itelyum Arena');
    });
  });
}
