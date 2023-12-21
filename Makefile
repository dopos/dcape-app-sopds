## dcape-app-sopds Makefile:
## Backup pg databases via docker container with crond
#:

SHELL               = /bin/bash
CFG                ?= .env
CFG_BAK            ?= $(CFG).bak

#- App name
APP_NAME           ?= sopds

#- Docker image name
IMAGE              ?= zveronline/sopds

#- Docker image tag
IMAGE_VER          ?= 0.47

# ------------------------------------------------------------------------------
# app custom config

#- app root
APP_ROOT           ?= $(PWD)

# If you need database, uncomment this var
USE_DB              = yes

# If you need user name and password, uncomment this var
ADD_USER            = yes

# Hostname for external access
#APP_SITE ?= lib.dev.lan

PERSIST_FILES = start.sh genre.sql

#- Relative path to library sources from DCAPE/var
LIB_PATH           ?= Library

# ------------------------------------------------------------------------------

# if exists - load old values
-include $(CFG_BAK)
export

-include $(CFG)
export

# ------------------------------------------------------------------------------
# Find and include DCAPE_ROOT/Makefile
DCAPE_COMPOSE   ?= dcape-compose
DCAPE_ROOT      ?= $(shell docker inspect -f "{{.Config.Labels.dcape_root}}" $(DCAPE_COMPOSE))

ifeq ($(shell test -e $(DCAPE_ROOT)/Makefile.app && echo -n yes),yes)
  include $(DCAPE_ROOT)/Makefile.app
else
  include /opt/dcape/Makefile.app
endif

# -----------------------------------------------------------------------------
## Custom app targets
#:

## Rescan library
rescan: CMD=run app python3 manage.py sopds_scanner scan --verbose
rescan: dc


# ...
