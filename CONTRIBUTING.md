# Contributing to 41

Thank you for your interest in contributing to the 41 project! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Process](#development-process)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)

## Code of Conduct

This project adheres to a code of conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainers.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/41.git
   cd 41
   ```
3. **Add the upstream remote**:
   ```bash
   git remote add upstream https://github.com/JetSquirrel/41.git
   ```
4. **Install dependencies**:
   ```bash
   make deps
   ```
5. **Install development tools**:
   ```bash
   make install-lint
   ```

## Development Process

### Creating a Branch

Create a new branch for your feature or bug fix:

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/your-bug-fix
```

### Building

Build the project using the Makefile:

```bash
make build          # Production build
make build-debug    # Debug build with symbols
```

### Running

```bash
make run            # Build and run with default settings
sudo ./bin/41 -i lo -p 8001 --protocol http1
```

### Making Changes

1. Make your changes in your feature branch
2. Follow the coding standards (see below)
3. Add or update tests as necessary
4. Ensure all tests pass
5. Run the linter

## Coding Standards

### Go Code Style

- Follow standard Go conventions and idiomatic Go practices
- Use `gofmt` to format your code (automatically done via `make fmt`)
- Follow the [Effective Go](https://golang.org/doc/effective_go) guidelines
- Use meaningful variable and function names
- Add comments for exported functions and complex logic

### Code Organization

- Keep functions small and focused
- Group related functionality together
- Use appropriate package names
- Avoid circular dependencies

### Linting

Run the linter before committing:

```bash
make lint
```

Fix any issues reported by the linter.

### Formatting

Format your code:

```bash
make fmt
```

## Testing

### Running Tests

```bash
make test              # Run all tests
make test-coverage     # Run tests with coverage report
```

### Writing Tests

- Write tests for new functionality
- Maintain or improve code coverage
- Use table-driven tests where appropriate
- Test edge cases and error conditions

Example:

```go
func TestMyFunction(t *testing.T) {
    tests := []struct {
        name    string
        input   string
        want    string
        wantErr bool
    }{
        {"valid input", "test", "result", false},
        {"empty input", "", "", true},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got, err := MyFunction(tt.input)
            if (err != nil) != tt.wantErr {
                t.Errorf("MyFunction() error = %v, wantErr %v", err, tt.wantErr)
                return
            }
            if got != tt.want {
                t.Errorf("MyFunction() = %v, want %v", got, tt.want)
            }
        })
    }
}
```

## Submitting Changes

### Before Submitting

1. Ensure all tests pass: `make test`
2. Run the linter: `make lint`
3. Format your code: `make fmt`
4. Update documentation if needed
5. Commit your changes with clear, descriptive messages

### Commit Messages

Follow these guidelines for commit messages:

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally after the first line

Example:
```
Add HTTP/2 protocol support

- Implement HTTP/2 frame parsing
- Add h2 protocol handler
- Update documentation

Fixes #123
```

### Pull Request Process

1. **Update your branch** with the latest upstream changes:
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

3. **Create a Pull Request** on GitHub with:
   - Clear title and description
   - Reference to related issues
   - Description of changes made
   - Any breaking changes highlighted

4. **Wait for review** and address any feedback

5. **Once approved**, a maintainer will merge your PR

### Review Process

- All submissions require review
- Reviewers may request changes
- Address feedback in new commits
- Once approved, your PR will be merged

## Additional Notes

### Adding Dependencies

When adding new dependencies:

1. Use `go get` to add the dependency
2. Run `make tidy` to clean up `go.mod` and `go.sum`
3. Ensure the dependency is necessary and well-maintained
4. Document why the dependency is needed in your PR

### Adding New Protocols

When adding support for a new protocol:

1. Create a new handler in `internal/protocol/`
2. Add protocol-specific types in `internal/stype/`
3. Update the protocol switch in `internal/protocol/protocol.go`
4. Add tests for the new protocol
5. Update the README with usage examples

## Questions?

If you have questions or need help, please:

- Open an issue on GitHub
- Tag it with the `question` label

Thank you for contributing!
