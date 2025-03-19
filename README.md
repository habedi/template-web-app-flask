## A Flask Web Application Template

[![Tests](https://img.shields.io/github/actions/workflow/status/habedi/template-web-app-flask/tests.yml?label=tests&style=flat&labelColor=282c34&logo=github)](https://github.com/habedi/template-web-app-flask/actions/workflows/tests.yml)
[![Lints](https://img.shields.io/github/actions/workflow/status/habedi/template-web-app-flask/lints.yml?label=lints&style=flat&labelColor=282c34&logo=github)](https://github.com/habedi/template-web-app-flask/actions/workflows/lints.yml)
[![Code Coverage](https://img.shields.io/codecov/c/github/habedi/template-web-app-flask?style=flat&labelColor=282c34&color=ffca28&logo=codecov)](https://codecov.io/gh/habedi/template-web-app-flask)
[![CodeFactor](https://img.shields.io/codefactor/grade/github/habedi/template-web-app-flask?style=flat&labelColor=282c34&color=4caf50&logo=codefactor)](https://www.codefactor.io/repository/github/habedi/template-web-app-flask)
[![Python version](https://img.shields.io/badge/python-%3E=3.10-3776ab?style=flat&labelColor=282c34&logo=python)](https://github.com/habedi/template-web-app-flask)
[![Docs](https://img.shields.io/badge/docs-latest-007ec6?style=flat&labelColor=282c34&logo=readthedocs)](https://github.com/habedi/template-web-app-flask/blob/main/docs/README.md)
[![License](https://img.shields.io/badge/license-MIT-007ec6?style=flat&labelColor=282c34&logo=open-source-initiative)](https://github.com/habedi/template-web-app-flask/blob/main/LICENSE)

This is a template for building [Flask](https://flask.palletsprojects.com/en/stable/) web applications.
It provides many features right out of the box, including user authentication, database migrations,
and modular blueprints to help you quickly get started on your projects.
I share it here in case it might be useful to others.

### Features

- Minimalistic template for building Flask web applications
- Modular blueprint-based structure
- Database support with Flask-SQLAlchemy and migrations
- User authentication with Flask-Login
- CSRF protection via Flask-WTF
- Responsive design with a top navigation bar
- Large collection of pre-installed Flask extensions:
    - Flask-Login: User session management
    - Flask-Bootstrap: Ready-to-use Twitter Bootstrap
    - Flask-Uploads: Handle file uploading and serving
    - Flask-Cache: Adds cache support
    - Flask-Admin: Admin interface module
    - Flask-Flatpages: Flat static pages based on text files
    - Flask-Gravatar: Easy Gravatar integration
    - Flask-Mail: Easy mail sending and unittesting support
    - Flask-Restless: Simple generation of ReSTful APIs
    - Flask-SQLAlchemy: Adds SQLAlchemy support
    - Flask-Themes: Support for a wide range of appearances
    - Flask-WTF: Integration of Flask and WTForms, including CSRF, file upload, and reCAPTCHA

### Getting Started

Check out the targets in the [Makefile](Makefile) for available commands to manage the development workflow of the
project.
You can use the `make help` command to see all available commands.

### Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to make a contribution.

### License

This project is licensed under the terms of the MIT license ([LICENSE](LICENSE) or https://opensource.org/licenses/MIT).
