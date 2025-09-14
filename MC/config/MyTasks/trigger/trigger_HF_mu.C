R__ADD_INCLUDE_PATH($O2DPG_ROOT)
#include "Generators/Trigger.h"
#include "TParticle.h"
#include "TParticlePDG.h"

Int_t GetFlavour(Int_t pdgCode);

o2::eventgen::Trigger trigger_HF_mu(Int_t flavour = 4, double yMin = -4.0, double yMax = -2.5, double pTmin = 10.0, double pTmax = 80.0) {
	auto trigger = [flavour, yMin, yMax, pTmin, pTmax](const std::vector<TParticle>& particles) -> bool {
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
        Int_t muMotherFlavour = GetFlavour(mpdg);
				if (muMotherFlavour == flavour) return kTRUE; // has HF as mother -> accept event
			};
		};
		return kFALSE;
	};
	return trigger;
};

Int_t GetFlavour(Int_t pdgCode)
{
  //
  // return the flavour of a particle
  // input: pdg code of the particle
  // output: Int_t
  //         3 in case of strange (open and hidden)
  //         4 in case of charm (")
  //         5 in case of beauty (")
  //
  Int_t pdg = TMath::Abs(pdgCode);
  // Resonance
  if (pdg > 100000)
    pdg %= 100000;
  if (pdg > 10000)
    pdg %= 10000;
  // meson ?
  if (pdg > 10)
    pdg /= 100;
  // baryon ?
  if (pdg > 10)
    pdg /= 10;
  return pdg;
}