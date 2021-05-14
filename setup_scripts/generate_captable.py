from shutil import copyfile, which
from skywater_path import *
from utils import *
import sys
import os
import subprocess

# Check whether the PDK already contains generated captables
if os.path.exists(PDK_CAPTABLES_PATH + '/skywater.nominal.captable'):
	print("Found captable files inside the PDK.")
	# copy generated captables
	copyfile(PDK_CAPTABLES_PATH + '/skywater.nominal.captable', VIEW_STANDARD_PATH + "/rtk-typical.captable")
else:
	print("Captables not found inside the PDK. Generate Captables using Innovus.")
	# Check if Cadence Innovus can be executed
	if which( "generateCapTbl" ):

		subprocess.run("generateCapTbl -ict " + ADK_ROOT + "/setup_scripts/skywater130.nominal.ict -lef " + WORK_PATH + "/rtk-tech.lef -output " + WORK_PATH +"/rtk-typical.captable", shell=True)
	
		if not os.path.exists('rtk-typical.captable'):
			print("Captable generation failed!")
			sys.exit(1)
			
		copyfile('rtk-typical.captable', VIEW_STANDARD_PATH + '/rtk-typical.captable')

		# copy result into PDK
		if not os.path.isdir(PDK_CAPTABLES_PATH):
			try:
			    os.makedirs(PDK_CAPTABLES_PATH)
			except OSError:
			    print ("Creation of the directory %s failed" % path)
			    sys.exit(1)

		copyfile('rtk-typical.captable', PDK_CAPTABLES_PATH + '/skywater.nominal.captable')

	else:
		print("Warning: Cant find Cadence Innovus. Captable generation will be skipped!")
		sys.exit(0)




