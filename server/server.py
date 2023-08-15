from flask import Flask, redirect, Response, request, render_template
from http import HTTPStatus
import pysondb
from pathlib import Path
from flask_cors import CORS

app = Flask(__name__)
CORS(app)
app.config["TEMPLATES_AUTO_RELOAD"] = True

Path("go-links/").mkdir(parents=True, exist_ok=True)
db = pysondb.getDb("./go-links/links.json")


@app.route("/", strict_slashes=False)
def home():
    return redirect("/go")


@app.route("/go", strict_slashes=False)
def all_links():
    links = db.getAll()
    return render_template("links.html", links=links)


@app.route("/go/<id>", methods=["DELETE"], strict_slashes=False)
def delete_link(id):
    deleted = db.deleteById(id)
    if deleted:
        return Response(status=HTTPStatus.OK)
    else:
        return Response(status=HTTPStatus.NOT_FOUND)


@app.route("/go/<id>", methods=["PUT"], strict_slashes=False)
def edit_link(id):
    data = request.get_json()
    if not data["go_link"]:
        return Response(
            response="body did not contain 'go_link' field",
            status=HTTPStatus.BAD_REQUEST,
        )
    if not data["full_link"]:
        return Response(
            response="body did not contain 'full_link' field",
            status=HTTPStatus.BAD_REQUEST,
        )

    go_link = data["go_link"]
    full_link = data["full_link"]
    db.updateById(int(id), {"go_link": go_link, "full_link": full_link})

    return Response(status=HTTPStatus.OK)


@app.route("/go", methods=["POST"], strict_slashes=False)
def create_link():
    data = request.get_json()
    if not data["go_link"]:
        return Response(
            response="body did not contain 'go_link' field",
            status=HTTPStatus.BAD_REQUEST,
        )
    if not data["full_link"]:
        return Response(
            response="body did not contain 'full_link' field",
            status=HTTPStatus.BAD_REQUEST,
        )

    go_link = data["go_link"]
    full_link = data["full_link"]

    links = db.getBy({"go_link": go_link})
    if len(links) > 0:
        return Response(status=HTTPStatus.CONFLICT)

    db.add({"go_link": go_link, "full_link": full_link})
    return Response(status=HTTPStatus.CREATED)


@app.route("/go/<link>", strict_slashes=False)
def go(link):
    links = db.getBy({"go_link": link})
    if len(links) == 0:
        return Response(status=HTTPStatus.NOT_FOUND)

    return redirect(links[0]["full_link"])


if __name__ == "__main__":
    app.run(host="0.0.0.0")
