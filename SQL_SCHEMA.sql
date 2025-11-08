-- Vouch Platform Database Schema
-- Run this in your Supabase SQL Editor

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table (employees/students)
CREATE TABLE users (
  user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  auth_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  username TEXT UNIQUE NOT NULL,
  wallet_address TEXT UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Employers/Institutions table
CREATE TABLE employers (
  employer_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  auth_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  organization_name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  issuer_wallet_address TEXT UNIQUE NOT NULL,
  email_domain TEXT UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Credential requests table
CREATE TABLE credential_requests (
  request_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
  company_name TEXT NOT NULL,
  role_title TEXT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE,
  proof_link TEXT,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  token_address TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Job postings table
CREATE TABLE job_postings (
  job_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  employer_id UUID REFERENCES employers(employer_id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  required_credential_roles TEXT[] DEFAULT '{}',
  created_at TIMESTAMP DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_users_auth_id ON users(auth_id);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_employers_auth_id ON employers(auth_id);
CREATE INDEX idx_credential_requests_user_id ON credential_requests(user_id);
CREATE INDEX idx_credential_requests_status ON credential_requests(status);
CREATE INDEX idx_job_postings_employer_id ON job_postings(employer_id);

-- Insert sample data for testing (optional)
INSERT INTO employers (organization_name, email, issuer_wallet_address, email_domain) VALUES
  ('Meta', 'hr@meta.com', 'DemoWallet1111111111111111111111111111111', 'meta.com'),
  ('Google', 'hr@google.com', 'DemoWallet2222222222222222222222222222222', 'google.com'),
  ('University of Waterloo', 'admissions@uwaterloo.ca', 'DemoWallet3333333333333333333333333333333', 'uwaterloo.ca');

-- Success message
SELECT 'Database schema created successfully!' as message;

