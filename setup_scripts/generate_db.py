from shutil import copyfile, which
from skywater_path import *
from utils import *
import sys
import os
import subprocess

# Check whether the PDK already contains generated captables
if os.path.exists(PDK_DB_PATH + '/sky130_fd_sc_hd__tt_025C_1v80.db'):
	print("Found compiled library files for Synopsys tools inside the PDK.")
	# copy generated captables
	copyfile(PDK_DB_PATH + '/sky130_fd_sc_hd__tt_025C_1v80.db', VIEW_STANDARD_PATH + '/stdcells.db')
else:
	print("Compiled library files for Synopsys tools not found in the PDK. Generate compiled libraries using Synopsys Library Compiler.")
	# Check if Cadence Innovus can be executed
	if which( "lc_shell" ):

		LC_OPTIONS = '"set input_lib ' + ADK_ROOT + '/work/sky130_fd_sc_hd__tt_025C_1v80.fixed.lib; set output_db ' + ADK_ROOT + '/work/sky130_fd_sc_hd__tt_025C_1v80.db;"'
		subprocess.run("lc_shell -f " + ADK_ROOT + "/setup_scripts/db_gen_lc.tcl -x " + LC_OPTIONS, shell=True, check=True)

		copyfile('sky130_fd_sc_hd__tt_025C_1v80.db', VIEW_STANDARD_PATH + '/stdcells.db')

		# copy result into PDK
		if not os.path.isdir(PDK_DB_PATH):
			try:
			    os.makedirs(PDK_DB_PATH)
			except OSError:
			    print ("Creation of the directory %s failed" % path)
			    sys.exit(1)

		copyfile('sky130_fd_sc_hd__tt_025C_1v80.db', PDK_DB_PATH + '/sky130_fd_sc_hd__tt_025C_1v80.db')

	else:
		print("Warning: Cant find Synopsys Library Compiler. Library compilation will be skipped!")
		sys.exit(0)