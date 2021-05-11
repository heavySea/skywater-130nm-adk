from shutil import copyfile
from glob import glob
from utils import *
from skywater_path import *
import os 

cell_dirs = glob(SKYWATER130_HOME + "/libraries/sky130_fd_sc_hd/latest/cells/*/")

if(~os.path.isdir("stdcellsgds")):
    os.mkdir("stdcellsgds")

infilenames = []

for cell_dir in cell_dirs:
    libname = cell_dir.split('/')[-5]
    cellname = cell_dir.split('/')[-2]


    infilenames = infilenames + glob(cell_dir+libname+'__'+cellname+'_*.gds')
    
    for fname in infilenames:
        copyfile(fname, 'stdcellsgds/'+fname.split('/')[-1])
