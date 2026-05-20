import '../models/team_content.dart';

class StaffMapper {
  const StaffMapper._();

  static StaffMember fromJson(Map<String, dynamic> json, {required String fallbackUrl}) => StaffMember(
        name: json['name']?.toString() ?? '',
        role: json['role']?.toString() ?? '',
        profileUrl: json['url']?.toString() ?? fallbackUrl,
      );
}
