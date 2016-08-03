### Scan-support software
# crate-resident scan.  This executes 1D, 2D, 3D, and 4D scans, and caches
# 1D data, but it doesn't store anything to disk.  (See 'saveData' below for that.)
dbLoadRecords("$(SSCAN)/sscanApp/Db/standardScans.db","P=$(PREFIX),MAXPTS1=1000,MAXPTS2=1000,MAXPTS3=1000,MAXPTS4=1000,MAXPTSH=1000")
dbLoadRecords("$(SSCAN)/sscanApp/Db/saveData.db","P=$(PREFIX)")
# Run this after iocInit:
doAfterIocInit("saveData_Init(saveData.req, 'P=$(PREFIX)')")
dbLoadRecords("$(SSCAN)/sscanApp/Db/scanProgress.db","P=$(PREFIX)scanProgress:")
# Run this after iocInit:
doAfterIocInit("seq &scanProgress, 'S=$(PREFIX), P=$(PREFIX)scanProgress:'")

# configMenu example.
#!dbLoadRecords("$(AUTOSAVE)/asApp/Db/configMenu.db","P=$(PREFIX),CONFIG=scan1")
# Note that the request file MUST be named $(CONFIG)Menu.req
# If the macro CONFIGMENU is defined with any value, backup (".savB") and
# sequence files (".savN") will not be written.  We don't want these for configMenu.
# Run this after iocInit:
#!doAfterIocInit("create_manual_set('scan1Menu.req','P=$(PREFIX),CONFIG=scan1,CONFIGMENU=1')")
