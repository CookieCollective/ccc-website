(
SynthDef(\cookie, {
	arg freq=220, sp=1, d=1, amp=(-5), out=0, atk=0.001, rel=0.2, c0=(-4), c1=4, imp=1, pan=0, ratio=500, pitch=1, fx, mult=1, rq=1;
	var sig, env, force;

	env = EnvGen.kr(Env.new([0,1,0],[atk,rel], [c0,c1]),doneAction:2);

	force = K2A.ar(Impulse.ar(imp).lag(0.1)) > 0;
	force = Spring.ar(force, sp.lag(2), d.lag(2));

	freq = force * ratio + freq;
	sig = SinOsc.ar(freq * 2, 0.01) + LFCub.ar(freq*1.1,mul:0.1);
	sig = Splay.ar(sig, 1).tanh;
	sig = Limiter.ar(sig, 0.1).tanh;
	// sig = RLPF.ar(sig, freq*1.5,rq);
	sig = sig * env * amp.dbamp;
	sig = Balance2.ar(sig[0],sig[1],pan.lag(5));
	// sig = Pan2.ar(sig);
	Out.ar(fx, sig);
	Out.ar(out,sig);
}).add;

SynthDef(\fx, {
	arg in, out=0, amp=(-5), pitch=1, del=1;
	var sig;

	sig = In.ar(in,2);
	sig = DelayL.ar(sig, 1, del.lag(2));
	sig = CombL.ar(sig, 0.5, LFNoise2.ar(0.2).linlin(-1,1,0.001,0.01),1,1);
	sig = PitchShift.ar(sig, 0.2, pitch.lag(3)).tanh;
	sig = sig * amp.dbamp;
	Out.ar(out, sig);
}).add;
)

b = Bus.audio(s,2);
c = Bus.audio(s,2);
~verb = Bus.audio(s,2);

(
~fxh = Synth.new(
	\fx,
	[
		\in, b,
		\out, ~verb,
		\amp, -5,
		\dw, -1
	]
);

~fxl = Synth.new(
	\fx,
	[
		\in, c,
		\out, 0,
		\amp, 0,
		\dw, -1
	]
);
)

// j'arrive pas à avoir une bonne reverb dans SC alors j'utilise la supermassive de valhalla, pas très vanilla tous ca :x
(
~vstMassiveSynth = VSTPluginController(Synth(
			\vstMassive,
			[
				\in, ~verb,
				\out, 0,
			]
		), id: \vstMassive);
)

~vstMassiveSynth.open("ValhallaSupermassive", editor: true, verbose:true);
~vstMassiveSynth.editor;

//routine aléatoire
(
~high.stop;
~high = Routine{
inf.do{
	~h = Synth(\cookie, [
			\d, rrand(1,1000)/100000,
			\sp, rrand(2,60).round(0.1),
	\pan, 0,
			\atk, rrand(4,7).round(0.1),
			\imp, 0.02,
	\c0, 4,
			\rel, rrand(0.5,2).round(0.1),
	\amp,-15,
			\pan,0.2,
			\freq, rrand(1500,3000).round(10),
			\ratio, rrand(30,600).round(10),
	\fx, b
]);
		rrand(3,8).wait;
	};
}.play;
)
(
~high.stop;
~grave = Routine{
inf.do{
	~h = Synth(\cookie, [
			\d, rrand(1,1000)/10000,
			\sp, rrand(40,60).round(1),
	\pan, 0,
			\atk, rrand(1,3).round(0.1),
			\imp, 0.02,
	\c0, 4,
			\rel, rrand(2.5,6).round(0.1),
	\amp,-10,
			\pan,-0.2,
			// \rq,0.2,
			\freq, rrand(20,90).round(1),
			\ratio, rrand(600,800).round(10),
	\fx, b
]);
		rrand(5,8).wait;
	};
}.play;
)
(
~low.stop;
~low = Routine{
2.do{
	~l = Synth(\cookie, [
			\d, rrand(1,1000)/100000,
			\sp, rrand(0.5,0.0001).round(0.0001),
	\pan, 0,
			\atk, rrand(0.002,0.01).round(0.001),
			\imp, rand(0.1,1.5).round(0.1),
	\c0, -4,
			\rel, rrand(0.2,1).round(0.1),
	\amp,0,
			\freq, rrand(50,250).round(1),
			\ratio, rrand(1,60).round(1),
	\fx, c
]);
		0.01.wait;
		~l.set(\pan, rrand(-1,1));
		rrand(0.2,1).wait;
	};
}.play;
)
(
~trait.free;
~trait = Routine{
	inf.do{
		~fxh.set(\del, rrand(0.1,5).round(0.1));
		~fxh.set(\pitch, rrand(0.98,1.02).round(0.001));
		~fxl.set(\del, rrand(0.01,15).round(0.01));
		~fxl.set(\pitch, rrand(0.2,5).round(0.1));
		rrand(0.1,1).wait;
	};
}.play;
)

~fxh.set(\amp, -15);


(
~x = Synth(\cookie, [
	\d, 0.000001,
	\sp, 0.01,
	\pan, 0,
	\atk, 2.5,
	\imp, 0.8,
	\c0, 4,
	\rel, 1.5,
	\amp,0,
	\freq, 120,
	\ratio, 50,
	\fx, b
]);
)
