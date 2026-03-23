package utils

import (
	"net"
	"strings"
)

var confLogger = GetLogger("network")

// GetLocalIpV4 retrieves the local IPv4 address for the specified network interface card.
// It returns the IPv4 address as a string or panics if the interface is not found or has no IPv4 address.
func GetLocalIpV4(card string) string {
	inters, err := net.Interfaces()
	if err != nil {
		confLogger.Panic(err)
	}
	ip := ""
	for _, inter := range inters {
		if inter.Flags&net.FlagUp != 0 && strings.HasPrefix(inter.Name, card) {
			addrs, err := inter.Addrs()
			if err != nil {
				continue
			}
			for _, addr := range addrs {
				if net, ok := addr.(*net.IPNet); ok {
					if net.IP.To4() != nil {
						ip = net.IP.String()
					}
				}
			}
		}
	}
	if ip == "" {
		confLogger.Panic("can't found local ip")
	}
	return ip
}
