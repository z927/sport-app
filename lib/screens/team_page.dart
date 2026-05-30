import 'package:flutter/material.dart';
import '../models/team_content.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({required this.players, super.key});

  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final player = players[index];
                return _PlayerCard(player: player);
              },
              childCount: players.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _PlayerCard extends StatelessWidget {
  const _PlayerCard({required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => _PlayerDetailsPage(player: player),
            ),
          );
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Player Image
            if (player.imageUrl.isNotEmpty)
              Hero(
                tag: 'player_image_${player.number}',
                child: Image.network(
                  player.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: colorScheme.surfaceContainerHighest,
                    child: Icon(Icons.person, size: 64, color: colorScheme.onSurfaceVariant),
                  ),
                ),
              )
            else
              Container(
                color: colorScheme.surfaceContainerHighest,
                child: Icon(Icons.person, size: 64, color: colorScheme.onSurfaceVariant),
              ),

            // Gradient Overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.1),
                      Colors.black.withValues(alpha: 0.8),
                    ],
                    stops: const [0.6, 0.8, 1.0],
                  ),
                ),
              ),
            ),

            // Player Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '#${player.number}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          player.role.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white70,
                            letterSpacing: 1.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    player.name.split(' ').join('\n').toUpperCase(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      fontSize: 18,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerDetailsPage extends StatelessWidget {
  const _PlayerDetailsPage({required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                player.name.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                ),
              ),
              background: Hero(
                tag: 'player_image_${player.number}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (player.imageUrl.isNotEmpty)
                      Image.network(
                        player.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: colorScheme.surfaceContainerHighest,
                          child: const Icon(Icons.person, size: 120),
                        ),
                      )
                    else
                      Container(
                        color: colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.person, size: 120),
                      ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black54],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _infoChip(context, 'Numero', '#${player.number}'),
                        const SizedBox(width: 12),
                        _infoChip(context, 'Ruolo', player.role),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'BIOGRAFIA',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Informazioni dettagliate su ${player.name} non disponibili in questa vista. Visita il profilo completo per maggiori dettagli.',
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                    ),
                    const SizedBox(height: 32),
                    OutlinedButton.icon(
                      onPressed: () {
                        // In a real app, use url_launcher
                      },
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('PROFILO COMPLETO'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
