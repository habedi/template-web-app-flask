import click
from src.app import create_app, db
from src.app.models import User

app = create_app()


@app.cli.command("make-admin")
@click.argument("username")
def make_admin(username):
    """Mark a user as admin."""
    user = User.query.filter_by(username=username).first()
    if user:
        user.is_admin = True
        db.session.commit()
        click.echo(f"User '{username}' is now an admin.")
    else:
        click.echo(f"User '{username}' not found.")
