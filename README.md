# 41 - Network Packet Capture and Protocol Analysis Tool

A high-performance network packet capture tool that intercepts, analyzes, and forwards protocol data to Apache Kafka for real-time processing and analysis.

## Features

- **Protocol Support**: HTTP/1.x, gRPC, Protobuf, JCE, RequestF
- **Real-time Capture**: Live network packet interception using libpcap
- **Kafka Integration**: Efficient message streaming to Kafka topics
- **Flexible Configuration**: Command-line interface with comprehensive options
- **Performance**: Optimized for high-throughput packet processing

## Status

This project is currently under active development.

### Roadmap

- [x] HTTP/1.x support
- [x] Kafka integration
- [x] Protobuf support
- [x] JCE protocol support
- [x] gRPC support
- [ ] HTTP/2 support
- [ ] HTTP/3 support

## Prerequisites

- Go 1.22 or higher
- libpcap development libraries
- Apache Kafka (optional, for message forwarding)

### Installing libpcap

**Ubuntu/Debian:**
```bash
sudo apt-get install libpcap-dev
```

**CentOS/RHEL:**
```bash
sudo yum install libpcap-devel
```

**macOS:**
```bash
brew install libpcap
```

## Installation

### From Source

```bash
# Clone the repository
git clone https://github.com/JetSquirrel/41.git
cd 41

# Build the binary
make build

# Or use go directly
go build -o 41 cmd/41/main.go
```

## Usage

### Basic Command

```bash
sudo ./41 -i <interface> -p <port> --protocol <protocol>
```

### Command-Line Options

| Flag | Short | Description | Default |
|------|-------|-------------|---------|
| `--interface` | `-i` | Network interface to capture on | Required |
| `--port` | `-p` | Target port to monitor | 80 |
| `--protocol` | | Protocol to parse (http1, requestf) | http1 |
| `--snapshot-length` | `-l` | Maximum packet capture length | 10240 |
| `--filter` | `-f` | BPF filter expression | - |
| `--kafka-host` | `-d` | Kafka broker address | 127.0.0.1:9092 |
| `--kafka-topic` | `-t` | Kafka topic name | test-41 |
| `--kafka-worker` | `-w` | Number of Kafka workers | 10 |
| `--kafka-send-interval` | `-s` | Send interval in seconds | 5 |
| `--kafka-send-queue` | `-q` | Send queue size | 500000 |

### Examples

**Capture HTTP traffic on port 8001:**
```bash
sudo ./41 -i lo -p 8001 --protocol http1
```

**Capture with Kafka forwarding:**
```bash
sudo ./41 -i eth0 -p 80 --protocol http1 \
  --kafka-host localhost:9092 \
  --kafka-topic web-traffic \
  --kafka-worker 20
```

**Capture on custom interface with filter:**
```bash
sudo ./41 -i ens33 -p 443 --protocol http1 -f "tcp and not port 22"
```

## Development

### Building

```bash
# Build the project
make build

# Build for development (with debug symbols)
make build-debug

# Run tests
make test

# Run linter
make lint
```

### Project Structure

```
.
├── cmd/
│   └── 41/              # Main application entry point
├── internal/
│   ├── protocol/        # Protocol handlers
│   ├── sender/          # Kafka sender implementation
│   ├── server/          # CLI server setup
│   ├── stype/           # Protocol-specific type definitions
│   └── utils/           # Utility functions
├── scripts/             # Helper scripts
└── build/               # Build scripts
```

## Testing with Docker

A Docker Compose setup is provided for local Kafka testing:

```bash
cd scripts
docker-compose up -d
```

This will start:
- Zookeeper on port 2181
- Kafka on port 9092

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with [gopacket](https://github.com/google/gopacket) for packet capture
- Uses [kafka-go](https://github.com/segmentio/kafka-go) for Kafka integration
- CLI powered by [urfave/cli](https://github.com/urfave/cli)

## Support

For issues, questions, or contributions, please open an issue on GitHub.
