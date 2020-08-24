#!/bin/bash

# Example for the Docker Hub V2 API
# Returns all images associated with a Docker Hub user account.
# Requires 'jq': https://stedolan.github.io/jq/

# Set username and password
#export UNAME='UNAME'
#export UPASS='UPASS'

# Acquire token
TOKEN=$(curl -s -H "Content-Type: application/json" -X POST -d '{"username": "'${UNAME}'", "password": "'${UPASS}'"}' https://hub.docker.com/v2/users/login/ | jq -r .token)

# Get list of repositories for the user account
REPO_LIST=$(curl -s -H "Authorization: JWT ${TOKEN}" "https://hub.docker.com/v2/repositories/${UNAME}/?page_size=100" | jq -r '.results|.[]|.name')

# Build a list of all images
for i in ${REPO_LIST}
do
    IMAGE="${UNAME}/${i}"
    echo "IMAGE: ${IMAGE}"
    docker pull ${IMAGE}

    sleep 1m
done
