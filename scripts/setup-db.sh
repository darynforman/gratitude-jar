#!/bin/bash

# Exit on any error
set -e

echo "🚀 Starting Gratitude Jar setup..."

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "❌ Error: Go is not installed. Please install Go first."
    exit 1
fi

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo "❌ Error: PostgreSQL is not installed. Please install PostgreSQL first."
    exit 1
fi

echo "📦 Installing project dependencies..."
make deps

echo "🛠️ Setting up development environment..."
make dev-setup

echo "🗄️ Setting up Gratitude Jar database..."

# Create database and user
psql -U postgres << EOF
CREATE DATABASE gratitude_jar;
CREATE USER gratitude_user WITH PASSWORD 'gratitude123';
GRANT ALL PRIVILEGES ON DATABASE gratitude_jar TO gratitude_user;
EOF

echo "✅ Database and user created successfully!"

# Run migrations
echo "🔄 Running database migrations..."
make migrate-up

echo "🎉 Setup complete! The application is ready to use."
echo "
To run the application:
1. Run 'make run'
2. Open your browser to http://localhost:4000
"
