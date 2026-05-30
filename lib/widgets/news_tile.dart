import 'package:flutter/material.dart';

import '../models/team_content.dart';

class NewsTile extends StatelessWidget {
  const NewsTile({
    required this.item,
    this.isAlternate = false,
    super.key,
  });

  final NewsItem item;
  final bool isAlternate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final backgroundColor = isAlternate ? colorScheme.primary : colorScheme.surface;
    final textColor = isAlternate ? colorScheme.onPrimary : colorScheme.onSurface;
    final dateColor = isAlternate ? colorScheme.onPrimary.withOpacity(0.8) : colorScheme.primary;
    final buttonColor = isAlternate ? colorScheme.onPrimary : colorScheme.primary;
    final buttonTextColor = isAlternate ? colorScheme.primary : colorScheme.onPrimary;

    return Card(
      elevation: isAlternate ? 4 : 0,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: isAlternate
            ? BorderSide.none
            : BorderSide(
                color: colorScheme.outlineVariant.withOpacity(0.5),
              ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _navigateToDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.dateLabel.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: dateColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.dateLabel.toUpperCase(),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: dateColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              Text(
                item.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _navigateToDetails(context),
                    style: TextButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: buttonTextColor,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'LEGGI',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _NewsDetailsPage(item: item),
      ),
    );
  }
}

class _NewsDetailsPage extends StatelessWidget {
  const _NewsDetailsPage({required this.item});

  final NewsItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(
              'NEWS',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            centerTitle: true,
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.primary,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.dateLabel.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_month, size: 16, color: colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            item.dateLabel.toUpperCase(),
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                  Text(
                    item.title,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 32),
                  Text(
                    'Questa è una versione demo del contenuto della notizia. '
                    'In un\'applicazione reale, qui verrebbe visualizzato il testo completo dell\'articolo, '
                    'comprese eventuali immagini, video e link correlati.\n\n'
                    'Resta aggiornato su tutte le ultime novità della tua squadra del cuore attraverso '
                    'l\'integrazione diretta con il nostro portale ufficiale.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.8,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('LEGGI ARTICOLO COMPLETO'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
