import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/team_content.dart';

class NewsTile extends StatelessWidget {
  const NewsTile({
    required this.item,
    this.isAlternate = false,
    this.loadDetails,
    super.key,
  });

  final NewsItem item;
  final bool isAlternate;
  final Future<NewsItem?> Function(String newsId)? loadDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor =
        isAlternate ? colorScheme.primary : colorScheme.surface;
    final textColor = isAlternate
        ? colorScheme.onPrimary
        : (isDark ? colorScheme.onSurface : colorScheme.primary);
    final dateColor = isAlternate
        ? colorScheme.onPrimary.withValues(alpha: 0.8)
        : (isDark ? colorScheme.onSurfaceVariant : colorScheme.primary);

    final buttonColor = isAlternate
        ? Colors.white
        : (isDark ? colorScheme.primaryContainer : colorScheme.primary);
    final buttonTextColor = isAlternate
        ? colorScheme.primary
        : (isDark ? colorScheme.onPrimaryContainer : colorScheme.onPrimary);

    return Card(
      elevation: isAlternate ? 4 : 2,
      color: backgroundColor,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: isAlternate
            ? BorderSide.none
            : BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _navigateToDetails(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.imageUrl != null)
              Hero(
                tag: 'news_image_${item.url}',
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    item.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: Icon(Icons.image_not_supported,
                          color: colorScheme.outline),
                    ),
                  ),
                ),
              ),
            Padding(
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
                  if (item.summary.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      item.summary,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isAlternate
                            ? colorScheme.onPrimary.withValues(alpha: 0.86)
                            : colorScheme.onSurfaceVariant,
                        height: 1.45,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => _navigateToDetails(context),
                        style: TextButton.styleFrom(
                          backgroundColor: buttonColor,
                          foregroundColor: buttonTextColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: const StadiumBorder(),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'LEGGI',
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
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
          ],
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NewsDetailsPage(
          item: item,
          loadDetails: loadDetails,
        ),
      ),
    );
  }
}

class NewsDetailsPage extends StatelessWidget {
  const NewsDetailsPage({
    required this.item,
    this.loadDetails,
    super.key,
  });

  final NewsItem item;
  final Future<NewsItem?> Function(String newsId)? loadDetails;

  @override
  Widget build(BuildContext context) {
    final detailFuture =
        item.id.isEmpty || loadDetails == null ? null : loadDetails!(item.id);

    return Scaffold(
      body: detailFuture == null
          ? _NewsDetailsContent(item: item)
          : FutureBuilder<NewsItem?>(
              future: detailFuture,
              builder: (context, snapshot) {
                final detailedItem = item.mergeDetails(snapshot.data);
                return _NewsDetailsContent(
                  item: detailedItem,
                  isLoading:
                      snapshot.connectionState == ConnectionState.waiting,
                  hasError: snapshot.hasError,
                );
              },
            ),
    );
  }
}

class _NewsDetailsContent extends StatelessWidget {
  const _NewsDetailsContent({
    required this.item,
    this.isLoading = false,
    this.hasError = false,
  });

  final NewsItem item;
  final bool isLoading;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final paragraphs = item.content
        .split(RegExp(r'\n\s*\n'))
        .map((paragraph) => paragraph.trim())
        .where((paragraph) => paragraph.isNotEmpty)
        .toList();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: item.imageUrl != null ? 320 : 160,
          pinned: true,
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              'NEWS',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color:
                    item.imageUrl != null ? Colors.white : colorScheme.primary,
                shadows: item.imageUrl != null
                    ? [
                        const Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black54,
                        ),
                      ]
                    : null,
              ),
            ),
            centerTitle: true,
            background: item.imageUrl != null
                ? Hero(
                    tag: 'news_image_${item.url}',
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          item.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: colorScheme.surfaceContainerHighest,
                            child: Icon(Icons.image_not_supported,
                                color: colorScheme.outline),
                          ),
                        ),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black26,
                                Colors.black87,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primary.withValues(alpha: 0.12),
                          colorScheme.surface,
                        ],
                      ),
                    ),
                  ),
          ),
          backgroundColor: colorScheme.surface,
          foregroundColor:
              item.imageUrl != null ? Colors.white : colorScheme.primary,
        ),
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _NewsMetaRow(item: item),
                    const SizedBox(height: 24),
                    Text(
                      item.title,
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        height: 1.08,
                        letterSpacing: -1,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (item.summary.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _SectionLabel(
                        icon: Icons.short_text_rounded,
                        label: 'Sommario',
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item.summary,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.55,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),
                    Divider(color: colorScheme.outlineVariant),
                    if (isLoading) ...[
                      const SizedBox(height: 28),
                      const _NewsContentSkeleton(),
                    ] else if (paragraphs.isNotEmpty) ...[
                      const SizedBox(height: 28),
                      _SectionLabel(
                        icon: Icons.article_outlined,
                        label: 'Articolo',
                      ),
                      const SizedBox(height: 14),
                      Semantics(
                        label: 'Contenuto completo della notizia',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: paragraphs
                              .map(
                                (paragraph) => Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    paragraph,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: colorScheme.onSurface,
                                      height: 1.75,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 28),
                      _MissingContentCard(hasError: hasError),
                    ],
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: item.url.isEmpty
                            ? null
                            : () => _openArticle(context, item.url),
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('LEGGI ARTICOLO ORIGINALE'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: const StadiumBorder(),
                          textStyle: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openArticle(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;

    final messenger = ScaffoldMessenger.of(context);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      messenger.showSnackBar(
        const SnackBar(
            content: Text('Impossibile aprire il link della notizia.')),
      );
    }
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }
}

class _NewsMetaRow extends StatelessWidget {
  const _NewsMetaRow({required this.item});

  final NewsItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        if (item.dateLabel.isNotEmpty)
          _MetaChip(
            icon: Icons.calendar_month,
            label: item.dateLabel.toUpperCase(),
          ),
        _MetaChip(
          icon: item.hasDetails ? Icons.article : Icons.travel_explore,
          label: item.hasDetails ? 'CONTENUTO COMPLETO' : 'ANTEPRIMA NEWS',
        ),
        DecoratedBox(
            decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(999),
        )),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.18)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewsContentSkeleton extends StatelessWidget {
  const _NewsContentSkeleton();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        4,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SizedBox(
              height: 18,
              width: index == 3 ? 220 : double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}

class _MissingContentCard extends StatelessWidget {
  const _MissingContentCard({required this.hasError});

  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              hasError ? Icons.cloud_off_outlined : Icons.article_outlined,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                hasError
                    ? 'Non siamo riusciti a recuperare il testo completo. Puoi comunque aprire l’articolo originale.'
                    : 'Il testo completo non è ancora disponibile per questa notizia. Apri l’articolo originale per continuare la lettura.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
