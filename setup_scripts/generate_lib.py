from shutil import copyfile
from skywater_path import *
import re

copyfile(SKYWATER130_HOME + '/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__tt_025C_1v80.lib', 'sky130_fd_sc_hd__tt_025C_1v80.lib')


# The lib file generated from the PDK does not work out of the box, and several changes are required.
# most of these problems require changes of the source JSON files from which the liberty files are generated
# as long, as these are not fixed properly we need to fix the lib files directly here

print ("Fixing .lib file of sky130_fd_sc_hd__tt_025C_1v80. Read the docs about this step to check if these modifications are still relevant!")

lib_read = open('sky130_fd_sc_hd__tt_025C_1v80.lib', 'r').read()

# Define some helper functions
# Some are derived from https://github.com/google/skywater-pdk/pull/185

def fix_pg_type_for_pg_pin(text, pg_pin, pg_type, orig_pg_type=r'\w+'):
    find    = r'(pg_pin \(\"' + pg_pin + r'\"\) \{\s*\n(\s+)pg_type : \")' + orig_pg_type + r'(\";)\n'
    replace = r'\1' + pg_type + r'\3' + '\n'
    return re.sub(find, replace, text)

def fix_related_pin_for_pg_pin(text, pg_pin, related_pin, new_pin):
    find    = r'(pg_pin \(\"' + pg_pin + r'\"\) \{\s*\n(.|\n)*?\s+' + related_pin + r' : \")\w+(\";)\n'
    replace = r'\1' + new_pin + r'\3' + '\n'
    return re.sub(find, replace, text)

def fix_related_pin_for_pin(text, pg_pin, related_pin, new_pin):
    find    = r'(pin \(\"' + pg_pin + r'\"\) \{\s*\n(\s*\w+ : \"\w+";\n){1,4}\s+' + related_pin + r' : \")\w+(\";)\n'
    replace = r'\1' + new_pin + r'\3' + '\n'
    return re.sub(find, replace, text)

def fix_missing_pg_pin(text, cell_name, pg_pin, attributes, insert_after_pg_pin=None):
    find    = r'(cell \(\"' + cell_name + r'.*\"\) \{\s*\n)'
    if insert_after_pg_pin != None:
        find    = find + r'(((.|\n)*?)(\n(\s*)pg_pin \(\"' + insert_after_pg_pin + r'\"\) \{\s*\n(.|\n)*?\n\s*\}))'
        replace = r'\1\2\n\6'
        tab = r'\6'
    else:
        find    = find + r'(\s*)'
        replace = r'\1\2\n'
        tab = r'\2'

    replace = replace + 'pg_pin ("' + pg_pin + '") {\n'

    for attr_key, attr_value in attributes.items():
        replace = replace + tab + '    ' + attr_key + ' : "' + attr_value + '";\n'

    replace = replace + tab + '}'

    return re.sub(find, replace, text)

    #find    = r'(pin \(\"' + pg_pin + r'\"\) \{\s*\n(\s*\w+ : \"\w+";\n){1,4}\s+' + related_pin + r' : \")\w+(\";)\n'
    #replace = r'\1' + new_pin + r'\3' + '\n'
    #return re.sub(find, replace, text, re.DOTALL)


# https://github.com/google/skywater-pdk/issues/288
# Fix Power, Gound and well pins
# VNB is the pwell pin and associated with related_pin beeing VGND 
# VPB is the mwell pin and associated with related_pin beeing VPWR 
# (this is an awfull choice of naming...)
# VGND is the primary_ground pin, with Voltage Name VGND and related_bias_pin VNB
# VPWR is the primary_power pin, with Voltage Name VGND and related_bias_pin VPB

# fix nwell/pwell
lib_read = fix_pg_type_for_pg_pin(lib_read, 'VNB', 'pwell')
lib_read = fix_pg_type_for_pg_pin(lib_read, 'VPB', 'nwell')

#fix related bias pin
lib_read = fix_related_pin_for_pg_pin(lib_read, 'VPWR', 'related_bias_pin', 'VPB')
lib_read = fix_related_pin_for_pg_pin(lib_read, 'VGND', 'related_bias_pin', 'VNB')

# some pins have as related_ground_pin VPB defined, which must be changed to VGND
lib_read = fix_related_pin_for_pin(lib_read, 'M0', 'related_ground_pin', 'VGND')



# https://github.com/google/skywater-pdk/issues/183
# sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap and sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap are missing VNB pg_pin

VNB_pg_pin_attributes = {'pg_type' : 'pwell', 'physical_connection' : 'device_layer', 'voltage_name' : 'VNB'}

lib_read= fix_missing_pg_pin(lib_read, 'sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap', 'VNB', VNB_pg_pin_attributes, insert_after_pg_pin='VGND')
lib_read= fix_missing_pg_pin(lib_read, 'sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap', 'VNB', VNB_pg_pin_attributes, insert_after_pg_pin='VGND')


with open('sky130_fd_sc_hd__tt_025C_1v80.fixed.lib','w') as write_file:
    write_file.write(lib_read)


#
# "There is a warning in DC: Warning: The 'sky130_fd_sc_hd__macro_sparecell' cell in the 'sky130_fd_sc_hd__tt_025C_1v80' technology library does not 
# have corresponding physical cell description. (PSYN-024), that causes an assertion to fail in mflowgen. So remove this cell manually from the lib."
# -> Better solution is to suppress this warning message
#


# Finally copy file to ADK
copyfile('sky130_fd_sc_hd__tt_025C_1v80.fixed.lib', VIEW_STANDARD_PATH + '/stdcells.lib')