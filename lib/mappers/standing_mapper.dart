import '../models/team_content.dart';

class StandingMapper {
  const StandingMapper._();

  static StandingRow fromJson(Map<String, dynamic> json) => StandingRow(
        teamName: json['team']?.toString() ?? json['teamName']?.toString() ?? '',
        points: int.tryParse('${json['points'] ?? 0}') ?? 0,
        played: int.tryParse('${json['played'] ?? 0}') ?? 0,
      );
}
