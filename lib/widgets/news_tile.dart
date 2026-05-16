import 'package:flutter/material.dart';

import '../models/team_content.dart';
import '../utils/link_launcher.dart';

class NewsTile extends StatelessWidget {
  const NewsTile({required this.item, super.key});

  final NewsItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(item.title),
        subtitle: item.dateLabel.isEmpty ? null : Text(item.dateLabel),
        trailing: const Icon(Icons.open_in_new),
        onTap: () => openExternalUrl(item.url),
      ),
    );
  }
}
