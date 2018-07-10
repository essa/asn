.DEFAULT_GOAL := dev
.PHONY: clean release dev-install dev build generate

OUTDIR=out
BINNAME=asn
VERSION=$(shell cat ./VERSION)

$(OUTDIR)/linux_amd64/asn:
	GOOS=linux GOARCH=amd64 go build -o $(OUTDIR)/linux_amd64/asn
$(OUTDIR)/darwin_amd64/asn:
	GOOS=darwin GOARCH=amd64 go build -o $(OUTDIR)/darwin_amd64/asn
$(OUTDIR)/windows_amd64/asn.exe:
	GOOS=windows GOARCH=amd64 go build -o $(OUTDIR)/windows_amd64/asn.exe

$(OUTDIR)/asn-$(VERSION)-linux_amd64.tar.gz: $(OUTDIR)/linux_amd64/asn
	zip -j $(OUTDIR)/asn-$(VERSION)-linux_amd64.zip $(OUTDIR)/linux_amd64/asn
$(OUTDIR)/asn-$(VERSION)-darwin_amd64.tar.gz: $(OUTDIR)/darwin_amd64/asn
	zip -j $(OUTDIR)/asn-$(VERSION)-darwin_amd64.zip $(OUTDIR)/darwin_amd64/asn
$(OUTDIR)/asn-$(VERSION)-windows_amd64.zip: $(OUTDIR)/windows_amd64/asn.exe
	zip -j $(OUTDIR)/asn-$(VERSION)-windows_amd64.zip $(OUTDIR)/windows_amd64/asn.exe

generate:
	go generate

build: generate $(OUTDIR)/linux_amd64/asn $(OUTDIR)/darwin_amd64/asn $(OUTDIR)/windows_amd64/asn.exe

dev: generate
	go build -o asn
install: dev
	cp ./asn ~/bin/asn

release: build $(OUTDIR)/asn-$(VERSION)-linux_amd64.tar.gz $(OUTDIR)/asn-$(VERSION)-darwin_amd64.tar.gz $(OUTDIR)/asn-$(VERSION)-windows_amd64.zip

clean:
	rm -rf $(OUTDIR)
	rm -f ./asn
