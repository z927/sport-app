export const seed = {
  news: [
    { id: 'n1', title: 'Varese wins at home', summary: '<b>Big win</b> for Varese.', date: '2026-05-18', url: '/it/news/varese-wins' },
    { id: 'n2', title: 'Coach press conference', summary: 'Coach comments after the game.', date: '2026-05-16', url: '/it/news/coach-press' }
  ],
  videos: [{ id: 'v1', title: 'Highlights', url: '/it/media/videogallery/highlights' }],
  photos: [{ id: 'p1', title: 'Game gallery', url: '/it/media/fotogallery/game-1' }],
  roster: [{ id: 'pl1', name: 'John Doe', role: 'Guard', number: 7 }],
  staff: [{ id: 's1', name: 'Jane Coach', role: 'Head Coach' }],
  matches: [{ id: 'm1', home: 'Varese', away: 'Milano', date: '2026-05-22', status: 'scheduled' }],
  standings: [{ team: 'Varese', points: 30, played: 20 }],
  profile: { name: 'Pallacanestro Varese', city: 'Varese', venue: 'Itelyum Arena' }
};
