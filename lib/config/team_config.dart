class TeamSiteConfig {
  const TeamSiteConfig({
    required this.appTitle,
    required this.teamKeyword,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backendBaseUrl,
    required this.apiKey,
  });

  final String appTitle;
  final String teamKeyword;
  final int primaryColor;
  final int secondaryColor;
  final String backendBaseUrl;
  final String apiKey;

  TeamSiteConfig copyWith({
    String? appTitle,
    String? teamKeyword,
    int? primaryColor,
    int? secondaryColor,
    String? backendBaseUrl,
    String? apiKey,
  }) {
    return TeamSiteConfig(
      appTitle: appTitle ?? this.appTitle,
      teamKeyword: teamKeyword ?? this.teamKeyword,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      backendBaseUrl: backendBaseUrl ?? this.backendBaseUrl,
      apiKey: apiKey ?? this.apiKey,
    );
  }
}

const defaultTeamConfig = TeamSiteConfig(
  appTitle: 'Varese Basket',
  teamKeyword: 'Varese',
  primaryColor: 0xFFE30613,
  secondaryColor: 0xFF8B0008,
  backendBaseUrl: 'https://api-varese-bk-658489904938.europe-west6.run.app/',
  apiKey: 'Rek5AE0G6svmnK9lLrvmf0jUruWTuwAS85zBWmSkb5l',
);
