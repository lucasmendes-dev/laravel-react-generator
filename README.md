# Laravel + React + Docker — Project Starter

> Scaffolding script that creates a fully configured **Laravel + React + TypeScript + Tailwind CSS** project running inside Docker, with a single command.

---

## What it does

Running `project-start.sh` will:

1. Create a new Laravel project via Composer
2. Copy the Docker configuration and `.env` into the project
3. Build and start the containers (`app` + `db` + `redis`)
4. Wait for MySQL to be ready, then run key generation and migrations
5. Move the React/TypeScript/Vite source files into the right Laravel directories
6. Install all npm dependencies and build the frontend assets
7. Move the finished project one level up, out of the starter directory

---

## Requirements

Make sure these are installed and available in your `PATH` before running:

| Tool | Purpose |
|------|---------|
| `bash` ≥ 4.0 | Script runtime |
| `composer` | Creates the Laravel project |
| `docker` | Container engine |
| `docker-compose` | Orchestrates `app` and `db` services |
| `npm` | Used inside the container — must also be available on the host for the pre-flight check |

---

## Container Modifications

If you want to add or remove containers to this application, before start the script go to the `docker-compose.yml` file and change what you want.
I’ve already left the `PHPMyAdmin` and `Mailhog` containers commented out in the service; to use them, simply uncomment them.


---

## Usage

Clone the starter repository, then run the script from inside it:

```bash
git clone https://github.com/lucasmendes-dev/laravel-react-generator.git
cd laravel-react-generator
chmod +x project-start.sh
bash project-start.sh
```

The script will prompt you for a project name:

```
  Project name
  ▸ my-app
```

That's the only input required. Everything else is automated.

When the script finishes, the project is placed **one directory above** the starter:

```
../my-app/        ← your new project
```
Then you can delete the `laravel-react-generator/` directory if you want

---

## What gets set up

### Backend

- Laravel (latest stable via Composer)
- MySQL database, pre-migrated and ready
- Application key generated automatically

### Frontend

- React + ReactDOM
- TypeScript with `@types/react` and `@types/react-dom`
- Tailwind CSS with `@tailwindcss/vite`
- Vite as the build tool via `@vitejs/plugin-react`
- Production assets built automatically

### Docker

The `app` container serves both the Laravel backend and the Vite-built frontend. The `db` container runs MySQL. The app is accessible at:

```
http://localhost:8888
```

---

## License

MIT