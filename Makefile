all: vet test testrace

build: deps
	go build github/mchirico/grpc/...

clean:
	go clean -i github/mchirico/grpc/...

deps:
	go get -d -v github/mchirico/grpc/...

proto:
	@ if ! which protoc > /dev/null; then \
		echo "error: protoc not installed" >&2; \
		exit 1; \
	fi
	go generate github/mchirico/grpc/...

test: testdeps
	go test -cpu 1,4 -timeout 7m github/mchirico/grpc/...

testsubmodule: testdeps
	cd security/advancedtls && go test -cpu 1,4 -timeout 7m github/mchirico/grpc/security/advancedtls/...

testappengine: testappenginedeps
	goapp test -cpu 1,4 -timeout 7m github/mchirico/grpc/...

testappenginedeps:
	goapp get -d -v -t -tags 'appengine appenginevm' github/mchirico/grpc/...

testdeps:
	go get -d -v -t github/mchirico/grpc/...

testrace: testdeps
	go test -race -cpu 1,4 -timeout 7m github/mchirico/grpc/...

updatedeps:
	go get -d -v -u -f github/mchirico/grpc/...

updatetestdeps:
	go get -d -v -t -u -f github/mchirico/grpc/...

vet: vetdeps
	./vet.sh

vetdeps:
	./vet.sh -install

.PHONY: \
	all \
	build \
	clean \
	deps \
	proto \
	test \
	testappengine \
	testappenginedeps \
	testdeps \
	testrace \
	updatedeps \
	updatetestdeps \
	vet \
	vetdeps
