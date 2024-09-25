(
~freqMin_ = 200.0;
~freqMax_ = 3000.0;
~notes = [38, 48, 58, 64];
s.waitForBoot({
	~divagation_divagation = Routine({
		var waitTime = 1;
		SynthDef(\divagation, {
			var sig, lpf_freq = \lpf_freq.kr(300), lpf_rq = 0.4,
			freq_modRate = \freq_modRate.kr(4), pan = 0.0, env, env2, sig2;
			sig = WhiteNoise.ar(0.8) + SinOsc.ar(\sineFreq.kr(400), mul: 0.5);
			sig2 = Pulse.ar(40 + LFNoise1.kr(1, mul:2.0));
			sig2 = RLPF.ar(sig2, 50, 0.3);
			env = Env.new(levels: [0.0, 1, 0.0], times: [0.5, \dur.kr(1)], curve: [-5, -1]);
			env2 = Env.new(levels: [0.0, 1, 0.0], times: [0.01, 0.5], curve: [-5, -1]);
			lpf_freq = LFNoise0.kr((LFNoise0.kr(freq_modRate)*30)).range(\freqMin.ir(300), \freqMax.ir(1000));
			lpf_rq = LFNoise0.kr(freq_modRate + 20 + 0.6).range(0.1, 0.9);
			pan = LFNoise2.kr(10).range(-1.0, 1.0);
			sig = RLPF.ar(sig, lpf_freq, lpf_rq);
			sig = Pan2.ar(sig, pan);
			sig = (sig * \amp.kr(1) * EnvGen.kr(env, doneAction: 2)) + (sig2 * EnvGen.kr(env2) * 0.10);
			sig = sig * LFNoise0.kr(5, 0.5, 0.5);
			sig = sig * -15.dbamp;
			Out.ar(0, sig);
		}).add;
		s.sync;
		30.do{
			Synth(\divagation, [
				\freqMin, exprand(100, ~freqMin_),
				\freqMax, exprand(~freqMin_, ~freqMax_),
				\amp, -10.dbamp.rand,
				\freq_modRate, rrand(2.0, 45.0),
				\lpf_freq, exprand(200.0, 500.0),
				\dur, rrand(1.0, 1.5),
				\sineFreq, ~notes.midicps.choose
			]);
			0.02.rand.wait;
			s.sync;
		};
		inf.do{
			~freqMax_ = exprand(1000.0, 3000.0);
			~notes[~notes.size-1] = [64, 68, 71, 72, 78].choose;
			20.do{
				Synth(\divagation, [
					\freqMin, exprand(20, ~freqMin_),
					\freqMax, exprand(~freqMin_, ~freqMax_),
					\amp, -10.dbamp.rand,
					\freq_modRate, rrand(2.0, 45.0),
					\lpf_freq, exprand(100.0, 400.0),
					\dur, rrand(1.0, 1.5),
					\sineFreq, ~notes.midicps.choose
				]);
				if( 100.rand > 80 ) { waitTime = 0.07.rand } { waitTime = 0.001.rand };
				waitTime.wait;
			};
			1.do{
				Synth(\divagation, [
					\freqMin, exprand(20, ~freqMin_),
					\freqMax, exprand(~freqMin_, ~freqMax_),
					\amp, -10.dbamp.rand,
					\freq_modRate, rrand(2.0, 45.0),
					\lpf_freq, exprand(100.0, 400.0),
					\dur, rrand(1.0, 1.5),
					\sineFreq, ~notes.midicps.choose
				]);
				if( 100.rand > 80 ) { waitTime = 0.3.rand } { waitTime = 0.1.rand };
				waitTime.wait;
			};
		};
	}).play;
});
)