# Soft motors
#!dbLoadTemplate("substitutions/softMotor.substitutions", "P=$(PREFIX)")

# Simulated motors
#!iocshLoad("$(MOTOR)/iocsh/motorSim.iocsh", "INSTANCE=motorSim, HOME_POS=0, NUM_AXES=16, SUB=substitutions/motorSim.substitutions")

# Allstop, alldone
iocshLoad("$(MOTOR)/iocsh/allstop.iocsh", "P=$(PREFIX)")
