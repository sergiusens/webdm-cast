package main

import (
	"fmt"
	"log"
	"net"
	"os"
	"strings"
	"time"

	"github.com/davecheney/mdns"
)

func mustPublish(rr string) {
	log.Println("Publishing", rr)
	if err := mdns.Publish(rr); err != nil {
		log.Fatalf(`Unable to publish record "%s": %v`, rr, err)
	}
}

func ipAddrs() (addrs []net.Addr, err error) {
	ifaces, err := net.InterfaceAddrs()
	if err != nil {
		return nil, err
	}

	for _, iface := range ifaces {
		addrs = append(addrs, iface)
	}

	return addrs, nil
}

func main() {
	for {
		loop()
		<-time.After(10 * time.Minute)
	}
}

const inAddr = `%s.local. 60 IN A %s`
const inPtr = `%s.in-addr.arpa. 60 IN PTR %s.local.`

func loop() {
	addrs, err := ipAddrs()
	if err != nil {
		log.Fatal(err)
	}

	hostname, err := os.Hostname()
	if err != nil {
		log.Fatal(err)
	}

	if strings.ContainsRune(hostname, '.') {
		hostname = strings.Split(hostname, ".")[0]
	}

	if hostname == "localhost" {
		hostname = "webdm"
	}

	for _, ip := range addrs {
		ip := strings.Split(ip.String(), "/")[0]
		if strings.HasPrefix(ip, "127.") {
			continue
		}

		mustPublish(fmt.Sprintf(inAddr, hostname, ip))
	}
}
