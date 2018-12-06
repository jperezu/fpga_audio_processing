proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {Common 17-41} -limit 10000000

start_step init_design
set ACTIVE_STEP init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param xicom.use_bs_reader 1
  create_project -in_memory -part xc7a100tcsg324-1
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir C:/Users/Jorge/Documents/VHDL/final_dsed/final_dsed.cache/wt [current_project]
  set_property parent.project_path C:/Users/Jorge/Documents/VHDL/final_dsed/final_dsed.xpr [current_project]
  set_property ip_output_repo C:/Users/Jorge/Documents/VHDL/final_dsed/final_dsed.cache/ip [current_project]
  set_property ip_cache_permissions {read write} [current_project]
  set_property XPM_LIBRARIES XPM_CDC [current_project]
  add_files -quiet C:/Users/Jorge/Documents/VHDL/final_dsed/final_dsed.runs/synth_1/controlador.dcp
  read_ip -quiet C:/Users/Jorge/Documents/VHDL/final_dsed/final_dsed.srcs/sources_1/ip/clk_12M/clk_12M.xci
  set_property is_locked true [get_files C:/Users/Jorge/Documents/VHDL/final_dsed/final_dsed.srcs/sources_1/ip/clk_12M/clk_12M.xci]
  read_xdc C:/Users/Jorge/Documents/VHDL/final_dsed/Nexys4DDR_Master.xdc
  link_design -top controlador -part xc7a100tcsg324-1
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
  unset ACTIVE_STEP 
}

start_step opt_design
set ACTIVE_STEP opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force controlador_opt.dcp
  catch { report_drc -file controlador_drc_opted.rpt }
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
  unset ACTIVE_STEP 
}

start_step place_design
set ACTIVE_STEP place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force controlador_placed.dcp
  catch { report_io -file controlador_io_placed.rpt }
  catch { report_utilization -file controlador_utilization_placed.rpt -pb controlador_utilization_placed.pb }
  catch { report_control_sets -verbose -file controlador_control_sets_placed.rpt }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
  unset ACTIVE_STEP 
}

start_step route_design
set ACTIVE_STEP route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force controlador_routed.dcp
  catch { report_drc -file controlador_drc_routed.rpt -pb controlador_drc_routed.pb -rpx controlador_drc_routed.rpx }
  catch { report_methodology -file controlador_methodology_drc_routed.rpt -rpx controlador_methodology_drc_routed.rpx }
  catch { report_power -file controlador_power_routed.rpt -pb controlador_power_summary_routed.pb -rpx controlador_power_routed.rpx }
  catch { report_route_status -file controlador_route_status.rpt -pb controlador_route_status.pb }
  catch { report_clock_utilization -file controlador_clock_utilization_routed.rpt }
  catch { report_timing_summary -warn_on_violation -max_paths 10 -file controlador_timing_summary_routed.rpt -rpx controlador_timing_summary_routed.rpx }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  write_checkpoint -force controlador_routed_error.dcp
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
  unset ACTIVE_STEP 
}

start_step write_bitstream
set ACTIVE_STEP write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  set src_rc [catch { 
    puts "source {C:/Users/Jorge/Desktop/Ingenieria Teleco/DSED/Lab4/lab3_prehook.tcl}"
    source {C:/Users/Jorge/Desktop/Ingenieria Teleco/DSED/Lab4/lab3_prehook.tcl}
  } _RESULT] 
  if {$src_rc} { 
    send_msg_id runtcl-1 error "$_RESULT"
    send_msg_id runtcl-2 error "sourcing script {C:/Users/Jorge/Desktop/Ingenieria Teleco/DSED/Lab4/lab3_prehook.tcl} failed"
    return -code error
  }
  set_property XPM_LIBRARIES XPM_CDC [current_project]
  catch { write_mem_info -force controlador.mmi }
  write_bitstream -force controlador.bit 
  catch {write_debug_probes -no_partial_ltxfile -quiet -force debug_nets}
  catch {file copy -force debug_nets.ltx controlador.ltx}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
  unset ACTIVE_STEP 
}

