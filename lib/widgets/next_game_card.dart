import 'package:flutter/material.dart';

import '../config/team_config.dart';
import '../models/team_content.dart';

class NextGameCard extends StatelessWidget {
  const NextGameCard({required this.game, required this.config, super.key});

  final Game game;
  final TeamSiteConfig config;

  String _shortLabel(String team) {
    final parts = team.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, parts.first.length.clamp(0, 3)).toUpperCase();
    }
    return parts.take(2).map((part) => part.substring(0, 1).toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [Color(config.primaryColor), Color(config.secondaryColor)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),✨
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NEXTGAME',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white70,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white,
                      child: Text(
                        _shortLabel(game.homeTeam),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Color(config.primaryColor),
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      game.homeTeam,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              Text(
                'VS',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Expanded(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white,
                      child: Text(
                        _shortLabel(game.awayTeam),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Color(config.primaryColor),
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      game.awayTeam,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            game.dateLabel,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
