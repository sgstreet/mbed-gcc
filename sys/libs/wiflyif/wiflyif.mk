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
# wiflyif.mk
# Created on: 13/11/13
# Author: Stephen Street (stephen@redrocketcomputing.com)
#

where-am-i := ${CURDIR}/$(lastword $(subst $(lastword ${MAKEFILE_LIST}),,${MAKEFILE_LIST}))

# Setup up default goal
ifeq ($(.DEFAULT_GOAL),)
	.DEFAULT_GOAL := all
endif

SOURCE_PATH := ${CURDIR}
BUILD_PATH := $(subst ${PROJECT_ROOT},${BUILD_ROOT},${SOURCE_PATH})

all: ${CROSS_ROOT}/lib/libwiflyif.a

clean: ${BUILD_PATH}/wiflyif.mk ${BUILD_PATH}/wiflyif.settings
	${MAKE} BUILD_PATH=${BUILD_PATH}/build -C ${BUILD_PATH} -f wiflyif.mk clean

distclean: clean
	${MAKE} BUILD_PATH=${BUILD_PATH}/build -C ${BUILD_PATH} -f wiflyif.mk distclean
	${RM} -rf ${BUILD_PATH}

${CROSS_ROOT}/lib/libwiflyif.a: ${BUILD_PATH}/build/libwiflyif.a

${BUILD_PATH}/build/libwiflyif.a: ${BUILD_PATH}/wiflyif.mk ${BUILD_PATH}/wiflyif.settings
	${MAKE} BUILD_PATH=${BUILD_PATH}/build -C ${BUILD_PATH} -f wiflyif.mk all

${BUILD_PATH}/wiflyif.mk: ${SOURCE_PATH}/wiflyif-makefile ${BUILD_PATH}/.git/description
	install -m 644 ${SOURCE_PATH}/wiflyif-makefile ${BUILD_PATH}/wiflyif.mk

${BUILD_PATH}/wiflyif.settings: ${SOURCE_PATH}/wiflyif-settings ${BUILD_PATH}/.git/description
	install -m 644 ${SOURCE_PATH}/wiflyif-settings ${BUILD_PATH}/wiflyif.settings

${BUILD_PATH}/.git/description:
	git clone ${REPOSITORY_ROOT}/WiflyInterface ${BUILD_PATH}
	cd ${BUILD_PATH} && patch -p1 < ${SOURCE_PATH}/use-stdint-header.patch



