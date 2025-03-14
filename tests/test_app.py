def test_home_redirects_to_login(client):
    # If your home page is protected, expect a redirect to login.
    response = client.get("/")

    # A 302 status code indicates a redirect.
    assert response.status_code == 302
    assert b"Login" in client.get(response.location).data


def test_register_and_login(client, app):
    # Test user registration.
    response = client.post("/auth/register", data={
        "username": "testuser",
        "password": "testpass123"
    }, follow_redirects=True)

    # Check that registration flash message appears.
    assert b"Registration successful" in response.data

    # Test logging in.
    response = client.post("/auth/login", data={
        "username": "testuser",
        "password": "testpass123"
    }, follow_redirects=True)

    # After login, you might be redirected to the dashboard.
    assert b"Welcome" in response.data  # Adjust according to your dashboard content
