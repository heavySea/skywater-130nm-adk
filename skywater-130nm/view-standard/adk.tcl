#=========================================================================
# ASIC Design Kit Setup TCL File
#=========================================================================
# This file is sourced by every asic flow tcl script that uses the
# ASIC design kit. This allows us to set ADK-specific variables.

# written by Priyanka Raina: 
# https://code.stanford.edu/ee272/skywater-130nm-adk

#-------------------------------------------------------------------------
# ADK_PROCESS
#-------------------------------------------------------------------------
# This variable is used by the Innovus Foundation Flow to automatically
# configure process-specific options (e.g., extraction engines).
#
# The process can be "28", "180", etc., with units in nm.

set ADK_PROCESS 130

#-------------------------------------------------------------------------
# Preferred routing layers
#-------------------------------------------------------------------------
# These variables are used by the Synopsys DC Topographical flow and also
# by the Innovus Foundation Flow. Typically the top few metal layers are
# reserved for power straps and maybe clock routing.

set ADK_MIN_ROUTING_LAYER_DC met2
set ADK_MAX_ROUTING_LAYER_DC met5

set ADK_MAX_ROUTING_LAYER_INNOVUS 6

set ADK_BASE_LAYER_IDX 1

#-------------------------------------------------------------------------
# Power mesh layers
#-------------------------------------------------------------------------
# These variables are used in Innovus scripts to reference the layers used
# for the coarse power mesh.
#
# Care must be taken to choose the right layers for the power mesh such
# that the bottom layer of the power mesh is perpendicular to the
# direction of the power rails in the stdcells. This allows Innovus to
# stamp stacked vias down at each intersection.

set ADK_POWER_MESH_BOT_LAYER 5
set ADK_POWER_MESH_TOP_LAYER 6

#-------------------------------------------------------------------------
# ADK_DRIVING_CELL
#-------------------------------------------------------------------------
# This variable should indicate which cell to use with the
# set_driving_cell command. The tools will assume all inputs to a block
# are being driven by this kind of cell. It should usually be some kind
# of simple inverter.

set ADK_DRIVING_CELL "sky130_fd_sc_hd__inv_8"

#-------------------------------------------------------------------------
# ADK_TYPICAL_ON_CHIP_LOAD
#-------------------------------------------------------------------------
# Our default timing constraints assume that we are driving another block of
# on-chip logic. Select how much load capacitance (in the same units as the
# lib/db) we should drive here. This is the load capacitance that the output
# pins of the block will expect to be driving.
#
# The stdcell lib shows about 9fF for an inverter x4, so about 9fF is
# reasonable.

set ADK_TYPICAL_ON_CHIP_LOAD 0.017

#-------------------------------------------------------------------------
# ADK_FILLER_CELLS
#-------------------------------------------------------------------------
# This variable should include a space delimited list of the names of
# the filler cells in the library. Note, you must order the filler cells
# from largest to smallest because ICC / Innovus will start by using the
# first filler cell, and only use the second filler cell if there is
# space.

set ADK_FILLER_CELLS \
  "sky130_fd_sc_hd__fill_8 \
   sky130_fd_sc_hd__fill_4 \
   sky130_fd_sc_hd__fill_2 \
   sky130_fd_sc_hd__fill_1"

#-------------------------------------------------------------------------
# ADK_TIE_CELLS
#-------------------------------------------------------------------------
# This list should specify the cells to use for tying high to VDD and
# tying low to VSS.

set ADK_TIE_CELLS \
  "sky130_fd_sc_hd__conb_1"
 
#-------------------------------------------------------------------------
# ADK_WELL_TAP_CELL
#-------------------------------------------------------------------------
# This list should specify the well tap cell if the stdcells in the
# library do not already include taps. The interval is the DRC rule for
# the required spacing between tap cells.

# source: https://github.com/RTimothyEdwards/open_pdks/blob/master/sky130/openlane/sky130_fd_sc_hd/config.tcl#L29
set ADK_WELL_TAP_CELL "sky130_fd_sc_hd__tapvpwrvgnd_1"

# source: https://github.com/RTimothyEdwards/open_pdks/blob/master/sky130/openlane/config.tcl#L70
set ADK_WELL_TAP_INTERVAL 13


#-------------------------------------------------------------------------
# ADK_END_CAP_CELL
#-------------------------------------------------------------------------
# This list should specify the end cap cells if the library requires them.

# source: https://github.com/RTimothyEdwards/open_pdks/blob/master/sky130/openlane/sky130_fd_sc_hd/config.tcl#L30
set ADK_END_CAP_CELL "sky130_fd_sc_hd__decap_3"

#-------------------------------------------------------------------------
# ADK_ANTENNA_CELL
#-------------------------------------------------------------------------
# This list has the antenna diode cell used to avoid antenna DRC
# violations.

# source: https://github.com/RTimothyEdwards/open_pdks/blob/master/sky130/openlane/sky130_fd_sc_hd/config.tcl#L55
set ADK_ANTENNA_CELL "sky130_fd_sc_hd__diode_2"

#-------------------------------------------------------------------------
# ADK_LVS_EXCLUDE_CELL_LIST (OPTIONAL)
#-------------------------------------------------------------------------
# For LVS, we usually want a netlist that excludes physical cells that
# have no devices in them (or else LVS will have issues). Specifically for
# filler cells, the extracted layout will not have any trace of the
# fillers because there are no devices in them. Meanwhile, the schematic
# generated from the netlist will show filler cells instances with VDD/VSS
# ports, and this will cause LVS to flag a "mismatch" with the layout.
#
# This list can be used to filter out physical-only cells from the netlist
# generated for LVS. If this is left empty, LVS will just be a bit more
# difficult to deal with.

set ADK_LVS_EXCLUDE_CELL_LIST \
  "sky130_fd_sc_hd__fill_* \
   sky130_fd_sc_hd__decap_* \
   sky130_fd_sc_hd__tapvpwrvgnd_1"

#-------------------------------------------------------------------------
# ADK_VIRTUOSO_EXCLUDE_CELL_LIST (OPTIONAL)
#-------------------------------------------------------------------------
# Similar to the case with LVS, we may want to filter out certain cells
# for Virtuoso simulation. Specifically, decaps can make Virtuoso
# simulation very slow. While we do eventually want to do a complete
# simulation including decaps, excluding them can speed up simulation
# significantly.
#
# This list can be used to filter out such cells from the netlist
# generated for Virtuoso simulation. If this is left empty, then Virtuoso
# simulations will just run more slowly.

set ADK_VIRTUOSO_EXCLUDE_CELL_LIST \
  "sky130_fd_sc_hd__fill_* \
   sky130_fd_sc_hd__decap_* \
   sky130_fd_sc_hd__tapvpwrvgnd_1"

#-------------------------------------------------------------------------
# ADK_BUF_CELL_LIST (OPTIONAL)
#-------------------------------------------------------------------------
# For ECOs, we specify what buffer cells can be used in order to resolve
# timing violations.
set ADK_BUF_CELL_LIST \
  "sky130_fd_sc_hd__buf_1 \
   sky130_fd_sc_hd__buf_2 \
   sky130_fd_sc_hd__buf_4 \
   sky130_fd_sc_hd__buf_6 \
   sky130_fd_sc_hd__buf_8 \
   sky130_fd_sc_hd__buf_12 \
   sky130_fd_sc_hd__buf_16"

#-------------------------------------------------------------------------
# Support for open-source tools
#-------------------------------------------------------------------------
# Open-source tools tend to require more detailed variables than
# commercial tools do. In this section we define extra variables for them.

set ADK_TIE_HI_CELL "sky130_fd_sc_hd__conb_1"
set ADK_TIE_LO_CELL "sky130_fd_sc_hd__conb_1"
set ADK_TIE_HI_PORT "HI"
set ADK_TIE_LO_PORT "LO"

set ADK_MIN_BUF_CELL   "sky130_fd_sc_hd__buf_1"
set ADK_MIN_BUF_PORT_I "A"
set ADK_MIN_BUF_PORT_O "X"


#-------------------------------------------------------------------------
# Don't use cells
#-------------------------------------------------------------------------
# Define a list of cells to not use from the libraries for synthesis
# list from openPDK
set ADK_DONT_USE_CELLS_SYNTH \
  "sky130_fd_sc_hd_*/sky130_fd_sc_hd__clkbuf_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__clkbuf_16 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__clkbuf_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__clkbuf_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__clkbuf_8 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__clkdlybuf4s15_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__clkdlybuf4s15_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__clkdlybuf4s18_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__clkdlybuf4s18_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__clkdlybuf4s25_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__clkdlybuf4s25_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__clkdlybuf4s50_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__clkdlybuf4s50_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__clkinv_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__clkinv_16 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__clkinv_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__clkinv_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__clkinv_8 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__clkinvlp_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__clkinvlp_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__decap_12 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__decap_3 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__decap_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__decap_6 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__decap_8 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__diode_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dlclkp_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dlclkp_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dlclkp_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dlrbn_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dlrbn_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dlrbp_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dlrbp_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dlrtn_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dlrtn_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dlrtn_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dlrtp_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dlrtp_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dlrtp_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dlxbn_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dlxbn_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dlxbp_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dlygate4sd1_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dlygate4sd2_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dlygate4sd3_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dlymetal6s2s_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dlymetal6s4s_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dlymetal6s6s_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__edfxbp_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__edfxtp_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__einvn_0 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__einvn_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__einvn_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__einvn_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__einvn_8 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__einvp_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__einvp_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__einvp_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__einvp_8 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__fah_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__fahcin_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__fahcon_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__ha_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__ha_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__ha_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__macro_sparecell \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__maj3_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__maj3_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__maj3_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__mux2i_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__mux2i_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__mux2i_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sdfbbn_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sdfbbn_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sdfbbp_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sdfrbp_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sdfrbp_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sdfrtn_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sdfrtp_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sdfrtp_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sdfrtp_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sdfsbp_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sdfsbp_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sdfstp_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sdfstp_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sdfstp_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sdfxbp_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sdfxbp_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sdfxtp_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sdfxtp_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sdfxtp_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sdlclkp_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sdlclkp_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sdlclkp_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sedfxbp_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sedfxbp_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sedfxtp_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sedfxtp_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__sedfxtp_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a2111oi_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a211o_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a211oi_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a2111o_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a21bo_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a21boi_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a21o_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a21oi_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a221o_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a221oi_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a222oi_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a22o_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a22oi_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a2bb2o_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a2bb2oi_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a311o_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a311oi_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a2111o_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a21bo_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a21boi_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a21o_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a21oi_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a221o_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a221oi_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a222oi_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a22o_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a22oi_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a2bb2o_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a2bb2oi_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a311o_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a311oi_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a31o_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a31oi_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a32o_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a32oi_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a41o_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a41oi_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__and2_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__and2b_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__and3_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__and3b_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__and4_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__and4b_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__and4bb_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dfbbn_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dfbbp_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dfrbp_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dfrtn_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dfrtp_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dfsbp_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dfstp_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dfxbp_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__dfxtp_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__ebufn_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__inv_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__nand2_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__nand2b_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__nand3_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__nand3b_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__nand4_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__nand4b_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__nand4bb_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__nor2_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__nor2b_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__nor3_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__nor3b_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__nor4_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__nor4b_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__nor4bb_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__o2111a_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__o2111ai_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__o211a_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__o211ai_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__o21a_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__o21ai_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__o21ba_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__o21bai_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__o221a_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__o221ai_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__o22a_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__o22ai_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__o2bb2a_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__o2bb2ai_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__o311a_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__o311ai_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__o31a_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__o31ai_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__o32a_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__o32ai_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__o41a_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__o41ai_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__or2_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__or2b_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__or3_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__or3b_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__or4_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__or4b_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__or4bb_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__xnor2_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__xor2_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a2111oi_0 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a21boi_0 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__and2_0 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__buf_16 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__clkdlybuf4s15_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__clkdlybuf4s18_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__fa_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_bleeder_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_clkbufkapwr_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_clkbufkapwr_16 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_clkbufkapwr_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_clkbufkapwr_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_clkbufkapwr_8 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_clkinvkapwr_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_clkinvkapwr_16 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_clkinvkapwr_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_clkinvkapwr_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_clkinvkapwr_8 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_decapkapwr_12 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_decapkapwr_3 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_decapkapwr_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_decapkapwr_6 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_decapkapwr_8 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_inputiso0n_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_inputiso0p_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_inputiso1n_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_inputiso1p_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_inputisolatch_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_isobufsrc_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_isobufsrc_16 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_isobufsrc_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_isobufsrc_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_isobufsrc_8 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_isobufsrckapwr_16 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__mux4_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__o21ai_0 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__o311ai_0 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__or2_0 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__probe_p_8 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__probec_p_8 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__xor3_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__xor3_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__xor3_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__xnor3_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__xnor3_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__xnor3_4"

# Define a list of cells to not use from the libraries for timing
# optimization/ violation fixing during PnR
# list from openPDK
set ADK_DONT_USE_CELLS_OPT \
  "sky130_fd_sc_hd_*/sky130_fd_sc_hd__a2111oi_0 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__a21boi_0 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__and2_0 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__buf_16 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__clkdlybuf4s15_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__clkdlybuf4s18_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__fa_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_bleeder_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_clkbufkapwr_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_clkbufkapwr_16 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_clkbufkapwr_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_clkbufkapwr_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_clkbufkapwr_8 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_clkinvkapwr_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_clkinvkapwr_16 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_clkinvkapwr_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_clkinvkapwr_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_clkinvkapwr_8 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_decapkapwr_12 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_decapkapwr_3 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_decapkapwr_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_decapkapwr_6 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_decapkapwr_8 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_inputiso0n_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_inputiso0p_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_inputiso1n_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_inputiso1p_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_inputisolatch_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_isobufsrc_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_isobufsrc_16 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_isobufsrc_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_isobufsrc_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_isobufsrc_8 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_isobufsrckapwr_16 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__mux4_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__o21ai_0 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__o311ai_0 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__or2_0 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__probe_p_8 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__probec_p_8 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__xor3_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__xor3_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__xor3_4 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__xnor3_1 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__xnor3_2 \
   sky130_fd_sc_hd_*/sky130_fd_sc_hd__xnor3_4 "