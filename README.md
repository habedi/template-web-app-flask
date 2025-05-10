## A Flask Web Application Template

[![Tests](https://img.shields.io/github/actions/workflow/status/habedi/template-web-app-flask/tests.yml?label=tests&style=flat&labelColor=282c34&logo=github)](https://github.com/habedi/template-web-app-flask/actions/workflows/tests.yml)
[![Lints](https://img.shields.io/github/actions/workflow/status/habedi/template-web-app-flask/lints.yml?label=lints&style=flat&labelColor=282c34&logo=github)](https://github.com/habedi/template-web-app-flask/actions/workflows/lints.yml)
[![Code Coverage](https://img.shields.io/codecov/c/github/habedi/template-web-app-flask?style=flat&labelColor=282c34&color=ffca28&logo=codecov)](https://codecov.io/gh/habedi/template-web-app-flask)
[![CodeFactor](https://img.shields.io/codefactor/grade/github/habedi/template-web-app-flask?style=flat&labelColor=282c34&color=4caf50&logo=codefactor)](https://www.codefactor.io/repository/github/habedi/template-web-app-flask)
[![Python version](https://img.shields.io/badge/python-%3E=3.10-3776ab?style=flat&labelColor=282c34&logo=python)](https://github.com/habedi/template-web-app-flask)
[![Docs](https://img.shields.io/badge/docs-latest-007ec6?style=flat&labelColor=282c34&logo=readthedocs)](https://github.com/habedi/template-web-app-flask/blob/main/docs/README.md)
[![License](https://img.shields.io/badge/license-MIT-007ec6?style=flat&labelColor=282c34&logo=open-source-initiative)](https://github.com/habedi/template-web-app-flask/blob/main/LICENSE)

This is a template for building [Flask](https://flask.palletsprojects.com/en/stable/) web applications.
It provides many useful features right out of the box, including user authentication, database migrations,
and modular blueprints to help you quickly get started on your projects.
I share it here in case it might be useful to others.

### Features

- Minimalistic template for building Flask web applications
- Modular blueprint-based structure for easy project organization
- Pre-configured settings for development, testing, and production environments
- Pre-configured GitHub Actions for automated testing and linting
- Makefile for managing the development workflow (testing, linting, database migrations, containerization, etc.)
- Poetry-based dependency management for a modern Python workflow
- Large collection of pre-installed Flask extensions (plugins):
    - Security & Authentication
        - Flask-Login: User login and session management
        - Flask-WTF: CSRF protection, form validation, and file uploads
        - Flask-Talisman: HTTP security headers (CSP, HSTS, etc.)
        - Flask-Limiter: Rate limiting support to prevent abuse
    - Database & Caching
        - Flask-SQLAlchemy: ORM support for working with databases
        - Flask-Migrate: Database migrations with Alembic
        - Flask-Caching: Adds caching support for improved performance
        - Flask-SQLAlchemy-Cache: Adds caching to SQLAlchemy queries
        - SQLAlchemy-Utils: Extra utilities for SQLAlchemy (UUIDs, JSON fields, etc.)
    - API & Real-Time Communication
        - Flask-RESTful: REST API support for Flask applications
        - Flask-GraphQL: GraphQL support using Graphene
        - Flask-SocketIO: WebSocket support for real-time applications
        - Flask-APScheduler: Background job scheduling (cron-like tasks)
        - Flask-HTMX: Enables dynamic content updates with minimal JavaScript
    - Frontend & UI
        - Bootstrap-Flask: Rendering Flask data into Bootstrap HTML using Jinja macros
        - Flask-Themes: Support for multiple UI themes
        - Flask-Flatpages: Static page rendering (Markdown, reStructuredText, etc.)
        - Flask-Dropzone: Drag-and-drop file uploads with preview support
    - File Handling & Misc Utilities
        - Flask-Reuploaded: Maintained fork of Flask-Uploads for file management
        - Flask-Mail: Email sending support (e.g., password resets, notifications)
        - Flask-Gravatar: Automatic Gravatar integration
        - Flask-Compress: Gzip/Brotli compression for faster responses
        - Flask-Injector: Dependency injection for better modularity

### Getting Started

Install the required dependencies using [Poetry](https://python-poetry.org/):

```shell
# Install the required system dependencies like GNU Make, Pip, and Docker (for Debian-based systems)
sudo sudo apt-get install make python3-pip docker.io docker-compose

# Install Poetry (version 2.0 or higher)
pip install poetry

# Install the Python dependencies (must be run in the project root directory)
poetry install --no-root

# Activate the Poetry environment
poetry env activate
```

Check out the [Makefile](Makefile) for available commands to manage the development workflow of the project.

```shell
# Show available commands in the Makefile
make help
```

You can put the environment variables in a `.env` file in the project root directory to be loaded on startup.
See the [.env.example](.env.example) file for an example.

```shell
# Create a new .env file
cp .env.example .env
```

> [!NOTE]
> The `.env` file normally should not be committed to the repository, so it is in the `.gitignore` file by default.

### Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to make a contribution.

### License

This project is licensed under the terms of the MIT license ([LICENSE](LICENSE) or https://opensource.org/licenses/MIT).
