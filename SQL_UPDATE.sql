-- Schema updates for authentication and public profiles
-- Run this AFTER SQL_SCHEMA.sql if you already have the database set up

-- Add username field to users table for public vouch links
ALTER TABLE users ADD COLUMN IF NOT EXISTS username TEXT UNIQUE;
CREATE UNIQUE INDEX IF NOT EXISTS idx_users_username ON users(username);

-- Add email field to employers table for login
ALTER TABLE employers ADD COLUMN IF NOT EXISTS email TEXT UNIQUE;

-- Link users to Supabase Auth (auth_id references auth.users table)
ALTER TABLE users ADD COLUMN IF NOT EXISTS auth_id UUID REFERENCES auth.users(id) ON DELETE CASCADE;
CREATE INDEX IF NOT EXISTS idx_users_auth_id ON users(auth_id);

-- Link employers to Supabase Auth
ALTER TABLE employers ADD COLUMN IF NOT EXISTS auth_id UUID REFERENCES auth.users(id) ON DELETE CASCADE;
CREATE INDEX IF NOT EXISTS idx_employers_auth_id ON employers(auth_id);

-- Update sample employers with email addresses
UPDATE employers SET email = 'hr@meta.com' WHERE organization_name = 'Meta';
UPDATE employers SET email = 'hr@google.com' WHERE organization_name = 'Google';
UPDATE employers SET email = 'admissions@uwaterloo.ca' WHERE organization_name = 'University of Waterloo';

-- Insert demo user for testing
INSERT INTO users (user_id, email, name, username, wallet_address) VALUES
  ('00000000-0000-0000-0000-000000000000', 'demo@vouch.com', 'Demo User', 'demo', 'D44j1wmmiDyJw9Vs8nWQTqwFTRWuY4wjEwHTj3ZoQHPz')
ON CONFLICT (user_id) DO NOTHING;

-- Success message
SELECT 'Schema updated successfully! Users can now sign up and employers can log in.' as message;
