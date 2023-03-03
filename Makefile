# Makefile for omniformer

INSTALL_DIR=/usr/local/bin
SCRIPTS=omniformer omnibuild omnivir omnidock
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

omniformer:
	@$(INSTALL_DIR)/omniformer.sh

omnibuild:
	@$(INSTALL_DIR)/omnibuild.sh

omnivir:
	@$(INSTALL_DIR)/omnivir.sh

omnidock:
	@$(INSTALL_DIR)/omnidock.sh

