

# ASN #

A simple utility which converts ip addresses to ASN.

* [Autonomous System numbers – FAQs – APNIC](https://www.apnic.net/get-ip/faqs/asn/)

## Requiement

* [GeoLite2 Free Downloadable Databases « MaxMind Developer Site](https://dev.maxmind.com/geoip/geoip2/geolite2/#IP_Geolocation_Usage)

Get `GeoLite2-ASN_20180709.tar.gz` and copy `GeoLite2-ASN.mmdb` in it to the current directory.


## Installation

Get binary from the [release page](https://github.com/essa/asn/releases)

Or compile it from the source with following package.

* [oschwald/geoip2\-golang: Unofficial MaxMind GeoIP2 Reader for Go](https://github.com/oschwald/geoip2-golang)

## Usage

### As a cli

Give one ip address as an argument

```
$ asn 191.204.14.134
26599 
```

### As a http server

Invoke it with `-h` option

```
$ asn -h
```

And give an ip address as the path of requests in other teminal.

```
$ curl http://localhost:8080/201.148.224.19
61838
```
