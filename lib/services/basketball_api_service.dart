import '../config/team_config.dart';
import '../models/team_content.dart';
import 'team_content_repository.dart';

class BasketballApiService {
  BasketballApiService({
    required TeamSiteConfig config,
    TeamContentRepository? repository,
  })  : _config = config,
        _repository = repository ?? TeamContentRepository(config: config);

  final TeamSiteConfig _config;
  final TeamContentRepository _repository;

  Future<List<NewsItem>> getNews({int limit = 10}) async {
    final dashboard = await _repository.loadDashboard();
    return dashboard.news.take(limit).toList();
  }

  Future<NewsItem?> getNewsById(String newsId) async {
    final items = await getNews(limit: 50);
    return items.where((item) => _slug(item.title) == newsId).cast<NewsItem?>().firstWhere(
          (item) => item != null,
          orElse: () => null,
        );
  }

  Future<List<MediaItem>> getVideos({int limit = 10}) async =>
      _config.seedVideos.take(limit).toList();

  Future<List<MediaItem>> getPhotos({int limit = 10}) async =>
      _config.seedPhotos.take(limit).toList();

  Future<List<Player>> getRoster() async {
    final dashboard = await _repository.loadDashboard();
    return dashboard.players;
  }

  Future<Player?> getPlayerById(String playerId) async {
    final players = await getRoster();
    return players.where((player) => _slug(player.name) == playerId).cast<Player?>().firstWhere(
          (item) => item != null,
          orElse: () => null,
        );
  }

  Future<List<StaffMember>> getStaff() async => _config.seedStaff;

  Future<List<Game>> getMatches() async {
    final dashboard = await _repository.loadDashboard();
    return dashboard.games;
  }

  Future<Game?> getMatchById(String matchId) async {
    final matches = await getMatches();
    return matches.where((game) => _slug('${game.homeTeam}-${game.awayTeam}-${game.dateLabel}') == matchId).cast<Game?>().firstWhere(
          (item) => item != null,
          orElse: () => null,
        );
  }

  Future<List<StandingRow>> getStandings() async => _config.seedStandings;

  Future<TeamProfile> getTeamProfile() async => _config.seedTeamProfile;

  String _slug(String value) => value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
}
