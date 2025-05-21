import logging
import os
from logging.handlers import RotatingFileHandler

from flask import Flask, flash, redirect, render_template, request, url_for
from flask_login import LoginManager, current_user, login_required
from flask_migrate import Migrate
from flask_sqlalchemy import SQLAlchemy
from flask_wtf import CSRFProtect
from src.config import DevelopmentConfig  # Import config from src/config.py

# Initialize extensions
db = SQLAlchemy()
migrate = Migrate()
login_manager = LoginManager()
csrf = CSRFProtect()


def create_app():
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_object(DevelopmentConfig)

    # Initialize extensions
    db.init_app(app)
    migrate.init_app(app, db)
    login_manager.init_app(app)
    login_manager.login_view = "auth.login"
    csrf.init_app(app)

    @login_manager.user_loader
    def load_user(user_id):
        from src.app.models import User  # Adjust the import as needed

        return User.query.get(int(user_id))

    # Register blueprints
    from src.app.auth import auth_bp
    from src.app.dashboard import dashboard_bp

    app.register_blueprint(auth_bp)
    app.register_blueprint(dashboard_bp)

    @app.route("/")
    def home():
        return render_template("dashboard.html")

    @app.route("/about")
    @login_required
    def about():
        return render_template("about.html")

    @app.route("/contact", methods=["GET", "POST"])
    @login_required
    def contact():
        if request.method == "POST":
            name = request.form.get("name")
            email = request.form.get("email")
            message = request.form.get("message")
            # Process the contact form data (store it, send email, etc.)
            flash("Your message has been sent!", "success")
            return redirect(url_for("contact"))
        return render_template("contact.html")

    # ==============================
    # Admin Panel via Flask-Admin
    # ==============================
    from flask_admin import Admin
    from flask_admin.contrib.sqla import ModelView
    from wtforms.fields import BooleanField

    class MyModelView(ModelView):
        # Exclude fields that shouldn't be edited via the form.
        form_excluded_columns = ["password_hash"]

        # Explicitly override is_admin to be a BooleanField.
        form_overrides = {"is_admin": BooleanField}

        def is_accessible(self):
            return current_user.is_authenticated and getattr(current_user, "is_admin", False)

        def inaccessible_callback(self, name, **kwargs):
            return redirect(url_for("auth.login"))

    admin = Admin(app, name="Admin Panel", template_mode="bootstrap3")
    # Import models to add them to admin
    from src.app.models import User  # Add additional models if needed

    admin.add_view(MyModelView(User, db.session))

    # Now, the admin panel is accessible at /admin

    # ==============================
    # Error Handlers
    # ==============================
    @app.errorhandler(404)
    def not_found_error(error):
        return render_template("errors/404.html"), 404

    @app.errorhandler(500)
    def internal_error(error):
        db.session.rollback()  # In case there was a database error
        return render_template("errors/500.html"), 500

    # ==============================
    # Logging Setup (optional)
    # ==============================
    if not app.debug and not app.testing:
        if not os.path.exists("logs"):
            os.mkdir("logs")
        file_handler = RotatingFileHandler("logs/app.log", maxBytes=10240, backupCount=10)
        file_handler.setFormatter(
            logging.Formatter("%(asctime)s %(levelname)s: %(message)s [in %(pathname)s:%(lineno)d]")
        )
        file_handler.setLevel(logging.INFO)
        app.logger.addHandler(file_handler)
        app.logger.setLevel(logging.INFO)
        app.logger.info("App startup")

    with app.app_context():
        db.create_all()

    return app


app = create_app()
