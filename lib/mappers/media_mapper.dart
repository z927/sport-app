import '../models/team_content.dart';

class MediaMapper {
  const MediaMapper._();

  static MediaItem fromJson(
    Map<String, dynamic> json, {
    required String prefix,
    required String fallbackUrl,
  }) =>
      MediaItem(
        id: json['id']?.toString() ?? '$prefix-${json['title'] ?? 'item'}',
        title: json['title']?.toString() ?? '',
        url: json['url']?.toString() ?? fallbackUrl,
        dateLabel: json['date']?.toString() ?? json['dateLabel']?.toString() ?? '',
      );
}
