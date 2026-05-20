import 'dart:convert';

import 'package:http/http.dart' as http;
import '../errors/api_exception.dart';
import '../config/team_config.dart';
import '../models/team_content.dart';

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

  void dispose() {
    _client.close();
  }

  Future<List<NewsItem>> getNews({int limit = 10}) async {
    final data = await _getList('/api/basketball/news', query: {'limit': '$limit'});
    return data.map(_toNews).toList();
  }

  Future<NewsItem?> getNewsById(String newsId) async {
    final data = await _getObject('/api/basketball/news/$newsId');
    return data == null ? null : _toNews(data);
  }

  Future<List<MediaItem>> getVideos({int limit = 10}) async {
    final data = await _getList('/api/basketball/media/videos', query: {'limit': '$limit'});
    return data.map((json) => _toMedia(json, 'video')).toList();
  }

  Future<List<MediaItem>> getPhotos({int limit = 10}) async {
    final data = await _getList('/api/basketball/media/photos', query: {'limit': '$limit'});
    return data.map((json) => _toMedia(json, 'photo')).toList();
  }

  Future<List<Player>> getRoster() async => (await _getList('/api/basketball/team/roster')).map(_toPlayer).toList();

  Future<Player?> getPlayerById(String playerId) async {
    final data = await _getObject('/api/basketball/team/players/$playerId');
    return data == null ? null : _toPlayer(data);
  }

  Future<List<StaffMember>> getStaff() async => (await _getList('/api/basketball/team/staff')).map(_toStaff).toList();

  Future<List<Game>> getMatches() async => (await _getList('/api/basketball/matches')).map(_toGame).toList();

  Future<Game?> getMatchById(String matchId) async {
    final data = await _getObject('/api/basketball/matches/$matchId');
    return data == null ? null : _toGame(data);
  }

  Future<List<StandingRow>> getStandings() async =>
      (await _getList('/api/basketball/standings')).map(_toStanding).toList();

  Future<TeamProfile?> getTeamProfile() async {
    final data = await _getObject('/api/basketball/team/profile');
    return data == null ? null : _toProfile(data);
  }

  Future<List<Map<String, dynamic>>> _getList(String path, {Map<String, String>? query}) async {
    final uri = _buildUri(path, query: query);
    final response = await _client.get(uri).timeout(_timeout);
    if (response.statusCode == 404) return [];
    if (response.statusCode >= 400) throw ApiException('HTTP ${response.statusCode} on $uri');
    final decoded = jsonDecode(response.body);
    if (decoded is! List) throw ApiException('Expected list response on $uri');
    return decoded.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<Map<String, dynamic>?> _getObject(String path) async {
    final uri = _buildUri(path);
    final response = await _client.get(uri).timeout(_timeout);
    if (response.statusCode == 404) return null;
    if (response.statusCode >= 400) throw ApiException('HTTP ${response.statusCode} on $uri');
    final decoded = jsonDecode(response.body);
    if (decoded is! Map) throw ApiException('Expected object response on $uri');
    return Map<String, dynamic>.from(decoded);
  }

  Uri _buildUri(String path, {Map<String, String>? query}) {
    final baseUri = Uri.parse(_config.backendBaseUrl);
    return baseUri.replace(
      path: path,
      queryParameters: query,
    );
  }

  NewsItem _toNews(Map<String, dynamic> json) => NewsItem(
        title: json['title']?.toString() ?? '',
        dateLabel: json['date']?.toString() ?? json['dateLabel']?.toString() ?? '',
        url: json['url']?.toString() ?? _config.backendBaseUrl,
      );

  MediaItem _toMedia(Map<String, dynamic> json, String prefix) => MediaItem(
        id: json['id']?.toString() ?? '$prefix-${json['title'] ?? 'item'}',
        title: json['title']?.toString() ?? '',
        url: json['url']?.toString() ?? _config.backendBaseUrl,
        dateLabel: json['date']?.toString() ?? json['dateLabel']?.toString() ?? '',
      );

  Player _toPlayer(Map<String, dynamic> json) => Player(
        number: json['number']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        profileUrl: json['url']?.toString() ?? json['profileUrl']?.toString() ?? _config.backendBaseUrl,
      );

  StaffMember _toStaff(Map<String, dynamic> json) => StaffMember(
        name: json['name']?.toString() ?? '',
        role: json['role']?.toString() ?? '',
        profileUrl: json['url']?.toString() ?? _config.backendBaseUrl,
      );

  Game _toGame(Map<String, dynamic> json) {
    final status = (json['status']?.toString() ?? 'scheduled').toLowerCase();
    return Game(
      competition: json['competition']?.toString() ?? 'Campionato',
      dateLabel: json['date']?.toString() ?? json['dateLabel']?.toString() ?? '',
      homeTeam: json['home']?.toString() ?? json['homeTeam']?.toString() ?? '',
      awayTeam: json['away']?.toString() ?? json['awayTeam']?.toString() ?? '',
      homeScore: int.tryParse('${json['homeScore'] ?? ''}'),
      awayScore: int.tryParse('${json['awayScore'] ?? ''}'),
      status: status == 'completed'
          ? GameStatus.completed
          : status == 'live'
              ? GameStatus.live
              : GameStatus.scheduled,
      boxScoreUrl: json['boxScoreUrl']?.toString(),
      streamUrl: json['streamUrl']?.toString(),
      venueUrl: json['venueUrl']?.toString(),
      highlightsUrl: json['highlightsUrl']?.toString(),
    );
  }

  StandingRow _toStanding(Map<String, dynamic> json) => StandingRow(
        teamName: json['team']?.toString() ?? json['teamName']?.toString() ?? '',
        points: int.tryParse('${json['points'] ?? 0}') ?? 0,
        played: int.tryParse('${json['played'] ?? 0}') ?? 0,
      );

  TeamProfile _toProfile(Map<String, dynamic> json) => TeamProfile(
        name: json['name']?.toString() ?? '',
        arena: json['venue']?.toString() ?? json['arena']?.toString() ?? '',
        city: json['city']?.toString() ?? '',
        websiteUrl: json['website']?.toString() ?? _config.backendBaseUrl,
      );
}
