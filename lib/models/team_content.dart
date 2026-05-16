class NewsItem {
  const NewsItem({
    required this.title,
    required this.dateLabel,
    required this.url,
  });

  final String title;
  final String dateLabel;
  final Uri url;
}

class Player {
  const Player({
    required this.number,
    required this.name,
    required this.profileUrl,
  });

  final String number;
  final String name;
  final Uri profileUrl;
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
  final Uri? venueUrl;
  final Uri? streamUrl;
  final Uri? boxScoreUrl;
  final Uri? highlightsUrl;

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
  final Uri sourceUrl;
  final DateTime updatedAt;
}
