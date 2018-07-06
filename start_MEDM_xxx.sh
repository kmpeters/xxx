#!/bin/bash

export EPICS_APP=`dirname $0`
export EPICS_APP_ADL_DIR=${EPICS_APP}/xxxApp/op/adl
export DEFAULT_UI_FILE=${DEFAULT_UI_FILE:-xxx.ui}

source ./setup_epics_common.sh medm

if [ -z "${MEDM_EXEC_LIST}" ] 
then
    export MEDM_EXEC_LIST='Probe;probe &P &'
fi

#export EPICS_CA_ADDR_LIST="164.54.53.126"

# This should agree with the environment variable set by the ioc
# see 'putenv "EPICS_CA_MAX_ARRAY_BYTES=64008"' in iocBoot/ioc<target>/st.cmd
export EPICS_CA_MAX_ARRAY_BYTES=64008

export START_PUTRECORDER=${EPICS_APP}/start_putrecorder
export MACROS_PY=${EPICS_APP_ADL_DIR}/../python/macros.py
export EDITOR=nedit

medm -x xxx.adl&
