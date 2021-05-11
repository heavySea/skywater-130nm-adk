from skywater_path import *

####
#   This is the original script. But since openPDK already provides a concated cdl file we can use just this!
###

# from glob import glob
# from utils import *

# cell_dirs = glob(SKYWATER130_HOME + "/libraries/sky130_fd_sc_hd/latest/cells/*/")

# outfilename = 'stdcells.cdl'
# infilenames = []

# for cell_dir in cell_dirs:
#     libname = cell_dir.split('/')[-5]
#     cellname = cell_dir.split('/')[-2]

#     # CDL file for each size
#     infilenames = infilenames + glob(cell_dir+libname+'__'+cellname+'_*.cdl')

# write_concat_file(outfilename, infilenames)


####
#   End of original script
###


## Using the concated standard cell cdl from openPDK

copyfile(SKYWATER130A + '/libs.ref/sky130_fd_sc_hd/cdl/sky130_fd_sc_hd.cdl', VIEW_STANDARD_PATH + '/stdcells.cdl')