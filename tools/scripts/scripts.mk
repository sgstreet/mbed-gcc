#
# Copyright (C) 2013 Red Rocket Computing
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
# scripts.mk
# Created on: 21/11/13
# Author: Stephen Street (stephen@redrocketcomputing.com)
#

where-am-i := ${CURDIR}/$(lastword $(subst $(lastword ${MAKEFILE_LIST}),,${MAKEFILE_LIST}))

# Setup up default goal
ifeq ($(.DEFAULT_GOAL),)
	.DEFAULT_GOAL := all
endif

SOURCE_PATH := ${CURDIR}
BUILD_PATH := $(subst ${PROJECT_ROOT},${BUILD_ROOT},${SOURCE_PATH})
INSTALL_PATH := ${TOOLS_ROOT}/bin

SOURCES := fetch-external-projects generate-external-projects setup-workspace softlink-toolchain update-external-projects

all: $(addprefix ${INSTALL_PATH}/, ${SOURCES})

clean: 
	rm $(addprefix ${INSTALL_PATH}/, ${SOURCES})

distclean: clean

$(addprefix ${INSTALL_PATH}/, ${SOURCES}): ${INSTALL_PATH}/% : ${SOURCE_PATH}/%
	install -m 755 -D $< $@


