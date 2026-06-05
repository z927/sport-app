import 'package:flutter/material.dart';
import '../config/team_config.dart';
import '../models/team_content.dart';
import '../widgets/news_tile.dart';
import '../widgets/next_game_card.dart';
import '../widgets/recent_games_carousel.dart';
import '../widgets/section_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    required this.dashboard,
    required this.config,
    required this.onRefresh,
    this.loadNewsDetails,
    super.key,
  });

  final TeamDashboard dashboard;
  final TeamSiteConfig config;
  final VoidCallback onRefresh;
  final Future<NewsItem?> Function(String newsId)? loadNewsDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nextGame = dashboard.games.firstWhere(
      (game) => game.status == GameStatus.scheduled,
      orElse: () => dashboard.games.first,
    );
    final recentCompletedGames = _recentCompletedGames(dashboard.games);

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
            child: SectionHeader(
                title: 'Ultime news', color: Color(config.primaryColor)),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: NewsTile(
                    item: dashboard.news[index],
                    isAlternate: index % 2 != 0,
                    loadDetails: loadNewsDetails,
                  ),
                ),
                childCount: dashboard.news.take(3).length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Ultime partite',
              color: Color(config.primaryColor),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: RecentGamesCarousel(
                games: recentCompletedGames,
                config: config,
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
            child: _SectionHeader(
                title: 'Palmarès', color: Color(config.primaryColor)),
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
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
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

List<Game> _recentCompletedGames(List<Game> games) {
  final completedGames = games
      .where((game) => game.status == GameStatus.completed)
      .toList(growable: false);

  return completedGames
    ..sort((a, b) {
      final aDate = _parseGameDate(a.dateLabel);
      final bDate = _parseGameDate(b.dateLabel);
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return bDate.compareTo(aDate);
    });
}

DateTime? _parseGameDate(String label) {
  final normalized = label.trim();
  final isoDate = DateTime.tryParse(normalized);
  if (isoDate != null) return isoDate;

  final numericMatch = RegExp(
    r'(\d{1,2})[./-](\d{1,2})[./-](\d{4})',
  ).firstMatch(normalized);
  if (numericMatch != null) {
    final day = int.parse(numericMatch.group(1)!);
    final month = int.parse(numericMatch.group(2)!);
    final year = int.parse(numericMatch.group(3)!);
    return DateTime(year, month, day);
  }

  final monthMatch = RegExp(
    r'(\d{1,2})\s+(gen|feb|mar|apr|mag|giu|lug|ago|set|ott|nov|dic)(?:\s+(\d{4}))?',
    caseSensitive: false,
  ).firstMatch(normalized);
  if (monthMatch == null) return null;

  const months = {
    'gen': 1,
    'feb': 2,
    'mar': 3,
    'apr': 4,
    'mag': 5,
    'giu': 6,
    'lug': 7,
    'ago': 8,
    'set': 9,
    'ott': 10,
    'nov': 11,
    'dic': 12,
  };
  final day = int.parse(monthMatch.group(1)!);
  final month = months[monthMatch.group(2)!.toLowerCase()];
  final year = int.tryParse(monthMatch.group(3) ?? '');
  if (month == null || year == null) return null;

  return DateTime(year, month, day);
}
