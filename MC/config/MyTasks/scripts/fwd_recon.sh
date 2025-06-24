o2-sim-digitizer-workflow --configKeyValues "HBFUtils.nHBFPerTF=32;HBFUtils.orbitFirst=29098560;HBFUtils.orbitFirstSampled=36559744"
o2-mft-reco-workflow
o2-mid-digits-reader-workflow | o2-mid-reco-workflow | o2-mch-reco-workflow | o2-muon-tracks-matcher-workflow --disable-root-input | o2-dpl-run --run --no-batch
o2-globalfwd-matcher-workflow --configKeyValues "FwdMatching.useMIDMatch=true"