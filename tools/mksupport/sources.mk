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
# source.mk
# Created on: 16/11/12
# Author: Stephen Street (stephen@redrocketcomputing.com)
#

where-am-i := ${CURDIR}/$(lastword $(subst $(lastword ${MAKEFILE_LIST}),,${MAKEFILE_LIST}))

# Setup up default goal
ifeq ($(.DEFAULT_GOAL),)
	.DEFAULT_GOAL := all
endif

SOURCE_PATH := ${CURDIR}
BUILD_PATH := $(subst ${PROJECT_ROOT},${BUILD_ROOT},${SOURCE_PATH})

# Try to include base setting file
-include ${PROJECT_ROOT}/Makefile.settings

# Try to include a override settings file
-include $(basename ${where-am-i}).settings

# Find all subdirectories with source code
mkobjects = $(addsuffix /objects.mk,$(subst ${SOURCE_PATH},${BUILD_PATH},$(shell find ${SOURCE_PATH} -type d -and -not -name ".*")))

# Generate object makefiles
${mkobjects}: ${BUILD_PATH}%/objects.mk : ${SOURCE_PATH}%
	@echo "configuring build directory: ${@:objects.mk=}"
	@mkdir -p ${@:objects.mk=}
	@echo 'objects += $$(addprefix ${@:objects.mk=}, $$(addsuffix .o, $$(notdir $$(basename $$(wildcard $</*.cpp) $$(wildcard $</*.c)))))' > $@
	@echo  >> $@
	@echo '-include $(subst ${SOURCE_PATH},${BUILD_PATH},$(shell find $< -mindepth 1 -maxdepth 1 -type d -and -not -name ".*" -exec echo -n "{}/objects.mk " \;))' >> $@
	@echo  >> $@
	@echo '${@:objects.mk=}%.o : $</%.cpp' >> $@
	@echo '	$${COMPILE.cpp} -MMD -MP -o "$$@" "$$<"' >> $@
	@echo >> $@
	@echo '${@:objects.mk=}%.o : $</%.c' >> $@
	@echo '	$${COMPILE.c} -MMD -MP -o "$$@" "$$<"' >> $@

# Generate target makefile, need to track .dep and .settings files for rebuild
${BUILD_PATH}/Makefile: ${mkobjects} $(basename ${where-am-i}).mk
	@echo "configuring makefile ${@}"
	@echo 'include objects.mk' > $@
	@echo >> $@
	@echo 'ifneq ($$(MAKECMDGOALS),clean)' >> $@
	@echo '-include $${objects:.o=.d}' >> $@
	@echo 'endif' >> $@
	@echo >> $@
	@for target in ${BINS} ${LIBS} ${HEADERS}; do \
		case $$target in \
			*.a) \
				echo $$target: '$${objects}' >> $@; \
				echo '	$${AR} $${ARFLAGS} $$@ $$^' >> $@; \
				echo >> $@; \
				if [ -n "${LIB_INSTALL_PATH}" ]; then \
					echo ${LIB_INSTALL_PATH}/$$target: $$target >> $@; \
					echo '	${INSTALL} -m 644 -D $$^ $$@' >> $@; \
					echo >> $@; \
				fi \
			;; \
			*.so) \
				echo $$target: '$${objects} $${EXTRA_DEPS}' >> $@; \
				echo '	$${LINK} $${LDFLAGS} -shared -o $$@ $${objects} $${LDLIBES} $${LDLIBS}' >> $@; \
				echo >> $@; \
				if [ -n "${LIB_INSTALL_PATH}" ]; then \
					echo ${LIB_INSTALL_PATH}/$$target: $$target >> $@; \
					echo '	${INSTALL} -m 755 -D $$^ $$@' >> $@; \
					echo >> $@; \
				fi \
			;; \
			*.hpp | *.h) \
				if [ -n "${INCLUDE_INSTALL_PATH}" ]; then \
					echo ${INCLUDE_INSTALL_PATH}/$$target: ${SOURCE_PATH}/$$target >> $@; \
					echo '	${INSTALL} -m 644 -D $$^ $$@' >> $@; \
					echo >> $@; \
				else \
					echo $$target: >> $@; \
					echo >> $@; \
				fi \
			;; \
			*) \
				echo $$target: '$${objects} $${EXTRA_DEPS}' >> $@; \
				echo '	$${LINK} $${LDFLAGS} -o $$@ $${objects} $${LDLIBES} $${LDLIBS}' >> $@; \
				echo >> $@; \
				if [ -n "${BIN_INSTALL_PATH}" ]; then \
					echo '${BIN_INSTALL_PATH}/$$target: $$target' >> $@; \
					echo '	${INSTALL} -m 644 -D $$^ $$@' >> $@; \
					echo >> $@; \
				fi \
			;; \
		esac; \
	done
	
	@if [ -n "${EXTRA_DEPS}" ]; then \
		echo '$${EXTRA_DEPS}:' >> $@; \
		echo >> $@; \
	fi
	
	@if [ -n "${BIN_INSTALL_PATH}" ]; then \
		echo 'BINS = $$(addprefix ${BIN_INSTALL_PATH}/, ${BINS})' >> $@; \
	else \
		echo 'BINS := ${BINS}' >> $@; \
	fi 

	@if [ -n "${LIB_INSTALL_PATH}" ]; then \
		echo 'LIBS = $$(addprefix ${LIB_INSTALL_PATH}/, ${LIBS})' >> $@; \
	else \
		echo 'LIBS := ${LIBS}' >> $@; \
	fi
	 
	@if [ -n "${INCLUDE_INSTALL_PATH}" ]; then \
		echo 'HEADERS = $$(addprefix ${INCLUDE_INSTALL_PATH}/, ${HEADERS})' >> $@; \
	else \
		echo 'HEADERS := ${HEADERS}' >> $@; \
	fi
	@echo >> $@
	
	@echo 'all: $${BINS} $${HEADERS} $${LIBS}' >> $@
	@echo >> $@
	@echo 'clean:' >> $@
	@echo '	rm -rf ${TARGETS} $${objects} $${objects:.o=.d}' >> $@
	@echo >> $@

all: ${BUILD_PATH}/Makefile
	${MAKE} -C ${BUILD_PATH} all
		
clean: ${BUILD_PATH}/Makefile
	${MAKE} -C ${BUILD_PATH} clean
	
distclean:
	@if [ -n "${BIN_INSTALL_PATH}" ]; then \
		echo rm -rf $(addprefix ${BIN_INSTALL_PATH}/, ${BINS}); \
		rm -rf $(addprefix ${BIN_INSTALL_PATH}/, ${BINS}); \
	fi
	 
	@if [ -n "${LIB_INSTALL_PATH}" ]; then \
		echo rm -rf $(addprefix ${LIB_INSTALL_PATH}/, ${LIBS}); \
		rm -rf $(addprefix ${LIB_INSTALL_PATH}/, ${LIBS}); \
	fi
	
	@if [ -n "${INCLUDE_INSTALL_PATH}" ]; then \
		echo rm -rf $(addprefix ${INCLUDE_INSTALL_PATH}/, ${HEADERS}); \
		rm -rf $(addprefix ${INCLUDE_INSTALL_PATH}/, ${HEADERS}); \
	fi
	rm -rf ${BUILD_PATH} ${_bins} ${_libs} ${_incs} 

