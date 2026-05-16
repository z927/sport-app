import 'package:flutter/material.dart';

import '../models/team_content.dart';
import '../widgets/game_card.dart';

class LivePage extends StatelessWidget {
  const LivePage({required this.games, super.key});

  final List<Game> games;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: games.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => GameCard(game: games[index]),
    );
  }
}
