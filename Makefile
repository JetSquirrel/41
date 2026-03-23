.PHONY: help build build-debug clean test lint fmt vet install run deps tidy

# Binary name
BINARY_NAME=41
BINARY_DEBUG=$(BINARY_NAME)_debug

# Build directory
BUILD_DIR=bin

# Go parameters
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
GOMOD=$(GOCMD) mod
GOFMT=$(GOCMD) fmt
GOVET=$(GOCMD) vet

# Main package path
MAIN_PATH=./cmd/41

# Build flags
LDFLAGS=-ldflags "-s -w"

help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

deps: ## Download dependencies
	@echo "Downloading dependencies..."
	$(GOMOD) download
	$(GOMOD) tidy

build: deps ## Build the binary
	@echo "Building $(BINARY_NAME)..."
	@mkdir -p $(BUILD_DIR)
	$(GOBUILD) $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME) $(MAIN_PATH)
	@echo "Build complete: $(BUILD_DIR)/$(BINARY_NAME)"

build-debug: deps ## Build binary with debug symbols
	@echo "Building $(BINARY_DEBUG) with debug symbols..."
	@mkdir -p $(BUILD_DIR)
	$(GOBUILD) -gcflags="all=-N -l" -o $(BUILD_DIR)/$(BINARY_DEBUG) $(MAIN_PATH)
	@echo "Debug build complete: $(BUILD_DIR)/$(BINARY_DEBUG)"

install: ## Install the binary to $GOPATH/bin
	@echo "Installing $(BINARY_NAME)..."
	$(GOBUILD) $(LDFLAGS) -o $(GOPATH)/bin/$(BINARY_NAME) $(MAIN_PATH)
	@echo "Installed to $(GOPATH)/bin/$(BINARY_NAME)"

clean: ## Remove build artifacts
	@echo "Cleaning..."
	$(GOCLEAN)
	@rm -rf $(BUILD_DIR)
	@rm -f $(BINARY_NAME) $(BINARY_DEBUG)
	@echo "Clean complete"

test: ## Run tests
	@echo "Running tests..."
	$(GOTEST) -v -race -coverprofile=coverage.txt -covermode=atomic ./...

test-coverage: test ## Run tests with coverage report
	@echo "Generating coverage report..."
	$(GOCMD) tool cover -html=coverage.txt -o coverage.html
	@echo "Coverage report generated: coverage.html"

lint: ## Run golangci-lint
	@echo "Running linter..."
	@which golangci-lint > /dev/null || (echo "golangci-lint not installed. Run: make install-lint" && exit 1)
	golangci-lint run --timeout=5m ./...

install-lint: ## Install golangci-lint
	@echo "Installing golangci-lint..."
	@which golangci-lint > /dev/null || curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $$(go env GOPATH)/bin v1.55.2

fmt: ## Format code
	@echo "Formatting code..."
	$(GOFMT) ./...

vet: ## Run go vet
	@echo "Running go vet..."
	$(GOVET) ./...

tidy: ## Tidy go.mod
	@echo "Tidying go.mod..."
	$(GOMOD) tidy

run: build ## Build and run the application (requires sudo for packet capture)
	@echo "Running $(BINARY_NAME)..."
	@echo "Note: You may need to run with sudo for packet capture"
	sudo $(BUILD_DIR)/$(BINARY_NAME) -i lo -p 8001 --protocol http1

run-debug: build-debug ## Build and run in debug mode
	@echo "Running $(BINARY_DEBUG)..."
	@echo "Note: You may need to run with sudo for packet capture"
	sudo $(BUILD_DIR)/$(BINARY_DEBUG) -i lo -p 8001 --protocol http1

docker-up: ## Start Kafka and Zookeeper with Docker Compose
	@echo "Starting Kafka and Zookeeper..."
	cd scripts && docker-compose up -d

docker-down: ## Stop Kafka and Zookeeper
	@echo "Stopping Kafka and Zookeeper..."
	cd scripts && docker-compose down

docker-logs: ## Show Docker Compose logs
	cd scripts && docker-compose logs -f

check: fmt vet lint test ## Run all checks (format, vet, lint, test)

all: clean deps check build ## Clean, check, and build
