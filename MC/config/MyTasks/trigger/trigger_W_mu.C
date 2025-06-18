R__ADD_INCLUDE_PATH($O2DPG_ROOT)
#include "Generators/Trigger.h"
#include "TParticle.h"
#include "TParticlePDG.h"

o2::eventgen::Trigger trigger_W_mu(double yMin = -4.0, double yMax = -2.5, double pTmin = 30.0, double pTmax = 80.0) {
	auto trigger = [yMin, yMax, pTmin, pTmax](const std::vector<TParticle>& particles) -> bool {
		int pdg = -1;
		int mpdg = -1;
		double rapidity = -999.;
		double pT = -999.;
		for (const auto& particle : particles) {
			pdg = TMath::Abs(particle.GetPdgCode());
			rapidity = particle.Y();
			pT = particle.Pt();
			if ((pdg == 13) && (rapidity > yMin) && (rapidity < yMax) && (pT > pTmin) && (pT < pTmax)) { // is there a muon that satisfies the acceptance cuts
				Int_t mi = particle.GetMother(0);
				if (mi < 0) continue;
				TParticle mother = particles.at(mi);
				mpdg = TMath::Abs(mother.GetPdgCode());
				if (mpdg == 24) return kTRUE; // has W as mother -> accept event
			};
		};
		return kFALSE;
	};
	return trigger;
};
