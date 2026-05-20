class NewsItem {
  const NewsItem({
    required this.title,
    required this.dateLabel,
    required this.url,
  });

  final String title;
  final String dateLabel;
  final String url;
}

class Player {
  const Player({
    required this.number,
    required this.name,
    required this.profileUrl,
  });

  final String number;
  final String name;
  final String profileUrl;
}

enum GameStatus { scheduled, live, completed }

class Game {
  const Game({
    required this.competition,
    required this.dateLabel,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.status,
    this.venueUrl,
    this.streamUrl,
    this.boxScoreUrl,
    this.highlightsUrl,
  });

  final String competition;
  final String dateLabel;
  final String homeTeam;
  final String awayTeam;
  final int? homeScore;
  final int? awayScore;
  final GameStatus status;
  final String? venueUrl;
  final String? streamUrl;
  final String? boxScoreUrl;
  final String? highlightsUrl;

  bool involves(String teamKeyword) {
    final normalizedKeyword = teamKeyword.toLowerCase();
    return homeTeam.toLowerCase().contains(normalizedKeyword) ||
        awayTeam.toLowerCase().contains(normalizedKeyword);
  }
}

class ClubInfo {
  const ClubInfo({
    required this.name,
    required this.arena,
    required this.email,
    required this.phone,
    required this.palmares,
  });

  final String name;
  final String arena;
  final String email;
  final String phone;
  final List<String> palmares;
}

class StaffMember {
  const StaffMember({
    required this.name,
    required this.role,
    required this.profileUrl,
  });

  final String name;
  final String role;
  final String profileUrl;
}

class MediaItem {
  const MediaItem({
    required this.id,
    required this.title,
    required this.url,
    this.dateLabel = '',
  });

  final String id;
  final String title;
  final String url;
  final String dateLabel;
}

class StandingRow {
  const StandingRow({
    required this.teamName,
    required this.points,
    required this.played,
  });

  final String teamName;
  final int points;
  final int played;
}

class TeamProfile {
  const TeamProfile({
    required this.name,
    required this.arena,
    required this.city,
    required this.websiteUrl,
  });

  final String name;
  final String arena;
  final String city;
  final String websiteUrl;
}

class TeamDashboard {
  const TeamDashboard({
    required this.news,
    required this.games,
    required this.players,
    required this.clubInfo,
    required this.sourceUrl,
    required this.updatedAt,
  });

  final List<NewsItem> news;
  final List<Game> games;
  final List<Player> players;
  final ClubInfo clubInfo;
  final String sourceUrl;
  final DateTime updatedAt;
}
