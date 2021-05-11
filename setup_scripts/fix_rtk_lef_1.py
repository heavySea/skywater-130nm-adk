from utils import *

# Hacky Lef Edits Part 1
# Insert OVERLAP after last metal
# "Edit this file to add these lines after the last metal layer, otherwise LEF generation in Innovus complains."

print ("Fixing tech LEF file. Read the docs about this step to check if these modifications are still relevant!")

insert_text="LAYER OVERLAP \n  TYPE OVERLAP ;\nEND OVERLAP"
file_insert_line_at_pattern('rtk-tech.lef', 'END met5', insert_text, replace_line=False)

