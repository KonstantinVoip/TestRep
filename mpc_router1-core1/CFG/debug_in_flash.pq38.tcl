variable CCSRBAR 0xFF700000

proc CCSR {reg_off} {
	global CCSRBAR
	
	return p:0x[format %x [expr {$CCSRBAR + $reg_off}]]
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

variable SPR_GROUP "e500 Special Purpose Registers/"
variable SSP_GROUP "Standard Special Purpose Registers/"
variable GPR_GROUP "General Purpose Registers/"

# set interrupt vectors
# IVPR (compatible to the Flash) 
reg ${SPR_GROUP}IVPR = 0xFFFF0000 	
# debug (a valid instruction should exist to be fetched)
reg ${SPR_GROUP}IVOR15 = 0x0000F000	

#######################################################################
# Set a breakpoint at the reset address 
reg ${SPR_GROUP}IAC1 = 0xfffffffc
reg ${SPR_GROUP}DBCR0 = 0x40800000
reg ${SPR_GROUP}DBCR1 = 0x00000000
reg	${SSP_GROUP}MSR = 0x02000200

config runcontrolsync off
go
wait 50   
config runcontrolsync on
stop

reg ${SPR_GROUP}DBCR0 = 0x41000000
reg ${SPR_GROUP}IAC1 = 0x00000000

#
#######################################################################

#############
# activate debug interrupt and enable SPU
reg	${SSP_GROUP}MSR = 0x02000200

# ABIST off
# L2ERRDIS[MBECCDIS]=1, L2ERRDIS[SBECCDIS]=1
mem [CCSR 0x20E44] = 0x0000000C	

# Clear debug event status
reg ${SPR_GROUP}DBSR = 0x01CF0000

#  set the PC back to the reset address (for debug-->connect)
reg	${GPR_GROUP}PC = 0xfffffffc
# re-activate debug interrupt and enable SPU (hitting the HW bp altered it)
reg	${SSP_GROUP}MSR = 0x02000200
# clear CSRR0 & CSRR1 to erase the effects of the HW breakpoint - enables
# stepping through 0xfffff000 and 0xfffff004.
reg ${SPR_GROUP}CSRR0 =	0
reg ${SPR_GROUP}CSRR1 =	0
# for debugging starting at program entry point when stack is not initialized
reg	${GPR_GROUP}SP = 0x0000000F
