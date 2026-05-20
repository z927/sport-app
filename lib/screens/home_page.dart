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
    final latestHighlights = dashboard.games
        .where((game) => game.status == GameStatus.completed)
        .take(5)
        .toList();

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
            'Ultimi highlights',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          if (latestHighlights.isEmpty)
            const ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.play_circle_outline),
              title: Text('Nessun highlight disponibile al momento'),
            )
          else
            ...latestHighlights.map(
              (game) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.play_circle_outline),
                title: Text('${game.homeTeam} vs ${game.awayTeam}'),
                subtitle: Text(game.dateLabel),
              ),
            ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: null,
              child: const Text('Vai alla classifica'),
            ),
          ),
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
