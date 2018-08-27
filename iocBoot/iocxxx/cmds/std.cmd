# Soft scaler
#!iocshLoad("$(STD)/iocsh/softScaler.iocsh", "P=$(PREFIX), INSTANCE=scaler1")

# pvHistory (in-crate archive of up to three PV's)
#!dbLoadRecords("$(STD)/stdApp/Db/pvHistory.db","P=$(PREFIX),N=1,MAXSAMPLES=1440")

# software timer
#!dbLoadRecords("$(STD)/stdApp/Db/timer.db","P=$(PREFIX),N=1")

# Miscellaneous PV's, such as burtResult
dbLoadRecords("$(STD)/stdApp/Db/misc.db","P=$(PREFIX)")
