import os

SKYWATER130_HOME = os.environ.get('PDK_ROOT') + '/skywater-pdk'
SKYWATER130A = os.environ.get('PDK_ROOT') + '/sky130A'

VIEW_STANDARD_PATH = os.environ.get('VIEW_STANDARD_DIR')
ADK_ROOT = os.environ.get('ADK_ROOT')
WORK_PATH = ADK_ROOT + "/work"

# As long as https://github.com/google/skywater-pdk/pull/185 is pending the vendor files are 
# checked out independently
SYNOPSYS_VENDOR_FILES = os.environ.get('PDK_ROOT') + '/SKY130_VENDOR_FILES/vendor/synopsys'
CADENCE_VENDOR_FILES = os.environ.get('PDK_ROOT') + '/SKY130_VENDOR_FILES/vendor/cadence'


PDK_CAPTABLES_PATH= CADENCE_VENDOR_FILES + '/captables'
PDK_DB_PATH = SYNOPSYS_VENDOR_FILES + '/lib'
