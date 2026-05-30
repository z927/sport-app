import 'package:flutter/material.dart';

import '../config/team_config.dart';
import '../models/team_content.dart';

class MorePage extends StatelessWidget {
  const MorePage({
    required this.dashboard,
    required this.config,
    super.key,
  });

  final TeamDashboard dashboard;
  final TeamSiteConfig config;

  @override
  Widget build(BuildContext context) {
    final info = dashboard.clubInfo;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.stadium_outlined),
          title: Text(info.name),
          subtitle: Text(info.arena),
        ),
        ListTile(
          leading: const Icon(Icons.email_outlined),
          title: Text(info.email),
          subtitle: const Text('Contatto disponibile in-app'),
        ),
        ListTile(
          leading: const Icon(Icons.phone_outlined),
          title: Text(info.phone),
          subtitle: const Text('Contatto disponibile in-app'),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.public),
          title: const Text('Sito ufficiale'),
          subtitle: Text(dashboard.sourceUrl),
        ),
      ],
    );
  }
}
