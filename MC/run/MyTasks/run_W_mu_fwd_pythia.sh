#!/usr/bin/env bash

# make sure O2DPG + O2 is loaded
[ ! "${O2DPG_ROOT}" ] && echo "Error: This needs O2DPG loaded" && exit 1
[ ! "${O2_ROOT}" ] && echo "Error: This needs O2 loaded" && exit 1

# ----------- SETUP LOCAL CCDB CACHE --------------------------
export ALICEO2_CCDB_LOCALCACHE=$PWD/.ccdb

# ----------- LOAD UTILITY FUNCTIONS --------------------------
. ${O2_ROOT}/share/scripts/jobutils.sh

NSIGEVENTS=150
NWORKERS=15
NTIMEFRAMES=1

${O2DPG_ROOT}/MC/bin/o2dpg_sim_workflow.py -eCM 5360 -seed 12345 -col pp -gen pythia8 -j ${NWORKERS} -ns ${NSIGEVENTS} -tf ${NTIMEFRAMES} -e TGeant4 \
    -interactionRate 500000 -run 559387 -mod "--skipModules ZDC" \
    -trigger "external" -ini /home/stephan/alice/O2DPG/MC/config/MyTasks/ini/trigger_W_mu_pythia.ini \
	-confKey "GeneratorPythia8.config=/home/stephan/alice/O2DPG/MC/config/MyTasks/pythia8/pythia_W_mu.cfg;GeneratorPythia8.includePartonEvent=true"

${O2DPG_ROOT}/MC/bin/o2_dpg_workflow_runner.py -f workflow.json -tt aod --cpu-limit 20 --mem-limit 40000