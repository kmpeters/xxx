### Scan-support software
# crate-resident scan.  This executes 1D, 2D, 3D, and 4D scans, and caches
# 1D data, but it doesn't store anything to disk.  (See 'saveData' below for that.)
putenv "SDB=$(SSCAN)/sscanApp/Db/standardScans.db"
dbLoadRecords("$(SDB)","P=xxx:,MAXPTS1=1000,MAXPTS2=1000,MAXPTS3=100,MAXPTS4=100,MAXPTSH=100")
#!dbLoadRecords("$(SSCAN)/sscanApp/Db/scanAux.db","P=xxx:,S=scanAux,MAXPTS=100")

# Start the saveData task.  If you start this task, scan records mentioned
# in saveData.req will *always* write data files.  There is no programmable
# disable for this software.
dbLoadRecords("$(SSCAN)/sscanApp/Db/saveData.db","P=xxx:")
doAfterIocInit("saveData_Init('saveData.req', 'P=xxx:')")

dbLoadRecords("$(SSCAN)/sscanApp/Db/scanProgress.db","P=xxx:scanProgress:")
doAfterIocInit("seq &scanProgress, 'S=xxx:, P=xxx:scanProgress:'")

# configMenu example.  See create_manual_set() command after iocInit.
#!dbLoadRecords("$(AUTOSAVE)/asApp/Db/configMenu.db","P=xxx:,CONFIG=scan1")
#!doAfterIocInit("create_manual_set('scan1Menu.req','P=xxx:,CONFIG=scan1,CONFIGMENU=1')")
