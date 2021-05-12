from shutil import copyfile
from skywater_path import *
#####
##
## Many files that have been generated originally (.spi, .cdl, .gds, ...) can be directly importer
## from the openPDK SKY130A build
##
####



################
##
## Std cell LEF
##
################

# copy lef into working directory for later steps
copyfile(SKYWATER130A + '/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef', WORK_PATH + '/sky130_fd_sc_hd.lef')
# copy lef into standard view directory
copyfile(SKYWATER130A + '/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef', VIEW_STANDARD_PATH + '/stdcells.lef')

################
##
## Tech LEF
##
################

# Copy into working directory because some fixes have to be done
copyfile(SKYWATER130A + '/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd.tlef',  WORK_PATH + '/rtk-tech.lef')


################
##
## Spice models
##
################

copyfile(SKYWATER130A + '/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice', VIEW_STANDARD_PATH + '/stdcells.spi')

################
##
## CDL files
##
################

copyfile(SKYWATER130A + '/libs.ref/sky130_fd_sc_hd/cdl/sky130_fd_sc_hd.cdl', VIEW_STANDARD_PATH + '/stdcells.cdl')

################
##
## GDS files
##
################

copyfile(SKYWATER130A + '/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds', VIEW_STANDARD_PATH + '/stdcells.gds')

################
##
## Verilog files
##
################

# For Simulation we also have to import behaviour models for io cells and hvl library
# Copy into working directory because some fixes have to be done
copyfile(SKYWATER130A + '/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v',  WORK_PATH + '/stdcells.v')
copyfile(SKYWATER130A + '/libs.ref/sky130_fd_sc_hvl/verilog/sky130_fd_sc_hvl.v',  WORK_PATH + '/stdcells-hvl.v')
copyfile(SKYWATER130A + '/libs.ref/sky130_fd_io/verilog/sky130_fd_io.v',  WORK_PATH + '/stdcells-io.v')


################
##
## Magic files for DRC
##
################

copyfile(SKYWATER130A + '/libs.tech/magic/sky130A.magicrc', VIEW_STANDARD_PATH + '/magicrc')
copyfile(SKYWATER130A + '/libs.tech/magic/sky130A.tcl', VIEW_STANDARD_PATH + '/sky130A_magic.tcl')
copyfile(SKYWATER130A + '/libs.tech/magic/sky130A.tech', VIEW_STANDARD_PATH + '/sky130A.tech')

################
##
## Negten files for LVS
##
################

copyfile(SKYWATER130A + '/libs.tech/netgen/sky130A_setup.tcl', VIEW_STANDARD_PATH + '/netgen-setup.tcl')
