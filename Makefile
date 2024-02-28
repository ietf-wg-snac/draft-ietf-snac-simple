#
# Makefile to create txt/html I-D documents from xml source.

DRAFT:=draft-ietf-snac-simple
SUBMITTER_EMAIL:=my.ietf.email.address.here@example.com

all: html txt

html: ${DRAFT}.html

txt: ${DRAFT}.txt

submit: ${DRAFT}.xml
	curl -S -F "user=${SUBMITTER_EMAIL}" -F "xml=@${DRAFT}.xml" https://datatracker.ietf.org/api/submit

%.txt: %.xml
	xml2rfc --text -o $@ $?

%.html: %.xml
	xml2rfc --html -o $@ $?


