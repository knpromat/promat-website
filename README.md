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
