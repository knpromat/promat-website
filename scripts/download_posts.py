#!/bin/env python
import requests
import json
import subprocess
import os
from pathlib import Path

POSTS_URL = "https://graph.facebook.com/v25.0/115858349789616/feed?fields=created_time%2Cmessage%2Cfull_picture%2Cid"
PATH = Path("content/posts/")


def fetch_page_access_token() -> str:
    token = os.getenv("ACCESS_TOKEN")
    if token is None:
        print("No ACCESS_TOKEN env")
        exit(1)
    return token


def create_hugo_file(
    id: int | str, date: str, summary: str, contents: str, photo: bool
):
    filepath = PATH / f"{id}" / "index.md"
    filepath.touch()
    with filepath.open("a") as file:
        file.write("---\n")
        file.write(f'id: "{id}"\n')
        file.write(f'date: "{date}"\n')
        file.write("---\n")
        file.write("\n")
        if photo:
            file.write("![header](main_image.jpg)\n")
        file.write(contents)


def exists(id: int | str) -> bool:
    q = PATH / f"{id}"
    return q.exists() and q.is_dir()


def crate_folder_and_image(id: int | str, image_url: str | None):
    post_path = PATH / f"{id}"
    post_path.mkdir()
    if image_url is not None:
        subprocess.run(["wget", "-O", str(post_path / "main_image.jpg"), image_url])


def parse_request(j):
    for post in j["data"]:
        if exists(post["id"]):
            print(f"Skipping post {j['id']}, because it already exists")
            continue
        if "message" not in post:
            print(f"Skipping post {j}, because it doesn't have message")
            continue
        summary = post["message"][:80]
        if "full_picture" in post:
            crate_folder_and_image(post["id"], post["full_picture"])
            create_hugo_file(
                post["id"], post["created_time"], summary, post["message"], True
            )
        else:
            crate_folder_and_image(post["id"], None)
            create_hugo_file(
                post["id"], post["created_time"], summary, post["message"], False
            )


def main():
    url = POSTS_URL
    access_token = fetch_page_access_token()
    while True:
        r = requests.get(url, params={"access_token": access_token})
        j = json.loads(r.text)

        if r.status_code != 200:
            print(f"recived: {r.status_code} status_code")
            print(r.text)
            exit(1)

        parse_request(j)

        if "next" not in j["paging"].keys():
            exit(0)
        url = j["paging"]["next"]


if __name__ == "__main__":
    main()
