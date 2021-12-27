DOCKER_IMAGE_NAME := egison-builder
EGISON_VERSION := 4.1.3
ARCH := $(shell uname -m | sed 's/x86_/amd/;s/aarch/arm/')

.PHONY: all
all: build

.PHONY: build
build: egison-linux-$(ARCH).tar.gz

# egison-linux-amd64.tar.gz はダミー
egison-linux-$(ARCH).tar.gz:
	case "$(ARCH)" in \
	  amd64) touch egison-linux-$(ARCH).tar.gz ;; \
	  arm64) \
	    docker image build -t $(DOCKER_IMAGE_NAME) --progress plain . ; \
	    docker run --rm -v $(CURDIR):/root/pkg $(DOCKER_IMAGE_NAME) /build.sh $(EGISON_VERSION) ;; \
	esac

clean:
	rm -f egison-linux-$(ARCH).tar.gz
