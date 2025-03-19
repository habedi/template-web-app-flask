import os

from dotenv import load_dotenv

# Load environment variables from .env file (if available)
load_dotenv()

# Define the path to the instance folder
basedir = os.path.abspath(os.path.join(os.path.dirname(__file__), "db", "instance"))


class Config:
    """Base configuration for all environments"""

    DEBUG = False
    TESTING = False
    BOOTSTRAP_FONTAWESOME = True
    CSRF_ENABLED = True
    SECRET_KEY = os.getenv("SECRET_KEY", "supersecretkey")  # Use env var, fallback to default
    SQLALCHEMY_DATABASE_URI = \
        os.getenv("DATABASE_URL", "sqlite:///" + os.path.join(basedir, "site.db"))
    SQLALCHEMY_TRACK_MODIFICATIONS = False

    # See https://www.google.com/recaptcha/admin/create
    # RECAPTCHA_PUBLIC_KEY = "PUT_YOUR_RECAPTCHA_PUBLIC_KEY_HERE"
    # RECAPTCHA_PRIVATE_KEY = "PUT_YOUR_RECAPTCHA_PRIVATE_KEY_HERE"


class DevelopmentConfig(Config):
    DEBUG = True


class TestingConfig(Config):
    TESTING = True
    WTF_CSRF_ENABLED = False
    SQLALCHEMY_DATABASE_URI = "sqlite:///" + os.path.join(basedir, "test.db")


class ProductionConfig(Config):
    DEBUG = False
    SESSION_COOKIE_SECURE = True  # Only send session cookie over HTTPS
    REMEMBER_COOKIE_SECURE = True  # Only send "remember me" cookie over HTTPS
    SESSION_COOKIE_HTTPONLY = True  # Prevent client-side scripts from accessing the session cookie
    SESSION_COOKIE_SAMESITE = "Lax"  # Helps mitigate CSRF by not sending cookies on cross-site requests (or 'Strict' for even tighter control)
