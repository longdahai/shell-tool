#!/bin/bash

curl -fsSL https://get.docker.com | bash -

curl -L https://github.com/docker/compose/releases/download/2.5.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
