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
BUILD_PATH ?= $(subst ${PROJECT_ROOT},${BUILD_ROOT},${SOURCE_PATH})

# Try to include base setting file
-include ${PROJECT_ROOT}/Makefile.settings

# Try to include a override settings file
-include $(basename ${where-am-i}).settings

# Find all subdirectories with source code
mkobjects = $(addsuffix /objects.mk,$(subst ${SOURCE_PATH},${BUILD_PATH},$(shell find ${SOURCE_PATH} -type d -and -not -name ".*" | grep -v ".git")))

# Generate object makefiles
${mkobjects}: ${BUILD_PATH}%/objects.mk : ${SOURCE_PATH}%
	@echo "configuring build directory: ${@:objects.mk=}"
	@mkdir -p ${@:objects.mk=}
	@echo 'objects += $$(addprefix ${@:objects.mk=}, $$(addsuffix .o, $$(notdir $$(basename $$(wildcard $</*.cpp) $$(wildcard $</*.c) $$(wildcard $</*.s) $$(wildcard $</*.S)))))' > $@
	@echo  >> $@
	@echo '-include $(subst ${SOURCE_PATH},${BUILD_PATH},$(shell find $< -mindepth 1 -maxdepth 1 -type d -and -not -name ".*" -exec echo -n "{}/objects.mk " \;))' >> $@
	@echo  >> $@
	@echo '${@:objects.mk=}%.o : $</%.cpp' >> $@
	@echo '	$${COMPILE.cpp} -MMD -MP -o "$$@" "$$<"' >> $@
	@echo >> $@
	@echo '${@:objects.mk=}%.o : $</%.c' >> $@
	@echo '	$${COMPILE.c} -MMD -MP -o "$$@" "$$<"' >> $@
	@echo >> $@
	@echo '${@:objects.mk=}%.o : $</%.s' >> $@
	@echo '	$${COMPILE.s} -o "$$@" "$$<"' >> $@
	@echo >> $@
	@echo '${@:objects.mk=}%.o : $</%.S' >> $@
	@echo '	$${COMPILE.S} -MMD -MP -o "$$@" "$$<"' >> $@

# Generate target makefile, need to track .dep and .settings files for rebuild
${BUILD_PATH}/Makefile: ${mkobjects} $(basename ${where-am-i}).mk
	@echo "configuring makefile ${@}"
	@echo 'include objects.mk' > $@
	@echo >> $@
	@echo 'ifneq ($$(MAKECMDGOALS),clean)' >> $@
	@echo '-include $${objects:.o=.d}' >> $@
	@echo 'endif' >> $@
	@echo >> $@
	@if [ -n "${EXTRA_DEPS}" ]; then \
		echo '$${EXTRA_DEPS}:' >> $@; \
		echo >> $@; \
	fi
	@echo 'BINS = $$(addprefix ${BUILD_PATH}/, ${BINS})' >> $@
	@echo 'LIBS = $$(addprefix ${BUILD_PATH}/, ${LIBS})' >> $@
	@echo 'HEADERS = $$(addprefix ${BUILD_PATH}/, ${HEADERS})' >> $@
	@echo 'OBJS = $$(addprefix ${BUILD_PATH}/, ${OBJS})' >> $@
	@echo 'EXTRAS = $$(addprefix ${BUILD_PATH}/, ${EXTRAS})' >> $@
	@echo >> $@
	@if [ -n "${INCLUDE_INSTALL_PATH}" ]; then \
		echo 'TARGETS += $$(subst ${BUILD_PATH},${INCLUDE_INSTALL_PATH},$${HEADERS})' >> $@; \
	else \
		echo 'TARGETS += $${HEADERS}' >> $@; \
	fi
	@if [ -n "${OBJECT_INSTALL_PATH}" ]; then \
		echo 'TARGETS += $$(subst ${BUILD_PATH},${OBJECT_INSTALL_PATH},$${OBJS})' >> $@; \
	else \
		echo 'TARGETS += $${OBJS}' >> $@; \
	fi
	@if [ -n "${LIB_INSTALL_PATH}" ]; then \
		echo 'TARGETS += $$(subst ${BUILD_PATH},${LIB_INSTALL_PATH},$${LIBS})' >> $@; \
	else \
		echo 'TARGETS += $${LIBS}' >> $@; \
	fi
	@if [ -n "${EXTRA_INSTALL_PATH}" ]; then \
		echo 'TARGETS += $$(subst ${BUILD_PATH},${EXTRA_INSTALL_PATH},$${EXTRAS})' >> $@; \
	else \
		echo 'TARGETS += $${EXTRAS}' >> $@; \
	fi
	@if [ -n "${BIN_INSTALL_PATH}" ]; then \
		echo 'TARGETS += $$(subst ${BUILD_PATH},${BIN_INSTALL_PATH},$${BINS})' >> $@; \
	else \
		echo 'TARGETS += $${BINS}' >> $@; \
	fi
	@echo >> $@
	@if [ -n "${HEADERS}" ]; then \
		echo '$${HEADERS}: ${BUILD_PATH}/% : ${SOURCE_PATH}/%' >> $@; \
		echo '	${INSTALL} -m 644 -D $$^ $$@' >> $@; \
		echo >> $@; \
		if [ -n "${INCLUDE_INSTALL_PATH}" ]; then \
			echo '$$(subst ${BUILD_PATH},${INCLUDE_INSTALL_PATH},$${HEADERS}): ${INCLUDE_INSTALL_PATH}/% : ${BUILD_PATH}/%' >> $@; \
			echo '	${INSTALL} -m 644 -D $$^ $$@' >> $@; \
		fi \
	fi
	@echo >> $@
	@if [ -n "${OBJS}" ]; then \
		if [ -n "${OBJECT_INSTALL_PATH}" ]; then \
			echo '$$(subst ${BUILD_PATH},${OBJECT_INSTALL_PATH},$${OBJS}): ${OBJECT_INSTALL_PATH}/% : ${BUILD_PATH}/%' >> $@; \
			echo '	${INSTALL} -m 644 -D $$^ $$@' >> $@; \
		else \
			echo '$${OBJS}:' >> $@; \
		fi \
	fi
	@echo >> $@
	@if [ -n "${EXTRAS}" ]; then \
		echo '$${EXTRAS}: ${BUILD_PATH}/% : ${SOURCE_PATH}/%' >> $@; \
		echo '	${INSTALL} -m 644 -D $$^ $$@' >> $@; \
		echo >> $@; \
		if [ -n "${EXTRA_INSTALL_PATH}" ]; then \
			echo '$$(subst ${BUILD_PATH},${EXTRA_INSTALL_PATH},$${EXTRAS}): ${EXTRA_INSTALL_PATH}/% : ${BUILD_PATH}/%' >> $@; \
			echo '	${INSTALL} -m 644 -D $$^ $$@' >> $@; \
		fi \
	fi
	@echo >> $@
	@if [ -n "${LIBS}" ]; then \
		if [ -n "${LIB_INSTALL_PATH}" ]; then \
			echo '$$(subst ${BUILD_PATH},${LIB_INSTALL_PATH},$${LIBS}): ${LIB_INSTALL_PATH}/% : ${BUILD_PATH}/%' >> $@; \
			echo '	${INSTALL} -m 644 -D $$^ $$@' >> $@; \
			echo >> $@; \
		fi \
	fi
	@echo >> $@
	@if [ -n "${BINS}" ]; then \
		if [ -n "${BIN_INSTALL_PATH}" ]; then \
			echo '$$(subst ${BUILD_PATH},${BIN_INSTALL_PATH},$${BINS}): ${BIN_INSTALL_PATH}/% : ${BUILD_PATH}/%' >> $@; \
			echo '	${INSTALL} -m 644 -D $$^ $$@' >> $@; \
			echo >> $@; \
		fi \
	fi
	@echo >> $@
	@for target in ${BINS} ${LIBS}; do \
		case $$target in \
			*.a) \
				echo ${BUILD_PATH}/$$target: '$$(filter-out $${OBJS} $${EXTRAS}, $${objects}) $${EXTRA_DEPS}' >> $@; \
				echo '	$${AR} $${ARFLAGS} $$@ $$^' >> $@; \
				echo >> $@; \
			;; \
			*.so) \
				echo ${BUILD_PATH}/$$target: '$$(filter-out $${OBJS} $${EXTRAS}, $${objects}) $${EXTRA_DEPS}' >> $@; \
				echo '	$${LD} $${LDFLAGS} -shared -o $$@ $${objects} $${LDLIBES} $${LDLIBS}' >> $@; \
				echo >> $@; \
			;; \
			*.elf) \
				echo ${BUILD_PATH}/$$target: '$$(filter-out ${OJBS} ${EXTRAS}, $${objects}) $${EXTRA_DEPS}' >> $@; \
				echo '	$${LD} -Wl,-Map=$$(basename $$@).map,--cref $${LDFLAGS} -o $$@ $${objects} $${LOADLIBES} $${LDLIBS}' >> $@; \
				echo '	@$${SIZE} $$@' >> $@; \
				echo >> $@; \
			;; \
			*.*) \
			;; \
			*) \
				echo ${BUILD_PATH}/$$target: '$$(filter-out ${OJBS} ${EXTRAS}, $${objects}) $${EXTRA_DEPS}' >> $@; \
				echo '	$${LD} $${LDFLAGS} -o $$@ $${objects} $${LOADLIBES} $${LDLIBS}' >> $@; \
				echo >> $@; \
			;; \
		esac; \
	done
	@echo 'all: $${TARGETS}' >> $@
	@echo >> $@
	@echo 'clean:' >> $@
	@echo '	rm -rf ${TARGETS} $${BINS} $${HEADERS} $${LIBS} $${OBJS} $${EXTRAS} $${objects} $${objects:.o=.d}' >> $@
	@echo >> $@
	@echo '%.bin: %.elf' >> $@
	@echo '	$${OBJCOPY} -O binary $$< $$@' >> $@
	@echo >> $@
	@echo '%.hex: %.elf' >> $@
	@echo '	$${OBJCOPY} -R .stack -O ihex $$< $$@' >> $@
	@echo >> $@
	@echo '%.dis: %.elf' >> $@
	@echo '	$${OBJDUMP} -d -f -M reg-names-std $$< > $$@' >> $@
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
	@if [ -n "${OBJECT_INSTALL_PATH}" ]; then \
		echo rm -rf $(addprefix ${OBJECT_INSTALL_PATH}/, ${OBJS}); \
		rm -rf $(addprefix ${OBJECT_INSTALL_PATH}/, ${OBJS}); \
	fi
	@if [ -n "${EXTRA_INSTALL_PATH}" ]; then \
		echo rm -rf $(addprefix ${EXTRA_INSTALL_PATH}/, ${EXTRAS}); \
		rm -rf $(addprefix ${EXTRA_INSTALL_PATH}/, ${EXTRAS}); \
	fi
	rm -rf ${BUILD_PATH}

