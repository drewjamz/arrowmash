#-- Lattice Semiconductor Corporation Ltd.
#-- Synplify OEM project file

#device options
set_option -technology SBTICE40UP
set_option -part iCE40UP5K
set_option -package SG48I
set_option -speed_grade -6
#compilation/mapping options
set_option -symbolic_fsm_compiler true
set_option -resource_sharing true

#use verilog standard option
set_option -vlog_std v2001

#map options
set_option -frequency 200
set_option -maxfan 1000
set_option -auto_constrain_io 0
set_option -retiming false; set_option -pipe true
set_option -force_gsr auto
set_option -compiler_compatible 0


set_option -default_enum_encoding default

#timing analysis options



#automatic place and route (vendor) options
set_option -write_apr_constraint 1

#synplifyPro options
set_option -fix_gated_and_generated_clocks 0
set_option -update_models_cp 0
set_option -resolve_multiple_driver 0
set_option -vhdl2008 1

set_option -rw_check_on_ram 0


#-- set any command lines input by customer

set_option -dup false
set_option -disable_io_insertion false
add_file -constraint {Final_impl_1_cpe.ldc}
add_file -verilog {C:/lscc/radiant/2023.1/ip/pmi/pmi_iCE40UP.v}
add_file -vhdl -lib pmi {C:/lscc/radiant/2023.1/ip/pmi/pmi_iCE40UP.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/top.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/NES_controller.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/vga.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/pattern_gen.vhd}
add_file -verilog -vlog_std v2001 {Z:/es4/Final-20241122T182447Z-001/Final/mypll/rtl/mypll.v}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/up_arrow_rom.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/right_arrow_rom.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/left_arrow_rom.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/down_arrow_rom.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/arrow_selector.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/randomizer.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/pattern_gen_helper.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/pattern_gen_helper2.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/blue_heart_rom.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/red_heart_rom.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/blank_heart_rom.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/right_blank_rom.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/up_blank_rom.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/down_blank_rom.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/left_blank_rom.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/start_screen_rom.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/blank_helper.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/Blank_Arrow_Selector.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/game.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/arrows_pkg.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/blank_helper2.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/heart_helper.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/heart_selector.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/states.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/states_pkg.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/red_win_rom.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/blue_win_rom.vhd}
add_file -vhdl -lib "work" {Z:/es4/Final-20241122T182447Z-001/Final/source/impl_1/fullscreen_helper.vhd}
#-- top module name
set_option -top_module top
set_option -include_path {Z:/es4/Final-20241122T182447Z-001/Final}

#-- run Synplify with 'arrange HDL file'
project -run hdl_info_gen -fileorder
set_option -include_path {Z:/es4/Final-20241122T182447Z-001/Final/mypll}

#-- set result format/file last
project -result_format "vm"
project -result_file {Z:/es4/Final-20241122T182447Z-001/Final/impl_1/Final_impl_1.vm}

#-- error message log file
project -log_file {Final_impl_1.srf}
project -run -clean
