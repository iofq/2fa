NAME=2fa
VERSION=1.0

PREFIX?=/usr/local
INSTALL_PREFIX=$(PREFIX)/bin
DOC_PREFIX=$(PREFIX)/man/man1

INSTALL_FILES=2fa
DOC_FILES=docs/2fa.1

install:
	mkdir -p $(INSTALL_PREFIX) 
	for file in $(INSTALL_FILES); do install -m 755 $$file $(INSTALL_PREFIX); done

install-man:
	mkdir -p $(DOC_PREFIX)
	for file in $(DOC_FILES); do install -m 644 $$file $(DOC_PREFIX); done

uninstall:
	for file in $(INSTALL_FILES); do rm $(INSTALL_PREFIX)/$$file; done
	for file in $(DOC_FILES); do rm $(DOC_PREFIX)/$$(basename $$file); done

.PHONY: install uninstall install-man
