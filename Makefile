# app custom Makefile

# Docker repo & image name without version
IMAGE    ?= zveronline/sopds
# Hostname for external access
APP_SITE ?= lib.dev.lan
# App names (db/user name etc)
APP_NAME ?= sopds

# Enable DB usage:
# * Add DB config part to .env.sample
# * Enable db* targets
# * make db-create inside .drone-default target
USE_DB   ?= yes

# Add user config part to .env.sample
ADD_USER ?= yes

# ------------------------------------------------------------------------------
# app custom config

LIB_PATH     ?= Library

PERSIST_FILES = start.sh genre.sql

# ------------------------------------------------------------------------------
# .env template (custom part)
# inserted in .env.sample via 'make config'
define CONFIG_CUSTOM
# ------------------------------------------------------------------------------
# app custom config, generated by make config
# db:$(USE_DB) user:$(ADD_USER)

# Relative path to library sources from DCAPE/var
LIB_PATH=$(LIB_PATH)

endef

# ------------------------------------------------------------------------------
# Find and include DCAPE/apps/drone/dcape-app/Makefile
DCAPE_COMPOSE  ?= dcape-compose
DCAPE_MAKEFILE  ?= $(shell docker inspect -f "{{.Config.Labels.dcape_app_makefile}}" $(DCAPE_COMPOSE))
ifeq ($(shell test -e $(DCAPE_MAKEFILE) && echo -n yes),yes)
  include $(DCAPE_MAKEFILE)
else
  include /opt/dcape-app/Makefile
endif

# -----------------------------------------------------------------------------
## Custom app targets
#:


# ...
