#
# Copyright (C) 2012 Red Rocket Computing
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# 
# targets.mk
# Created on: 16/10/12
# Author: Stephen Street (stephen@redrocketcomputing.com)
#

# Some support functions
root-target = $(firstword $(subst /, ,${1}))
remaining-target = $(filter-out $(call root-target,${1}),$(subst $(firstword $(subst /, ,${1}))/,,${1}))

where-am-i := ${CURDIR}/$(lastword $(subst $(lastword ${MAKEFILE_LIST}),,${MAKEFILE_LIST}))

# Setup up default goal
ifeq ($(.DEFAULT_GOAL),)
	.DEFAULT_GOAL := all
endif

# Try to include base setting file
-include ${PROJECT_ROOT}/Makefile.settings

# Try to include a override settings file
-include $(basename ${where-am-i}).settings

# Try to include a dependency file
-include $(basename ${where-am-i}).dep

# Define auto generated goals, this can be overidden if required
# TODO keep an eye on the interaction between overridden AUTOGOALS and GOAL filtering
AUTOGOALS ?= all clean distclean
AUTOGOALS := $(filter-out ${EXCLUDEGOALS},${AUTOGOALS})
GOAL = $(filter ${AUTOGOALS},${MAKECMDGOALS})
ifneq (${GOAL},)
	SUBMAKE_GOAL = GOAL=${GOAL}
endif 
SUBDIRS ?= $(subst ${CURDIR}/,,$(shell find ${CURDIR} -mindepth 2 -maxdepth 2 -name "*.mk" -printf "%h "))

# Generate AUTOGOALS
ifeq ($(wildcard $(basename ${where-am-i}).dep),)
targets: ${SUBDIRS}
endif
${AUTOGOALS}: targets

# Support sub directory building goals
$(filter-out ${AUTOGOALS} ${EXCLUDEGOALS},${MAKECMDGOALS}):
	@if [ "$(call remaining-target,$@)" != "" ]; then \
		echo ${MAKE} -C $(call root-target,$@) -f $(call root-target,$@).mk ${SUBMAKE_GOAL} $(call remaining-target,$@); \
		${MAKE} -C $(call root-target,$@) -f $(call root-target,$@).mk ${SUBMAKE_GOAL} $(call remaining-target,$@); \
	else \
		echo ${MAKE} -C $(call root-target,$@) -f $(call root-target,$@).mk ${GOAL}; \
		${MAKE} -C $(call root-target,$@) -f $(call root-target,$@).mk ${GOAL}; \
	fi
.PHONY: $(filter-out ${AUTOGOALS},${MAKECMDGOALS})

# Support recursive directory decent
$(filter-out ${AUTOGOALS} ${EXCLUDEGOALS} ${MAKECMDGOALS},${SUBDIRS}):
	${MAKE} -C $@ -f $@.mk ${GOAL}
.PHONY: $(filter-out ${AUTOGOALS} ${EXCLUDEGOALS} ${MAKECMDGOALS},${SUBDIRS})

debug-targets:
	@echo "where-am-i=${where-am-i}"
	@echo "DEFAULT_GOAL=${.DEFAULT_GOAL}"
	@echo "AUTOGOALS=${AUTOGOALS}"
	@echo "GOAL=${GOAL}"
	@echo "targets=${targets}"
.PHONY: debug-targets
