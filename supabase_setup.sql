-- =====================================================
-- Complete DDL for Movie Catalog App
-- Run this SQL in your Supabase SQL Editor
-- =====================================================

-- =====================================================
-- 1. MOVIES TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS movies (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  overview TEXT NOT NULL,
  poster_path VARCHAR(500) NOT NULL,
  rating_average DECIMAL(3,1),
  release_date DATE,
  category VARCHAR(50) NOT NULL CHECK (category IN ('now_showing', 'upcoming', 'top_rated')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_movies_category ON movies(category);
CREATE INDEX IF NOT EXISTS idx_movies_rating ON movies(rating_average DESC);
CREATE INDEX IF NOT EXISTS idx_movies_release_date ON movies(release_date);

-- =====================================================
-- 2. GENRES TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS genres (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- =====================================================
-- 3. MOVIE_GENRES JUNCTION TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS movie_genres (
  movie_id INTEGER NOT NULL REFERENCES movies(id) ON DELETE CASCADE,
  genre_id INTEGER NOT NULL REFERENCES genres(id) ON DELETE CASCADE,
  PRIMARY KEY (movie_id, genre_id)
);

CREATE INDEX IF NOT EXISTS idx_movie_genres_movie_id ON movie_genres(movie_id);
CREATE INDEX IF NOT EXISTS idx_movie_genres_genre_id ON movie_genres(genre_id);

-- =====================================================
-- 4. FAVORITES TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS favorites (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  movie_id INTEGER NOT NULL REFERENCES movies(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  UNIQUE(user_id, movie_id)
);

-- Create indexes for faster queries
CREATE INDEX IF NOT EXISTS idx_favorites_user_id ON favorites(user_id);
CREATE INDEX IF NOT EXISTS idx_favorites_movie_id ON favorites(movie_id);

-- =====================================================
-- 5. ROW LEVEL SECURITY (RLS)
-- =====================================================

-- Enable RLS on movies table (public read access)
ALTER TABLE movies ENABLE ROW LEVEL SECURITY;

-- Policy: Everyone can read movies
CREATE POLICY "Movies are viewable by everyone"
  ON movies
  FOR SELECT
  USING (true);

-- Enable RLS on genres table (public read access)
ALTER TABLE genres ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Genres are viewable by everyone"
  ON genres
  FOR SELECT
  USING (true);

-- Enable RLS on movie_genres table (public read access)
ALTER TABLE movie_genres ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Movie genres are viewable by everyone"
  ON movie_genres
  FOR SELECT
  USING (true);

-- Enable RLS on favorites table
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;

-- Policy: Users can only see their own favorites
CREATE POLICY "Users can view their own favorites"
  ON favorites
  FOR SELECT
  USING (auth.uid() = user_id);

-- Policy: Users can insert their own favorites
CREATE POLICY "Users can insert their own favorites"
  ON favorites
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Policy: Users can delete their own favorites
CREATE POLICY "Users can delete their own favorites"
  ON favorites
  FOR DELETE
  USING (auth.uid() = user_id);

-- =====================================================
-- 6. SAMPLE DATA INSERTION
-- =====================================================

-- Insert genres
INSERT INTO genres (name) VALUES
  ('Action'),
  ('Adventure'),
  ('Animation'),
  ('Comedy'),
  ('Crime'),
  ('Drama'),
  ('Family'),
  ('Horror'),
  ('Romance'),
  ('Sci-Fi'),
  ('Thriller')
ON CONFLICT (name) DO NOTHING;

-- Insert movies
INSERT INTO movies (title, overview, poster_path, rating_average, release_date, category) VALUES
  -- Now Showing Movies
  ('Interstellar', 'A team of explorers travels through a wormhole in space to ensure humanity''s survival. Directed by Christopher Nolan.', 'assets/images/interstellar.jpg', 8.1, NULL, 'now_showing'),
  ('The Shawshank Redemption', 'Imprisoned banker Andy Dufresne finds hope and friendship in Shawshank Prison through perseverance and faith.', 'assets/images/shawshank.jpg', 7.5, NULL, 'now_showing'),
  ('The Dark Knight', 'Batman faces chaos unleashed by the Joker in Gotham City, testing his morality and heroism to the limit.', 'assets/images/dark_knight.jpg', 8.0, NULL, 'now_showing'),
  
  -- Top Rated Movies
  ('The Shawshank Redemption', 'Imprisoned banker Andy Dufresne finds hope and friendship in Shawshank Prison through perseverance and faith.', 'assets/images/shawshank.jpg', 9.3, NULL, 'top_rated'),
  ('Inception', 'A thief enters the dreams of others to steal secrets and plant ideas, blurring the line between reality and illusion.', 'assets/images/inception.jpg', 7.5, NULL, 'top_rated'),
  ('The Dark Knight', 'Batman faces chaos unleashed by the Joker in Gotham City, testing his morality and heroism to the limit.', 'assets/images/dark_knight.jpg', 8.8, NULL, 'top_rated'),
  ('Interstellar', 'A team of explorers travels through a wormhole in space to ensure humanity''s survival. Directed by Christopher Nolan.', 'assets/images/interstellar.jpg', 8.5, NULL, 'top_rated'),
  
  -- Upcoming Movies
  ('Inception', 'Overview Inception.', 'assets/images/inception.jpg', NULL, '2025-12-20', 'upcoming'),
  ('Interstellar', 'Overview Interstellar.', 'assets/images/interstellar.jpg', NULL, '2025-11-15', 'upcoming'),
  ('Shawhan Redemption', 'Overview Shawhan Redemption.', 'assets/images/shawshank.jpg', NULL, '2025-10-25', 'upcoming')
ON CONFLICT DO NOTHING;

-- Insert movie-genre relationships
-- Using CTE to get movie IDs after insertion
WITH movie_data AS (
  SELECT id, title, category FROM movies
),
genre_data AS (
  SELECT id, name FROM genres
)
INSERT INTO movie_genres (movie_id, genre_id)
SELECT m.id, g.id
FROM movie_data m
CROSS JOIN genre_data g
WHERE 
  -- Now Showing
  (m.title = 'Interstellar' AND m.category = 'now_showing' AND g.name IN ('Sci-Fi', 'Action', 'Adventure')) OR
  (m.title = 'The Shawshank Redemption' AND m.category = 'now_showing' AND g.name IN ('Horror', 'Thriller')) OR
  (m.title = 'The Dark Knight' AND m.category = 'now_showing' AND g.name IN ('Action', 'Crime')) OR
  -- Top Rated
  (m.title = 'The Shawshank Redemption' AND m.category = 'top_rated' AND g.name IN ('Drama', 'Crime')) OR
  (m.title = 'Inception' AND m.category = 'top_rated' AND g.name IN ('Animation', 'Comedy', 'Family')) OR
  (m.title = 'The Dark Knight' AND m.category = 'top_rated' AND g.name IN ('Action', 'Crime')) OR
  (m.title = 'Interstellar' AND m.category = 'top_rated' AND g.name IN ('Drama', 'Romance')) OR
  -- Upcoming
  (m.title = 'Inception' AND m.category = 'upcoming' AND g.name IN ('Animation', 'Comedy', 'Family')) OR
  (m.title = 'Interstellar' AND m.category = 'upcoming' AND g.name IN ('Action', 'Sci-Fi', 'Adventure')) OR
  (m.title = 'Shawhan Redemption' AND m.category = 'upcoming' AND g.name IN ('Drama', 'Romance'))
ON CONFLICT DO NOTHING;

-- =====================================================
-- 7. HELPER FUNCTIONS (Optional)
-- =====================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = TIMEZONE('utc'::text, NOW());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to automatically update updated_at
CREATE TRIGGER update_movies_updated_at BEFORE UPDATE ON movies
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- 8. VIEWS FOR EASIER QUERIES (Optional)
-- =====================================================

-- View to get movies with their genres as array
CREATE OR REPLACE VIEW movies_with_genres AS
SELECT 
  m.id,
  m.title,
  m.overview,
  m.poster_path,
  m.rating_average,
  m.release_date,
  m.category,
  m.created_at,
  m.updated_at,
  COALESCE(
    ARRAY_AGG(g.name ORDER BY g.name) FILTER (WHERE g.name IS NOT NULL),
    ARRAY[]::VARCHAR[]
  ) as genres
FROM movies m
LEFT JOIN movie_genres mg ON m.id = mg.movie_id
LEFT JOIN genres g ON mg.genre_id = g.id
GROUP BY m.id, m.title, m.overview, m.poster_path, m.rating_average, m.release_date, m.category, m.created_at, m.updated_at;
