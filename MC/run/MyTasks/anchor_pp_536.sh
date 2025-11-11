#!/bin/bash

export ALIEN_JDL_LPMANCHORPASSNAME=apass1
export ALIEN_JDL_MCANCHOR=apass1
export ALIEN_JDL_CPULIMIT=20
export ALIEN_JDL_LPMRUNNUMBER=559456
export ALIEN_JDL_LPMPRODUCTIONTYPE=MC
export ALIEN_JDL_LPMINTERACTIONTYPE=pp
export ALIEN_JDL_LPMPRODUCTIONTAG=LHC25b4b2
export ALIEN_JDL_LPMANCHORRUN=559456
export ALIEN_JDL_LPMANCHORPRODUCTION=LHC24aq
export ALIEN_JDL_LPMANCHORYEAR=2024

export NTIMEFRAMES=2
export NSIGEVENTS=1000
export SPLITID=1 # ?
export PRODSPLIT=3351
export CYCLE=0

# on the GRID, this is set and used as seed; when set, it takes precedence over SEED
#export ALIEN_PROC_ID=2963436952
export SEED=1

# for pp and 50 events per TF, we launch only 4 workers.
export NWORKERS=20

export ALIEN_JDL_ANCHOR_SIM_OPTIONS="-eCM 5360 -col pp -gen pythia8 -trigger \"external\" -ini /home/stephan/alice/O2DPG/MC/config/MyTasks/ini/trigger_charm_mu_pythia.ini -confKey \"GeneratorPythia8.config=/home/stephan/alice/O2DPG/MC/config/MyTasks/pythia8/pythia_charm_mu.cfg;GeneratorPythia8.includePartonEvent=true\""

# run the central anchor steering script; this includes
# * derive timestamp
# * derive interaction rate
# * extract and prepare configurations (which detectors are contained in the run etc.)
# * run the simulation (and QC)
# To disable QC, uncomment the following line
export DISABLE_QC=1
${O2DPG_ROOT}/MC/run/ANCHOR/anchorMC.sh