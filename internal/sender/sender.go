// Package sender provides interfaces and implementations for sending captured data
// to various backends (e.g., Kafka).
package sender

// Sender is an interface for sending captured packet data to a backend.
type Sender interface {
	// Send transmits the provided byte slice to the configured backend.
	// Returns an error if the send operation fails.
	Send([]byte) error
}
