import 'news';

class NewsMapper {
    NewsItem _toNews(Map<String, dynamic> json) => NewsItem(
        title: json['title']?.toString() ?? '',
        dateLabel: json['date']?.toString() ?? json['dateLabel']?.toString() ?? '',
        url: json['url']?.toString() ?? _config.backendBaseUrl,
      );
}