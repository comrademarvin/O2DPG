#!/usr/bin/env bash
#
# Example on how to produce an event pool and how to feed it
# to the O2DPG simulation workflow 
#
# make sure O2DPG + O2 is loaded
[ ! "${O2DPG_ROOT}" ] && echo "Error: This needs O2DPG loaded" && exit 1
[ ! "${O2_ROOT}" ] && echo "Error: This needs O2 loaded" && exit 1
#
#
ECM=${ECM:-5360} # energy in GeV
TF=${TF:-1} # number of timeframes
N=${N:-500} # number of events per timeframe
totalevents=$((TF * N)) # total number of events (just for checking correct number of total events)
#
# Parse arguments
MAKE=false
INPUT=""
#
help() {
    echo "Usage: $0 [--make] [-i|--input <input_file>]"
    echo "  --make: Create the event pool"
    echo "  -i|--input: Input event pool file to be used in the simulation workflow. Alien paths are supported."
    echo "              A full path must be provided (use of environment variables allowed), otherwise generation will fail."
    echo "  -h|--help: Display this help message"
    exit 0
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --make) MAKE=true ;;
        -i|--input) INPUT="$2"; shift ;;
        -h|--help) help ;;
        *) echo "Unknown operation requested: $1"; help ;;
    esac
    shift
done

if $MAKE; then
    echo "Validate alien certificate"
    alien-token-init
    start1=`date +%s`
    echo "Task started at `date`"
    echo "Started generation of event pool for $totalevents events!"
    # copy a template pythia8 config file with powheg
    cp ${O2_ROOT}/share/Generators/egconfig/pythia8_powheg.cfg ./pythia8_powheg_template.cfg
    # fix the path of powheg.lhe in the config file to absolute location of powheg file
    PATHTOPOWHEGFILE=/home/stephan/sims/powheg/pwgevents_W+_10k.lhe
    POWHEGFILE=$(readlink -f $PATHTOPOWHEGFILE)
    # changes in .config according to the user requirement
    sed -e "s|powheg.lhe|$POWHEGFILE|" -e "s|5360|$ECM|" -e "s|POWHEG:nFinal = 2|POWHEG:nFinal = -1|" pythia8_powheg_template.cfg > pythia8_powheg_final.cfg
    rm -rf pythia8_powheg_template.cfg
    echo "POWHEG + Pythia8 config file created"
    # Workflow creation. All the parameters are used as examples
    # No transport will be executed. The workflow will stop at the event generation and will conclude with the merging of all the
    # kinematic root files of the timeframes in a file called evtpool.root in the current working directory
    ${O2DPG_ROOT}/MC/bin/o2dpg_sim_workflow.py -eCM $ECM -col pp -gen pythia8 -proc cdiff -tf $TF -ns $N -e TGeant4 -j 8 -interactionRate 500000 -run 300000 -seed 624 -confKey "GeneratorPythia8.config=${PWD}/pythia8_powheg_final.cfg" --make-evtpool -productionTag "evtpoolcreation" -o evtpool 
    # Workflow runner
    ${O2DPG_ROOT}/MC/bin/o2dpg_workflow_runner.py -f evtpool.json -tt pool
    # Print total task duration
    stop1=`date +%s`
    duration1=$((stop1-start1))
    echo "Task completed at `date`"
    echo "Total task duration = $duration1 second(s)"
#
elif [[ -n "$INPUT" ]]; then
    echo "Input file provided: $INPUT"
    if [[ -f "$INPUT" && -s "$INPUT" ]] || [[ "$INPUT" == alien://* ]]; then
        start2=`date +%s`
        echo "Task started at `date`"
        echo "Running POWHEG+Pythia8 MC production for $totalevents events!"
        # Workflow creation.
        ${O2DPG_ROOT}/MC/bin/o2dpg_sim_workflow.py -eCM $ECM -confKey "GeneratorFromO2Kine.fileName=$INPUT" -gen extkinO2 -tf $TF -ns $N -e TGeant4 -j 4 -interactionRate 500000 -run 300000 -seed 546 -productionTag "evtpooltest"
        # changes in workflow.json according to the user requirement
        sed 's/GeneratorFromO2Kine.randomize=true;/GeneratorFromO2Kine.randomize=false;/g' workflow.json > workflow_new.json
        # Loop through sgngen_2 to sgngen_1000 to add --startEvent flag
        for i in $(seq 2 $TF)
        do
            # Calculate the startEvent value
            startEvent=$((1000 * (i - 1)))
        
            # Use sed to modify the cmd line by adding --startEvent 1000*(i-1) after --noGeant
        
            sed -i "/\"name\": \"sgngen_$i\"/ {
                n; 
                s/--noGeant/--noGeant --startEvent $startEvent/ 
            }" workflow_new.json
        done
        echo "workflow.json created and edited!!"
        # Workflow runner. The rerun option is set in case you will run directly the script in the same folder (no need to manually delete files)
        #${O2DPG_ROOT}/MC/bin/o2dpg_workflow_runner.py -f workflow_new.json -tt aod --rerun-from grpcreate
        # Print total task duration
        stop2=`date +%s`
        duration2=$((stop2-start2))
        echo "Task completed at `date`"
        echo "Total task duration = $duration2 second(s)"
    else
        echo "Error: File does not exist or is empty: $INPUT"
        exit 1
    fi
else
    echo "Usage: $0 [--make] [-i|--input <input_file>]"
    exit 1
fi