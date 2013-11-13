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
# lcd.mk
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

all: ${CROSS_ROOT}/lib/liblcd.a

clean: ${BUILD_PATH}/lcd.mk ${BUILD_PATH}/lcd.settings
	${MAKE} BUILD_PATH=${BUILD_PATH}/build -C ${BUILD_PATH} -f lcd.mk clean

distclean: clean
	${MAKE} BUILD_PATH=${BUILD_PATH}/build -C ${BUILD_PATH} -f lcd.mk distclean
	${RM} -rf ${BUILD_PATH}

${CROSS_ROOT}/lib/liblcd.a: ${BUILD_PATH}/build/liblcd.a

${BUILD_PATH}/build/liblcd.a: ${BUILD_PATH}/lcd.mk ${BUILD_PATH}/lcd.settings
	${MAKE} BUILD_PATH=${BUILD_PATH}/build -C ${BUILD_PATH} -f lcd.mk all

${BUILD_PATH}/lcd.mk: ${SOURCE_PATH}/lcd-makefile ${BUILD_PATH}/.git/description
	install -m 644 ${SOURCE_PATH}/lcd-makefile ${BUILD_PATH}/lcd.mk

${BUILD_PATH}/lcd.settings: ${SOURCE_PATH}/lcd-settings ${BUILD_PATH}/.git/description
	install -m 644 ${SOURCE_PATH}/lcd-settings ${BUILD_PATH}/lcd.settings

${BUILD_PATH}/.git/description:
	git clone ${REPOSITORY_ROOT}/C12832_lcd ${BUILD_PATH}



