import 'package:flutter/material.dart';

import '../config/team_config.dart';
import '../models/team_content.dart';

class RecentGamesCarousel extends StatefulWidget {
  const RecentGamesCarousel({
    required this.games,
    required this.config,
    super.key,
  });

  final List<Game> games;
  final TeamSiteConfig config;

  @override
  State<RecentGamesCarousel> createState() => _RecentGamesCarouselState();
}

class _RecentGamesCarouselState extends State<RecentGamesCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final games = widget.games.take(3).toList(growable: false);

    if (games.isEmpty) {
      return Card(
        child: ListTile(
          leading: Icon(
            Icons.sports_basketball_outlined,
            color: Color(widget.config.primaryColor),
          ),
          title: const Text('Nessuna partita conclusa disponibile'),
          subtitle:
              const Text('Torna più tardi per vedere gli ultimi risultati.'),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 420,
          child: PageView.builder(
            itemCount: games.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: RecentGameResultCard(
                game: games[index],
                config: widget.config,
              ),
            ),
          ),
        ),
        if (games.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              games.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: _currentIndex == index ? 24 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? Color(widget.config.primaryColor)
                      : Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class RecentGameResultCard extends StatelessWidget {
  const RecentGameResultCard({
    required this.game,
    required this.config,
    super.key,
  });

  final Game game;
  final TeamSiteConfig config;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = Color(config.primaryColor);
    final homeScore = game.homeScore?.toString() ?? '-';
    final awayScore = game.awayScore?.toString() ?? '-';

    return Semantics(
      label:
          '${game.competition}, ${game.dateLabel}, ${game.homeTeam} $homeScore - $awayScore ${game.awayTeam}',
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              color: primaryColor,
              child: Text(
                game.competition.toUpperCase(),
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 26, 18, 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      game.dateLabel,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 34),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _TeamMark(
                            name: game.homeTeam,
                            primaryColor: primaryColor,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '$homeScore - $awayScore',
                                maxLines: 1,
                                style: theme.textTheme.displayLarge?.copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w900,
                                  height: 0.95,
                                  letterSpacing: -2.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: _TeamMark(
                            name: game.awayTeam,
                            primaryColor: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 34),
                    Text(
                      '${game.homeTeam}  vs  ${game.awayTeam}'.toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamMark extends StatelessWidget {
  const _TeamMark({required this.name, required this.primaryColor});

  final String name;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    final initials = _teamInitials(name);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: primaryColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Text(
              initials,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }

  String _teamInitials(String value) {
    final words = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList(growable: false);
    if (words.isEmpty) return 'BK';
    if (words.length == 1) {
      final end = words.first.length < 3 ? words.first.length : 3;
      return words.first.substring(0, end).toUpperCase();
    }
    return words
        .take(2)
        .map((word) => word.substring(0, 1))
        .join()
        .toUpperCase();
  }
}
