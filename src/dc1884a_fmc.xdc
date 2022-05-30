####################################################################################################################
#                                                   Frame                                                          #
####################################################################################################################
### FMC 1 HPC ###
# FRB-/FRB+: Frame Start Outputs for Channels 2, 3, 6 and 7.
set_property -dict { PACKAGE_PIN "K39"  IOSTANDARD LVDS } [ get_ports {Frame_P[0]} ]                               ;
set_property -dict { PACKAGE_PIN "K40"  IOSTANDARD LVDS } [ get_ports {Frame_N[0]} ]                               ;
# FRA-/FRA+: Frame Start Outputs for Channels 1, 4, 5 and 8.
set_property -dict { PACKAGE_PIN "M32"  IOSTANDARD LVDS } [ get_ports {Frame_P[1]} ]                               ;
set_property -dict { PACKAGE_PIN "L32"  IOSTANDARD LVDS } [ get_ports {Frame_N[1]} ]                               ;

### FMC 2 HPC ###
# FRB-/FRB+: Frame Start Outputs for Channels 2, 3, 6 and 7.
set_property -dict { PACKAGE_PIN "AD40" IOSTANDARD LVDS } [ get_ports {Frame_P[2]} ]                               ;
set_property -dict { PACKAGE_PIN "AD41" IOSTANDARD LVDS } [ get_ports {Frame_N[2]} ]                               ;
# FRA-/FRA+: Frame Start Outputs for Channels 1, 4, 5 and 8.
set_property -dict { PACKAGE_PIN "U36"  IOSTANDARD LVDS } [ get_ports {Frame_P[3]} ]                               ;
set_property -dict { PACKAGE_PIN "T37"  IOSTANDARD LVDS } [ get_ports {Frame_N[3]} ]                               ;


####################################################################################################################
#                                                 Data clock                                                       #
####################################################################################################################
### FMC 1 HPC ###
# DCOA-/DCOA+: Data Clock Outputs for Channles 1, 4, 5 and 8.
set_property -dict { PACKAGE_PIN "J40"  IOSTANDARD LVDS } [ get_ports {Data_Clock_P[0]} ]                          ;
set_property -dict { PACKAGE_PIN "J41"  IOSTANDARD LVDS } [ get_ports {Data_Clock_N[0]} ]                          ;
# DCOB-/DCOB+: Data Clock Outputs for Channles 2, 3, 6 and 7.
set_property -dict { PACKAGE_PIN "L31"  IOSTANDARD LVDS } [ get_ports {Data_Clock_P[1]} ]                          ;
set_property -dict { PACKAGE_PIN "K32"  IOSTANDARD LVDS } [ get_ports {Data_Clock_N[1]} ]                          ;

### FMC 2 HPC ###
# DCOA-/DCOA+: Data Clock Outputs for Channles 1, 4, 5 and 8.
set_property -dict { PACKAGE_PIN "AF41" IOSTANDARD LVDS } [ get_ports {Data_Clock_P[2]} ]                          ;
set_property -dict { PACKAGE_PIN "AG41" IOSTANDARD LVDS } [ get_ports {Data_Clock_N[2]} ]                          ;
# DCOB-/DCOB+: Data Clock Outputs for Channles 2, 3, 6 and 7.
set_property -dict { PACKAGE_PIN "U37"  IOSTANDARD LVDS } [ get_ports {Data_Clock_P[3]} ]                          ;
set_property -dict { PACKAGE_PIN "U38"  IOSTANDARD LVDS } [ get_ports {Data_Clock_N[3]} ]                          ;


####################################################################################################################
#                                             Serial data outputs                                                  #
####################################################################################################################
### FMC 1 HPC ###
# OUT2A-/OUT2A+: Serial Data Outputs for Channel 2. In 1-lane output mode only OUT2A-/OUT2A+ are used.
set_property -dict { PACKAGE_PIN "H40"  IOSTANDARD LVDS } [ get_ports {Data_Input_P[0]}  ]                         ;
set_property -dict { PACKAGE_PIN "H41"  IOSTANDARD LVDS } [ get_ports {Data_Input_N[0]}  ]                         ;
# OUT2B-/OUT2B+: Serial Data Outputs for Channel 2. In 1-lane output mode only OUT2A-/OUT2A+ are used.
set_property -dict { PACKAGE_PIN "G41"  IOSTANDARD LVDS } [ get_ports {Data_Input_P[1]}  ]                         ;
set_property -dict { PACKAGE_PIN "G42"  IOSTANDARD LVDS } [ get_ports {Data_Input_N[1]}  ]                         ;

# OUT3A-/OUT3A+: Serial Data Outputs for Channel 3. In 1-lane output mode only OUT3A-/OUT3A+ are used.
set_property -dict { PACKAGE_PIN "F40"  IOSTANDARD LVDS } [ get_ports {Data_Input_P[2]}  ]                         ;
set_property -dict { PACKAGE_PIN "F41"  IOSTANDARD LVDS } [ get_ports {Data_Input_N[2]}  ]                         ;
# OUT3B-/OUT3B+: Serial Data Outputs for Channel 3. In 1-lane output mode only OUT3A-/OUT3A+ are used.
set_property -dict { PACKAGE_PIN "M36"  IOSTANDARD LVDS } [ get_ports {Data_Input_P[3]}  ]                         ;
set_property -dict { PACKAGE_PIN "L37"  IOSTANDARD LVDS } [ get_ports {Data_Input_N[3]}  ]                         ;

# OUT6A-/OUT6A+: Serial Data Outputs for Channel 6. In 1-lane output mode only OUT6A-/OUT6A+ are used.
set_property -dict { PACKAGE_PIN "N28"  IOSTANDARD LVDS } [ get_ports {Data_Input_P[4]}  ]                         ;
set_property -dict { PACKAGE_PIN "N29"  IOSTANDARD LVDS } [ get_ports {Data_Input_N[4]}  ]                         ;
# OUT6B-/OUT6B+: Serial Data Outputs for Channel 6. In 1-lane output mode only OUT6A-/OUT6A+ are used.
set_property -dict { PACKAGE_PIN "R30"  IOSTANDARD LVDS } [ get_ports {Data_Input_P[5]}  ]                         ;
set_property -dict { PACKAGE_PIN "P31"  IOSTANDARD LVDS } [ get_ports {Data_Input_N[5]}  ]                         ;

# OUT7A-/OUT7A+: Serial Data Outputs for Channel 7. In 1-lane output mode only OUT7A-/OUT7A+ are used.
set_property -dict { PACKAGE_PIN "L29"  IOSTANDARD LVDS } [ get_ports {Data_Input_P[6]}  ]                         ;
set_property -dict { PACKAGE_PIN "L30"  IOSTANDARD LVDS } [ get_ports {Data_Input_N[6]}  ]                         ;
# OUT7B-/OUT7B+: Serial Data Outputs for Channel 7. In 1-lane output mode only OUT7A-/OUT7A+ are used.
set_property -dict { PACKAGE_PIN "V30"  IOSTANDARD LVDS } [ get_ports {Data_Input_P[7]}  ]                         ;
set_property -dict { PACKAGE_PIN "V31"  IOSTANDARD LVDS } [ get_ports {Data_Input_N[7]}  ]                         ;

# OUT1A-/OUT1A+: Serial Data Outputs for Channel 1. In 1-lane output mode only OUT1A-/OUT1A+ are used.
set_property -dict { PACKAGE_PIN "M42"  IOSTANDARD LVDS } [ get_ports {Data_Input_P[8]}  ]                         ;
set_property -dict { PACKAGE_PIN "L42"  IOSTANDARD LVDS } [ get_ports {Data_Input_N[8]}  ]                         ;
# OUT1B-/OUT1B+: Serial Data Outputs for Channel 1. In 1-lane output mode only OUT1A-/OUT1A+ are used.
set_property -dict { PACKAGE_PIN "M37"  IOSTANDARD LVDS } [ get_ports {Data_Input_P[9]}  ]                         ;
set_property -dict { PACKAGE_PIN "M38"  IOSTANDARD LVDS } [ get_ports {Data_Input_N[9]}  ]                         ;

# OUT4A-/OUT4A+: Serial Data Outputs for Channel 4. In 1-lane output mode only OUT4A-/OUT4A+ are used.
set_property -dict { PACKAGE_PIN "R40"  IOSTANDARD LVDS } [ get_ports {Data_Input_P[10]} ]                         ;
set_property -dict { PACKAGE_PIN "P40"  IOSTANDARD LVDS } [ get_ports {Data_Input_N[10]} ]                         ;
# OUT4B-/OUT4B+: Serial Data Outputs for Channel 4. In 1-lane output mode only OUT4A-/OUT4A+ are used.
set_property -dict { PACKAGE_PIN "K37"  IOSTANDARD LVDS } [ get_ports {Data_Input_P[11]} ]                         ;
set_property -dict { PACKAGE_PIN "K38"  IOSTANDARD LVDS } [ get_ports {Data_Input_N[11]} ]                         ;

# OUT5A-/OUT5A+: Serial Data Outputs for Channel 5. In 1-lane output mode only OUT5A-/OUT5A+ are used.
set_property -dict { PACKAGE_PIN "R28"  IOSTANDARD LVDS } [ get_ports {Data_Input_P[12]} ]                         ;
set_property -dict { PACKAGE_PIN "P28"  IOSTANDARD LVDS } [ get_ports {Data_Input_N[12]} ]                         ;
# OUT5B-/OUT5B+: Serial Data Outputs for Channel 5. In 1-lane output mode only OUT5A-/OUT5A+ are used.
set_property -dict { PACKAGE_PIN "K29"  IOSTANDARD LVDS } [ get_ports {Data_Input_P[13]} ]                         ;
set_property -dict { PACKAGE_PIN "K30"  IOSTANDARD LVDS } [ get_ports {Data_Input_N[13]} ]                         ;

# OUT8A-/OUT8A+: Serial Data Outputs for Channel 8. In 1-lane output mode only OUT8A-/OUT8A+ are used.
set_property -dict { PACKAGE_PIN "T29"  IOSTANDARD LVDS } [ get_ports {Data_Input_P[14]} ]                         ;
set_property -dict { PACKAGE_PIN "T30"  IOSTANDARD LVDS } [ get_ports {Data_Input_N[14]} ]                         ;
# OUT8B-/OUT8B+: Serial Data Outputs for Channel 8. In 1-lane output mode only OUT8A-/OUT8A+ are used.
set_property -dict { PACKAGE_PIN "M28"  IOSTANDARD LVDS } [ get_ports {Data_Input_P[15]} ]                         ;
set_property -dict { PACKAGE_PIN "M29"  IOSTANDARD LVDS } [ get_ports {Data_Input_N[15]} ]                         ;

### FMC 2 HPC ###
# OUT2A-/OUT2A+: Serial Data Outputs for Channel 2. In 1-lane output mode only OUT2A-/OUT2A+ are used.
set_property -dict { PACKAGE_PIN "AL41" IOSTANDARD LVDS } [ get_ports {Data_Input_P[16]} ]                         ;
set_property -dict { PACKAGE_PIN "AL42" IOSTANDARD LVDS } [ get_ports {Data_Input_N[16]} ]                         ;
# OUT2B-/OUT2B+: Serial Data Outputs for Channel 2. In 1-lane output mode only OUT2A-/OUT2A+ are used.
set_property -dict { PACKAGE_PIN "AC40" IOSTANDARD LVDS } [ get_ports {Data_Input_P[17]} ]                         ;
set_property -dict { PACKAGE_PIN "AC41" IOSTANDARD LVDS } [ get_ports {Data_Input_N[17]} ]                         ;

# OUT3A-/OUT3A+: Serial Data Outputs for Channel 3. In 1-lane output mode only OUT3A-/OUT3A+ are used.
set_property -dict { PACKAGE_PIN "Y42"  IOSTANDARD LVDS } [ get_ports {Data_Input_P[18]} ]                         ;
set_property -dict { PACKAGE_PIN "AA42" IOSTANDARD LVDS } [ get_ports {Data_Input_N[18]} ]                         ;
# OUT3B-/OUT3B+: Serial Data Outputs for Channel 3. In 1-lane output mode only OUT3A-/OUT3A+ are used.
set_property -dict { PACKAGE_PIN "AC38" IOSTANDARD LVDS } [ get_ports {Data_Input_P[19]} ]                         ;
set_property -dict { PACKAGE_PIN "AC39" IOSTANDARD LVDS } [ get_ports {Data_Input_N[19]} ]                         ;

# OUT6A-/OUT6A+: Serial Data Outputs for Channel 6. In 1-lane output mode only OUT6A-/OUT6A+ are used.
set_property -dict { PACKAGE_PIN "P35"  IOSTANDARD LVDS } [ get_ports {Data_Input_P[20]} ]                         ;
set_property -dict { PACKAGE_PIN "P36"  IOSTANDARD LVDS } [ get_ports {Data_Input_N[20]} ]                         ;
# OUT6B-/OUT6B+: Serial Data Outputs for Channel 6. In 1-lane output mode only OUT6A-/OUT6A+ are used.
set_property -dict { PACKAGE_PIN "U34"  IOSTANDARD LVDS } [ get_ports {Data_Input_P[21]} ]                         ;
set_property -dict { PACKAGE_PIN "T35"  IOSTANDARD LVDS } [ get_ports {Data_Input_N[21]} ]                         ;

# OUT7A-/OUT7A+: Serial Data Outputs for Channel 7. In 1-lane output mode only OUT7A-/OUT7A+ are used.
set_property -dict { PACKAGE_PIN "V35"  IOSTANDARD LVDS } [ get_ports {Data_Input_P[22]} ]                         ;
set_property -dict { PACKAGE_PIN "V36"  IOSTANDARD LVDS } [ get_ports {Data_Input_N[22]} ]                         ;
# OUT7B-/OUT7B+: Serial Data Outputs for Channel 7. In 1-lane output mode only OUT7A-/OUT7A+ are used.
set_property -dict { PACKAGE_PIN "T32"  IOSTANDARD LVDS } [ get_ports {Data_Input_P[23]} ]                         ;
set_property -dict { PACKAGE_PIN "R32"  IOSTANDARD LVDS } [ get_ports {Data_Input_N[23]} ]                         ;

# OUT1A-/OUT1A+: Serial Data Outputs for Channel 1. In 1-lane output mode only OUT1A-/OUT1A+ are used.
set_property -dict { PACKAGE_PIN "AJ42" IOSTANDARD LVDS } [ get_ports {Data_Input_P[24]} ]                         ;
set_property -dict { PACKAGE_PIN "AK42" IOSTANDARD LVDS } [ get_ports {Data_Input_N[24]} ]                         ;
# OUT1B-/OUT1B+: Serial Data Outputs for Channel 1. In 1-lane output mode only OUT1A-/OUT1A+ are used.
set_property -dict { PACKAGE_PIN "AD42" IOSTANDARD LVDS } [ get_ports {Data_Input_P[25]} ]                         ;
set_property -dict { PACKAGE_PIN "AE42" IOSTANDARD LVDS } [ get_ports {Data_Input_N[25]} ]                         ;

# OUT4A-/OUT4A+: Serial Data Outputs for Channel 4. In 1-lane output mode only OUT4A-/OUT4A+ are used.
set_property -dict { PACKAGE_PIN "Y39"  IOSTANDARD LVDS } [ get_ports {Data_Input_P[26]} ]                         ;
set_property -dict { PACKAGE_PIN "AA39" IOSTANDARD LVDS } [ get_ports {Data_Input_N[26]} ]                         ;
# OUT4B-/OUT4B+: Serial Data Outputs for Channel 4. In 1-lane output mode only OUT4A-/OUT4A+ are used.
set_property -dict { PACKAGE_PIN "AJ40" IOSTANDARD LVDS } [ get_ports {Data_Input_P[27]} ]                         ;
set_property -dict { PACKAGE_PIN "AJ41" IOSTANDARD LVDS } [ get_ports {Data_Input_N[27]} ]                         ;

# OUT5A-/OUT5A+: Serial Data Outputs for Channel 5. In 1-lane output mode only OUT5A-/OUT5A+ are used.
set_property -dict { PACKAGE_PIN "W32"  IOSTANDARD LVDS } [ get_ports {Data_Input_P[28]} ]                         ;
set_property -dict { PACKAGE_PIN "W33"  IOSTANDARD LVDS } [ get_ports {Data_Input_N[28]} ]                         ;
# OUT5B-/OUT5B+: Serial Data Outputs for Channel 5. In 1-lane output mode only OUT5A-/OUT5A+ are used.
set_property -dict { PACKAGE_PIN "R33"  IOSTANDARD LVDS } [ get_ports {Data_Input_P[29]} ]                         ;
set_property -dict { PACKAGE_PIN "R34"  IOSTANDARD LVDS } [ get_ports {Data_Input_N[29]} ]                         ;

# OUT8A-/OUT8A+: Serial Data Outputs for Channel 8. In 1-lane output mode only OUT8A-/OUT8A+ are used.
set_property -dict { PACKAGE_PIN "W36"  IOSTANDARD LVDS } [ get_ports {Data_Input_P[30]} ]                         ;
set_property -dict { PACKAGE_PIN "W37"  IOSTANDARD LVDS } [ get_ports {Data_Input_N[30]} ]                         ;
# OUT8B-/OUT8B+: Serial Data Outputs for Channel 8. In 1-lane output mode only OUT8A-/OUT8A+ are used.
set_property -dict { PACKAGE_PIN "V39"  IOSTANDARD LVDS } [ get_ports {Data_Input_P[31]} ]                         ;
set_property -dict { PACKAGE_PIN "V40"  IOSTANDARD LVDS } [ get_ports {Data_Input_N[31]} ]                         ;


####################################################################################################################
#                                             Serial programming                                                   #
####################################################################################################################
### FMC 1 HPC ###
# CSA: In serial programming mode, CSA is the serial interface chip select input for registers
#      controlling channels 1, 4, 5 and 8.
set_property -dict { PACKAGE_PIN "M39"  IOSTANDARD LVDS } [ get_ports ADC_Chip_Select_A_1 ]                        ;
# CSB: In serial programming mode, CSB is the serial interface chip select input for registers
#      controlling channels 2, 3, 6 and 7.
set_property -dict { PACKAGE_PIN "N39"  IOSTANDARD LVDS } [ get_ports ADC_Chip_Select_B_1 ]                        ;

# SCK: In serial programming mode, SCK is the serial interface clock input.
set_property -dict { PACKAGE_PIN "H31"  IOSTANDARD LVDS } [ get_ports ADC_Interface_Clock_1 ]                      ;
# SDI: In serial programming mode, SDI is the serial interface data input.

# SDOA: In serial programming mode, SDOA is the optional serial interface data output for registers
#       controlling channels 1, 4, 5 and 8.
set_property -dict { PACKAGE_PIN "N40"  IOSTANDARD LVDS } [ get_ports ADC_Program_Input_A_1 ]                      ;
# SDOB: In serial programming mode, SDOB is the optional serial interface data output for registers
#       controlling channels 2, 3, 6 and 7.
set_property -dict { PACKAGE_PIN "N38"  IOSTANDARD LVDS } [ get_ports ADC_Program_Input_B_1 ]                      ;

### FMC 2 HPC ###
# CSA: In serial programming mode, CSA is the serial interface chip select input for registers
#      controlling channels 1, 4, 5 and 8.
set_property -dict { PACKAGE_PIN "AB42" IOSTANDARD LVDS } [ get_ports ADC_Chip_Select_A_2 ]                        ;
# CSB: In serial programming mode, CSB is the serial interface chip select input for registers
#      controlling channels 2, 3, 6 and 7.
set_property -dict { PACKAGE_PIN "AB38" IOSTANDARD LVDS } [ get_ports ADC_Chip_Select_B_2 ]                        ;

# SCK: In serial programming mode, SCK is the serial interface clock input.
set_property -dict { PACKAGE_PIN "P33"  IOSTANDARD LVDS } [ get_ports ADC_Interface_Clock_2 ]                      ;
# SDI: In serial programming mode, SDI is the serial interface data input.

# SDOA: In serial programming mode, SDOA is the optional serial interface data output for registers
#       controlling channels 1, 4, 5 and 8.
set_property -dict { PACKAGE_PIN "AB39" IOSTANDARD LVDS } [ get_ports ADC_Program_Input_A_2 ]                      ;
# SDOB: In serial programming mode, SDOB is the optional serial interface data output for registers
#       controlling channels 2, 3, 6 and 7.
set_property -dict { PACKAGE_PIN "AB41" IOSTANDARD LVDS } [ get_ports ADC_Program_Input_B_2 ]                      ;