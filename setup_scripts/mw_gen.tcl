# Variables from the outside
set target_lib_dir 		$::env(target_lib_dir)
set target_lib_name 	$::env(target_lib_name)

set working_dir [pwd]

# This script builds MW library using technology and std cell LEF files
# This is very basic. The mw generate script from https://github.com/google/skywater-pdk/pull/185
# contains much more modifications, but generates new lef files at the end

read_lef \
  -lib_name ${target_lib_name}.mwlib \
  -cell_lef_files ${working_dir}/${target_lib_name}.lef \
  -tech_lef_files ${working_dir}/rtk-tech.lef

write_mw_lib_files -technology -output ${working_dir}/${target_lib_name}.tf ${working_dir}/${target_lib_name}.mwlib

exit