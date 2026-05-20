import 'package:flutter/material.dart';

import '../models/team_content.dart';

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
            if (game.streamUrl != null || game.boxScoreUrl != null || game.highlightsUrl != null || game.venueUrl != null) ...[
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => _GameDetailsPage(game: game),
                    ),
                  );
                },
                icon: const Icon(Icons.info_outline),
                label: const Text('Dettagli partita'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _GameDetailsPage extends StatelessWidget {
  const _GameDetailsPage({required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dettagli partita')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('${game.homeTeam} - ${game.awayTeam}', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('Competizione: ${game.competition}'),
          Text('Data: ${game.dateLabel}'),
          Text('Punteggio: ${game.homeScore ?? '-'} - ${game.awayScore ?? '-'}'),
          if (game.streamUrl != null) Text('Diretta (backend): ${game.streamUrl}'),
          if (game.boxScoreUrl != null) Text('Tabellino (backend): ${game.boxScoreUrl}'),
          if (game.highlightsUrl != null) Text('Highlights (backend): ${game.highlightsUrl}'),
          if (game.venueUrl != null) Text('Venue (backend): ${game.venueUrl}'),
        ],
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
