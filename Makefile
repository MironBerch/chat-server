LOCAL_BIN := $(CURDIR)/bin
export PATH := $(LOCAL_BIN):$(PATH)

install-golangci-lint:
	curl -sSfL https://golangci-lint.run/install.sh | sh -s -- -b $(LOCAL_BIN) v2.12.2

install-protoc:
	sudo apt install -y protobuf-compiler

install-protoc-gen-go:
	GOBIN=$(LOCAL_BIN) go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	GOBIN=$(LOCAL_BIN) go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

install-deps:
	install-golangci-lint install-protoc install-protoc-gen-go

lint:
	golangci-lint run ./... --config .golangci.yaml

lint-fix:
	golangci-lint run --fix ./... --config .golangci.yaml

lint-feature:
	golangci-lint run --config .golangci.yaml --new-from-rev dev

generate:
	protoc --proto_path=api --go_out=. --go-grpc_out=. api/chat_v1/chat.proto
