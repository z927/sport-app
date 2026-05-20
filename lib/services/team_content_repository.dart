import '../config/team_config.dart';
import '../models/team_content.dart';
import 'basketball_api_service.dart';

class TeamContentRepository {
  TeamContentRepository({
    required TeamSiteConfig config,
    BasketballApiService? apiService,
  })  : _config = config,
        _apiService = apiService ?? BasketballApiService(config: config);

  final TeamSiteConfig _config;
  final BasketballApiService _apiService;

  void dispose() {
    _apiService.dispose();
  }

  Future<TeamDashboard> loadDashboard() async {
    try {
      final results = await Future.wait([
        _apiService.getNews(limit: 12),
        _apiService.getMatches(),
        _apiService.getRoster(),
        _apiService.getTeamProfile(),
      ]);

      final news = results[0] as List<NewsItem>;
      final games = results[1] as List<Game>;
      final players = results[2] as List<Player>;
      final profile = results[3] as TeamProfile?;

      return TeamDashboard(
        news: news.isEmpty ? _config.seedDashboard.news : news,
        games: games.isEmpty ? _config.seedDashboard.games : games,
        players: players.isEmpty ? _config.seedDashboard.players : players,
        clubInfo: profile == null
            ? _config.seedDashboard.clubInfo
            : ClubInfo(
                name: profile.name,
                arena: profile.arena,
                email: _config.seedDashboard.clubInfo.email,
                phone: _config.seedDashboard.clubInfo.phone,
                palmares: _config.seedDashboard.clubInfo.palmares,
              ),
        sourceUrl: _config.backendBaseUrl,
        updatedAt: DateTime.now(),
      );
    } on Exception {
      return _config.seedDashboard;
    }
  }
}
