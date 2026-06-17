#!/bin/bash
# ---------------------------------------
# Initialize a Laravel + React + Docker project
# ---------------------------------------

echo "## Welcome to the Laravel + React + Docker Project Starter!"
echo "================================================================================"

# ---------------------------------------
# 1. Get the project name
# ---------------------------------------
read -p "Project Name: " project_name

if [ -z "$project_name" ]; then
    echo "Error: No project name provided."
    exit 1
fi

if [ -d "$project_name" ]; then
    echo "Error: Directory '$project_name' already exists."
    exit 1
fi

# ---------------------------------------
# 2. Create the laravel project
# ---------------------------------------

echo "# 1/3 Creating laravel project with name $project_name"
composer create-project laravel/laravel "$project_name"

echo "Laravel successfully created!"
echo "================================================================================"

# ---------------------------------------
# 3. Create the docker 
# ---------------------------------------

echo "# 2/3 Starting the docker containers"

mv docker Dockerfile docker-compose.yml "$project_name"
cp .env.example.docker "$project_name/.env"

cd "$project_name" || exit 1

docker-compose up -d --build

echo "Waiting for MySQL to be ready..."

MAX_TRIES=40
COUNT=0

until docker-compose exec -T app bash -c "php -r \"new PDO('mysql:host=db;port=3306;dbname=laravel_react', 'root', 'root');\" " &>/dev/null; do
    COUNT=$((COUNT + 1))
    if [ "$COUNT" -ge "$MAX_TRIES" ]; then
        echo "Error: MySQL did not become ready in time."
        exit 1
    fi
    echo "  MySQL not ready yet... ($COUNT/$MAX_TRIES)"
    sleep 2
done

echo "MySQL is ready!"

echo "Generating application key..."
docker-compose exec app php artisan key:generate

echo "Run the migrations to MySQL"
docker-compose exec app php artisan migrate

echo "Containers started successfully!"
echo "================================================================================"

# ---------------------------------------
# 4. Setting up React frontend
# ---------------------------------------

echo "# 3/3 Setting up React frontend..."

echo "Moving files..."

# moving vite file
rm vite.config.js
mv ../vite.config.ts ./vite.config.ts

# moving tsconfig file
mv ../tsconfig.json tsconfig.json

# moving react files
mv ../lib/ resources/js/
mv ../main.tsx resources/js/main.tsx
mv ../App.tsx resources/js/App.tsx
rm resources/js/app.js

# moving laravel files
mv ../app.blade.php resources/views/
mv ../web.php routes/web.php

# Install dependencies

echo "Updating npm..."
docker-compose exec -T app npm install -g npm@latest --silent

echo "Installing React..."
docker-compose exec -T app npm install react react-dom @vitejs/plugin-react --silent --fund=false --audit=false

echo "Installing Typescript..."
docker-compose exec -T app npm install -D typescript @types/react @types/react-dom --silent --fund=false --audit=false

echo "Installing Tailwindcss..."
docker-compose exec -T app npm install -D tailwindcss @tailwindcss/vite --silent --fund=false --audit=false

echo "Installing all dependencies..."
docker-compose exec -T app npm install --silent --fund=false --audit=false

echo "Building..."
docker-compose exec -T app npm run build --silent

echo "React started successfully!"
echo "================================================================================"

# ---------------------------------------
# 5. Move project to parent directory
# ---------------------------------------

echo "Moving project to parent directory..."

cd ..
mv "$project_name" ../
cd ..

echo "Project moved to `pwd`/$project_name"

echo "Access the project at http://localhost:8888"
