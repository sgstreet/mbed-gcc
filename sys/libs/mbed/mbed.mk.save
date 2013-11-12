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
# mbed.mk
# Created on: 05/11/13
# Author: Stephen Street (stephen@redrocketcomputing.com)
#

where-am-i := ${CURDIR}/$(lastword $(subst $(lastword ${MAKEFILE_LIST}),,${MAKEFILE_LIST}))

# Setup up default goal
ifeq ($(.DEFAULT_GOAL),)
	.DEFAULT_GOAL := all
endif

SOURCE_PATH := ${CURDIR}
BUILD_PATH := $(subst ${PROJECT_ROOT},${BUILD_ROOT},${SOURCE_PATH})

MACHINE ?= LPC1768
TOOLCHAIN := GCC_ARM

ifeq ($(MAKECMDGOALS),install)
	LIBS := $(shell find ${BUILD_PATH}/build -name "*.[ao]" -o -name "*.ld" | grep -v "\.temp")
	INCLUDES := $(shell find ${BUILD_PATH}/build -name "*.h")
endif

CROSS_PATH := ${CROSS_ROOT}
CROSS_INCLUDE_PATH := ${CROSS_PATH}/include
CROSS_LIB_PATH := ${CROSS_PATH}/lib
CROSS_LIBS := $(addprefix ${CROSS_LIB_PATH}/, $(subst ${BUILD_PATH}/build/,,${LIBS}))
CROSS_INCLUDES := $(addprefix ${CROSS_INCLUDE_PATH}/, $(subst ${BUILD_PATH}/build/,,${INCLUDES}))

debug:
	@echo "LIBS = ${LIBS}"
	@echo "INCLUDES = ${INCLUDES}"
	@echo "CROSS_LIBS = ${CROSS_LIBS}"
	@echo "CROSS_INCLUDES = ${CROSS_INCLUDES}"

all: ${BUILD_PATH}/workspace_tools/private_settings.py
#	cd ${BUILD_PATH} && python ./workspace_tools/build.py -v -m ${MACHINE} -t ${TOOLCHAIN} -r -e -U -u
	cd ${BUILD_PATH} && python ./workspace_tools/build.py -v -m ${MACHINE} -t ${TOOLCHAIN} -r
	${MAKE} -f ${MAKEFILE_LIST} install

clean: 
	rm -rf ${BUILD_PATH}/build

distclean:
	rm -rf ${BUILD_PATH}

install: ${CROSS_LIBS} ${CROSS_INCLUDES}

${CROSS_LIBS}: ${CROSS_PATH}/lib/% : ${BUILD_PATH}/build/%
	install -C -m 644 -D $< $(addprefix ${CROSS_PATH}/lib/,$(notdir $@))

${CROSS_INCLUDES}: ${CROSS_PATH}/include/% : ${BUILD_PATH}/build/%
	install -C -m 644 -D $< $(subst TARGET_${MACHINE},,$@)

${BUILD_PATH}/workspace_tools/private_settings.py:
	mkdir -p ${BUILD_PATH}
	cd ${BUILD_PATH} && git clone ${REPOSITORY_ROOT}/mbed.git .
	echo 'GCC_ARM_PATH = "${TOOLS_ROOT}/bin/"' > ${BUILD_PATH}/workspace_tools/private_settings.py

