#
# Copyright (C) 2012 Red Rocket Computing
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
# Makefile
# Created on: 30/10/12
# Author: Stephen Street (stephen@redrocketcomputing.com)
#

EXCLUDEGOALS = distclean realclean update $(wildcard ${REPOSITORY_ROOT}/*.git)

export WORKSPACE ?= ${CURDIR}
export PROJECT_ROOT ?= ${CURDIR}
export REPOSITORY_ROOT ?= ${PROJECT_ROOT}/repositories
export TOOLS_ROOT ?= ${PROJECT_ROOT}/local
export IMAGE_ROOT ?= ${PROJECT_ROOT}/images
export BUILD_ROOT ?= ${PROJECT_ROOT}/build
export CROSS_ROOT ?= ${PROJECT_ROOT}/rootfs

export MKSUPPORT_PATH := ${PROJECT_ROOT}/tools/mksupport
export MKSOURCE := ${MKSUPPORT_PATH}/sources.mk
export MKTARGETS := ${MKSUPPORT_PATH}/targets.mk

include ${MKTARGETS}

.PHONY: update
update: ${REPOSITORY_ROOT} $(wildcard ${REPOSITORY_ROOT}/*.git)

.PHONY: $(wildcard ${REPOSITORY_ROOT}/*.git)
$(wildcard ${REPOSITORY_ROOT}/*.git):
	git --git-dir=$@ fetch -p

.PHONY: distclean
distclean:
	@echo "target disabled"
#	rm -rf ${BUILD_ROOT} ${CROSS_ROOT} ${IMAGE_ROOT} ${TOOLS_ROOT}

.PHONY: realclean
realclean: distclean
	@echo "target disabled"
#	rm -rf ${REPOSITORY_ROOT} ${PROJECT_ROOT}/sources

