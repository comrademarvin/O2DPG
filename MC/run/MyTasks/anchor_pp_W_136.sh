#!/bin/bash

export ALIEN_JDL_LPMANCHORPASSNAME=apass1
export ALIEN_JDL_MCANCHOR=apass1
export ALIEN_JDL_CPULIMIT=20
export ALIEN_JDL_LPMRUNNUMBER=551398
export ALIEN_JDL_LPMPRODUCTIONTYPE=MC
export ALIEN_JDL_LPMINTERACTIONTYPE=pp
export ALIEN_JDL_LPMPRODUCTIONTAG=LHC25i3
export ALIEN_JDL_LPMANCHORRUN=551398
export ALIEN_JDL_LPMANCHORPRODUCTION=LHC24ag
export ALIEN_JDL_LPMANCHORYEAR=2024

export NTIMEFRAMES=1
export NSIGEVENTS=100
export SPLITID=1 # ?
export PRODSPLIT=22
export CYCLE=0

# on the GRID, this is set and used as seed; when set, it takes precedence over SEED
#export ALIEN_PROC_ID=2963436952
export SEED=1
export NWORKERS=20

export ALIEN_JDL_ANCHOR_SIM_OPTIONS="-eCM 13600 -col pp -gen pythia8 -trigger \"external\" -ini /home/stephan/alice/O2DPG/MC/config/MyTasks/ini/trigger_W_mu_powheg.ini \
-confKey \"GeneratorPythia8.config=/home/stephan/alice/O2DPG/MC/config/MyTasks/pythia8/pythia8_powheg.cfg;GeneratorPythia8.includePartonEvent=true\" --mft-assessment-full --fwdmatching-assessment-full"

# run the central anchor steering script; this includes
# * derive timestamp
# * derive interaction rate
# * extract and prepare configurations (which detectors are contained in the run etc.)
# * run the simulation (and QC)
# To disable QC, uncomment the following line
export DISABLE_QC=1
${O2DPG_ROOT}/MC/run/ANCHOR/anchorMC.sh