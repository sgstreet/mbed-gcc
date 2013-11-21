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
# pyocd.mk
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
PYOCD_INSTALL_PATH := ${TOOLS_ROOT}/libexec/pyocd

PYOCD_INSTALLS := $(subst ${BUILD_PATH}/pyOCD,${PYOCD_INSTALL_PATH},$(shell find ${BUILD_PATH}/pyOCD/pyOCD -name "*.py"))
PYUSB_INSTALLS := $(subst ${BUILD_PATH}/pyusb,${PYOCD_INSTALL_PATH},$(shell find ${BUILD_PATH}/pyusb/usb -name "*.py"))

all: ${PYOCD_INSTALLS} ${PYUSB_INSTALLS} ${PYOCD_INSTALL_PATH}/gdbserver.py ${TOOLS_ROOT}/bin/gdbserver

clean: 
	${RM} -rf ${PYOCD_INSTALL_PATH} ${TOOLS_ROOT}/bin/gdbserver

distclean:
	${RM} -rf ${PYOCD_PATH}
	rm -rf ${BUILD_PATH}

${PYOCD_INSTALL_PATH}/gdbserver.py: ${SOURCE_PATH}/gdbserver.py
	install -m 644 -D $< $@

${TOOLS_ROOT}/bin/gdbserver: ${SOURCE_PATH}/gdbserver
	install -m 755 -D $< $@

${PYOCD_INSTALLS}: ${PYOCD_INSTALL_PATH}/% : ${BUILD_PATH}/pyOCD/% ${BUILD_PATH}/pyOCD/LICENSE
	install -m 644 -D $< $@

${PYUSB_INSTALLS}: ${PYOCD_INSTALL_PATH}/% : ${BUILD_PATH}/pyusb/% ${BUILD_PATH}/pyusb/LICENSE
	install -m 644 -D $< $@

${BUILD_PATH}/pyOCD/LICENSE:
	mkdir -p ${BUILD_PATH}
	git clone ${REPOSITORY_ROOT}/pyOCD ${BUILD_PATH}/pyOCD

${BUILD_PATH}/pyusb/LICENSE:
	mkdir -p ${BUILD_PATH}
	git clone ${REPOSITORY_ROOT}/pyusb ${BUILD_PATH}/pyusb


