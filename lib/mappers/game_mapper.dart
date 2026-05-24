import '../models/team_content.dart';

class GameMapper {
  const GameMapper._();

  static Game fromJson(Map<String, dynamic> json) {
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
}
