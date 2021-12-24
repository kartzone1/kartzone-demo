#!jinja|yaml|gpg
# -*- coding: utf-8 -*-
# vim: ft=yaml
---
docker:
  wanted:
    - docker

  pkg:
    docker:
      use_upstream: repo
      daemon_config:
        data-root: "/srv/docker"
        bridge: "none"

  networks:
    - frontend
    - backend

  compose:
    ng:
      shaarli:
        image: 'shaarli/shaarli:latest'
        container_name: 'shaarli'
        networks:
          - frontend
        ports:
          - '8000:80'
        restart: unless-stopped
        volumes:
          - shaarli-data:/var/www/shaarli/data
          - shaarli-cache:/var/www/shaarli/cache
