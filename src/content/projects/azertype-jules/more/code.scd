1.
//saturation
SynthDef(\satu, {
    arg in, amp=(-5), out=0, saturation=1.1, mix=0, freqLpf=10000, freqHpf=40;
    var dry, wet, sig;

    dry = In.ar(in, 1);
    wet = (dry * saturation).tanh(1);

    sig = XFade2.ar(dry, wet, mix*2-1);
    sig = LPF.ar(sig, freqLpf);
    sig = HPF.ar(sig, freqHpf);
    sig = sig*amp.dbamp.lag(2);

    Out.ar(out,sig);
}).add;

2.
// BickWall
SynthDef(\brickWall,{
    arg in, amp=(-5), wipe=0, mix=0.5, out=0;
    var dry, wet, sig, chain, size=2048;

    dry = In.ar(in, 1);

    chain = FFT(LocalBuf(size, 1).clear, dry);
    chain = PV_BrickWall(chain, wipe);
    wet = IFFT(chain);

    sig = XFade2.ar(dry, wet, mix*2-1, amp.dbamp.lag(1));

    Out.ar(out, sig);
}).add;

3.
//Delay
//à styliser avec une enveloppe || spatialiser
SynthDef(\delay, {
    arg in, out=0, amp=(-5), mix=0.3, decay=3, min=0.3;
    var sig, dry, wet;

    dry = In.ar(in, 1);
    // wet = CombL.ar(dry, 0.5, LFNoise2.kr(0.2).linlin(-1,1, minDel+0.001,minDel+(minDel*3)), decay);

    wet = dry + CombL.ar(dry, 0.5, (min.lag(3) + (LFNoise2.kr(0.5).linlin(-1,1,0.001,0.01)).lag(2)), decay, 0.8);
    // wet = PanAz.ar(wet,  LFNoise2.kr(1).linlin(-1,1,-0.2,1.2));

    sig = XFade2.ar(dry, wet, mix*2-1, amp.dbamp.lag(1));
    // sig = Pan2.ar(sig);

    Out.ar(out,sig);
}).add;

4.
// PitchShift
SynthDef(\pitchShift, {
    arg in, predelay=0.1, pitch=1, lpf=4500, mix=0, amp=(-5), out=0;
    var dry, wet, temp, sig;

    dry = In.ar(in, 1);
    wet = PitchShift.ar(dry, 0.2, revtime.lag(1));
    sig = XFade2.ar(dry, wet, mix*2-1, amp.dbamp.lag(1));
    // sig = wet *amp.dbamp.lag(1);

    Out.ar(out,sig);
}).add;

 // Voilà les bus et le chaînage

~bus = Dictionary.new;
~bus.add(\pitch -> Bus.audio(s, 1));
~bus.add(\fftBrick -> Bus.audio(s, 1));
~bus.add(\delay -> Bus.audio(s, 1));
~bus.add(\satura -> Bus.audio(s, 1));
~saturationGrp = Group.after(~granGrp); // j’ai d’’autres bus dans le projet il faut remplacer “~granGrp”.
~brickWallGrp = Group.after(~saturationGrp);
~delayGrp = Group.after(~brickWallGrp);
~pitchGrp = Group.after(~delayGrp);

~saturator = Synth.new(
   		 \satu,
   		 [
   			 \amp, 0,
   			 \saturation, 15,
   			 \freqLpf, 10000,
   			 \in, ~bus[\satura],
   			 \out, ~bus[\fftBrick],
   		 ],
   		 ~saturationGrp
   	 );

   	 ~brickWallSynth = Synth.new(
   		 \brickWall,
   		 [
   			 \amp, 0,
   			 \wipe, -0.99,
   			 \in, ~bus[\fftBrick],
   			 \out, ~bus[\delay],
   		 ],
   		 ~brickWallGrp
   	 );

   	 ~delaySynth = Synth.new(
   		 \delay,
   		 [
   			 \amp, 0,
   			 \decay, 3,
   			 \mix, 0,
   			 \min, 0.3,
   			 \in, ~bus[\delay],
   			 \out, ~bus[\pitch],
   		 ],
   		 ~delayGrp
   	 );

   	 ~reverbSynth = Synth.new(
   		 \pitchShift,
   		 [
   			 \amp, -3,
   			 \pitch, 1,
   			 \lpf, 4500,
   			 \mix, 0,
   			 \in, ~bus[\reverb],
   			 \out, ~bus[\masterSamples], // c’est un bus pour faire la spatialisation après, tout est en mono pour le moment ! on peu remplacer simplement 0 pour entendre à gauche
   		 ],
   		 ~pitchGrp
   	 );

Je déclenche aléatoirement les familles de samples avec plusieurs bouton midi sur mon launch control XL, et joue les effets avec. exemple de mapping midi (sample et effets)


{num==59 && val==127 && chan==4}{e[\sample27].value;"zombie".postln;}

e.add(\sample27 -> {(
   	 Synth(\lectechant, [
   		 \buf, ~buffers[\zombie][(0..4).choose],
   			 \loop, 0,
   			 \out, ~bus[\satura],
   			 \amp, 0,
   		 ], ~mainGrp);
    )});


//wipe du filtre brickWall
   	 if(ccNum == 55 /*&& channel == 1*/, {
   		 ~wipeBrick = val.linexp(0, 127, -0.5, -0.995).round(0.001) ;
   		 ~brickWallSynth.set(\wipe, ~wipeBrick);
   		 "wipe brick".postln;
   		 ~wipeBrick.postln;
   	 });
