import 'dart:io';
import 'dart:convert';

const int port = 8090;
const String mockToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9';

void main() async {
  final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
  print('🏀 Mock Server running on http://localhost:$port');

  await for (HttpRequest request in server) {
    final response = request.response;
    final path = request.uri.path;
    final method = request.method;

    // CORS headers
    response.headers.add('Access-Control-Allow-Origin', '*');
    response.headers.add('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    response.headers.add('Access-Control-Allow-Headers',
        'Origin, Content-Type, Authorization, x-api-key');

    if (method == 'OPTIONS') {
      response.statusCode = 200;
      await response.close();
      continue;
    }

    response.headers.contentType = ContentType.json;

    try {
      print('[$method] $path');

      // 0) Authentication
      if (path == '/auth/token' && method == 'POST') {
        final apiKey = request.headers.value('x-api-key');
        if (apiKey != null && apiKey.isNotEmpty) {
          response.statusCode = 200;
          response.write(jsonEncode({'token': mockToken}));
        } else {
          response.statusCode = 401;
          response.write(jsonEncode(
              {'message': 'Unauthorized: Missing or invalid API Key'}));
        }
        await response.close();
        continue;
      }

      // Check Authorization Header for all other endpoints
      final authHeader = request.headers.value('authorization');
      if (authHeader != 'Bearer $mockToken') {
        response.statusCode = 401;
        response.write(jsonEncode({'message': 'Unauthorized'}));
        await response.close();
        continue;
      }

      if (method == 'GET') {
        // 1) News
        if (path == '/api/basketball/news') {
          response.write(jsonEncode([
            {
              "id":
                  "pallacanestro-varese-labbraccio-dei-tifosi-al-balthazar-il-rompete-le-righe",
              "title":
                  "PALLACANESTRO VARESE, L’ABBRACCIO DEI TIFOSI AL BALTHAZAR PER IL ROMPETE LE RIGHE",
              "summary": "Ieri sera l'abbraccio dei tifosi...",
              "content": null,
              "publishedAt": "13/05/2026",
              "coverImage":
                  "https://www.pallacanestrovarese.it/storage/app/uploads/public/...png",
              "url": "https://www.pallacanestrovarese.it/it/news/..."
            }
          ]));
        } else if (path.startsWith('/api/basketball/news/')) {
          response.write(jsonEncode({
            "id": "kastritis-playoff-il-destino-e-nelle-nostre-mani",
            "title": "KASTRITIS: «PLAYOFF? IL DESTINO È NELLE NOSTRE MANI»",
            "summary": null,
            "content":
                "testo articolo sanificato in formato HTML o testo piano...",
            "publishedAt": "08/05/2026",
            "coverImage":
                "https://www.pallacanestrovarese.it/storage/app/uploads/public/...png",
            "url": "https://www.pallacanestrovarese.it/it/news/..."
          }));
        }

        // 2) Media
        else if (path == '/api/basketball/media/videos') {
          response.write(jsonEncode([
            {
              "id": "kastritis-playoff-il-destino-e-nelle-nostre-mani",
              "type": "video",
              "title": "KASTRITIS: «PLAYOFF? IL DESTINO È NELLE NOSTRE MANI»",
              "thumbnail": "https://img.youtube.com/vi/TAiTCC1cEcc/0.jpg",
              "publishedAt": "08/05/2026",
              "url": "https://www.youtube.com/embed/TAiTCC1cEcc"
            }
          ]));
        } else if (path == '/api/basketball/media/photos') {
          response.write(jsonEncode([
            {
              "id": "photo-0",
              "type": "photo",
              "title": "LBA 2025-2026. LA GALLERY DI VARESE-CREMONA",
              "thumbnail":
                  "https://www.pallacanestrovarese.it/storage/app/uploads/public/...png",
              "publishedAt": null,
              "url": "https://www.pallacanestrovarese.it/it/news/..."
            }
          ]));
        }

        // 3) Team
        else if (path == '/api/basketball/team/roster') {
          response.write(jsonEncode([
            {
              "id": "davide-alviti",
              "name": "DAVIDE ALVITI",
              "number": "2",
              "role": "Ala",
              "heightCm": 200,
              "weightKg": 92,
              "birthDate": "05.11.1996",
              "nationality": "ITA",
              "photo":
                  "https://www.pallacanestrovarese.it/storage/app/uploads/public/...png",
              "bio": null
            }
          ]));
        } else if (path.startsWith('/api/basketball/team/players/')) {
          response.write(jsonEncode({
            "id": "davide-alviti",
            "name": "DAVIDE ALVITI",
            "number": "2",
            "role": "Ala",
            "heightCm": 200,
            "weightKg": 92,
            "birthDate": "05.11.1996",
            "nationality": "ITA",
            "photo":
                "https://www.pallacanestrovarese.it/storage/app/uploads/public/...png",
            "bio": "Davide Alviti nasce a Alatri il 5 novembre 1996..."
          }));
        } else if (path == '/api/basketball/team/staff') {
          response.write(jsonEncode([
            {
              "id": "staff-0",
              "name": "Giannis Kastritis",
              "role": "Capo Allenatore",
              "photo":
                  "https://www.pallacanestrovarese.it/storage/app/uploads/public/...png"
            }
          ]));
        } else if (path == '/api/basketball/team/profile') {
          response.write(jsonEncode({
            "id": "varese",
            "name": "Pallacanestro Varese",
            "city": "Varese",
            "arena": "Itelyum Arena",
            "profile": "La Pallacanestro Varese è una società storica...",
            "honours": ["10 Scudetti", "5 Coppe dei Campioni"]
          }));
        }

        // 4) Matches
        else if (path == '/api/basketball/matches') {
          response.write(jsonEncode([
            {
              "id": "match-0",
              "competition": "Campionato",
              "season": "2025-2026",
              "date": "dom 10 mag 17:00",
              "homeTeam": "Virtus Bologna",
              "awayTeam": "Varese",
              "homeScore": 104,
              "awayScore": 85,
              "status": "finished",
              "boxscoreText": "Tabellino: Belinelli 20, Shengelia 15...",
              "url": null
            }
          ]));
        } else if (path.startsWith('/api/basketball/matches/')) {
          response.write(jsonEncode({
            "id": "match-0",
            "competition": "Campionato",
            "season": "2025-2026",
            "date": "dom 10 mag 17:00",
            "homeTeam": "Virtus Bologna",
            "awayTeam": "Varese",
            "homeScore": 104,
            "awayScore": 85,
            "status": "finished",
            "boxscoreText": "Tabellino: Belinelli 20, Shengelia 15...",
            "url": null
          }));
        }

        // 5) Standings
        else if (path == '/api/basketball/standings') {
          response.write(jsonEncode([
            {
              "teamId": "virtus-bologna",
              "teamName": "Virtus Bologna",
              "position": 1,
              "played": 30,
              "won": 24,
              "lost": 6,
              "points": 48
            },
            {
              "teamId": "varese",
              "teamName": "Varese",
              "position": 10,
              "played": 30,
              "won": 12,
              "lost": 18,
              "points": 24
            }
          ]));
        } else {
          response.statusCode = 404;
          response.write(jsonEncode({'message': 'Resource not found'}));
        }
      } else {
        response.statusCode = 405; // Method Not Allowed
        response.write(jsonEncode({'message': 'Method not allowed'}));
      }
    } catch (e) {
      print('Error processing request: $e');
      response.statusCode = 500;
      response.write(jsonEncode({'message': 'Unexpected error'}));
    } finally {
      await response.close();
    }
  }
}
