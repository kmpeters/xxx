# vxWorks startup script

sysVmeMapShow

# For devIocStats
putenv("ENGINEER=Peterson")
putenv("LOCATION=location")
putenv("GROUP=group")

cd ""
< ../nfsCommands
< cdCommands

# How to set and get the clock rate (in Hz.  Default is 60 Hz)
#sysClkRateSet(100)
#sysClkRateGet()

################################################################################
cd topbin

# If the VxWorks kernel was built using the project facility, the following must
# be added before any C++ code is loaded (see SPR #28980).
sysCplusEnable=1

# If using a PowerPC CPU with more than 32MB of memory, and not building with longjump, then
# allocate enough memory here to force code to load in lower 32 MB.
##mem = malloc(1024*1024*96)

### Load synApps EPICS software
load("xxx.munch")
cd startup

# Increase size of buffer for error logging from default 1256
errlogInit(20000)

# need more entries in wait/scan-record channel-access queue?
recDynLinkQsize = 1024

# Specify largest array CA will transport
# Note for N sscanRecord data points, need (N+1)*8 bytes, else MEDM
# plot doesn't display
putenv "EPICS_CA_MAX_ARRAY_BYTES=64008"

# set the protocol path for streamDevice
epicsEnvSet("STREAM_PROTOCOL_PATH", ".")

################################################################################
# Tell EPICS all about the record types, device-support modules, drivers,
# etc. in the software we just loaded (xxx.munch)
dbLoadDatabase("$(TOP)/dbd/iocxxxVX.dbd")
iocxxxVX_registerRecordDeviceDriver(pdbbase)

### save_restore setup
< save_restore.cmd

### Allstop, alldone
dbLoadRecords("$(MOTOR)/db/motorUtil.db", "P=xxx:")
doAfterIocInit("motorUtilInit('xxx:')")

### Scan support
#!< sscan.cmd

### Stuff for user programming ###
< calc.cmd

###############################################################################
# Set shell prompt
shellPromptSet "iocvxWorks> "
iocLogDisable=0
iocInit
###############################################################################

# write all the PV names to a local file
dbl > dbl-all.txt
memShow

# If memory allocated at beginning free it now
##free(mem)

# Diagnostic: CA links in all records
#dbcar(0,1)


# print the time our boot was finished
date
