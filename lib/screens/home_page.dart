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
    final theme = Theme.of(context);
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
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                config.appTitle.toUpperCase(),
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(config.primaryColor),
                      Color(config.secondaryColor),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: NextGameCard(game: nextGame, config: config),
            ),
          ),
          SliverToBoxAdapter(
            child: _SectionHeader(title: 'Ultime news', color: Color(config.primaryColor)),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: NewsTile(item: dashboard.news[index]),
                ),
                childCount: dashboard.news.take(3).length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _SectionHeader(title: 'Ultimi highlights', color: Color(config.primaryColor)),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: latestHighlights.isEmpty
                  ? const Card(
                      child: ListTile(
                        leading: Icon(Icons.play_circle_outline),
                        title: Text('Nessun highlight disponibile'),
                      ),
                    )
                  : Column(
                      children: latestHighlights
                          .map(
                            (game) => Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: Icon(Icons.play_circle_fill, color: Color(config.primaryColor)),
                                title: Text(
                                  '${game.homeTeam} vs ${game.awayTeam}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(game.dateLabel),
                                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: FilledButton.tonal(
                onPressed: () {},
                child: const Text('VAI ALLA CLASSIFICA'),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _SectionHeader(title: 'Palmarès', color: Color(config.primaryColor)),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
            sliver: SliverToBoxAdapter(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: dashboard.clubInfo.palmares
                    .map((item) => Chip(
                          label: Text(
                            item,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          backgroundColor: theme.colorScheme.surfaceContainerHighest,
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.color});

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
          ),
        ],
      ),
    );
  }
}
