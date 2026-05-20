import '../models/team_content.dart';

class TeamSiteConfig {
  const TeamSiteConfig({
    required this.appTitle,
    required this.teamKeyword,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backendBaseUrl,
    required this.seedDashboard,
    required this.seedStaff,
    required this.seedVideos,
    required this.seedPhotos,
    required this.seedStandings,
    required this.seedTeamProfile,
  });

  final String appTitle;
  final String teamKeyword;
  final int primaryColor;
  final int secondaryColor;
  final String backendBaseUrl;
  final TeamDashboard seedDashboard;
  final List<StaffMember> seedStaff;
  final List<MediaItem> seedVideos;
  final List<MediaItem> seedPhotos;
  final List<StandingRow> seedStandings;
  final TeamProfile seedTeamProfile;

  TeamSiteConfig copyWith({
    String? appTitle,
    String? teamKeyword,
    int? primaryColor,
    int? secondaryColor,
    String? homeUrl,
    String? ticketingUrl,
    String? backendBaseUrl,
    TeamDashboard? seedDashboard,
    List<StaffMember>? seedStaff,
    List<MediaItem>? seedVideos,
    List<MediaItem>? seedPhotos,
    List<StandingRow>? seedStandings,
    TeamProfile? seedTeamProfile,
  }) {
    return TeamSiteConfig(
      appTitle: appTitle ?? this.appTitle,
      teamKeyword: teamKeyword ?? this.teamKeyword,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      backendBaseUrl: backendBaseUrl ?? this.backendBaseUrl,
      seedDashboard: seedDashboard ?? this.seedDashboard,
      seedStaff: seedStaff ?? this.seedStaff,
      seedVideos: seedVideos ?? this.seedVideos,
      seedPhotos: seedPhotos ?? this.seedPhotos,
      seedStandings: seedStandings ?? this.seedStandings,
      seedTeamProfile: seedTeamProfile ?? this.seedTeamProfile,
    );
  }
}

final defaultTeamConfig = TeamSiteConfig(
  appTitle: 'Varese Basket',
  teamKeyword: 'Varese',
  primaryColor: 0xFFE30613,
  secondaryColor: 0xFF8B0008,
  backendBaseUrl: 'http://localhost:3000',
  seedDashboard: TeamDashboard(
    news: const [
      NewsItem(
        title: 'ATTIVE LE PREVENDITE PER VARESE-CREMONA',
        dateLabel: '01/04/2026',
        url: 'https://www.pallacanestrovarese.it/news',
      ),
      NewsItem(
        title: "LBA 25-26. UFFICIALE L'ORARIO DELLA VENTOTTESIMA GIORNATA",
        dateLabel: '01/04/2026',
        url: 'https://www.pallacanestrovarese.it/news',
      ),
      NewsItem(
        title: 'VARESE DA URLO: SUCCESSO CASALINGO CONTRO TORTONA',
        dateLabel: '28/03/2026',
        url: 'https://www.pallacanestrovarese.it/news',
      ),
    ],
    games: const [
      Game(
        competition: 'Campionato',
        dateLabel: '28.03.2026 / 18:30',
        homeTeam: 'Varese',
        awayTeam: 'Derthona',
        homeScore: 97,
        awayScore: 87,
        status: GameStatus.completed,
        boxScoreUrl: 'https://www.pallacanestrovarese.it/',
      ),
      Game(
        competition: 'Campionato',
        dateLabel: '04.04.2026 / 19:00',
        homeTeam: 'Trieste',
        awayTeam: 'Varese',
        homeScore: 0,
        awayScore: 0,
        status: GameStatus.scheduled,
        streamUrl: 'https://www.lbatv.com/',
      ),
      Game(
        competition: 'Campionato',
        dateLabel: '12.04.2026 / 17:30',
        homeTeam: 'Varese',
        awayTeam: 'Sassari',
        homeScore: 0,
        awayScore: 0,
        status: GameStatus.scheduled,
      ),
    ],
    players: const [
      Player(number: '1', name: 'CARLOS STEWART JR.', profileUrl: 'https://www.pallacanestrovarese.it/squadra'),
      Player(number: '2', name: 'DAVIDE ALVITI', profileUrl: 'https://www.pallacanestrovarese.it/squadra'),
      Player(number: '4', name: 'TAZÉ MOORE', profileUrl: 'https://www.pallacanestrovarese.it/squadra'),
      Player(number: '5', name: 'MAURO VILLA', profileUrl: 'https://www.pallacanestrovarese.it/squadra'),
      Player(number: '7', name: 'ELISÉE ASSUI', profileUrl: 'https://www.pallacanestrovarese.it/squadra'),
      Player(number: '8', name: 'OLIVIER NKAMHOUA', profileUrl: 'https://www.pallacanestrovarese.it/squadra'),
      Player(number: '11', name: 'IKE IROEGBU', profileUrl: 'https://www.pallacanestrovarese.it/squadra'),
      Player(number: '13', name: 'MATTEO LIBRIZZI', profileUrl: 'https://www.pallacanestrovarese.it/squadra'),
      Player(number: '15', name: 'NATE RENFRO', profileUrl: 'https://www.pallacanestrovarese.it/squadra'),
      Player(number: '19', name: 'MARCO BERGAMIN', profileUrl: 'https://www.pallacanestrovarese.it/squadra'),
      Player(number: '34', name: 'MAXIMILIAN LADURNER', profileUrl: 'https://www.pallacanestrovarese.it/squadra'),
      Player(number: '55', name: 'ALLERIK FREEMAN', profileUrl: 'https://www.pallacanestrovarese.it/squadra'),
    ],
    clubInfo: const ClubInfo(
      name: 'Pallacanestro Varese',
      arena: 'Itelyum Arena',
      email: 'info@pallacanestrovarese.it',
      phone: '0332 240 990',
      palmares: [
        '10 Scudetti',
        '5 Coppe Campioni',
        '3 Intercontinentali',
        '4 Coppe Italia',
        '1 Supercoppa Italiana',
      ],
    ),
    sourceUrl: 'https://www.pallacanestrovarese.it/it/',
    updatedAt: DateTime(2026, 4, 1, 12),
  ),
  seedStaff: const [
    StaffMember(
      name: 'Herman Mandole',
      role: 'Head Coach',
      profileUrl: 'https://www.pallacanestrovarese.it/it/squadra/staff',
    ),
  ],
  seedVideos: const [
    MediaItem(
      id: 'video-1',
      title: 'Match Highlights',
      url: 'https://www.pallacanestrovarese.it/it/media/videogallery',
    ),
  ],
  seedPhotos: const [
    MediaItem(
      id: 'photo-1',
      title: 'Game Photo Gallery',
      url: 'https://www.pallacanestrovarese.it/it/media/fotogallery',
    ),
  ],
  seedStandings: const [
    StandingRow(teamName: 'Pallacanestro Varese', points: 30, played: 20),
  ],
  seedTeamProfile: const TeamProfile(
    name: 'Pallacanestro Varese',
    arena: 'Itelyum Arena',
    city: 'Varese',
    websiteUrl: 'https://www.pallacanestrovarese.it/it/',
  ),
);
