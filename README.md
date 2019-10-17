# ShellgeiBot-Image

[![CircleCI](https://circleci.com/gh/theoremoon/ShellgeiBot-Image/tree/master.svg?style=svg)](https://circleci.com/gh/theoremoon/ShellgeiBot-Image/tree/master)

A docker image for [shellgeibot](https://github.com/theoremoon/ShellgeiBot). Available at [dockerhub](https://hub.docker.com/r/theoldmoon0602/shellgeibot).


## Build Docker Image

Docker version 18.09 >= is requried.

```
DOCKER_BUILDKIT=1 docker build . -t shellgeibot
```

## Test Docker image

```
docker container run --rm \
  --net=none \
  --oom-kill-disable \
  --pids-limit=1024 \
  -v $(pwd):/root/src \
  shellgeibot \
  /bin/bash -c "bats /root/src/docker_image.bats"
```

## Author

theoremoon

## LICENSE

Apache License

1
