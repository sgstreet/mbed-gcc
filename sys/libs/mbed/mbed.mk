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

all: ${INSTALL_ROOT}/lib/libcore.a ${INSTALL_ROOT}/lib/librtx.a ${INSTALL_ROOT}/lib/librtos.a 

clean: ${BUILD_PATH}/core/core.mk ${BUILD_PATH}/rtos/rtos.mk ${BUILD_PATH}/rtx/rtx.mk
	${MAKE} BUILD_PATH=${BUILD_PATH}/build/core -C ${BUILD_PATH}/core -f core.mk clean
	${MAKE} BUILD_PATH=${BUILD_PATH}/build/rtx -C ${BUILD_PATH}/rtx -f rtx.mk clean
	${MAKE} BUILD_PATH=${BUILD_PATH}/build/rtos -C ${BUILD_PATH}/rtos -f rtos.mk clean

distclean: clean
	${MAKE} BUILD_PATH=${BUILD_PATH}/build -C ${BUILD_PATH}/core -f core.mk distclean
	${MAKE} BUILD_PATH=${BUILD_PATH}/build/rtx -C ${BUILD_PATH}/rtx -f rtx.mk distclean
	${MAKE} BUILD_PATH=${BUILD_PATH}/build/core -C ${BUILD_PATH}/rtos -f rtos.mk distclean
	${RM} -rf ${BUILD_PATH}

debug:
	@echo "targets=${targets}"

${INSTALL_ROOT}/lib/libcore.a: ${BUILD_PATH}/core/core.mk
	${MAKE} BUILD_PATH=${BUILD_PATH}/build/core -C ${BUILD_PATH}/core -f core.mk all

${INSTALL_ROOT}/lib/librtos.a: ${BUILD_PATH}/rtos/rtos.mk
	${MAKE} BUILD_PATH=${BUILD_PATH}/build/rtos -C ${BUILD_PATH}/rtos -f rtos.mk all

${INSTALL_ROOT}/lib/librtx.a: ${BUILD_PATH}/rtx/rtx.mk
	${MAKE} BUILD_PATH=${BUILD_PATH}/build/rtx -C ${BUILD_PATH}/rtx -f rtx.mk all

${BUILD_PATH}/core/core.mk: ${BUILD_PATH}/offical/README.md
	mkdir -p ${BUILD_PATH}/core
	cp ${BUILD_PATH}/offical/libraries/mbed/api/*.* ${BUILD_PATH}/core/
	cp ${BUILD_PATH}/offical/libraries/mbed/common/* ${BUILD_PATH}/core/
	cp ${BUILD_PATH}/offical/libraries/mbed/hal/*.* ${BUILD_PATH}/core/
	cp ${BUILD_PATH}/offical/libraries/mbed/targets/cmsis/*.* ${BUILD_PATH}/core/
	cp ${BUILD_PATH}/offical/libraries/mbed/targets/cmsis/TARGET_NXP/TARGET_LPC176X/*.* ${BUILD_PATH}/core/
	cp ${BUILD_PATH}/offical/libraries/mbed/targets/cmsis/TARGET_NXP/TARGET_LPC176X/TOOLCHAIN_GCC_ARM/*.* ${BUILD_PATH}/core/
	cp ${BUILD_PATH}/offical/libraries/mbed/targets/hal/TARGET_NXP/TARGET_LPC176X/*.* ${BUILD_PATH}/core/
	install -m 644 ${SOURCE_PATH}/core.* ${BUILD_PATH}/core/

${BUILD_PATH}/rtos/rtos.mk: ${BUILD_PATH}/offical/README.md
	mkdir -p ${BUILD_PATH}/rtos
	cp ${BUILD_PATH}/offical/libraries/rtos/rtos/*.* ${BUILD_PATH}/rtos/
	install -m 644 ${SOURCE_PATH}/rtos.* ${BUILD_PATH}/rtos/

${BUILD_PATH}/rtx/rtx.mk: ${BUILD_PATH}/offical/README.md
	mkdir -p ${BUILD_PATH}/rtx
	cp ${BUILD_PATH}/offical/libraries/rtos/rtx/*.* ${BUILD_PATH}/rtx/
	cp ${BUILD_PATH}/offical/libraries/rtos/rtx/TARGET_M3/TOOLCHAIN_GCC/*.* ${BUILD_PATH}/rtx/
	install -m 644 ${SOURCE_PATH}/rtx.* ${BUILD_PATH}/rtx/

${BUILD_PATH}/offical/README.md:
	mkdir -p ${BUILD_PATH}
	git clone ${REPOSITORY_ROOT}/mbed ${BUILD_PATH}/offical

