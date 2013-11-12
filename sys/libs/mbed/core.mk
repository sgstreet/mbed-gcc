# Copyright (C) 2013 Red Rocket Computing
# 
# This file is part of AppFramework.
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
# code-template.mk
# Created on: 21/07/13
# Author: Stephen Street (stephen@redrocketcomputing.com)
#

LIBS := libcore.a
HEADERS := $(subst ${CURDIR}/,,$(shell find ${CURDIR} -name "*.h" -o -name "*.hpp"))
OBJS := cmsis_nvic.o retarget.o startup_LPC17xx.o system_LPC17xx.o
EXTRAS := LPC1768.ld

LIB_INSTALL_PATH := ${CROSS_ROOT}/lib
INCLUDE_INSTALL_PATH := ${CROSS_ROOT}/include
OBJECT_INSTALL_PATH := ${LIB_INSTALL_PATH}
EXTRA_INSTALL_PATH := ${LIB_INSTALL_PATH}

include ${MKSOURCE}
