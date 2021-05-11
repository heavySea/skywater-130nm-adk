from skywater_path import *
from shutil import copyfile
####
#   This is the original script. But since openPDK already provides a concated lef file we can use just this!
###
#from glob import glob

# cell_dirs = glob(SKYWATER130_HOME + "/libraries/sky130_fd_sc_hd/latest/cells/*/")

# def write_concat_lef_file(outfilename, infilenames):
#     first_file = True
#     with open(outfilename, 'w') as outfile:
#         for fname in infilenames:
#             with open(fname) as infile:
#                 start_macro = False
#                 end_macro = False
#                 for line in infile:
#                     # Only write lines between MACRO ... END macro
#                     if line.startswith('MACRO'):
#                         start_macro = True
#                     if line.startswith('END LIBRARY'):
#                         end_macro = True
#                         outfile.write("#--------EOF---------\n\n")
#                     if (first_file and not end_macro) or (not first_file and (start_macro and not end_macro)):
#                         outfile.write(line)
#                 first_file = False
#         outfile.write('END LIBRARY')

# outfilename = WORK_PATH + '/stdcells.lef'
# infilenames = []

# for cell_dir in cell_dirs:
#     libname = cell_dir.split('/')[-5]
#     cellname = cell_dir.split('/')[-2]

#     # LEF file for each size
#     infilenames = infilenames + glob(cell_dir+libname+'__'+cellname+'_*.magic.lef')

# write_concat_lef_file(outfilename, infilenames)


####
#   End of original script
###


## Using the concated standard cell lef from openPDK

# copy lef into working directory for later steps
copyfile(SKYWATER130A + '/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef', WORK_PATH + '/stdcells.lef')

# copy lef into standard view directory
copyfile(SKYWATER130A + '/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef', VIEW_STANDARD_PATH + '/stdcells.lef')