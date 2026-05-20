import express from 'express';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import { z } from 'zod';
import { VareseProvider } from './providers/vareseProvider.js';
import { MemoryCache } from './utils/cache.js';
import { normalizeText } from './utils/sanitize.js';
import { validate } from './middleware/validate.js';

const provider = new VareseProvider();
const cache = new MemoryCache(Number(process.env.CACHE_TTL_SECONDS || 120));

const limitSchema = z.object({ limit: z.coerce.number().int().min(1).max(50).default(10) });

const app = express();
app.use(helmet());
app.use(express.json());
app.use(rateLimit({
  windowMs: Number(process.env.RATE_LIMIT_WINDOW_MS || 60000),
  max: Number(process.env.RATE_LIMIT_MAX || 100)
}));

const cached = async (key, fetcher) => {
  const hit = cache.get(key);
  if (hit) return hit;
  const data = await fetcher();
  cache.set(key, data);
  return data;
};

app.get('/api/basketball/news', validate(limitSchema), async (req, res) => {
  const { limit } = req.validated;
  const data = await cached(`news:${limit}`, () => provider.getNews(limit));
  res.json(data.map((n) => ({ ...n, summary: normalizeText(n.summary) })));
});
app.get('/api/basketball/news/:newsId', async (req, res) => {
  const item = await provider.getNewsById(req.params.newsId);
  if (!item) return res.status(404).json({ error: 'News not found' });
  res.json({ ...item, summary: normalizeText(item.summary) });
});
app.get('/api/basketball/media/videos', validate(limitSchema), async (req, res) => res.json(await provider.getVideos(req.validated.limit)));
app.get('/api/basketball/media/photos', validate(limitSchema), async (req, res) => res.json(await provider.getPhotos(req.validated.limit)));
app.get('/api/basketball/team/roster', async (_req, res) => res.json(await provider.getRoster()));
app.get('/api/basketball/team/players/:playerId', async (req, res) => {
  const item = await provider.getPlayer(req.params.playerId);
  if (!item) return res.status(404).json({ error: 'Player not found' });
  res.json(item);
});
app.get('/api/basketball/team/staff', async (_req, res) => res.json(await provider.getStaff()));
app.get('/api/basketball/matches', async (_req, res) => res.json(await provider.getMatches()));
app.get('/api/basketball/matches/:matchId', async (req, res) => {
  const item = await provider.getMatch(req.params.matchId);
  if (!item) return res.status(404).json({ error: 'Match not found' });
  res.json(item);
});
app.get('/api/basketball/standings', async (_req, res) => res.json(await provider.getStandings()));
app.get('/api/basketball/team/profile', async (_req, res) => res.json(await provider.getProfile()));

export default app;
