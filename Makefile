USER := hermantolim
NODE_VERSION := 12
BASE := bionic
NODE := node:$(NODE_VERSION)-$(BASE)
PPTR := pptr:$(NODE_VERSION)-$(BASE)
ARG_BUILD := build --rm --compress -t

.PHONY: all clean build-node test-node build-pptr test-pptr

clean:
	docker container prune -f
	docker image prune -f
	docker image rm -f $(USER)/$(NODE) $(USER)/$(PPTR) >/dev/null 2>&1

build-node: clean
	docker $(ARG_BUILD) $(USER)/$(NODE) ./node/$(NODE_VERSION)

test-node: build-node
	docker run --rm $(USER)/$(NODE) sh -c "echo 'console.log(\"hello world\")' | node -"

build-pptr: test-node
	docker $(ARG_BUILD) $(USER)/$(PPTR) ./pptr

test-pptr: build-pptr
	docker run --rm $(USER)/$(PPTR) /usr/bin/chromium-browser --no-sandbox --headless --disable-gpu --dump-dom https://httpbin.org/anything

gen-node: test
	exec generate-node-dockerfile.sh

all: test-pptr

push: all
	docker push $(USER)/$(NODE)
	docker push $(USER)/$(PPTR)