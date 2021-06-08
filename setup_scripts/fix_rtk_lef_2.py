# Hacky LEF Edits Part 2
#
# "With the current version of the lef file, Innovus gives an error: **ERROR: (IMPLF-121):   
#  You need to have cut layer after layer 'pwell'.. Manually add the licon layer after pwell layer definition in rtk-tech.lef. 
#  Captable generation fails with this change, so we should do that earlier. This is really hacky, and should be fixed properly.""
#
#
from skywater_path import *
from utils import *
from shutil import copyfile

print ("Fixing tech LEF file (part 2). Read the docs about this step to check if these modifications are still relevant!")

#insert_text="LAYER licon \n  TYPE CUT ;\nEND licon"

insert_text	= "### https://github.com/google/skywater-pdk-libs-sky130_fd_sc_hd/pull/3/files\n"
			+ "LAYER poly\n    TYPE MASTERSLICE ;\nEND poly"
			+ "LAYER licon1\n    TYPE CUT ;\n"
			+ "    WIDTH 0.17 ;                # Licon 1\n"
			+ "    SPACING 0.17 ;              # Licon 2\n"
			+ "    ENCLOSURE BELOW 0 0 ;       # Licon 4\n"
			+ "    ENCLOSURE ABOVE 0.08 0.08 ; # Poly / Met1 4 / Met1 5\n"
			+ "END licon1\n###"

file_insert_line_at_pattern( 'rtk-tech.lef', 'END pwell', insert_text, replace_line=False)

# Copy final RTK LEF into standard view
copyfile('rtk-tech.lef', VIEW_STANDARD_PATH + '/rtk-tech.lef', )