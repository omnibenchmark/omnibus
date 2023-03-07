# Makefile for omnibus

INSTALL_DIR=/usr/local/bin
SCRIPTS=omnibus omnicast omnidock
SCRIPTS_DIR=bin

.PHONY: install uninstall

install:
	@for script in $(SCRIPTS); do \
            cp $(SCRIPTS_DIR)/$$script.sh $(INSTALL_DIR)/$$script ; \
            chmod +x $(INSTALL_DIR)/$$script ; \
            echo "Installed $$script in $(INSTALL_DIR)" ; \
        done

uninstall:
	@for script in $(SCRIPTS); do \
            rm -f $(INSTALL_DIR)/$$script ; \
            echo "Uninstalled $$script" ; \
        done

omnibus:
	@$(INSTALL_DIR)/omnibus.sh

omnicast:
	@$(INSTALL_DIR)/omnicast.sh

omnidock:
	@$(INSTALL_DIR)/omnidock.sh

