class NewsItem {
  const NewsItem({
    required this.title,
    required this.dateLabel,
    required this.url,
    this.id = '',
    this.summary = '',
    this.content = '',
    this.imageUrl,
  });

  final String id;
  final String title;
  final String dateLabel;
  final String url;
  final String summary;
  final String content;
  final String? imageUrl;

  bool get hasDetails => summary.trim().isNotEmpty || content.trim().isNotEmpty;

  NewsItem mergeDetails(NewsItem? details) {
    if (details == null) return this;

    return NewsItem(
      id: details.id.isNotEmpty ? details.id : id,
      title: details.title.isNotEmpty ? details.title : title,
      dateLabel: details.dateLabel.isNotEmpty ? details.dateLabel : dateLabel,
      url: details.url.isNotEmpty ? details.url : url,
      summary: details.summary.isNotEmpty ? details.summary : summary,
      content: details.content.isNotEmpty ? details.content : content,
      imageUrl: details.imageUrl ?? imageUrl,
    );
  }
}

class Player {
  const Player({
    required this.number,
    required this.name,
    required this.profileUrl,
    required this.imageUrl,
    this.id = '',
    this.role = '',
    this.biography = '',
  });

  final String id;
  final String number;
  final String name;
  final String profileUrl;
  final String imageUrl;
  final String role;
  final String biography;
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
    this.email = '',
    this.phone = '',
    this.palmares = const [],
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
