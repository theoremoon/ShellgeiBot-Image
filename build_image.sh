#!/bin/bash

readonly NO_CACHE=$1

time DOCKER_BUILDKIT=1 docker build $NO_CACHE -t shellgeibot .
