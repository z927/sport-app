import 'dart:convert';

import 'package:http/http.dart' as http;
import '../errors/api_exception.dart';
import '../config/team_config.dart';
import '../models/team_content.dart';
import '../mappers/game_mapper.dart';
import '../mappers/media_mapper.dart';
import '../mappers/news_mapper.dart';
import '../mappers/player_mapper.dart';
import '../mappers/staff_mapper.dart';
import '../mappers/standing_mapper.dart';
import '../mappers/team_profile_mapper.dart';

class BasketballApiService {
  BasketballApiService({
    required TeamSiteConfig config,
    http.Client? client,
    Duration timeout = const Duration(seconds: 7),
  })  : _config = config,
        _client = client ?? http.Client(),
        _timeout = timeout;

  final TeamSiteConfig _config;
  final http.Client _client;
  final Duration _timeout;
  String? _token;

  void dispose() {
    _client.close();
  }

  Future<String> _getToken() async {
    if (_token != null) return _token!;

    final uri = _buildUri('/auth/token');
    final response = await _client.post(
      uri,
      headers: {'x-api-key': _config.apiKey},
    ).timeout(_timeout);

    if (response.statusCode >= 400) {
      throw ApiException('Auth failed: HTTP ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    final token = decoded['token'] as String?;
    if (token == null) {
      throw ApiException('Invalid token response');
    }

    _token = token;
    return token;
  }

  Future<List<NewsItem>> getNews({int limit = 10}) async {
    final data = await _getList('/api/basketball/news', query: {'limit': '$limit'});
    return data.map((json) => NewsMapper.fromJson(json, fallbackUrl: _config.backendBaseUrl)).toList();
  }

  Future<NewsItem?> getNewsById(String newsId) async {
    final data = await _getObject('/api/basketball/news/$newsId');
    return data == null ? null : NewsMapper.fromJson(data, fallbackUrl: _config.backendBaseUrl);
  }

  Future<List<MediaItem>> getVideos({int limit = 10}) async {
    final data = await _getList('/api/basketball/media/videos', query: {'limit': '$limit'});
    return data.map((json) => MediaMapper.fromJson(json, prefix: 'video', fallbackUrl: _config.backendBaseUrl)).toList();
  }

  Future<List<MediaItem>> getPhotos({int limit = 10}) async {
    final data = await _getList('/api/basketball/media/photos', query: {'limit': '$limit'});
    return data.map((json) => MediaMapper.fromJson(json, prefix: 'photo', fallbackUrl: _config.backendBaseUrl)).toList();
  }

  Future<List<Player>> getRoster() async =>
      (await _getList('/api/basketball/team/roster')).map((json) => PlayerMapper.fromJson(json, fallbackUrl: _config.backendBaseUrl)).toList();

  Future<Player?> getPlayerById(String playerId) async {
    final data = await _getObject('/api/basketball/team/players/$playerId');
    return data == null ? null : PlayerMapper.fromJson(data, fallbackUrl: _config.backendBaseUrl);
  }

  Future<List<StaffMember>> getStaff() async =>
      (await _getList('/api/basketball/team/staff')).map((json) => StaffMapper.fromJson(json, fallbackUrl: _config.backendBaseUrl)).toList();

  Future<List<Game>> getMatches() async => (await _getList('/api/basketball/matches')).map(GameMapper.fromJson).toList();

  Future<Game?> getMatchById(String matchId) async {
    final data = await _getObject('/api/basketball/matches/$matchId');
    return data == null ? null : GameMapper.fromJson(data);
  }

  Future<List<StandingRow>> getStandings() async =>
      (await _getList('/api/basketball/standings')).map(StandingMapper.fromJson).toList();

  Future<TeamProfile?> getTeamProfile() async {
    final data = await _getObject('/api/basketball/team/profile');
    return data == null ? null : TeamProfileMapper.fromJson(data, fallbackUrl: _config.backendBaseUrl);
  }

  Future<List<Map<String, dynamic>>> _getList(String path, {Map<String, String>? query}) async {
    final uri = _buildUri(path, query: query);
    final response = await _getWithAuth(uri);
    if (response.statusCode == 404) return [];
    if (response.statusCode >= 400) throw ApiException('HTTP ${response.statusCode} on $uri');
    final decoded = jsonDecode(response.body);
    if (decoded is! List) throw ApiException('Expected list response on $uri');
    return decoded.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<Map<String, dynamic>?> _getObject(String path) async {
    final uri = _buildUri(path);
    final response = await _getWithAuth(uri);
    if (response.statusCode == 404) return null;
    if (response.statusCode >= 400) throw ApiException('HTTP ${response.statusCode} on $uri');
    final decoded = jsonDecode(response.body);
    if (decoded is! Map) throw ApiException('Expected object response on $uri');
    return Map<String, dynamic>.from(decoded);
  }

  Future<http.Response> _getWithAuth(Uri uri) async {
    final token = await _getToken();
    var response = await _client.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    ).timeout(_timeout);

    if (response.statusCode == 401) {
      _token = null;
      final newToken = await _getToken();
      response = await _client.get(
        uri,
        headers: {'Authorization': 'Bearer $newToken'},
      ).timeout(_timeout);
    }

    return response;
  }

  Uri _buildUri(String path, {Map<String, String>? query}) {
    final baseUri = Uri.parse(_config.backendBaseUrl);
    return baseUri.replace(
      path: path,
      queryParameters: query,
    );
  }


}
