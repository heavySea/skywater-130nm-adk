from shutil import copyfile
from skywater_path import *
from glob import glob

# The standard cell behaviour models are written in an non-ANSI style verilog format,
# using implicit port type declarations. Alle in and out ports are automatically
# interpreted as wires, if not changed inside the body.
# The concated verilog files contain a compiler directive, which prohibites these
# assumptions. This will produce an error during simulation with most simulators.
# This behaviour has already an issue in the PDK repo:
# https://github.com/google/skywater-pdk/issues/198
# 
# This fix can be removed, once the issue has been solved.


print ("Fixing standard cell behaviour model files. Read the docs about this step to check if these modifications are still relevant!")

verilog_files = glob(WORK_PATH + "/*.v")

for vfile in verilog_files:
	vlines = open(vfile, 'r').readlines()
	with open(vfile, 'w') as outfile: 
		for line in vlines:
			if line=="`default_nettype none\n":
				line="`default_nettype wire\n"
			outfile.write(line)