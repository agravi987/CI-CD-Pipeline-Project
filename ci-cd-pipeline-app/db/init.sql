-- =======================================================
-- Database Initialization Script for PostgreSQL
-- This script runs automatically when the PostgreSQL container
-- is started for the first time.
-- =======================================================

-- Create tasks table
CREATE TABLE IF NOT EXISTS tasks (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Insert initial sample data so the app has data on first launch
INSERT INTO tasks (title, description, completed) VALUES
('Learn CI/CD Fundamentals', 'Understand the difference between Continuous Integration and Continuous Deployment.', true),
('Build Docker Containers', 'Create Dockerfile for React and Express and test with Docker Compose.', true),
('Set up GitHub Actions Pipeline', 'Automate testing, container building, and pushing to Docker Hub.', false),
('Deploy to AWS EC2', 'Automatically deploy the latest containers to an AWS EC2 instance over SSH.', false);
