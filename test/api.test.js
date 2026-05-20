import request from 'supertest';
import { describe, it, expect } from 'vitest';
import app from '../src/app.js';

describe('basketball api', () => {
  it('gets news with sanitization', async () => {
    const res = await request(app).get('/api/basketball/news?limit=1');
    expect(res.status).toBe(200);
    expect(res.body).toHaveLength(1);
    expect(res.body[0].summary).not.toContain('<b>');
  });

  it('validates limit', async () => {
    const res = await request(app).get('/api/basketball/news?limit=1000');
    expect(res.status).toBe(400);
  });

  it('returns 404 for missing player', async () => {
    const res = await request(app).get('/api/basketball/team/players/missing');
    expect(res.status).toBe(404);
  });
});
