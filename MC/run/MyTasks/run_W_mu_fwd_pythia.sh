#!/usr/bin/env bash

# make sure O2DPG + O2 is loaded
[ ! "${O2DPG_ROOT}" ] && echo "Error: This needs O2DPG loaded" && exit 1
[ ! "${O2_ROOT}" ] && echo "Error: This needs O2 loaded" && exit 1

# ----------- SETUP LOCAL CCDB CACHE --------------------------
export ALICEO2_CCDB_LOCALCACHE=$PWD/.ccdb

# ----------- LOAD UTILITY FUNCTIONS --------------------------
. ${O2_ROOT}/share/scripts/jobutils.sh

# number of timeframes to simulate
NTFS=${NTFS:-3}
# number of simulation workers per timeframe
NWORKERS=${NWORKERS:-20}
# number of events to be simulated per timeframe
NEVENTS=${NEVENTS:-100}

${O2DPG_ROOT}/MC/bin/o2dpg_sim_workflow.py -eCM 13600 -seed 12345 -col pp -gen pythia8 -j ${NWORKERS} -ns ${NEVENTS} -tf ${NTFS} -e TGeant4 \
    -interactionRate 500000 -run 558744 -mod "--skipModules ZDC" \
	-confKey "GeneratorPythia8.config=/home/stephan/alice/O2DPG/MC/config/MyTasks/pythia8/pythia_W_mu.cfg;GeneratorPythia8.includePartonEvent=true"
    # -trigger "external" -ini /home/stephan/alice/O2DPG/MC/config/MyTasks/ini/trigger_W_mu_pythia.ini
    # --readoutDets MFT,MCH,MID,ITS

${O2DPG_ROOT}/MC/bin/o2_dpg_workflow_runner.py -f workflow.json -tt aod --cpu-limit 20 --mem-limit 40000