import '../models/team_content.dart';

class TeamProfileMapper {
  const TeamProfileMapper._();

  static TeamProfile fromJson(Map<String, dynamic> json, {required String fallbackUrl}) => TeamProfile(
        name: json['name']?.toString() ?? '',
        arena: json['venue']?.toString() ?? json['arena']?.toString() ?? '',
        city: json['city']?.toString() ?? '',
        websiteUrl: json['website']?.toString() ?? fallbackUrl,
      );
}
