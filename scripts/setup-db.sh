#!/bin/bash

# Exit on any error
set -e

echo "Setting up Gratitude Jar database..."

# Create database and user
psql -U postgres << EOF
CREATE DATABASE gratitude_jar;
CREATE USER gratitude_user WITH PASSWORD 'gratitude123';
GRANT ALL PRIVILEGES ON DATABASE gratitude_jar TO gratitude_user;
EOF

echo "Database and user created successfully!"

# Run migrations
echo "Running database migrations..."
make migrate-up

echo "Setup complete! The database is ready to use."
