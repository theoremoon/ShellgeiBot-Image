#!/bin/bash

set -eu

docker container run --rm \
  -v $(pwd):/root/src \
  shellgeibot \
  /bin/bash -c "bats /root/src/docker_image.bats"
