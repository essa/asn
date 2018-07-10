package main

import (
	"flag"
	"fmt"
	"log"
	"net"
	"os"

	"net/http"

	"github.com/oschwald/geoip2-golang"
)

var (
	startHttp = flag.Bool("h", false, "start http server")
	port      = flag.Int("p", 8080, "port number")
	db        *geoip2.Reader
)

func init() {
	var err error
	db, err = geoip2.Open("GeoLite2-ASN.mmdb")
	if err != nil {
		log.Fatal(err)
		os.Exit(-1)
	}
}

type AsnError struct {
	Msg string
}

func (e *AsnError) Error() string {
	return e.Msg
}

func getASN(db *geoip2.Reader, asn string) (uint, error) {
	asnIp := net.ParseIP(asn)
	if asnIp == nil {
		return 0, &AsnError{Msg: "can't convert " + asn}
	}
	record, err := db.ASN(asnIp)
	if err != nil {
		return 0, &AsnError{Msg: "can't get ASN from " + asn}
	}
	return record.AutonomousSystemNumber, nil
}

func handler(w http.ResponseWriter, r *http.Request) {
	url := r.URL

	log.Println(url.Path)
	asn, err := getASN(db, url.Path[1:])
	if err != nil {
		w.WriteHeader(http.StatusNotFound)
		log.Print(err)
		fmt.Fprintln(w, err)
	} else {
		log.Print(asn)
		fmt.Fprintf(w, "%d\n", asn)
	}
}

func main() {

	defer db.Close()
	flag.Parse()

	if *startHttp {
		http.HandleFunc("/", handler)
		http.ListenAndServe(":8080", nil)
	} else {
		asn, err := getASN(db, os.Args[1])
		if err != nil {
			log.Fatal(err)
			os.Exit(-1)
		}
		fmt.Printf("%d\n", asn)
	}

}
