########################################################################################
# Initialization file for P10xx-P20xxRDB board with P2020 CPU
# Clock Configuration:
#       CPU:1200 MHz, CCB: 600 MHz,
#       DDR: 666 MHz, SYSCLK:  50 MHz
########################################################################################

variable CCSRBAR 0xFF700000

proc CCSR {reg_off} {
	global CCSRBAR
	
	return p:0x[format %x [expr {$CCSRBAR + $reg_off}]]
}

proc init_board {} {

	global CCSRBAR

	##################################################################################
	#	
	#	Memory Windows
	#
	#	0xFF000000	0xFFFFFFFF	LAW0	Local Bus NOR FLASH - 16M
	#   0xA0000000  0xBFFFFFFF  LAW1    PEX1 - 512M
	#   0xEFC20000  0xEFC2FFFF  LAW2    PEX1 - 64K
	#   0x80000000  0x9FFFFFFF  LAW3    PEX2 - 512M
	#   0xEFC10000  0xEFC1FFFF  LAW4    PEX2 - 64K
	#   0xF8000000  0xF80FFFFF  LAW5    Local Bus NAND FLASH 1M
	#	0x00000000	0x3FFFFFFF	LAW11	DDRC - 1G
	#
	##################################################################################
	# configure local access windows
	# LAWBAR0 - Local Bus
	# bit 8 - 31 = 0xFF000000 - base addr
	mem [CCSR 0xC08] = 0x000ff000

	# LAWAR0
	# bit 0 = 1 - enable window
	# bit 7-11 = 00100 - Local Bus
	# bit 26 - 31 =  011011 16M - size
	mem [CCSR 0xC10] = 0x80400017

	# LAWBAR1 - PEX1
	# bit 8 - 31 = 0xA0000000 - base addr
	mem [CCSR 0xC28] = 0x000a0000

	# LAWAR1
	# bit 0 = 1 - enable window
	# bit 7-11 = 00010 - PEX1
	# bit 26 - 31 =  011100 512M - size
	mem [CCSR 0xC30] = 0x8020001c

	# LAWBAR2 - PEX 1
	# bit 8 - 31 = 0xEFC200000 - base addr
	mem [CCSR 0xC48] = 0x000efc20

	# LAWAR2
	# bit 0 = 1 - enable window
	# bit 7-11 = 00010 - PEX1
	# bit 26-31 = 001111 64k - size
	mem [CCSR 0xC50] = 0x8020000f

	# LAWBAR3 - PEX2
	# bit 8 - 31 = 0x80000000 - base addr
	mem [CCSR 0xC68] = 0x00080000

	# LAWAR3
	# bit 0 = 1 - enable window
	# bit 7-11 = 00001 - PEX2
	# bit 26 - 31 =  011100 512M - size
	mem [CCSR 0xC70] = 0x8010001c

	# LAWBAR4 - PEX 2
	# bit 8 - 31 = 0xEFC100000 - base addr
	mem [CCSR 0xC88] = 0x000efc10

	# LAWAR4
	# bit 0 = 1 - enable window
	# bit 7-11 = 00001 - PEX1
	# bit 26-31 = 001111 64k - size
	mem [CCSR 0xC90] = 0x8010000f

	# LAWBAR5 - Local Bus
	# bit 8 - 31 = 0xF8000000 - base addr
	mem [CCSR 0xCA8] = 0x000f8000

	# LAWAR5
	# bit 0 = 1 - enable window
	# bit 7-11 = 00100 - Local Bus
	# bit 26-31 = 010011 1M - size
	mem [CCSR 0xCB0] = 0x80400013

	# LAWBAR11 - Local Bus
	# bit 8 - 31 = 0x00000000 - base addr
	mem [CCSR 0xD68] = 0x00000000

	# LAWAR11
	# bit 0 = 1 - enable window
	# bit 7-11 = 01111 - DDR
	# bit 26 - 31 =  011101 1G - size
	mem [CCSR 0xD70] = 0x80F0001d


	#######################################
	#	DDRC INITIALIZATION
	#######################################

	# DDR_SDRAM_CFG
	mem [CCSR 0x2110] = 0x43080000
	 
	# CS0_BNDS
	mem [CCSR 0x2000] = 0x0000003F

	# CS0_CONFIG
	mem [CCSR 0x2080] = 0x80014202

	# TIMING_CFG_0
	mem [CCSR 0x2104] = 0x55770802

	# TIMING_CFG_1
	mem [CCSR 0x2108] = 0x5f599543

	# TIMING_CFG_2
	mem [CCSR 0x210C] = 0x0fa074d1

	# TIMING_CFG_3
	mem [CCSR 0x2100] = 0x00030000

	# DDR_SDRAM_CFG_2
	mem [CCSR 0x2114] = 0x24401000

	# DDR_SDRAM_MODE
	mem [CCSR 0x2118] = 0x00040852 

	# DDR_SDRAM_MODE_2
	mem [CCSR 0x211C] = 0x00000000

	# DDR_SDRAM_MD_CNTL
	mem [CCSR 0x2120] = 0x00000000

	# DDR_SDRAM_INTERVAL
	mem [CCSR 0x2124] = 0x0a280100

	# DDR_DATA_INIT
	mem [CCSR 0x2128] = 0xDEADBEEF

	# DDR_SDRAM_CLK_CNTL
	mem [CCSR 0x2130] = 0x03000000

	# TIMING_CFG_4
	mem [CCSR 0x2160] = 0x00000000

	# TIMING_CFG_5
	mem [CCSR 0x2164] = 0x00000000

	# DDR_ZQ_CNTL
	mem [CCSR 0x2170] = 0x00000000

	# DDR_WRLVL_CNTL
	mem [CCSR 0x2174] = 0x00000000

	# ERR_INT_EN
	mem [CCSR 0x2E48] = 0x00000000

	# ERR_SBE
	mem [CCSR 0x2E58] = 0x00000000

	# DDRCDR_1
	mem [CCSR 0x2B28] = 0x00000000

	# DDRCDR_2
	mem [CCSR 0x2B2C] = 0x00000000

	#delay before enable
	wait 500

	# DDR_SDRAM_CFG
	mem [CCSR 0x2110] = 0xC3000000

	#wait for DRAM data initialization
	wait 500
	
	
	##################################################################################
	# configure Local Bus memory controller 

	# CS0 - Flash 
	# BR0 base address at 0xF8000000, port size 16 bit, GPCM, valid
	mem [CCSR 0x5000] = 0xFF001001 
	# OR0 16MB flash size
	mem [CCSR 0x5004] = 0xFF000FF7 

	# CS1 - NAND Flash
	# BR1 base address at 0xF8000000, port size  8 bit, FCM, valid
	mem [CCSR 0x5008] = 0xF8000C21 
	# OR1 1MB size
	mem [CCSR 0x500C] = 0xFFF80396 

	# NAND Flash settings
	#
	# FMR
	mem [CCSR 0x50E0] = 0x0000F020 
	
	# LBCR
	mem [CCSR 0x50D0] = 0x40000000

	# LCRR
	mem [CCSR 0x50D4] = 0x80000008 
	
	#SPI init
	# SPMODE 
	mem [CCSR 0x7000] = 0x80000403 
	# SPIM - catch all events
	mem [CCSR 0x7008] = 0x0000FB00
	# SPMODE0
	mem [CCSR 0x7020] = 0x2e170008
	

}

proc apply_e500v2_workaround {} {
	# After reset, e500 cores need to run before being able to enter debug mode.
	# Work-around: set a HW BP at reset address and run the core; after the core hits the BP, it enters debug mode
	# e500 cores need to have valid opcode at the interrupt vector

	variable SPR_GROUP "e500 Special Purpose Registers/"	

	#######################################################################
	# Set a breakpoint at the reset address 
	reg ${SPR_GROUP}IAC1 = 0xfffffffc
	reg ${SPR_GROUP}DBCR0 = 0x40800000
	reg ${SPR_GROUP}DBCR1 = 0x00000000

	# Run the core
	config runcontrolsync off
	go
	wait 50   
	config runcontrolsync on
	stop

	# Clear affected registers 	
	reg ${SPR_GROUP}DBSR  = 0x01CF0000
	reg ${SPR_GROUP}DBCR0 = 0x41000000
	reg ${SPR_GROUP}IAC1  = 0x00000000
	reg ${SPR_GROUP}CSRR0 = 0x00000000
	reg ${SPR_GROUP}CSRR1 = 0x00000000	
}

proc P10xx_P20xx_P2020_init_core {} {

	global CCSRBAR

	variable SPR_GROUP "e500 Special Purpose Registers/"
	variable SSP_GROUP "Standard Special Purpose Registers/"
	variable CAM_GROUP "regPPCTLB1/"
	variable GPR_GROUP "General Purpose Registers/"
	variable e500_CM_GROUP "e500 Coherency Module/"
	variable proc_id [expr {[reg ${SPR_GROUP}PIR %d -np]} ]

	if {$proc_id == 0} {
		##################################################################################
		# move CCSR at 0xE0000000

		# CCSRBAR
		# bit 8 - 23 - BASE_ADDR
		mem [CCSR 0x0] = 0x000e0000
		set CCSRBAR 0xe0000000
	
		#######################################################################
		# invalidate BR0
		mem [CCSR 0x5000] = 0x00001000
	
		# ABIST off
		# L2ERRDIS[MBECCDIS]=1 L2ERRDIS[SBECCDIS]=1
		mem [CCSR 0x20E44] = 0x0000000C
	}
	
	# activate debug interrupt and enable SPU
	reg	${SSP_GROUP}MSR = 0x02000200
		
	##################################################################################
	#	
	#	Memory Map
	#
	#   0x00000000  0x3FFFFFFF 	DDR	                1GB
	#   0x80000000  0x9FFFFFFF  PEX2           		512MB
	#   0xA0000000  0xBFFFFFFF  PEX1                512MB
	#	0xE0000000	0xE00FFFFF	CCSRBAR Space	    1M
	#   0xEFC00000  0xEFC3FFFF  PEX I/O 			256k
	#   0xF8000000  0xF80FFFFF  LocalBus NAND FLASH 1M
	#   0xFF000000	0xFFFFFFFF  LocalBus NOR FLASH	16M		
	#
	##################################################################################

	# MMU  initialization
	# define 1MB    TLB1 entry 1: 0xE0000000 - 0xE00FFFFF; for CCSR Space, cache inhibited, guarded
	reg ${CAM_GROUP}L2MMU_CAM1 = 0x500003CAFC080000E0000000E0000001

	# define 16MB   TLB1 entry 2: 0xFF000000 - 0xFFFFFFFF; for Local Bus, cache inhibited, guarded
	reg ${CAM_GROUP}L2MMU_CAM2 = 0x70000FCAFC080000FF000000FF000001

	# define 1GB    TLB1 entry 3: 0x80000000 - 0xBFFFFFFF; for PCI Express 1&2, cache inhibited, guarded
	reg ${CAM_GROUP}L2MMU_CAM3 = 0xA0007FCAFC0800008000000080000001

	# define 256KB  TLB1 entry 6: 0xEFC00000 - 0xEFC3FFFF; for PCI Express I/O, cache inhibited, guarded
	reg ${CAM_GROUP}L2MMU_CAM6 = 0x400001CAFC080000EFC00000EFC00001

	# define 1MB    TLB1 entry 7: 0xF8000000 - 0xF80FFFFF; for NAND, cache inhibited, guarded
	reg ${CAM_GROUP}L2MMU_CAM7 = 0x500003CAFC080000F8000000F8000001

	# define 1GB  TLB1 entry 9: 0x00000000 - 0x3FFFFFFF; DDR
	reg ${CAM_GROUP}L2MMU_CAM9 = 0xA0007FC4FC0800000000000000000001
	

	# init board, only when the init is run for core 0
	if {$proc_id == 0} {
        init_board
    }
    
	##################################################################################
	# Interrupt vectors initialization 
	# interrupt vectors in RAM at 0x00000000 for every core (interrupt vector zone is mapped only by core0 from 0x00000000)
	# IVPR (default reset value) 
	reg ${SPR_GROUP}IVPR = 0x[expr {${proc_id} << 1}]0000000
	
	# interrupt vector offset registers 
	# IVOR0 - critical input
	reg ${SPR_GROUP}IVOR0 = 0x00000100	
	# IVOR1 - machine check
	reg ${SPR_GROUP}IVOR1 = 0x00000200	
	# IVOR2 - data storage
	reg ${SPR_GROUP}IVOR2 = 0x00000300	
	# IVOR3 - instruction storage
	reg ${SPR_GROUP}IVOR3 = 0x00000400	
	# IVOR4 - external input
	reg ${SPR_GROUP}IVOR4 = 0x00000500	
	# IVOR5 - alignment
	reg ${SPR_GROUP}IVOR5 = 0x00000600	
	# IVOR6 - program
	reg ${SPR_GROUP}IVOR6 = 0x00000700
	# IVOR8 - system call
	reg ${SPR_GROUP}IVOR8 = 0x00000c00	
	# IVOR10 - decrementer
	reg ${SPR_GROUP}IVOR10 = 0x00000900	
	# IVOR11 - fixed-interval timer interrupt
	reg ${SPR_GROUP}IVOR11 = 0x00000f00	
	# IVOR12 - watchdog timer interrupt
	reg ${SPR_GROUP}IVOR12 = 0x00000b00	
	# IVOR13 - data TLB errror
	reg ${SPR_GROUP}IVOR13 = 0x00001100	
	# IVOR14 - instruction TLB error
	reg ${SPR_GROUP}IVOR14 = 0x00001000	
	# IVOR15 - debug
	reg ${SPR_GROUP}IVOR15 = 0x00001500	
	# IVOR32 - SPE-APU unavailable
	reg ${SPR_GROUP}IVOR32 = 0x00001600	
	# IVOR33 - SPE-floating point data exception
	reg ${SPR_GROUP}IVOR33 = 0x00001700
	# IVOR34 - SPE-floating point round exception
	reg ${SPR_GROUP}IVOR34 = 0x00001800
	# IVOR35 - performance monitor
	reg ${SPR_GROUP}IVOR35 = 0x00001900	
	
	# infinite loop at program exception to prevent taking the exception again
	mem v:0x[expr {${proc_id} << 1}]0000700 = 0x48000000
	mem v:0x[expr {${proc_id} << 1}]0001500 = 0x48000000
	
	##################################################################################
	apply_e500v2_workaround
	
	##################################################################################
	# Debugger settings
	# enable floating point
	reg ${SSP_GROUP}MSR = 0x02001200
	
	# enable machine check
	reg ${SPR_GROUP}HID0 = 0x00004000
	
	
	#Trap debug event enable
	reg ${SPR_GROUP}DBCR0 = 0x41000000

	#  set the PC at the reset address (for debug-->connect)
	reg ${GPR_GROUP}PC = 0xFFFFFFFC
	# for debugging starting at program entry point when stack is not initialized
	reg ${GPR_GROUP}SP = 0x0000000F
	
	if {$proc_id == 0} {
		# BRRL - enable all cores
		mem [CCSR 0x1010] = 0x03000000
	}
}

proc envsetup {} {
	# Environment Setup
	radix x 
	config hexprefix 0x
	config MemIdentifier v
	config MemWidth 32 
	config MemAccess 32 
	config MemSwap off
}

#-------------------------------------------------------------------------------
# Main                                                                          
#-------------------------------------------------------------------------------

  envsetup
  
  P10xx_P20xx_P2020_init_core