from shutil import copyfile
from skywater_path import *
from utils import *

copyfile(SKYWATER130_HOME + '/libraries/sky130_fd_sc_hd/latest/tech/sky130_fd_sc_hd.tlef', VIEW_STANDARD_PATH + '/rtk-tech.lef')


# Hacky Lef Edits Part 1
# Insert OVERLAP after last metal
# "Edit this file to add these lines after the last metal layer, otherwise LEF generation in Innovus complains."
insert_text="LAYER OVERLAP \n  TYPE OVERLAP ;\nEND OVERLAP"
file_insert_line_at_pattern(VIEW_STANDARD_PATH + '/rtk-tech.lef', 'END met5', insert_text, replace_line=False)

