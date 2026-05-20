import 'package:flutter_test/flutter_test.dart';
import 'package:sports_team_app/config/team_config.dart';
import 'package:sports_team_app/models/team_content.dart';
import 'package:sports_team_app/services/basketball_api_service.dart';
import 'package:sports_team_app/services/team_content_repository.dart';

class _FakeBasketballApiService extends BasketballApiService {
  _FakeBasketballApiService({
    required this.news,
    required this.games,
    required this.players,
    required this.profile,
  }) : super(config: defaultTeamConfig);

  final List<NewsItem> news;
  final List<Game> games;
  final List<Player> players;
  final TeamProfile? profile;

  @override
  Future<List<NewsItem>> getNews({int limit = 10}) async => news;

  @override
  Future<List<Game>> getMatches() async => games;

  @override
  Future<List<Player>> getRoster() async => players;

  @override
  Future<TeamProfile?> getTeamProfile() async => profile;

  @override
  void dispose() {}
}

void main() {
  group('TeamContentRepository backend composition', () {
    test('builds dashboard from backend responses only', () async {
      final api = _FakeBasketballApiService(
        news: const [
          NewsItem(title: 'Backend News', dateLabel: '13/05/2026', url: 'http://localhost:3000/n1'),
        ],
        games: const [
          Game(
            competition: 'Campionato',
            dateLabel: 'dom 10 mag 17:00 Campionato',
            homeTeam: 'Virtus Bologna',
            awayTeam: 'Varese',
            homeScore: 104,
            awayScore: 85,
            status: GameStatus.completed,
          )
        ],
        players: const [
          Player(number: '2', name: 'DAVIDE ALVITI', profileUrl: 'http://localhost:3000/p2'),
        ],
        profile: const TeamProfile(
          name: 'Pallacanestro Varese',
          arena: 'Itelyum Arena',
          city: 'Varese',
          websiteUrl: 'http://localhost:3000',
        ),
      );

      final repository = TeamContentRepository(config: defaultTeamConfig, apiService: api);
      final dashboard = await repository.loadDashboard();

      expect(dashboard.news.single.title, 'Backend News');
      expect(dashboard.games.single.homeTeam, 'Virtus Bologna');
      expect(dashboard.players.single.name, 'DAVIDE ALVITI');
      expect(dashboard.clubInfo.name, 'Pallacanestro Varese');
      expect(dashboard.sourceUrl, defaultTeamConfig.backendBaseUrl);
    });
  });
}
