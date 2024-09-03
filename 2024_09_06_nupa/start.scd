(
"SC_JACK_DEFAULT_INPUTS".setenv("");
//"SC_JACK_DEFAULT_OUTPUTS".setenv("");

s.options.numBuffers = 1024 * 32; // increase this if you need to load more samples
s.options.memSize = 8192 * 32; // increase this if you get "alloc failed" messages
s.options.maxNodes = 1024 * 32; // increase this if you are getting drop outs and the message "too many nodes"
s.options.numOutputBusChannels = 2; // set this to your hardware output channel size, if necessary
s.options.numInputBusChannels = 2;

s.options.maxLogins=4;

s.freeAll;

s.waitForBoot {
	~dirt = SuperDirt(2, s); // two output channels, increase if you want to pan across more channels
	~dirt.loadSoundFiles;   // load samples (path containing a wildcard can be passed in)
	s.sync;
	// load samples (path containing a wildcard can be passed in)
	~dirt.loadSoundFiles("/home/diegodorado/Music/samples/long-samples/*");
  ~dirt.loadSoundFiles("/home/diegodorado/Music/samples/trap-samples/*");
  ~dirt.loadSoundFiles("/home/diegodorado/Music/samples/misc-samples/*");
	~dirt.loadSoundFiles("/home/diegodorado/Music/samples/long-samples/*");
	~dirt.loadSoundFiles("/home/diegodorado/Music/samples/boehmer-samples/*");

  s.sync; // wait for samples to be read
	~dirt.start(57120, 0!8);

  MIDIClient.init(0,1);

  // first sc midi out forwards tidal midi events
  m = MIDIOut(0);
  m.latency = 0.0;
  ~dirt.soundLibrary.addMIDI(\midi, m);

  //create a bus for each orbit
  ~busses = ~dirt.orbits.collect { |each|
    var bus = Bus.audio(~dirt.server, ~dirt.numChannels);
    each.outBus = bus;
    bus
  };

  Ndef(\mix, {
    arg delay=0.2,thresh=0.006, slopeBelow=1, slopeAbove=0.2, clampTime=0.01, relaxTime=0.1,
    sidechainWet = 0.5;
    var wet;
    var ins = In.ar(SoundIn.channelOffset,2);
    // get orbits signals
    var all = ~busses.collect { |b| InBus.ar(b, 2) };
    // take kick out
    var kick = all.removeAt(0);
    //  delay orbits signals and sum them
    var sig = all.sum { |o| DelayN.ar(o,1.0,delay)};
    // delay kick also
    kick = DelayN.ar(kick,1.0,delay);
    // sum external audio
    sig = sig+ins;
    //get sidechain control signal from first kick
    wet = Compander.ar(sig, kick.sum, thresh:thresh, slopeBelow:slopeBelow, slopeAbove: slopeAbove, clampTime:clampTime, relaxTime:relaxTime);
    sig = (sig *(1-sidechainWet)) + (wet*sidechainWet) + kick;
    Out.ar(0,sig);
  }).play;

  "/home/diegodorado/Music/tidal/tidal-synths/loadAll.scd".load();

};

s.latency = 0.3;
Ndef(\mix).set(\delay, 0.03 );
);


(
Ndef(\mix).set(\delay, 0.03 );
)

(
s.latency = 0.3;
  m.latency = 0.0;
)
