import 'package:flutter/material.dart';

import '../models/team_content.dart';
import '../widgets/news_tile.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({required this.items, super.key});

  final List<NewsItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) => NewsTile(
        item: items[index],
        isAlternate: index % 2 != 0,
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemCount: items.length,
    );
  }
}
