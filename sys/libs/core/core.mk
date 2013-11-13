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
# core.mk
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

all: ${CROSS_ROOT}/lib/libcore.a

clean: ${BUILD_PATH}/core.mk ${BUILD_PATH}/core.settings
	${MAKE} BUILD_PATH=${BUILD_PATH}/build -C ${BUILD_PATH} -f core.mk clean

distclean: ${BUILD_PATH}/core.mk ${BUILD_PATH}/core.settings
	${MAKE} BUILD_PATH=${BUILD_PATH}/build -C ${BUILD_PATH} -f core.mk distclean
	${RM} -rf ${BUILD_PATH}

${CROSS_ROOT}/lib/libcore.a: ${BUILD_PATH}/build/libcore.a

${BUILD_PATH}/build/libcore.a: ${BUILD_PATH}/core.mk ${BUILD_PATH}/core.settings
	${MAKE} BUILD_PATH=${BUILD_PATH}/build -C ${BUILD_PATH} -f core.mk all

${BUILD_PATH}/core.mk: ${SOURCE_PATH}/core-makefile ${BUILD_PATH}/.git/description
	install -m 644 ${SOURCE_PATH}/core-makefile ${BUILD_PATH}/core.mk

${BUILD_PATH}/core.settings: ${SOURCE_PATH}/core-settings ${BUILD_PATH}/.git/description
	install -m 644 ${SOURCE_PATH}/core-settings ${BUILD_PATH}/core.settings

${BUILD_PATH}/.git/description:
	git clone ${REPOSITORY_ROOT}/mbed-src ${BUILD_PATH}
	cp ${BUILD_PATH}/api/*.* ${BUILD_PATH}
	cp ${BUILD_PATH}/common/* ${BUILD_PATH}
	cp ${BUILD_PATH}/hal/*.* ${BUILD_PATH}
	cp ${BUILD_PATH}/targets/cmsis/*.* ${BUILD_PATH}
	cp ${BUILD_PATH}/targets/cmsis/TARGET_NXP/TARGET_LPC176X/*.* ${BUILD_PATH}
	cp ${BUILD_PATH}/targets/cmsis/TARGET_NXP/TARGET_LPC176X/TOOLCHAIN_GCC_ARM/*.* ${BUILD_PATH}
	cp ${BUILD_PATH}/targets/hal/TARGET_NXP/TARGET_LPC176X/*.* ${BUILD_PATH}
	${RM} -rf ${BUILD_PATH}/api ${BUILD_PATH}/common ${BUILD_PATH}/hal ${BUILD_PATH}/targets

