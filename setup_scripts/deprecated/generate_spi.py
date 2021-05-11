
from skywater_path import *

####
#   This is the original script. But since openPDK already provides a concated spice file we can use just this!
###

# from glob import glob
# from utils import *

# cell_dirs = glob(SKYWATER130_HOME + "/libraries/sky130_fd_sc_hd/latest/cells/*/")

# outfilename = 'stdcells.spi'
# infilenames = []

# for cell_dir in cell_dirs:
#     libname = cell_dir.split('/')[-5]
#     cellname = cell_dir.split('/')[-2]

#     # Spice file for each size
#     infilenames = infilenames + glob(cell_dir+libname+'__'+cellname+'_*.spice')

# write_concat_file(outfilename, infilenames)

####
#   End of original script
###


## Using the concated standard cell spice models from openPDK

# copy lef into standard view directory
copyfile(SKYWATER130A + '/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice', VIEW_STANDARD_PATH + '/stdcells.spi')