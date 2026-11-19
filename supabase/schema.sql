-- ============================================================
-- Puzzle Frenzi — Supabase schema
-- Run in Supabase Dashboard -> SQL Editor -> New Query -> Run
-- Project owner: naimybinomo2@gmail.com (amy.superant is full)
-- ============================================================

-- 1. Player progress (one row per device; localStorage stays the
--    offline source of truth, this is the cloud copy + leaderboard base)
CREATE TABLE IF NOT EXISTS player_progress (
  device_id TEXT PRIMARY KEY,
  total_stars INT NOT NULL DEFAULT 0,
  total_xp INT NOT NULL DEFAULT 0,
  rank TEXT NOT NULL DEFAULT 'Pemula',
  completed_levels JSONB NOT NULL DEFAULT '{}'::jsonb,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. Leaderboard (mirrors player_progress totals for fast ranking)
CREATE TABLE IF NOT EXISTS leaderboard (
  device_id TEXT PRIMARY KEY,
  display_name TEXT,
  total_stars INT NOT NULL DEFAULT 0,
  total_xp INT NOT NULL DEFAULT 0,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 3. Votes for the next appliance to feature (from the certificate screen)
CREATE TABLE IF NOT EXISTS level_votes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  device_id TEXT NOT NULL,
  choice TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 4. Row Level Security
ALTER TABLE player_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE leaderboard ENABLE ROW LEVEL SECURITY;
ALTER TABLE level_votes ENABLE ROW LEVEL SECURITY;

-- Anon (the game's public key) can read the leaderboard and votes,
-- and can insert/upsert only its own device rows. No deletes via anon.
DROP POLICY IF EXISTS "public read progress" ON player_progress;
CREATE POLICY "public read progress" ON player_progress
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "anon upsert own progress" ON player_progress;
CREATE POLICY "anon upsert own progress" ON player_progress
  FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "public read leaderboard" ON leaderboard;
CREATE POLICY "public read leaderboard" ON leaderboard
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "anon upsert own leaderboard" ON leaderboard;
CREATE POLICY "anon upsert own leaderboard" ON leaderboard
  FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "public read votes" ON level_votes;
CREATE POLICY "public read votes" ON level_votes
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "anon insert votes" ON level_votes;
CREATE POLICY "anon insert votes" ON level_votes
  FOR INSERT WITH CHECK (true);

-- Helpful indexes
CREATE INDEX IF NOT EXISTS leaderboard_stars_idx
  ON leaderboard (total_stars DESC, total_xp DESC);
CREATE INDEX IF NOT EXISTS level_votes_choice_idx
  ON level_votes (choice);
