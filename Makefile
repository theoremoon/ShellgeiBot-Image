.PHENY: build prefetch

DOCKER_IMAGE_NAME=theoldmoon0602/shellgeibot

build: prefetch buildlog revisionlog
	DOCKER_BUILDKIT=1 docker image build -t ${DOCKER_IMAGE_NAME} .

build-ci:
	DOCKER_BUILDKIT=1 docker image build -t ${DOCKER_IMAGE_NAME} --progress=plain .

prefetch:
	./prefetch_files.sh

buildlog:
	./get_build_log.sh > ci_build.log

revisionlog:
	git log --pretty="format:%h %cd %s [%an]" --date=iso -n 20 > revision.log

test:
	docker container run \
		--rm \
		--net=none \
		--oom-kill-disable \
		--pids-limit=1024 \
		-v ${CURDIR}:/root/src \
		${DOCKER_IMAGE_NAME} \
		/bin/bash -c "bats /root/src/docker_image.bats"

clean:
	rm -f *.log
	rm -f prefetched/*.gz prefetched/*.zip
