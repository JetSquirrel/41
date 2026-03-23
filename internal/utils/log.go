// Package utils provides utility functions for logging, networking, and other common operations.
package utils

import (
	"log"
	"os"
)

// GetLogger creates and returns a new logger instance with the specified name.
// The logger is configured with timestamps, microseconds, and short file information.
func GetLogger(name string) *log.Logger {
	return log.New(os.Stdout, name+":  ", log.Lshortfile|log.Lmicroseconds|log.Ldate)
}
