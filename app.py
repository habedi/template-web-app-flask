from flask import Flask, redirect, render_template, request

app = Flask(__name__)

tasks = [
    {"id":1,"title":"Design Dashboard UI","priority":"High","done":True},
    {"id":2,"title":"Review Pull Request #18","priority":"Medium","done":False},
    {"id":3,"title":"Implement GitHub Actions","priority":"High","done":False},
    {"id":4,"title":"Deploy Production Build","priority":"Low","done":False},
]

@app.route("/")
def index():
    completed = sum(1 for t in tasks if t["done"])
    progress = int((completed / len(tasks)) * 100) if tasks else 0
    return render_template("index.html", tasks=tasks, progress=progress)

@app.post("/add")
def add():
    title = request.form["title"].strip()
    priority = request.form["priority"]

    if title:
        tasks.append({
            "id": len(tasks) + 1,
            "title": title,
            "priority": priority,
            "done": False
        })

    return redirect("/")

@app.post("/toggle/<int:id>")
def toggle(id):
    for t in tasks:
        if t["id"] == id:
            t["done"] = not t["done"]
            break
    return redirect("/")

@app.post("/delete/<int:id>")
def delete(id):
    global tasks
    tasks = [t for t in tasks if t["id"] != id]
    return redirect("/")

if __name__ == "__main__":
    app.run(debug=True)
