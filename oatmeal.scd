//[oatmeal].

//r.mcmasters


// To play this piece, click Language -> Evaluate File, read the instructions on the first page, then click "play."

s.boot;
s.waitForBoot{

	SynthDef(\keytone, {
		arg keyfreq,amp=0.9,dur=2.0;
		var sin, env, delay,pan;
		env = XLine.kr(amp,0.001,dur,doneAction:2);
		sin = Pulse.ar((keyfreq).midicps/[4,2], mul:env);
		delay = AllpassC.ar(sin,0.5,[0.5,0.75,0.25],5);
		pan = Pan2.ar(delay,TRand.ar(-1,1,Dust2.ar(10)));
		Out.ar(0,[sin,pan]);
	}).load(s);

	w = Window.new("[oatmeal].", Rect(100, 100, 600, 600))
	.background_(Color.black)
	.front
	.alwaysOnTop_(true)
	.view.keyDownAction = {
		arg view, char, modifiers, unicode, keycode;
		[char, unicode, keycode].postln;
		~x = Synth(\keytone, [\keyfreq,(unicode-44)]);
		~x.set(\keyfreq,(unicode-44));
	};

	~textbox = StaticText(w, Rect(50, 250, 500, 310))
	.align_(\center)
	.string_("Type the words that appear in time with the blinking corners.")
	.stringColor_(Color.white)
	.background_(Color.black)
	.font_(Font(size:24));

	~metsize = 100;
	~metcolor = Color.cyan(0.75);
	~metLU = StaticText(w, Rect(0, 0, ~metsize, ~metsize));
	~metLD = StaticText(w, Rect(0, 500, ~metsize, ~metsize));
	~metRU = StaticText(w, Rect(500, 0, ~metsize, ~metsize));
	~metRD = StaticText(w, Rect(500, 500, ~metsize ,~metsize));

	~button1 = Button(w, Rect(125, 50, 350, 100))
	.states_([
		["play", Color.grey, Color.black],
		["stop", Color.grey, Color.black],
		["close"]
	])
	.font_(Font(size:72))
	.action_({
		arg obj;
		if(
			obj.value ==1,
			{

				AppClock.sched(0.0, Routine(
					{
						loop{
							~metLU.background_(Color.black);
							~metRU.background_(~metcolor);
							~metLD.background_(~metcolor);
							~metRD.background_(Color.black);
							0.5.wait;
							~metLD.background_(Color.black);
							~metRD.background_(~metcolor);
							~metLU.background_(~metcolor);
							~metRU.background_(Color.black);
							0.5.wait;
						}
					}
				)
				);

				AppClock.sched(0.0, Routine(
					{[3,2,1].do{
						arg counter;
						~textbox.string_(counter)
						.font_(Font(size:96))
						.stringColor_(~metcolor);
						1.0.wait;}}));

				AppClock.sched(3.0, Routine(
					{[
						"me",
						"he",
						"she",
						"the",
						"aft",
						"hat",
						"cat",
						"cafe",
						"coffee",
						"taffy",
						"left",
						"heft",
						"heat",
						"eat",
						"oat",
						"oatmeal",
						"team",
						"tea",
						"am",
						"a"

					].do{
						arg word;
						~textbox.string_(word).stringColor_(Color.white);
						15.0.wait;

						[1.0, 0.75, 0.25, 0.0].do{
							arg counter1;
							~textbox.stringColor_(Color.grey(counter1));
							0.5.wait;};
					}
					}
				)
				);
			};
		);

		if(
			obj.value ==2,
			{Window.closeAll});

	});
}
