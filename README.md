<img src="https://raw.githubusercontent.com/knpromat/promat-website/refs/heads/main/assets/PROMAT-removebg-white.svg" />

# Website

This repository contains source code of https://promat.agh.edu.pl website.

# Development

*The website will deploy automatically when pushed to the `main` branch.*

## Local build

To build the website locally, you need to have [Hugo](https://gohugo.io/) installed. Then, you can run the following command in the root of the repository:

```bash
hugo server
```

# Maintainance Guide

## Updating VPN Certificate

1. go to https://panel.agh.edu.pl
2. Click on "VPN AGH"
3. Download VPN configuration file
4. go to this repository main page -> Settings -> Secrets and Variables -> Actions
5. Next ot the `VPN_CONFIG` variable click on `Edit`
6. Paste content of the downloaded file
7. Configm. Gg, vpn is now up to date!

## Facebook Integration

> [!warning]
> This section is a bit 'experimental' and might not be complete.

> [!note]
> The steps below explain the whole "setup from scratch" process.
> If you came here for maintainance (because e.g. fb integration stopped to work) you probably don't need to start from scratch.
> I'll try to note which steps to start if you just need to re-generate token.

1. Go to https://developers.facebook.com/ and create a new app. If the app already exists, proceed to the step number 4.
2. Go to the "Use cases" tab and add the following cases:
    - "Manage everything on your page": `public_profile`, `pages_show_list`, `pages_read_user_content`, `pages_read_engagement`, `pages_manage_posts`, `business_management`
    - "Access the Thread API": `threads_basic`
3. Publish the app
4. Go to the `App Settings` -> `Basic`. Here you can find `APP_ID` and `APP_SECRET`. Save them for later.
5. Go to https://developers.facebook.com/tools/explorer/
6. Select the following:
    - Meta App: `<Your apps's name>`
    - User or Page: `User Token` (this actually doesn't matter)
    - Permissions: `pages_show_list`, `pages_read_engagement`, `pages_read_user_content`
7. Download the [generations cript](./scripts/generate_app_token.sh) and run it like this:

```sh
APP_ID=<your_app_ID> \
    APP_SECRET=<your_app_secret> \
    USER_TOKEN=<user_access_token> \
    ./scripts/generate_page_token.sh
```

8. On GitHub, navigate: Settings -> Secrets and Variables -> Actions
9. Update/create the following variables:
    - `FB_APP_ID`
    - `FB_APP_SECRET`
    - `FB_PAGE_TOKEN`
