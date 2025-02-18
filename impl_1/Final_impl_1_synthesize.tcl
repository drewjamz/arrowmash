if {[catch {

# define run engine funtion
source [file join {C:/lscc/radiant/2023.1} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) 1
set para(prj_dir) "Z:/es4/Final-20241122T182447Z-001/Final"
# synthesize IPs
# synthesize VMs
# propgate constraints
file delete -force -- Final_impl_1_cpe.ldc
run_engine_newmsg cpe -f "Final_impl_1.cprj" "mypll.cprj" -a "iCE40UP"  -o Final_impl_1_cpe.ldc
# synthesize top design
file delete -force -- Final_impl_1.vm Final_impl_1.ldc
run_engine synpwrap -prj "Final_impl_1_synplify.tcl" -log "Final_impl_1.srf"
run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o Final_impl_1_syn.udb Final_impl_1.vm] "Z:/es4/Final-20241122T182447Z-001/Final/impl_1/Final_impl_1.ldc"

} out]} {
   runtime_log $out
   exit 1
}
