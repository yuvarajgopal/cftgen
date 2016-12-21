
# install the cftgen tool suite


TARGETDIR=/usr/local/aws/cf

install: install.bin install.lib

install.bin:
	-mkdir -p $(TARGETDIR)/bin
	for f in bin/*.sh; do \
	  cp $$f $(TARGETDIR)/bin/`basename $$f .sh`; \
	done

install.lib:
	-mkdir -p $(TARGETDIR)/lib
	for f in lib/*.m4; do \
	  cp $$f $(TARGETDIR)/lib/`basename $$f` ; \
	done
