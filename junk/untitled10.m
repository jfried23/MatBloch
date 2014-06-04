%Integration Test of p1331 Selective Excitation pulse
clear;
clc;

s1=Spin( 4,  7,   0,   [0 0 1]);
s2=Spin( 4,  7,   5,   [0 0 1]);


sim = BlochSim( s1, s2 );
sim.add_kex(2,1, 0);
seq=PulseSequence();

d19 = 1/(2*5*400);

seq.add( Delay(10) );
seq.add( RGPulse(90*.125,9e-6,   0) );
seq.add( Delay(d19) );
seq.add( RGPulse(90*.375,9e-6, 180) );
seq.add( Delay(d19) );
seq.add( RGPulse(90*.375,9e-6,   0) );
seq.add( Delay(d19) );
seq.add( RGPulse(90*.125,9e-6, 180) );
seq.add( END() );

sim.run( seq );
