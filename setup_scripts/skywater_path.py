import os

SKYWATER130_HOME = os.environ.get('PDK_ROOT') + '/skywater-pdk'
SKYWATER130A = os.environ.get('PDK_ROOT') + '/sky130A'

VIEW_STANDARD_PATH = os.environ.get('VIEW_STANDARD_DIR')
ADK_ROOT = os.environ.get('ADK_ROOT')
WORK_PATH = ADK_ROOT + "/work"

PDK_CAPTABLES_PATH= SKYWATER130A + '/libs.tech/cadence/captables'
PDK_DB_PATH = SKYWATER130A + '/libs.tech/synopsys/db'
PDK_MW_PATH = SKYWATER130A + '/libs.ref/sky130_fd_sc_hd/milkyway'
