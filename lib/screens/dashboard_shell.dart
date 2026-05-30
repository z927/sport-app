import 'package:flutter/material.dart';

import '../config/team_config.dart';
import '../models/team_content.dart';
import '../services/team_content_repository.dart';
import 'home_page.dart';
import 'live_page.dart';
import 'more_page.dart';
import 'news_page.dart';
import 'team_page.dart';

class DashboardShell extends StatefulWidget {
  const DashboardShell({required this.config, super.key});

  final TeamSiteConfig config;

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  late final TeamContentRepository _repository;
  late Future<TeamDashboard> _dashboard;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _repository = TeamContentRepository(config: widget.config);
    _dashboard = _repository.loadDashboard();
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }

  void _refresh() {
    setState(() {
      _dashboard = _repository.loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TeamDashboard>(
      future: _dashboard,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text(widget.config.appTitle)),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Errore durante il caricamento: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refresh,
                    child: const Text('Riprova'),
                  ),
                ],
              ),
            ),
          );
        }

        if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text(widget.config.appTitle)),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final dashboard = snapshot.data!;
        final pages = [
          HomePage(
            dashboard: dashboard,
            config: widget.config,
            onRefresh: _refresh,
          ),
          NewsPage(items: dashboard.news),
          LivePage(games: dashboard.games),
          TeamPage(players: dashboard.players),
          MorePage(dashboard: dashboard, config: widget.config),
        ];

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.config.appTitle),
            actions: [
              IconButton(
                tooltip: 'Aggiorna',
                onPressed: _refresh,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: pages[_selectedIndex],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() => _selectedIndex = index);
            },
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.article_outlined), label: 'News'),
              NavigationDestination(icon: Icon(Icons.sports_basketball), label: 'Live'),
              NavigationDestination(icon: Icon(Icons.groups_outlined), label: 'Team'),
              NavigationDestination(icon: Icon(Icons.more_horiz), label: 'Più'),
            ],
          ),
        );
      },
    );
  }
}
