import '../models/team_content.dart';

class NewsMapper {
  const NewsMapper._();

  static NewsItem fromJson(Map<String, dynamic> json, {required String fallbackUrl}) => NewsItem(
        title: json['title']?.toString() ?? '',
        dateLabel: json['date']?.toString() ?? json['dateLabel']?.toString() ?? '',
        url: json['url']?.toString() ?? fallbackUrl,
        imageUrl: json['coverImage']?.toString(),
      );
}
