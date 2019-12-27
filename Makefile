OWNER:=hermantolim
BASE:=chromium:bionic
NODE:=chromium:12.14.0-bionic

.PHONY: clean build test build-node test-node push

clean:
	docker container prune -f
	docker image rm -f $(OWNER)/$(BASE) $(OWNER)/$(NODE) $(OWNER)/$(NODE)-test

build: clean
	docker build --rm --compress -t $(OWNER)/$(BASE) ./base

test: build
	docker run --rm $(OWNER)/$(BASE) sh -c "/usr/bin/id -G -n"
	docker run --rm $(OWNER)/$(BASE) sh -c "/usr/bin/chromium-browser --dump-dom https://httpbin.org/anything"
	docker run --rm $(OWNER)/$(BASE) chromium-browser --dump-dom https://httpbin.org/status/200

build-node: test
	docker build --rm --compress -t $(OWNER)/$(NODE) ./nodejs

test-node: build-node
	docker build --rm --compress -t $(OWNER)/$(NODE)-test ./test
	docker run --rm $(OWNER)/$(NODE)-test sh -c "npm -v && node -v"
	docker run --rm $(OWNER)/$(NODE)-test npm start
	docker image rm $(OWNER)/$(NODE)-test

push: test-node
	docker push $(OWNER)/$(BASE)
	docker push $(OWNER)/$(NODE)