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
# blinky.mk
# Created on: 21/07/13
# Author: Stephen Street (stephen@redrocketcomputing.com)
#

BIN_INSTALL_PATH := ${IMAGE_ROOT}

BINS := lcd.elf lcd.bin lcd.map lcd.dis

include ${MKSOURCE}
