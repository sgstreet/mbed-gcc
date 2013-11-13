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
# rtx.mk
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

all: ${CROSS_ROOT}/lib/librtx.a ${CROSS_ROOT}/lib/librtos.a 

clean: 

distclean: clean
	${RM} -rf ${BUILD_PATH}

${CROSS_ROOT}/lib/librtx.a: ${BUILD_PATH}/build/rtx/librtx.a

${CROSS_ROOT}/lib/librtos.a: ${BUILD_PATH}/build/rtos/librtos.a

${BUILD_PATH}/build/rtos/librtos.a: ${BUILD_PATH}/.git/description ${BUILD_PATH}/rtos/rtos.mk ${BUILD_PATH}/rtos/rtos.settings
	${MAKE} BUILD_PATH=${BUILD_PATH}/build/rtos -C ${BUILD_PATH}/rtos -f rtos.mk

${BUILD_PATH}/build/rtx/librtx.a: ${BUILD_PATH}/.git/description ${BUILD_PATH}/rtx/rtx.mk ${BUILD_PATH}/rtx/rtx.settings
	${MAKE} BUILD_PATH=${BUILD_PATH}/build/rtx -C ${BUILD_PATH}/rtx -f rtx.mk

${BUILD_PATH}/rtos/rtos.mk: rtos-makefile
	install -m 644 rtos-makefile ${BUILD_PATH}/rtos/rtos.mk

${BUILD_PATH}/rtos/rtos.settings: rtos-settings
	install -m 644 rtos-settings ${BUILD_PATH}/rtos/rtos.settings

${BUILD_PATH}/rtx/rtx.mk: rtx-makefile
	install -m 644 rtx-makefile ${BUILD_PATH}/rtx/rtx.mk

${BUILD_PATH}/rtx/rtx.settings: rtos-settings
	install -m 644 rtx-settings ${BUILD_PATH}/rtx/rtx.settings

${BUILD_PATH}/.git/description:
	git clone ${REPOSITORY_ROOT}/mbed-rtos ${BUILD_PATH}
	cp ${BUILD_PATH}/rtx/TARGET_M3/TOOLCHAIN_GCC/*.* ${BUILD_PATH}/rtx/
	${RM} -rf ${BUILD_PATH}/rtx/TARGET_*


