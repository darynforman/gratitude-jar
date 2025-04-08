#!/bin/bash

# Exit on any error
set -e

echo "🚀 Starting Gratitude Jar setup..."

# Function to setup database
setup_database() {
    echo "🗄️ Setting up Gratitude Jar database..."
    psql -U postgres << EOF
CREATE DATABASE gratitude_jar;
CREATE USER gratitude_user WITH PASSWORD 'gratitude123';
GRANT ALL PRIVILEGES ON DATABASE gratitude_jar TO gratitude_user;
EOF
    
    # Grant schema permissions
    psql -U postgres -d gratitude_jar << EOF
GRANT ALL ON SCHEMA public TO gratitude_user;
EOF
    
    echo "✅ Database and user created successfully!"
}

# Function to setup application
setup_application() {
    # Check if Go is installed
    if ! command -v go &> /dev/null; then
        echo "❌ Error: Go is not installed. Please install Go first."
        exit 1
    fi

    echo "📦 Installing project dependencies..."
    make deps

    echo "🛠️ Setting up development environment..."
    make dev-setup

    # Run migrations
    echo "🔄 Running database migrations..."
    make migrate-up
}

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo "❌ Error: PostgreSQL is not installed. Please install PostgreSQL first."
    exit 1
fi

# If run as postgres user, only do database setup
if [ "$(whoami)" = "postgres" ]; then
    setup_database
else
    # If run as normal user, do full setup
    echo "Setting up database (may ask for sudo password)..."
    sudo -u postgres bash -c "$(declare -f setup_database); setup_database"
    setup_application
fi

echo "🎉 Setup complete! The application is ready to use."
echo "
To run the application:
1. Run 'make run'
2. Open your browser to http://localhost:4000
"
