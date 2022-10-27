.PHONY: awslabs/sigv4-proxy/build
awslabs/sigv4-proxy/build:
ifeq ("$(wildcard /tmp/aws-sigv4-proxy)", "")
	git clone https://github.com/awslabs/aws-sigv4-proxy.git /tmp/aws-sigv4-proxy
endif
	cd /tmp/aws-sigv4-proxy ;\
	docker build . -t aws-sigv4-proxy

.PHONY: awslabs/sigv4-proxy/run
awslabs/sigv4-proxy/run:
	$(call assert-set,AWS_PROFILE)
	docker run --rm -ti -v ~/.aws:/root/.aws -p 8080:8080 -e 'AWS_SDK_LOAD_CONFIG=true' -e 'AWS_PROFILE=$(AWS_PROFILE)' aws-sigv4-proxy -v

.PHONY: awslabs/sigv4-proxy/run-service-region
awslabs/sigv4-proxy/run-service-region:
	$(call assert-set,AWS_PROFILE)
	$(call assert-set,AWS_SERVICE)
	$(call assert-set,AWS_DEFAULT_REGION)
	docker run --rm -ti -v ~/.aws:/root/.aws -p 8080:8080 -e 'AWS_SDK_LOAD_CONFIG=true' -e 'AWS_PROFILE=$(AWS_PROFILE)' aws-sigv4-proxy -v --name $(AWS_SERVICE) --port :9200
