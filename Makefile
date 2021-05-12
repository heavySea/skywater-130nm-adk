# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

ifndef PDK_ROOT
$(error You must set PDK_ROOT to the director containing skywater-pdk, open-pdk and SKY130A.)
endif

SKY_PDK_ROOT:=$(PDK_ROOT)/skywater-pdk
SKY130A:=$(PDK_ROOT)/sky130A


SETUP_DIR:=$(PWD)/setup_scripts
export ADK_ROOT:=$(PWD)
export VIEW_STANDARD_DIR:=$(ADK_ROOT)/skywater-130nm/view-standard

setup:
	test -d work || mkdir work

check-pdk:
	@if [ ! -d "$(PDK_ROOT)" ]; then \
		@echo "PDK Root: "$(PDK_ROOT)" doesn't exists, please export the correct path before running make. "; \
		exit 1; \
	fi
	@if [ ! -d "$(SKY_PDK_ROOT)" ]; then \
		@echo "PDK Root: "$(SKY_PDK_ROOT)" doesn't exists, please export the correct path to the folder that contains skywater-pdk and SKY130A before running make. "; \
		exit 1; \
	fi
	@if [ ! -d "$(SKY130A)" ]; then \
		@echo "PDK Root: "$(SKY130A)" doesn't exists, please export the correct path to the folder that contains skywater-pdk and SKY130A before running make. "; \
		exit 1; \
	fi

.PHONY: install
install: check-pdk setup openPDK_import captable_generate db_generate mw_generate

openPDK_import:
	cd work && python3 $(SETUP_DIR)/openPDK_import.py
	cd work && python3 $(SETUP_DIR)/fix_rtk_lef_1.py
	@echo "\n"
	cd work && python3 $(SETUP_DIR)/fix_verilog.py
	@echo "\n"

captable_generate: check-pdk setup
	cd work && python3 $(SETUP_DIR)/generate_captable.py
	@echo "\n"
# after captable generation the LEF can be further fixed
	cd work && python3 $(SETUP_DIR)/fix_rtk_lef_2.py
	@echo "\n"


lib_generate:
	cd work && python3 $(SETUP_DIR)/generate_lib.py
	@echo "\n"

db_generate: lib_generate
	cd work && python3 $(SETUP_DIR)/generate_db.py
	@echo "\n"

mw_generate:
	cd work && python3 $(SETUP_DIR)/generate_mw.py
	@echo "\n"

.PHONY: clean
clean: 
	@echo "Removing working directory."
	rm -rf work