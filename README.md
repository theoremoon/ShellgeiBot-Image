# ShellgeiBot-Image

[![CircleCI](https://circleci.com/gh/theoldmoon0602/ShellgeiBot-Image/tree/master.svg?style=svg)](https://circleci.com/gh/theoldmoon0602/ShellgeiBot-Image/tree/master)

A docker image for [shellgeibot](https://github.com/theoldmoon0602/ShellgeiBot). Available at [dockerhub](https://hub.docker.com/r/theoldmoon0602/shellgeibot).


## Build Docker Image

Docker version 18.09 >= is requried.

```
DOCKER_BUILDKIT=1 docker build . -t shellgeibot
```

## Test Docker image

```
docker container run --rm \
  --net=none \
  --memory=100m \
  --oom-kill-disable \
  --pids-limit=1024 \
  --cap-add=sys_ptrace \
  -v $(pwd):/root/src \
  shellgeibot \
  /bin/bash -c "bats /root/src/docker_image.bats"
```

## Author

theoldmooon0602

## LICENSE

Apache License

