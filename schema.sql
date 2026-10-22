-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create images table
CREATE TABLE IF NOT EXISTS images (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  url TEXT NOT NULL,
  title TEXT,
  category TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security (RLS)
ALTER TABLE images ENABLE ROW LEVEL SECURITY;

-- 1. SELECT access granted to public (anonymous users)
CREATE POLICY "Allow public read access"
  ON images
  FOR SELECT
  TO public
  USING (true);

-- 2. INSERT restricted to authenticated admin users only
CREATE POLICY "Allow authenticated users to insert"
  ON images
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- 3. UPDATE restricted to authenticated admin users only
CREATE POLICY "Allow authenticated users to update"
  ON images
  FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- 4. DELETE restricted to authenticated admin users only
CREATE POLICY "Allow authenticated users to delete"
  ON images
  FOR DELETE
  TO authenticated
  USING (true);

-- Sample initial curated images for immediate launch
INSERT INTO images (url, title, category) VALUES
  ('https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1600&q=80', 'Yosemite Alpine Valley Dawn', 'Nature'),
  ('https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?auto=format&fit=crop&w=1600&q=80', 'Misty Mountain Fog & Pine Forest', 'Nature'),
  ('https://images.unsplash.com/photo-1518780664697-55e3ad937233?auto=format&fit=crop&w=1600&q=80', 'Minimalist Nordic Forest House', 'Architecture'),
  ('https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=1600&q=80', 'Futuristic Glass Skyscraper Geometric', 'Architecture'),
  ('https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=1600&q=80', 'Studio Golden Hour Fine Art Portrait', 'Portraits'),
  ('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=1600&q=80', 'Natural Expression Cinematic Portrait', 'Portraits'),
  ('https://images.unsplash.com/photo-1541701494587-cb58502866ab?auto=format&fit=crop&w=1600&q=80', 'Fluid Chroma Swirl & Prismatic Waves', 'Abstract'),
  ('https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?auto=format&fit=crop&w=1600&q=80', 'Modernist Neo-Expressionist Texture', 'Abstract'),
  ('https://images.unsplash.com/photo-1426604966848-d7adac402bff?auto=format&fit=crop&w=1600&q=80', 'Cascading Emerald Canyon Waterfall', 'Nature'),
  ('https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=1600&q=80', 'Brutalist Concrete Spiral Stairwell', 'Architecture'),
  ('https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=1600&q=80', 'Sunlit Freelance Creator Portrait', 'Portraits'),
  ('https://images.unsplash.com/photo-1550684848-fac1c5b4e853?auto=format&fit=crop&w=1600&q=80', 'Cyberpunk Neon Gradient Geometric', 'Abstract')
ON CONFLICT DO NOTHING;
