from app import app

client = app.test_client()

def test_home():
    response = client.get("/")
    assert response.status_code == 200
    assert b"TaskFlow" in response.data

def test_add_page():
    response = client.post(
        "/add",
        data={
            "title":"Sample Task",
            "priority":"High"
        },
        follow_redirects=True
    )

    assert response.status_code == 200
    assert b"Sample Task" in response.data
