import 'package:flutter/material.dart';

import '../models/team_content.dart';
import '../utils/link_launcher.dart';

class GameCard extends StatelessWidget {
  const GameCard({required this.game, super.key});

  final Game game;

  @override
  Widget build(BuildContext context) {
    final status = switch (game.status) {
      GameStatus.scheduled => 'In programma',
      GameStatus.live => 'Live',
      GameStatus.completed => 'Finale',
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(label: Text(status)),
                Text(game.dateLabel),
              ],
            ),
            const SizedBox(height: 12),
            _ScoreLine(team: game.homeTeam, score: game.homeScore),
            const SizedBox(height: 8),
            _ScoreLine(team: game.awayTeam, score: game.awayScore),
            if (game.streamUrl != null || game.boxScoreUrl != null) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  if (game.streamUrl != null)
                    OutlinedButton.icon(
                      onPressed: () => openExternalUrl(game.streamUrl!),
                      icon: const Icon(Icons.live_tv),
                      label: const Text('Diretta'),
                    ),
                  if (game.boxScoreUrl != null)
                    OutlinedButton.icon(
                      onPressed: () => openExternalUrl(game.boxScoreUrl!),
                      icon: const Icon(Icons.scoreboard_outlined),
                      label: const Text('Tabellino'),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ScoreLine extends StatelessWidget {
  const _ScoreLine({required this.team, required this.score});

  final String team;
  final int? score;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(team, style: Theme.of(context).textTheme.titleMedium),
        ),
        Text('${score ?? '-'}', style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}
