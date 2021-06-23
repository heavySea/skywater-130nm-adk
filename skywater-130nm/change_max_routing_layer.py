# This script changes the maximum metal layer to use during PnR 

def replace_line_at_pattern(filename, pattern, text_insert):
    read_file = open(filename, 'r').readlines()
    with open(filename,'w') as write_file:
        for line in read_file:
            if pattern in line:
               	write_file.write(text_insert + "\n")
            else:
                write_file.write(line)


adk_file = "./view-standard/adk.tcl"

# replace ADK_MAX_ROUTING_LAYER_DC

replace_line_at_pattern(adk_file, "set ADK_MAX_ROUTING_LAYER_DC", "set ADK_MAX_ROUTING_LAYER_DC met4")

# replace ADK_MAX_ROUTING_LAYER_INNOVUS
replace_line_at_pattern(adk_file, "set ADK_MAX_ROUTING_LAYER_INNOVUS", "set ADK_MAX_ROUTING_LAYER_INNOVUS 5")


# replace ADK_POWER_MESH_BOT_LAYER
replace_line_at_pattern(adk_file, "set ADK_POWER_MESH_BOT_LAYER", "set ADK_POWER_MESH_BOT_LAYER 4")

# replace ADK_POWER_MESH_TOP_LAYER
replace_line_at_pattern(adk_file, "set ADK_POWER_MESH_TOP_LAYER", "set ADK_POWER_MESH_TOP_LAYER 5")