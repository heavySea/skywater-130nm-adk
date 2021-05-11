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

# Currently the vendor files for Synopsys are still in an PR state
# Do a sparse checkout to only download the directory containing the vendor files
# This is mostly required to get the ITF file to generate captables
SPARSE_CHECKOUT_PDK_FILES_PATH:=$(PDK_ROOT)/SKY130_VENDOR_FILES

SETUP_DIR:=$(PWD)/setup_scripts
export VIEW_STANDARD_DIR:=$(PWD)/view-standard
export ADK_ROOT:=$(PWD)


.PHONY: install
install: check-pdk  
# Technology LEF generate
	test -d work || mkdir work
	cd work && python3 $(SETUP_DIR)/generate_rtk_lef.py
	cd work && python3 $(SETUP_DIR)/generate_captable.py
#rm -rf work

check-pdk:
	@if [ ! -d "$(PDK_ROOT)" ]; then \
		echo "PDK Root: "$(PDK_ROOT)" doesn't exists, please export the correct path before running make. "; \
		exit 1; \
	fi
	@if [ ! -d "$(SKY_PDK_ROOT)" ]; then \
		echo "PDK Root: "$(SKY_PDK_ROOT)" doesn't exists, please export the correct path to the folder that contains skywater-pdk and SKY130A before running make. "; \
		exit 1; \
	fi
	@if [ ! -d "$(SKY130A)" ]; then \
		echo "PDK Root: "$(SKY130A)" doesn't exists, please export the correct path to the folder that contains skywater-pdk and SKY130A before running make. "; \
		exit 1; \
	fi

# This is only required as long https://github.com/google/skywater-pdk/pull/185 is pending!
.PHONY: sparse_checkout_synopsys_files
sparse_checkout_synopsys_files:
	@if [ ! -d "$(SPARSE_CHECKOUT_PDK_FILES_PATH)" ]; then \
		mkdir $(SPARSE_CHECKOUT_PDK_FILES_PATH); \
		cd $(SPARSE_CHECKOUT_PDK_FILES_PATH) && git init && git remote add -f origin https://github.com/20Mhz/skywater-pdk.git; \
		cd $(SPARSE_CHECKOUT_PDK_FILES_PATH) && git config core.sparseCheckout true && echo "vendor/synopsys/" >> .git/info/sparse-checkout; \
		cd $(SPARSE_CHECKOUT_PDK_FILES_PATH) && git pull origin synopsys_pull; \
		ln -sf $(SKY_PDK_ROOT)/libraries $(SPARSE_CHECKOUT_PDK_FILES_PATH)/libraries; \
	fi

# Not tested yet. Todo on Monday
.PHONY: synopsys_vendor_files
synopsys_vendor_files: sparse_checkout_synopsys_files
	cd $(SPARSE_CHECKOUT_PDK_FILES_PATH)/vendor/synopsys && $(MAKE) sky130_fd_sc_hd_db
	cd $(SPARSE_CHECKOUT_PDK_FILES_PATH)/vendor/synopsys && $(MAKE) sky130_fd_sc_hd_mw