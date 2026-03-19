#!/usr/bin/env bash

# make sure O2DPG + O2 is loaded
[ ! "${O2DPG_ROOT}" ] && echo "Error: This needs O2DPG loaded" && exit 1
[ ! "${O2_ROOT}" ] && echo "Error: This needs O2 loaded" && exit 1

# ----------- SETUP LOCAL CCDB CACHE --------------------------
export ALICEO2_CCDB_LOCALCACHE=$PWD/.ccdb

# ----------- LOAD UTILITY FUNCTIONS --------------------------
. ${O2_ROOT}/share/scripts/jobutils.sh

# number of timeframes to simulate
NTFS=${NTFS:-1}
# number of simulation workers per timeframe
NWORKERS=${NWORKERS:-20}
# number of events to be simulated per timeframe
NEVENTS=${NEVENTS:-1000}

${O2DPG_ROOT}/MC/bin/o2dpg_sim_workflow.py -eCM 13600 -seed 12345 -col pp -gen external -j ${NWORKERS} -ns ${NEVENTS} -tf ${NTFS} -e TGeant4 \
    -interactionRate 691338 -run 539874 -mod "--skipModules ZDC" \
    -trigger "external" -ini /home/stephan/alice/O2DPG/MC/config/MyTasks/ini/GeneratorPythia8Powheg_W_mu_fwd.ini \
	-confKey "GeneratorPythia8.config=/home/stephan/alice/O2DPG/MC/config/MyTasks/pythia8/pythia8_powheg.cfg;GeneratorPythia8.includePartonEvent=true"

${O2DPG_ROOT}/MC/bin/o2_dpg_workflow_runner.py -f workflow.json -tt aod --cpu-limit 20 --mem-limit 40000