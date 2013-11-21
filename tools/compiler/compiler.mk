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
# compiler.mk
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

all: ${TOOLS_ROOT}/etc/softlinked-gcc-arm-none-eabi-4_7

clean: 
	${RM} -rf ${TOOLS_ROOT}/bin/arm-none-eabi* ${TOOLS_ROOT}/libexec/gcc-arm-none-eabi-4_7

distclean: clean

realclean: distclean
	${RM} -rf ${TOOLS_ROOT}/share/gcc-arm-none-eabi-4_7-linux.tar.bz2 ${BUILD_PATH}

${TOOLS_ROOT}/libexec/gcc-arm-none-eabi-4_7/bin/arm-none-eabi-gcc: ${TOOLS_ROOT}/share/gcc-arm-none-eabi-4_7-linux.tar.bz2 
	mkdir -p ${TOOLS_ROOT}/libexec
	tar -C ${TOOLS_ROOT}/libexec -mxf ${TOOLS_ROOT}/share/gcc-arm-none-eabi-4_7-linux.tar.bz2

${TOOLS_ROOT}/etc/softlinked-gcc-arm-none-eabi-4_7: ${TOOLS_ROOT}/libexec/gcc-arm-none-eabi-4_7/bin/arm-none-eabi-gcc
	${TOOLS_ROOT}/bin/softlink-toolchain gcc-arm-none-eabi-4_7

${TOOLS_ROOT}/share/gcc-arm-none-eabi-4_7-linux.tar.bz2: ${BUILD_PATH}/LICENSE
	${MAKE} -C ${BUILD_PATH} -f Makefile BUILD_PATH=${BUILD_PATH}/build IMAGE_ROOT=${TOOLS_ROOT}/share GOAL=all compilers/gcc-arm-embedded 

${BUILD_PATH}/LICENSE:
	git clone ${REPOSITORY_ROOT}/toolchains ${BUILD_PATH}
	cd ${BUILD_PATH} && patch -p1 < ${SOURCE_PATH}/build-path.patch



