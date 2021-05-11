# Hacky LEF Edits Part 2
#
# "With the current version of the lef file, Innovus gives an error: **ERROR: (IMPLF-121):   
#  You need to have cut layer after layer 'pwell'.. Manually add the licon layer after pwell layer definition in rtk-tech.lef. 
#  Captable generation fails with this change, so we should do that earlier. This is really hacky, and should be fixed properly.""
#
#
from skywater_path import *
from utils import *

print("Fixing RTK LEF.")

insert_text="LAYER licon \n  TYPE CUT ;\nEND licon"
file_insert_line_at_pattern(VIEW_STANDARD_PATH + '/rtk-tech.lef', 'END pwell', insert_text, replace_line=False)