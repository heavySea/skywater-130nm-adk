from shutil import *
from skywater_path import *
from utils import *
import sys
import os
import subprocess

# Check whether the PDK already contains generated captables
if os.path.exists(PDK_MW_PATH):
	print("Found Milkyway database files in the PDK.")
	# copy generated captables
	try:
		copyfile(PDK_MW_PATH + '/sky130_fd_sc_hd.tf', VIEW_STANDARD_PATH + "/rtk-tech.tf")
		# Overwrite direcotry
		if os.path.exists(VIEW_STANDARD_PATH + "/stdcells.mwlib"):
			rmtree(VIEW_STANDARD_PATH + "/stdcells.mwlib")
		copytree(PDK_MW_PATH + '/sky130_fd_sc_hd.mwlib', VIEW_STANDARD_PATH + "/stdcells.mwlib")
	except Exception as e:
		raise e
	
else:
	print("Milkyway database not found in the PDK. Generate Milkyway using Synopsys Milkyway tool.")
	# Check if Cadence Innovus can be executed
	if which( "Milkyway" ):

		MWFlags = '-tcl -nogui'
		# Some EDA bundles have different licenses for Milkyway. This must be set during the start of Milkyway
		Galaxy_Flag = os.environ.get('MW_GALAXY')
		if Galaxy_Flag:
			MWFlags = MWFlags + ' -galaxy'
		MWlog = '-log ' + WORK_PATH + '/mw.log'

		# Copy and modify enviroment variables
		sub_env = os.environ.copy()

		sub_env["target_lib_dir"] 	= SKYWATER130_HOME + '/libraries/sky130_fd_sc_hd/latest'
		sub_env["target_lib_name"] 	= 'sky130_fd_sc_hd'

		subprocess.run("Milkyway " + MWFlags + ' ' + MWlog +" -file " + ADK_ROOT + "/setup_scripts/mw_gen.tcl", shell=True, check=True, env=sub_env)

		# When mwlib generation was sucessfull copy the result into the ADK
		copyfile('sky130_fd_sc_hd.tf', VIEW_STANDARD_PATH + '/rtk-tech.tf')
		# Overwrite direcotry
		if os.path.exists(VIEW_STANDARD_PATH + "/stdcells.mwlib"):
			rmtree(VIEW_STANDARD_PATH + "/stdcells.mwlib")
		copytree('sky130_fd_sc_hd.mwlib', VIEW_STANDARD_PATH + '/stdcells.mwlib')

		# copy result into PDK
		if not os.path.isdir(PDK_MW_PATH):
			try:
				os.makedirs(PDK_MW_PATH)
			except OSError:
				print ("Creation of the directory %s failed" % path)
				sys.exit(1)

		copyfile('sky130_fd_sc_hd.tf', PDK_MW_PATH + '/sky130_fd_sc_hd.tf')
		
		# Overwrite direcotry
		if os.path.exists(PDK_MW_PATH + "/sky130_fd_sc_hd.mwlib"):
			rmtree(PDK_MW_PATH + '/sky130_fd_sc_hd.mwlib')
		copytree('sky130_fd_sc_hd.mwlib', PDK_MW_PATH + '/sky130_fd_sc_hd.mwlib')

	else:
		print("Warning: Cant find Synopsys Milkyway. Milkyway generation will be skipped!")
		sys.exit(0)
