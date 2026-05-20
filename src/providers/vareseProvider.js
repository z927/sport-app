import { seed } from '../data/seed.js';

export class VareseProvider {
  async getNews(limit) { return seed.news.slice(0, limit); }
  async getNewsById(newsId) { return seed.news.find((n) => n.id === newsId) || null; }
  async getVideos(limit) { return seed.videos.slice(0, limit); }
  async getPhotos(limit) { return seed.photos.slice(0, limit); }
  async getRoster() { return seed.roster; }
  async getPlayer(playerId) { return seed.roster.find((p) => p.id === playerId) || null; }
  async getStaff() { return seed.staff; }
  async getMatches() { return seed.matches; }
  async getMatch(matchId) { return seed.matches.find((m) => m.id === matchId) || null; }
  async getStandings() { return seed.standings; }
  async getProfile() { return seed.profile; }
}
