import 'package:flutter/material.dart';

import '../models/team_content.dart';

class NewsTile extends StatelessWidget {
  const NewsTile({required this.item, super.key});

  final NewsItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(item.title),
        subtitle: item.dateLabel.isEmpty ? null : Text(item.dateLabel),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => _NewsDetailsPage(item: item),
            ),
          );
        },
      ),
    );
  }
}

class _NewsDetailsPage extends StatelessWidget {
  const _NewsDetailsPage({required this.item});

  final NewsItem item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dettaglio notizia')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            if (item.dateLabel.isNotEmpty) Text('Data: ${item.dateLabel}'),
            const SizedBox(height: 12),
            Text('Riferimento backend: ${item.url}'),
          ],
        ),
      ),
    );
  }
}
