# Windows startup script

< envPaths

epicsEnvSet("PREFIX", "xxx:")

### For alive
epicsEnvSet("RHOST", "164.54.100.11")
epicsEnvSet("IOCBOOT", $(TOP)/iocBoot/$(IOC))

### For devIocStats
epicsEnvSet("ENGINEER","Peterson")
epicsEnvSet("LOCATION","location")
epicsEnvSet("GROUP","group")

# save_restore.cmd needs the full path to the startup directory, which
# envPaths currently does not provide
epicsEnvSet(STARTUP,$(TOP)/iocBoot/$(IOC))

# Increase size of buffer for error logging from default 1256
errlogInit(20000)

# Specify largest array CA will transport
# Note for N doubles, need N*8 bytes+some overhead
epicsEnvSet EPICS_CA_MAX_ARRAY_BYTES 64010

################################################################################
# Tell EPICS all about the record types, device-support modules, drivers, etc
# 64-bit Windows
dbLoadDatabase("../../dbd/iocxxxWin64.dbd")
iocxxxWin64_registerRecordDeviceDriver(pdbbase)
# 32-bit Windows
#!dbLoadDatabase("../../dbd/iocxxxWin32.dbd")
#!iocxxxWin32_registerRecordDeviceDriver(pdbbase)

### save_restore setup
< cmds/save_restore.cmd

# motorUtil (allstop & alldone)
dbLoadRecords("$(MOTOR)/db/motorUtil.db", "P=$(PREFIX)")
# Run this after iocInit:
doAfterIocInit("motorUtilInit('$(PREFIX)')")

# Scan support
#!< cmds/sscan.cmd

### Stuff for user programming ###
< cmds/calc.cmd

# Miscellaneous PV's, such as burtResult
dbLoadRecords("$(STD)/stdApp/Db/misc.db","P=$(PREFIX)")

# devIocStats
dbLoadRecords("$(DEVIOCSTATS)/db/iocAdminSoft.db","IOC=xxx")

### Load database record for alive heartbeating support.
# RHOST specifies the IP address that receives the heartbeats.
dbLoadRecords("$(ALIVE)/aliveApp/Db/alive.db", "P=$(PREFIX),RHOST=$(RHOST)")

###############################################################################
iocInit
###############################################################################

### write all the PV names to a local file
dbl > dbl-all.txt

### also report these environment variables to the alive server
dbpf("$(PREFIX)alive.ENV8", "IOCBOOT")

### Report  states of database CA links
dbcar(*,1)

### print the time our boot was finished
date

