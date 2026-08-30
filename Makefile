#
# Makefile to create txt/html I-D documents from xml source.

# Datatracker I-D submission API
# See https://datatracker.ietf.org/api/submission
SUBMIT_API:=https://datatracker.ietf.org/api/submission
DRAFT:=draft-ietf-snac-simple
SUBMITTER_EMAIL:=submitter.email.here@example.com

all: html txt

html: ${DRAFT}.html

txt: ${DRAFT}.txt

submit: ${DRAFT}.xml
	@resp=`curl -sS -F "user=${SUBMITTER_EMAIL}" -F "xml=@${DRAFT}.xml" ${SUBMIT_API}`; \
	echo "$$resp"; \
	status_url=`echo "$$resp" | sed -n 's/.*"status_url"[ ]*:[ ]*"\([^"]*\)".*/\1/p'`; \
	if [ -z "$$status_url" ]; then echo "Submission was not accepted."; exit 1; fi; \
	while true; do \
	    sleep 5; \
	    state=`curl -sS "$$status_url" | sed -n 's/.*"state"[ ]*:[ ]*"\([^"]*\)".*/\1/p'`; \
	    echo "state: $$state"; \
	    case "$$state" in validating) ;; \
	        cancel) echo "Validation failed or submission cancelled."; exit 1;; \
	        *) break;; esac; \
	done; \
	echo "Now confirm the submission via the link emailed to ${SUBMITTER_EMAIL}."

%.txt: %.xml
	xml2rfc --text -o $@ $?

%.html: %.xml
	xml2rfc --html -o $@ $?


