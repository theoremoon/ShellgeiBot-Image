# ShellgeiBot-Image

A docker image for [shellgeibot](https://github.com/theoldmoon0602/ShellgeiBot). Available at [dockerhub](https://hub.docker.com/r/theoldmoon0602/shellgeibot).


## Test Docker image

```
docker container run --rm \
  -v $(pwd):/root/src \
  shellgeibot \
  /bin/bash -c "bats /root/src/docker_image.bats"
```

## Author

theoldmooon0602

## LICENSE

Apache License

