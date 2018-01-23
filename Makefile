build:
	docker build -t rollbar-gem -f Dockerfile .; touch build
with_proxy: build
	docker run --rm \
	-e USER=root \
	-e RAILS_ENV=production \
	-e RACK_ENV=production \
	-e http_proxy=http://using.proxy.com:3128 \
	-e https_proxy=https://using.proxy.com:3128 \
	-e SECRET_KEY_BASE=dba9c806684e4d616eb1ede175fe2eb0585fdbaafc5e12b29ebe9eab3dc523cdd72bdfd0cd5881d8901bda8b993cc3bc7b4cb3583ca4d86fd4578ed692344424 \
	-e ROLLBAR_ACCESS_TOKEN=ae4399e930e34c988d09735769a3b065 \
	--add-host=using.proxy.com:127.0.0.1 \
	-v ${PWD}:/app \
	rollbar-gem
without_proxy: build
	docker run --rm \
	-e USER=root \
	-e RAILS_ENV=production \
	-e RACK_ENV=production \
	-e SECRET_KEY_BASE=dba9c806684e4d616eb1ede175fe2eb0585fdbaafc5e12b29ebe9eab3dc523cdd72bdfd0cd5881d8901bda8b993cc3bc7b4cb3583ca4d86fd4578ed692344424 \
	-e ROLLBAR_ACCESS_TOKEN=ae4399e930e34c988d09735769a3b065 \
	-v ${PWD}:/app \
	rollbar-gem
dev: build
	docker run --rm \
	-it \
	-e USER=root \
	-e RAILS_ENV=production \
	-e RACK_ENV=production \
	-e SECRET_KEY_BASE=dba9c806684e4d616eb1ede175fe2eb0585fdbaafc5e12b29ebe9eab3dc523cdd72bdfd0cd5881d8901bda8b993cc3bc7b4cb3583ca4d86fd4578ed692344424 \
	-e ROLLBAR_ACCESS_TOKEN=ae4399e930e34c988d09735769a3b065 \
	-v ${PWD}:/app \
	--add-host=using.proxy.com:127.0.0.1 \
	rollbar-gem \
	/bin/bash
results.txt:
	@MAKE with_proxy without_proxy 2>&1 > results.txt
