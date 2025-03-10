# Astro 5 / Deno 2 / Tailwind 4 Bootstrap template

This template sets up a project using Astro v5, Deno v2 runtime, and Tailwind
CSS v4.

## Installation

Follow these steps to get started:

```bash
# Initialize the project
deno init

# Install dependencies
deno task install

# Build the project
deno task astro:build

# Preview the project
deno task preview
```

## Project Structure

```
.
├── astro.config.mjs
├── deno.json
├── deno.lock
├── .devcontainer
│   ├── config_init.sh
│   ├── devcontainer.json
│   ├── docker-compose.yml
│   ├── Dockerfile
│   ├── .dockerignore
│   ├── .env
│   └── .env.dist
├── .gitignore
├── LICENSE
├── main_test.ts
├── main.ts
├── package.json
├── public
│   └── favicon.svg
├── README.md
├── src
│   ├── actions
│   ├── assets
│   │   ├── astro.svg
│   │   └── background.svg
│   ├── components
│   │   └── Welcome.astro
│   ├── content
│   ├── layouts
│   │   └── Layout.astro
│   ├── pages
│   │   └── index.astro
│   └── styles
│       └── global.css
└── .vscode
    ├── launch.json
    ├── settings.json
    └── tasks.json

12 directories, 26 files
```

## Technologies

- **Astro v5**: A modern static site builder.
- **Deno v2**: A secure runtime for JavaScript and TypeScript.
- **Tailwind CSS v4**: A utility-first CSS framework.
- **PostgreSQL 17 (optional)**: SQL database
  (`.devcontainer/docker-compose.yml`).
- **pgAdmin 4 (optional)**: PostgreSQL UI (`.devcontainer/docker-compose.yml`).

Note: The Svelte VS Code extension is also installed for convenience, but can be
removed easily if not needed `.devcontainer/devcontainer.json` and
`.vscode/settings.json`).

## Development

To start the development server:

```bash
deno task dev
```

## Building

To build the project for production:

```bash
deno task astro:build
```

## Preview

To preview the production build:

```bash
deno task preview
```

## Upgrade

In order to upgrade the project to the latest versions of it's dependencies, run

```bash
deno task upgrade
```

## License

This project is licensed under the Apache 2.0 license.
