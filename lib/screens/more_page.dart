import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/team_config.dart';
import '../models/team_content.dart';
import '../widgets/section_header.dart';

class MorePage extends StatelessWidget {
  const MorePage({
    required this.dashboard,
    required this.config,
    super.key,
  });

  final TeamDashboard dashboard;
  final TeamSiteConfig config;

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final info = dashboard.clubInfo;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 180.0,
          floating: false,
          pinned: true,
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [
              StretchMode.zoomBackground,
              StretchMode.blurBackground,
            ],
            title: Text(
              'ALTRO',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            centerTitle: true,
            background: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primary,
                        colorScheme.secondary,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Opacity(
                    opacity: 0.15,
                    child: Icon(
                      Icons.info_outline,
                      size: 200,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SectionHeader(
              title: 'Il Club',
              color: colorScheme.primary,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _InfoCard(
                icon: Icons.stadium_outlined,
                title: 'Arena',
                subtitle: info.arena,
              ),
              _InfoCard(
                icon: Icons.email_outlined,
                title: 'Email',
                subtitle: info.email,
                onTap: () => _launchUrl('mailto:${info.email}'),
              ),
              _InfoCard(
                icon: Icons.phone_outlined,
                title: 'Telefono',
                subtitle: info.phone,
                onTap: () => _launchUrl('tel:${info.phone}'),
              ),
            ]),
          ),
        ),
        if (info.palmares.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Palmarès',
              color: colorScheme.primary,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: info.palmares
                    .map((item) => Chip(
                          label: Text(item),
                          backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.4),
                          side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.1)),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
        SliverToBoxAdapter(
          child: SectionHeader(
            title: 'Link & Social',
            color: colorScheme.primary,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _InfoCard(
                icon: Icons.public,
                title: 'Sito Ufficiale',
                subtitle: dashboard.sourceUrl,
                onTap: () => _launchUrl(dashboard.sourceUrl),
              ),
              _InfoCard(
                icon: Icons.share,
                title: 'Condividi l\'App',
                subtitle: 'Invia ai tuoi amici tifosi',
                onTap: () {
                  // Integration for sharing could go here
                },
              ),
            ]),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  config.appTitle.toUpperCase(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    final version = snapshot.hasData 
                        ? 'Versione ${snapshot.data!.version} (${snapshot.data!.buildNumber})'
                        : 'Versione ...';
                    return Text(
                      version,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Icon(
                  Icons.sports_basketball,
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  size: 32,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.5)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.hintColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  color: theme.hintColor.withValues(alpha: 0.5),
                  size: 14,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
