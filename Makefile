NAME := banking-api
FILE_COVER := ./cover/$(NAME)-cover.html
CMD_PATH := ./cmd/$(NAME)
CMD := $(CMD_PATH)$(NAME)/main.go
RUN_BIN := ./bin/$(NAME)

# HELP COMMANDS
.PHONY: help
help:  ## show this help
	@echo "usage: make [target]"
	@echo ""
	@egrep "^(.+)\:\ .*##\ (.+)" ${MAKEFILE_LIST} | sed 's/:.*##/#/' | column -t -c 2 -s '#'

.PHONY: test
test: deps ## run the application tests (unit)
	@ echo Running GO tests
	@ mkdir -p cover
	@ go test -coverprofile "$(FILE_COVER)" ./... && \
		go tool cover -func="$(FILE_COVER)"
	@ echo Done

.PHONY: run
run: deps ## start the application
	@ go run $(CMD)

.PHONY: run-bin
run-bin: build ## start the application by binary after that compile
	@ $(RUN_BIN)

.PHONY : deps
deps: ## get projects dependencies
	@ cd $(CMD_PATH)/ && \
	go mod verify && \
	go mod tidy;

.PHONY : build
build: deps ## build application code
	@ go version
	@ cd $(CMD_PATH)/ && \
	go build -o ./bin/$(NAME)

.PHONY : clean
clean: ## delete additional application files
	@ rm -rf bin/* cover
	@ go clean --modcache