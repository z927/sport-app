# API Basketball - Pallacanestro Varese

Base path: `/api/basketball`  
Content-Type: `application/json`

## Regole generali

- Campi non disponibili dalla fonte esterna vengono restituiti come `null`.
- `limit` (dove presente) è validato: intero `1..50`.
- Rate limit globale applicato lato server.
- Dati cache-izzati lato service (TTL specifico per dominio).
- Tutte le chiamate (tranne `/auth/token`) richiedono un header `Authorization: Bearer <JWT_TOKEN>`.

---

## 0) Autenticazione

### `POST /auth/token`

Richiede una API Key nell'header per generare un token JWT.

**Request:**

```http
POST /auth/token
x-api-key: your-api-key-here
```

**Response 200:**

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

## 1) News

### `GET /api/basketball/news`

Restituisce l'elenco delle ultime news.

**Query params:**

- `limit?: number` (default `10`, min `1`, max `50`)

**Request:**

```http
GET /api/basketball/news?limit=5
Authorization: Bearer <token>
```

**Response 200:**

```json
[
  {
    "id": "pallacanestro-varese-labbraccio-dei-tifosi-al-balthazar-il-rompete-le-righe",
    "title": "PALLACANESTRO VARESE, L’ABBRACCIO DEI TIFOSI AL BALTHAZAR PER IL ROMPETE LE RIGHE",
    "summary": "Ieri sera l'abbraccio dei tifosi...",
    "content": null,
    "publishedAt": "13/05/2026",
    "coverImage": "https://www.pallacanestrovarese.it/storage/app/uploads/public/...png",
    "url": "https://www.pallacanestrovarese.it/it/news/..."
  }
]
```

### `GET /api/basketball/news/{newsId}`

Restituisce il dettaglio di una singola news (incluso il contenuto completo).

**Request:**

```http
GET /api/basketball/news/kastritis-playoff-il-destino-e-nelle-nostre-mani
Authorization: Bearer <token>
```

**Response 200:**

```json
{
  "id": "kastritis-playoff-il-destino-e-nelle-nostre-mani",
  "title": "KASTRITIS: «PLAYOFF? IL DESTINO È NELLE NOSTRE MANI»",
  "summary": null,
  "content": "testo articolo sanificato in formato HTML o testo piano...",
  "publishedAt": "08/05/2026",
  "coverImage": "https://www.pallacanestrovarese.it/storage/app/uploads/public/...png",
  "url": "https://www.pallacanestrovarese.it/it/news/..."
}
```

---

## 2) Media

### `GET /api/basketball/media/videos`

**Query params:**

- `limit?: number` (default `10`, min `1`, max `50`)

**Request:**

```http
GET /api/basketball/media/videos?limit=5
Authorization: Bearer <token>
```

**Response 200:**

```json
[
  {
    "id": "kastritis-playoff-il-destino-e-nelle-nostre-mani",
    "type": "video",
    "title": "KASTRITIS: «PLAYOFF? IL DESTINO È NELLE NOSTRE MANI»",
    "thumbnail": "https://img.youtube.com/vi/TAiTCC1cEcc/0.jpg",
    "publishedAt": "08/05/2026",
    "url": "https://www.youtube.com/embed/TAiTCC1cEcc"
  }
]
```

### `GET /api/basketball/media/photos`

**Query params:**

- `limit?: number` (default `10`, min `1`, max `50`)

**Request:**

```http
GET /api/basketball/media/photos?limit=5
Authorization: Bearer <token>
```

**Response 200:**

```json
[
  {
    "id": "photo-0",
    "type": "photo",
    "title": "LBA 2025-2026. LA GALLERY DI VARESE-CREMONA",
    "thumbnail": "https://www.pallacanestrovarese.it/storage/app/uploads/public/...png",
    "publishedAt": null,
    "url": "https://www.pallacanestrovarese.it/it/news/..."
  }
]
```

---

## 3) Team

### `GET /api/basketball/team/roster`

**Request:**

```http
GET /api/basketball/team/roster
Authorization: Bearer <token>
```

**Response 200:**

```json
[
  {
    "id": "davide-alviti",
    "name": "DAVIDE ALVITI",
    "number": "2",
    "role": "Ala",
    "heightCm": 200,
    "weightKg": 92,
    "birthDate": "05.11.1996",
    "nationality": "ITA",
    "photo": "https://www.pallacanestrovarese.it/storage/app/uploads/public/...png",
    "bio": null
  }
]
```

### `GET /api/basketball/team/players/{playerId}`

**Request:**

```http
GET /api/basketball/team/players/davide-alviti
Authorization: Bearer <token>
```

**Response 200:**

```json
{
  "id": "davide-alviti",
  "name": "DAVIDE ALVITI",
  "number": "2",
  "role": "Ala",
  "heightCm": 200,
  "weightKg": 92,
  "birthDate": "05.11.1996",
  "nationality": "ITA",
  "photo": "https://www.pallacanestrovarese.it/storage/app/uploads/public/...png",
  "bio": "Davide Alviti nasce a Alatri il 5 novembre 1996..."
}
```

### `GET /api/basketball/team/staff`

**Request:**

```http
GET /api/basketball/team/staff
Authorization: Bearer <token>
```

**Response 200:**

```json
[
  {
    "id": "staff-0",
    "name": "Giannis Kastritis",
    "role": "Capo Allenatore",
    "photo": "https://www.pallacanestrovarese.it/storage/app/uploads/public/...png"
  }
]
```

### `GET /api/basketball/team/profile`

**Request:**

```http
GET /api/basketball/team/profile
Authorization: Bearer <token>
```

**Response 200:**

```json
{
  "id": "varese",
  "name": "Pallacanestro Varese",
  "city": "Varese",
  "arena": "Itelyum Arena",
  "profile": "La Pallacanestro Varese è una società storica...",
  "honours": ["10 Scudetti", "5 Coppe dei Campioni"]
}
```

---

## 4) Matches

### `GET /api/basketball/matches`

**Request:**

```http
GET /api/basketball/matches
Authorization: Bearer <token>
```

**Response 200:**

```json
[
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
]
```

### `GET /api/basketball/matches/{matchId}`

**Request:**

```http
GET /api/basketball/matches/match-0
Authorization: Bearer <token>
```

**Response 200:** stesso schema di `GET /matches` per la partita richiesta.

---

## 5) Standings

### `GET /api/basketball/standings`

**Request:**

```http
GET /api/basketball/standings
Authorization: Bearer <token>
```

**Response 200:**

```json
[
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
]
```

---

## Errori

### 401 Unauthorized

```json
{ "message": "Unauthorized" }
```

### 404 Not Found

```json
{ "message": "Resource not found" }
```

### 500 Internal Server Error

```json
{ "message": "Unexpected error" }
```
