import 'package:flutter_test/flutter_test.dart';
import 'package:sports_team_app/config/team_config.dart';
import 'package:sports_team_app/models/team_content.dart';
import 'package:sports_team_app/services/basketball_api_service.dart';
import 'package:sports_team_app/services/team_content_repository.dart';

class _FakeRepository extends TeamContentRepository {
  _FakeRepository(this.dashboard) : super(config: defaultTeamConfig);

  final TeamDashboard dashboard;

  @override
  Future<TeamDashboard> loadDashboard() async => dashboard;
}

void main() {
  group('BasketballApiService', () {
    final dashboard = defaultTeamConfig.seedDashboard;
    final service = BasketballApiService(
      config: defaultTeamConfig,
      repository: _FakeRepository(dashboard),
    );

    test('returns limited news list', () async {
      final items = await service.getNews(limit: 1);
      expect(items, hasLength(1));
    });

    test('resolves player by slug id', () async {
      final player = await service.getPlayerById('carlos-stewart-jr');
      expect(player, isNotNull);
      expect(player!.number, '1');
    });

    test('returns seeded sections for media and profile', () async {
      final videos = await service.getVideos(limit: 1);
      final profile = await service.getTeamProfile();
      expect(videos.single.id, 'video-1');
      expect(profile.name, 'Pallacanestro Varese');
    });
  });
}
