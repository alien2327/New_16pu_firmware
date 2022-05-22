####################################################################################################################
#                                             SYSTEM CONTROL                                                       #
####################################################################################################################
set_property -dict { PACKAGE_PIN "E19"   IOSTANDARD LVDS     } [ get_ports {SystemClockP} ]                        ;
set_property -dict { PACKAGE_PIN "E18"   IOSTANDARD LVDS     } [ get_ports {SystemClockN} ]                        ;

create_clock -period 5.000 -name SystemClockP -waveform {0.000 2.500} [get_ports SystemClockP]                     ;

####################################################################################################################
#                                                LED PIN                                                           #
####################################################################################################################
set_property -dict { PACKAGE_PIN "AM39"  IOSTANDARD LVCMOS18 } [ get_ports {UserLED[0]} ]                          ;
set_property -dict { PACKAGE_PIN "AN39"  IOSTANDARD LVCMOS18 } [ get_ports {UserLED[1]} ]                          ;
set_property -dict { PACKAGE_PIN "AR37"  IOSTANDARD LVCMOS18 } [ get_ports {UserLED[2]} ]                          ;
set_property -dict { PACKAGE_PIN "AT37"  IOSTANDARD LVCMOS18 } [ get_ports {UserLED[3]} ]                          ;
set_property -dict { PACKAGE_PIN "AR35"  IOSTANDARD LVCMOS18 } [ get_ports {UserLED[4]} ]                          ;
set_property -dict { PACKAGE_PIN "AP41"  IOSTANDARD LVCMOS18 } [ get_ports {UserLED[5]} ]                          ;
set_property -dict { PACKAGE_PIN "AP42"  IOSTANDARD LVCMOS18 } [ get_ports {UserLED[6]} ]                          ;
set_property -dict { PACKAGE_PIN "AU39"  IOSTANDARD LVCMOS18 } [ get_ports {UserLED[7]} ]                          ;

####################################################################################################################
#                                                 SWITCH                                                           #
####################################################################################################################
set_property -dict { PACKAGE_PIN "AR40"  IOSTANDARD LVCMOS18 } [ get_ports {Switch[0]} ]                           ; # Directional Pushbutton Switches GPIO_SW_N
set_property -dict { PACKAGE_PIN "AU38"  IOSTANDARD LVCMOS18 } [ get_ports {Switch[1]} ]                           ; # Directional Pushbutton Switches GPIO_SW_E
set_property -dict { PACKAGE_PIN "AP40"  IOSTANDARD LVCMOS18 } [ get_ports {Switch[2]} ]                           ; # Directional Pushbutton Switches GPIO_SW_S
set_property -dict { PACKAGE_PIN "AW40"  IOSTANDARD LVCMOS18 } [ get_ports {Switch[3]} ]                           ; # Directional Pushbutton Switches GPIO_SW_W
set_property -dict { PACKAGE_PIN "AV39"  IOSTANDARD LVCMOS18 } [ get_ports {Switch[4]} ]                           ; # Directional Pushbutton Switches GPIO_SW_C

####################################################################################################################
#                                              DIP SWITCH                                                          #
####################################################################################################################
set_property -dict { PACKAGE_PIN "AV30"  IOSTANDARD LVCMOS18 } [ get_ports {DIP[0]} ]                              ;
set_property -dict { PACKAGE_PIN "AY33"  IOSTANDARD LVCMOS18 } [ get_ports {DIP[1]} ]                              ;
set_property -dict { PACKAGE_PIN "BA31"  IOSTANDARD LVCMOS18 } [ get_ports {DIP[2]} ]                              ;
set_property -dict { PACKAGE_PIN "BA32"  IOSTANDARD LVCMOS18 } [ get_ports {DIP[3]} ]                              ;
set_property -dict { PACKAGE_PIN "AW30"  IOSTANDARD LVCMOS18 } [ get_ports {DIP[4]} ]                              ;
set_property -dict { PACKAGE_PIN "AY30"  IOSTANDARD LVCMOS18 } [ get_ports {DIP[5]} ]                              ;
set_property -dict { PACKAGE_PIN "BA30"  IOSTANDARD LVCMOS18 } [ get_ports {DIP[6]} ]                              ;
set_property -dict { PACKAGE_PIN "BB31"  IOSTANDARD LVCMOS18 } [ get_ports {DIP[7]} ]                              ;

####################################################################################################################
#                                             Gigabit Ethernet                                                     #
####################################################################################################################
set_property -dict { PACKAGE_PIN "AH8" } [ get_ports {SGMIIClockP} ]                                               ;
set_property -dict { PACKAGE_PIN "AH7" } [ get_ports {SGMIIClockN} ]                                               ;
set_property -dict { PACKAGE_PIN "AM7" } [ get_ports {SGMIIRecieverN} ]                                            ;
set_property -dict { PACKAGE_PIN "AM8" } [ get_ports {SGMIIRecieverP} ]                                            ;
set_property -dict { PACKAGE_PIN "AN1" } [ get_ports {SGMIITransmitterN} ]                                         ;
set_property -dict { PACKAGE_PIN "AN2" } [ get_ports {SGMIITransmitterP} ]                                         ;
set_property -dict { PACKAGE_PIN "AJ33" IOSTANDARD LVCMOS18 } [ get_ports {PHYReset} ]                             ;
set_property -dict { PACKAGE_PIN "AH31" IOSTANDARD LVCMOS18 } [ get_ports {GMIIMDC} ]                              ;
set_property -dict { PACKAGE_PIN "AK33" IOSTANDARD LVCMOS18 } [ get_ports {GMIIMDIOInputOuput} ]                   ;

create_clock -period 8.000 -name SGMIIClockP -waveform {0.000 4.000} [get_ports SGMIIClockP]                       ;
set_max_delay 20 -datapath_only -from [get_clocks {SystemClockP}] -to [get_ports {UserLED*}]                       ;
set_max_delay 20 -datapath_only -from [get_clocks {SystemClockP}] -to [get_ports {PHYReset}]                       ;

####################################################################################################################
#                                            ADC CLOCK CONTROL                                                     #
####################################################################################################################
set_property -dict { PACKAGE_PIN "AJ32"  IOSTANDARD LVCMOS18 } [ get_ports {ClockMultiplied64}        ]            ;  # User SMA USER_SMA_CLOCK_P
set_property -dict { PACKAGE_PIN "AP31"  IOSTANDARD LVCMOS18 } [ get_ports {ClockMultiplied52}        ]            ;  # User SMA USER_SMA_GPIO_N

create_clock -period 9.084 -name ClockMultiplied64 -waveform {0.000 4.542} [get_ports ClockMultiplied64]           ;

####################################################################################################################
#                                               ADC CONTROL                                                        #
####################################################################################################################
set_property -dict { PACKAGE_PIN "K39"   IOSTANDARD LVDS } [ get_ports {FrameClockP[0]} ]                          ;
set_property -dict { PACKAGE_PIN "M32"   IOSTANDARD LVDS } [ get_ports {FrameClockP[1]} ]                          ;
set_property -dict { PACKAGE_PIN "AD40"  IOSTANDARD LVDS } [ get_ports {FrameClockP[2]} ]                          ;
set_property -dict { PACKAGE_PIN "U36"   IOSTANDARD LVDS } [ get_ports {FrameClockP[3]} ]                          ;

create_clock -period 9.080 -name FrameClockP -add [get_ports FrameClockP]                                          ;
set_false_path -from [get_ports FrameClockP] -to [get_pins -hier -filter {name =~ *iserdes_c*/DDLY}]               ;

set_property -dict { PACKAGE_PIN "K40"   IOSTANDARD LVDS } [ get_ports {FrameClockN[0]} ]                          ;
set_property -dict { PACKAGE_PIN "L32"   IOSTANDARD LVDS } [ get_ports {FrameClockN[1]} ]                          ;
set_property -dict { PACKAGE_PIN "AD41"  IOSTANDARD LVDS } [ get_ports {FrameClockN[2]} ]                          ;
set_property -dict { PACKAGE_PIN "T37"   IOSTANDARD LVDS } [ get_ports {FrameClockN[3]} ]                          ;

set_property -dict { PACKAGE_PIN "H40"  IOSTANDARD LVDS } [ get_ports {DataInputP[0]}  ]                           ;
set_property -dict { PACKAGE_PIN "G41"  IOSTANDARD LVDS } [ get_ports {DataInputP[1]}  ]                           ;
set_property -dict { PACKAGE_PIN "F40"  IOSTANDARD LVDS } [ get_ports {DataInputP[2]}  ]                           ;
set_property -dict { PACKAGE_PIN "M36"  IOSTANDARD LVDS } [ get_ports {DataInputP[3]}  ]                           ;
set_property -dict { PACKAGE_PIN "N28"  IOSTANDARD LVDS } [ get_ports {DataInputP[4]}  ]                           ;
set_property -dict { PACKAGE_PIN "R30"  IOSTANDARD LVDS } [ get_ports {DataInputP[5]}  ]                           ;
set_property -dict { PACKAGE_PIN "L29"  IOSTANDARD LVDS } [ get_ports {DataInputP[6]}  ]                           ;
set_property -dict { PACKAGE_PIN "V30"  IOSTANDARD LVDS } [ get_ports {DataInputP[7]}  ]                           ;
set_property -dict { PACKAGE_PIN "M42"  IOSTANDARD LVDS } [ get_ports {DataInputP[8]}  ]                           ;
set_property -dict { PACKAGE_PIN "M37"  IOSTANDARD LVDS } [ get_ports {DataInputP[9]}  ]                           ;
set_property -dict { PACKAGE_PIN "R40"  IOSTANDARD LVDS } [ get_ports {DataInputP[10]} ]                           ;
set_property -dict { PACKAGE_PIN "K37"  IOSTANDARD LVDS } [ get_ports {DataInputP[11]} ]                           ;
set_property -dict { PACKAGE_PIN "R28"  IOSTANDARD LVDS } [ get_ports {DataInputP[12]} ]                           ;
set_property -dict { PACKAGE_PIN "K29"  IOSTANDARD LVDS } [ get_ports {DataInputP[13]} ]                           ;
set_property -dict { PACKAGE_PIN "T29"  IOSTANDARD LVDS } [ get_ports {DataInputP[14]} ]                           ;
set_property -dict { PACKAGE_PIN "M28"  IOSTANDARD LVDS } [ get_ports {DataInputP[15]} ]                           ;
set_property -dict { PACKAGE_PIN "AL41" IOSTANDARD LVDS } [ get_ports {DataInputP[16]} ]                           ;
set_property -dict { PACKAGE_PIN "AC40" IOSTANDARD LVDS } [ get_ports {DataInputP[17]} ]                           ;
set_property -dict { PACKAGE_PIN "Y42"  IOSTANDARD LVDS } [ get_ports {DataInputP[18]} ]                           ;
set_property -dict { PACKAGE_PIN "AC38" IOSTANDARD LVDS } [ get_ports {DataInputP[19]} ]                           ;
set_property -dict { PACKAGE_PIN "P35"  IOSTANDARD LVDS } [ get_ports {DataInputP[20]} ]                           ;
set_property -dict { PACKAGE_PIN "U34"  IOSTANDARD LVDS } [ get_ports {DataInputP[21]} ]                           ;
set_property -dict { PACKAGE_PIN "V35"  IOSTANDARD LVDS } [ get_ports {DataInputP[22]} ]                           ;
set_property -dict { PACKAGE_PIN "T32"  IOSTANDARD LVDS } [ get_ports {DataInputP[23]} ]                           ;
set_property -dict { PACKAGE_PIN "AJ42" IOSTANDARD LVDS } [ get_ports {DataInputP[24]} ]                           ;
set_property -dict { PACKAGE_PIN "AD42" IOSTANDARD LVDS } [ get_ports {DataInputP[25]} ]                           ;
set_property -dict { PACKAGE_PIN "Y39"  IOSTANDARD LVDS } [ get_ports {DataInputP[26]} ]                           ;
set_property -dict { PACKAGE_PIN "AJ40" IOSTANDARD LVDS } [ get_ports {DataInputP[27]} ]                           ;
set_property -dict { PACKAGE_PIN "W32"  IOSTANDARD LVDS } [ get_ports {DataInputP[28]} ]                           ;
set_property -dict { PACKAGE_PIN "R33"  IOSTANDARD LVDS } [ get_ports {DataInputP[29]} ]                           ;
set_property -dict { PACKAGE_PIN "W36"  IOSTANDARD LVDS } [ get_ports {DataInputP[30]} ]                           ;
set_property -dict { PACKAGE_PIN "V39"  IOSTANDARD LVDS } [ get_ports {DataInputP[31]} ]                           ;

set_property -dict { PACKAGE_PIN "H41"  IOSTANDARD LVDS } [ get_ports {DataInputN[0]}  ]                           ;
set_property -dict { PACKAGE_PIN "G42"  IOSTANDARD LVDS } [ get_ports {DataInputN[1]}  ]                           ;
set_property -dict { PACKAGE_PIN "F41"  IOSTANDARD LVDS } [ get_ports {DataInputN[2]}  ]                           ;
set_property -dict { PACKAGE_PIN "L37"  IOSTANDARD LVDS } [ get_ports {DataInputN[3]}  ]                           ;
set_property -dict { PACKAGE_PIN "N29"  IOSTANDARD LVDS } [ get_ports {DataInputN[4]}  ]                           ;
set_property -dict { PACKAGE_PIN "P31"  IOSTANDARD LVDS } [ get_ports {DataInputN[5]}  ]                           ;
set_property -dict { PACKAGE_PIN "L30"  IOSTANDARD LVDS } [ get_ports {DataInputN[6]}  ]                           ;
set_property -dict { PACKAGE_PIN "V31"  IOSTANDARD LVDS } [ get_ports {DataInputN[7]}  ]                           ;
set_property -dict { PACKAGE_PIN "L42"  IOSTANDARD LVDS } [ get_ports {DataInputN[8]}  ]                           ;
set_property -dict { PACKAGE_PIN "M38"  IOSTANDARD LVDS } [ get_ports {DataInputN[9]}  ]                           ;
set_property -dict { PACKAGE_PIN "P40"  IOSTANDARD LVDS } [ get_ports {DataInputN[10]} ]                           ;
set_property -dict { PACKAGE_PIN "K38"  IOSTANDARD LVDS } [ get_ports {DataInputN[11]} ]                           ;
set_property -dict { PACKAGE_PIN "P28"  IOSTANDARD LVDS } [ get_ports {DataInputN[12]} ]                           ;
set_property -dict { PACKAGE_PIN "K30"  IOSTANDARD LVDS } [ get_ports {DataInputN[13]} ]                           ;
set_property -dict { PACKAGE_PIN "T30"  IOSTANDARD LVDS } [ get_ports {DataInputN[14]} ]                           ;
set_property -dict { PACKAGE_PIN "M29"  IOSTANDARD LVDS } [ get_ports {DataInputN[15]} ]                           ;
set_property -dict { PACKAGE_PIN "AL42" IOSTANDARD LVDS } [ get_ports {DataInputN[16]} ]                           ;
set_property -dict { PACKAGE_PIN "AC41" IOSTANDARD LVDS } [ get_ports {DataInputN[17]} ]                           ;
set_property -dict { PACKAGE_PIN "AA42" IOSTANDARD LVDS } [ get_ports {DataInputN[18]} ]                           ;
set_property -dict { PACKAGE_PIN "AC39" IOSTANDARD LVDS } [ get_ports {DataInputN[19]} ]                           ;
set_property -dict { PACKAGE_PIN "P36"  IOSTANDARD LVDS } [ get_ports {DataInputN[20]} ]                           ;
set_property -dict { PACKAGE_PIN "T35"  IOSTANDARD LVDS } [ get_ports {DataInputN[21]} ]                           ;
set_property -dict { PACKAGE_PIN "V36"  IOSTANDARD LVDS } [ get_ports {DataInputN[22]} ]                           ;
set_property -dict { PACKAGE_PIN "R32"  IOSTANDARD LVDS } [ get_ports {DataInputN[23]} ]                           ;
set_property -dict { PACKAGE_PIN "AK42" IOSTANDARD LVDS } [ get_ports {DataInputN[24]} ]                           ;
set_property -dict { PACKAGE_PIN "AE42" IOSTANDARD LVDS } [ get_ports {DataInputN[25]} ]                           ;
set_property -dict { PACKAGE_PIN "AA39" IOSTANDARD LVDS } [ get_ports {DataInputN[26]} ]                           ;
set_property -dict { PACKAGE_PIN "AJ41" IOSTANDARD LVDS } [ get_ports {DataInputN[27]} ]                           ;
set_property -dict { PACKAGE_PIN "W33"  IOSTANDARD LVDS } [ get_ports {DataInputN[28]} ]                           ;
set_property -dict { PACKAGE_PIN "R34"  IOSTANDARD LVDS } [ get_ports {DataInputN[29]} ]                           ;
set_property -dict { PACKAGE_PIN "W37"  IOSTANDARD LVDS } [ get_ports {DataInputN[30]} ]                           ;
set_property -dict { PACKAGE_PIN "V40"  IOSTANDARD LVDS } [ get_ports {DataInputN[31]} ]                           ;