# vxWorks startup script

# Read environment variables
< envPaths

# save_restore.cmd needs the full path to the startup directory, which
# envPaths currently does not provide
epicsEnvSet(STARTUP,$(TOP)/iocBoot/$(IOC))

################################################################################
# Tell EPICS all about the record types, device-support modules, drivers,
# etc. in the software we just loaded (xxx.munch)
dbLoadDatabase("../../dbd/iocxxx_solaris.dbd")
iocxxx_solaris_registerRecordDeviceDriver(pdbbase)

# Increase size of buffer for error logging from default 1256
errlogInit(5000)

# debug sseq record
#var sseqRecDebug,10
# need more entries in wait/scan-record channel-access queue?
#var recDynLinkQsize, 1024

# Specify largest array CA will transport
# Note for N sscanRecord data points, need (N+1)*8 bytes, else MEDM
# plot doesn't display
epicsEnvSet EPICS_CA_MAX_ARRAY_BYTES 64008

### save_restore setup
# We presume a suitable initHook routine was compiled into the executable.
# See also create_monitor_set(), after iocInit() .
< save_restore.cmd

# Motors
#dbLoadTemplate("motor.substitutions")
dbLoadTemplate("softMotor.substitutions")
< motorSim.cmd

### Allstop, alldone
# This database must agree with the motors and other positioners you've actually loaded.
# Several versions (e.g., all_com_*.db) are in stdApp/Db
#dbLoadRecords("$(STD)/stdApp/Db/all_com_0.db","P=xxx:")
dbLoadRecords("$(MOTOR)/db/motorUtil.db", "P=xxx:")

# interpolation
dbLoadRecords("$(CALC)/calcApp/Db/interp.db", "P=xxx:,N=2000")


### Scan-support software
# crate-resident scan.  This executes 1D, 2D, 3D, and 4D scans, and caches
# 1D data, but it doesn't store anything to disk.  (See 'saveData' below for that.)
dbLoadRecords("$(SSCAN)/sscanApp/Db/standardScans.db","P=xxx:,MAXPTS1=8000,MAXPTS2=1000,MAXPTS3=1000,MAXPTS4=1000,MAXPTSH=2000")
dbLoadRecords("$(SSCAN)/sscanApp/Db/saveData.db","P=xxx:")

# A set of scan parameters for each positioner.  This is a convenience
# for the user.  It can contain an entry for each scannable thing in the
# crate.
dbLoadTemplate("scanParms.substitutions")

# Slits
#dbLoadRecords("$(OPTICS)/opticsApp/Db/2slit.db","P=xxx:,SLIT=Slit1V,mXp=m3,mXn=m4")
#dbLoadRecords("$(OPTICS)/opticsApp/Db/2slit.db","P=xxx:,SLIT=Slit1H,mXp=m5,mXn=m6")

# 2-post mirror
#dbLoadRecords("$(OPTICS)/opticsApp/Db/2postMirror.db","P=xxx:,Q=M1,mDn=m1,mUp=m2,LENGTH=0.3")

# User filters
#dbLoadRecords("$(OPTICS)/opticsApp/Db/filterMotor.db","P=xxx:,Q=fltr1:,MOTOR=m1,LOCK=fltr_1_2:")
#dbLoadRecords("$(OPTICS)/opticsApp/Db/filterMotor.db","P=xxx:,Q=fltr2:,MOTOR=m2,LOCK=fltr_1_2:")

# Optical tables
#var tableRecordDebug,1
#dbLoadRecords("$(OPTICS)/opticsApp/Db/table.db","P=xxx:,Q=Table1,T=table1,M0X=m1,M0Y=m2,M1Y=m3,M2X=m4,M2Y=m5,M2Z=m6,GEOM=SRI")

# Io calculation
dbLoadRecords("$(OPTICS)/opticsApp/Db/Io.db","P=xxx:Io:")

### Monochromator support ###
# Kohzu and PSL monochromators: Bragg and theta/Y/Z motors
# standard geometry (geometry 1)
#dbLoadRecords("$(OPTICS)/opticsApp/Db/kohzuSeq.db","P=xxx:,M_THETA=m1,M_Y=m2,M_Z=m3,yOffLo=17.4999,yOffHi=17.5001")
# modified geometry (geometry 2)
#dbLoadRecords("$(OPTICS)/opticsApp/Db/kohzuSeq.db","P=xxx:,M_THETA=m1,M_Y=m2,M_Z=m3,yOffLo=4,yOffHi=36")

# Spherical grating monochromator
#dbLoadRecords("$(OPTICS)/opticsApp/Db/SGM.db","P=xxx:,N=1,M_x=m1,M_rIn=m2,M_rOut=m3,M_g=m4")

# 4-bounce high-resolution monochromator
#dbLoadRecords("$(OPTICS)/opticsApp/Db/hrSeq.db","P=xxx:,N=1,M_PHI1=m1,M_PHI2=m2")

### Orientation matrix, four-circle diffractometer (see seq program 'orient' below)
#dbLoadRecords("$(OPTICS)/opticsApp/Db/orient.db", "P=xxx:,O=1,PREC=4")
#dbLoadTemplate("orient_xtals.substitutions")

### Stuff for user programming ###
dbLoadRecords("$(CALC)/calcApp/Db/userCalcs10.db","P=xxx:")
dbLoadRecords("$(CALC)/calcApp/Db/userCalcOuts10.db","P=xxx:")
dbLoadRecords("$(CALC)/calcApp/Db/userStringCalcs10.db","P=xxx:")
var aCalcArraySize, 2000
dbLoadRecords("$(CALC)/calcApp/Db/userArrayCalcs10.db","P=xxx:,N=2000")
dbLoadRecords("$(CALC)/calcApp/Db/userTransforms10.db","P=xxx:")
# extra userCalcs (must also load userCalcs10.db for the enable switch)
dbLoadRecords("$(CALC)/calcApp/Db/userCalcN.db","P=xxx:,N=I_Detector")
#dbLoadRecords("$(CALC)/calcApp/Db/userAve10.db","P=xxx:")
# string sequence (sseq) records
dbLoadRecords("$(STD)/stdApp/Db/userStringSeqs10.db","P=xxx:")
# ramp/tweak
dbLoadRecords("$(STD)/stdApp/Db/ramp_tweak.db","P=xxx:,Q=rt1")

# pvHistory (in-crate archive of up to three PV's)
dbLoadRecords("$(STD)/stdApp/Db/pvHistory.db","P=xxx:,N=1,MAXSAMPLES=1440")

### serial support ###

# generic serial ports
#dbLoadRecords("$(IP)/ipApp/Db/generic_serial.db", "P=xxx:,C=0,SERVER=serial1")
#dbLoadRecords("$(IP)/ipApp/Db/generic_serial.db", "P=xxx:,C=0,SERVER=serial2")

# serial O/I block (generic serial record with format and parse string calcs)
# on epics/mpf processor
#dbLoadRecords("$(IP)/ipApp/Db/serial_OI_block.db","P=xxx:,N=0_1,C=0,SERVER=serial5")
# on stand-alone mpf processor
#dbLoadRecords("$(IP)/ipApp/Db/serial_OI_block.db","P=xxx:,N=1_1,C=0,SERVER=serial5")

# Miscellaneous PV's, such as burtResult
dbLoadRecords("$(STD)/stdApp/Db/misc.db","P=xxx:")

### Load database records for Femto amplifiers
#dbLoadRecords("$(STD)/stdApp/Db/femto.db","P=xxx:,H=fem01:,F=seq01:")

### Load database records for PF4 filters
#dbLoadRecords("$(OPTICS)/opticsApp/Db/pf4common.db","P=xxx:,H=pf4:,A=A,B=B")
#dbLoadRecords("$(OPTICS)/opticsApp/Db/pf4bank.db","P=xxx:,H=pf4:,B=A")
#dbLoadRecords("$(OPTICS)/opticsApp/Db/pf4bank.db","P=xxx:,H=pf4:,B=B")

###############################################################################
iocInit

### startup State Notation Language programs
#seq &kohzuCtl, "P=xxx:, M_THETA=m1, M_Y=m2, M_Z=m3, GEOM=1, logfile=kohzuCtl.log"
#seq &hrCtl, "P=xxx:, N=1, M_PHI1=m1, M_PHI2=m2, logfile=hrCtl1.log"

# Orientation-matrix
#seq &orient, "P=xxx:orient1:,PM=xxx:,mTTH=m9,mTH=m10,mCHI=m11,mPHI=m12"

# Start PF4 filter sequence program
#seq &pf4,"name=pf1,P=xxx:,H=pf4:,B=A,M=xxx:BraggEAO,B1=xxx:Unidig1Bo3,B2=xxx:Unidig1Bo4,B3=xxx:Unidig1Bo5,B4=xxx:Unidig1Bo6"
#seq &pf4,"name=pf2,P=xxx:,H=pf4:,B=B,M=xxx:BraggEAO,B1=xxx:Unidig1Bo7,B2=xxx:Unidig1Bo8,B3=xxx:Unidig1Bo9,B4=xxx:Unidig1Bo10"

# Start Femto amplifier sequence programs
#seq femto,"name=fem1,P=xxx:,H=fem01:,F=seq01:,G1=xxx:Unidig1Bo6,G2=xxx:Unidig1Bo7,G3=xxx:Unidig1Bo8,NO=xxx:Unidig1Bo10"

### Start up the autosave task and tell it what to do.
# The task is actually named "save_restore".
# Note that you can reload these sets after creating them: e.g., 
# reload_monitor_set("auto_settings.req",30,"P=xxx:")
#
# save positions every five seconds
create_monitor_set("auto_positions.req",5,"P=xxx:")
# save other things every thirty seconds
create_monitor_set("auto_settings.req",30,"P=xxx:")

### Start the saveData task.
# saveData_MessagePolicy
# 0: wait forever for space in message queue, then send message
# 1: send message only if queue is not full
# 2: send message only if queue is not full and specified time has passed (SetCptWait()
#    sets this time.)
# 3: if specified time has passed, wait for space in queue, then send message
# else: don't send message
#var "debug_saveData" 2
#saveData_MessagePolicy = 2
#saveData_SetCptWait_ms(100)
saveData_Init("saveData.req", "P=xxx:")
#saveData_PrintScanInfo("xxx:scan1")

motorUtilInit("xxx:")
