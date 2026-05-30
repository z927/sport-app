import '../models/team_content.dart';

class PlayerMapper {
  const PlayerMapper._();

  static Player fromJson(Map<String, dynamic> json, {required String fallbackUrl}) => Player(
        number: json['number']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        profileUrl: json['url']?.toString() ?? json['profileUrl']?.toString() ?? fallbackUrl,
        imageUrl: json['photo']?.toString() ?? '',
        role: json['role']?.toString() ?? '',
      );
}
