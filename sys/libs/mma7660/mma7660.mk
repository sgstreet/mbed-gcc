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
# mma7660.mk
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

all: ${CROSS_ROOT}/lib/libmma7660.a

clean: ${BUILD_PATH}/mma7660.mk ${BUILD_PATH}/mma7660.settings
	${MAKE} BUILD_PATH=${BUILD_PATH}/build -C ${BUILD_PATH} -f mma7660.mk clean

distclean: clean
	${MAKE} BUILD_PATH=${BUILD_PATH}/build -C ${BUILD_PATH} -f mma7660.mk distclean
	${RM} -rf ${BUILD_PATH}

${CROSS_ROOT}/lib/libmma7660.a: ${BUILD_PATH}/build/libmma7660.a

${BUILD_PATH}/build/libmma7660.a: ${BUILD_PATH}/mma7660.mk ${BUILD_PATH}/mma7660.settings
	${MAKE} BUILD_PATH=${BUILD_PATH}/build -C ${BUILD_PATH} -f mma7660.mk all

${BUILD_PATH}/mma7660.mk: ${SOURCE_PATH}/mma7660-makefile ${BUILD_PATH}/.git/description
	install -m 644 ${SOURCE_PATH}/mma7660-makefile ${BUILD_PATH}/mma7660.mk

${BUILD_PATH}/mma7660.settings: ${SOURCE_PATH}/mma7660-settings ${BUILD_PATH}/.git/description
	install -m 644 ${SOURCE_PATH}/mma7660-settings ${BUILD_PATH}/mma7660.settings

${BUILD_PATH}/.git/description:
	git clone ${REPOSITORY_ROOT}/MMA7660 ${BUILD_PATH}



