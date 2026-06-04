import 'package:html/parser.dart' as html_parser;

import '../models/team_content.dart';

class NewsMapper {
  const NewsMapper._();

  static NewsItem fromJson(Map<String, dynamic> json, {required String fallbackUrl}) => NewsItem(
        id: json['id']?.toString() ?? '',
        title: _plainText(json['title']),
        dateLabel: json['publishedAt']?.toString() ?? json['date']?.toString() ?? json['dateLabel']?.toString() ?? '',
        url: json['url']?.toString() ?? fallbackUrl,
        summary: _plainText(json['summary']),
        content: _normalizedContent(json['content'] ?? json['body'] ?? json['description']),
        imageUrl: json['coverImage']?.toString() ?? json['imageUrl']?.toString(),
      );

  static String _plainText(Object? value) {
    final source = value?.toString().trim() ?? '';
    if (source.isEmpty) return '';

    return html_parser.parse(source).documentElement?.text.trim() ?? source;
  }

  static String _normalizedContent(Object? value) {
    final source = value?.toString().trim() ?? '';
    if (source.isEmpty) return '';

    final withBreaks = source
        .replaceAll(RegExp(r'<\s*br\s*/?\s*>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</\s*p\s*>', caseSensitive: false), '\n\n')
        .replaceAll(RegExp(r'</\s*(h[1-6]|li|blockquote)\s*>', caseSensitive: false), '\n');
    final parsed = html_parser.parse(withBreaks).documentElement?.text ?? withBreaks;
    return parsed
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .join('\n\n');
  }
}
