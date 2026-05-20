import 'package:flutter/material.dart';

import '../config/team_config.dart';
import '../models/team_content.dart';
import '../widgets/news_tile.dart';
import '../widgets/next_game_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    required this.dashboard,
    required this.config,
    required this.onRefresh,
    super.key,
  });

  final TeamDashboard dashboard;
  final TeamSiteConfig config;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final nextGame = dashboard.games.firstWhere(
      (game) => game.status == GameStatus.scheduled,
      orElse: () => dashboard.games.first,
    );

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          NextGameCard(game: nextGame, config: config),
          const SizedBox(height: 16),
          Text(
            'Ultime news',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ...dashboard.news.take(3).map((item) => NewsTile(item: item)),
          const SizedBox(height: 16),
          Text(
            'Palmarès',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: dashboard.clubInfo.palmares
                .map((item) => Chip(label: Text(item)))
                .toList(),
          ),
        ],
      ),
    );
  }
}
