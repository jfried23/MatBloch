offsets = -12:.1:12;

points=[1 2 3 4 5 6];

exp=zeros(length(points),length(offsets));

i=1;
for pts=points
    pp = 10e-9;
    d19 = 1/(2*( pts )*400);
    pulse_seq = PulseSequence();
    pulse_seq.add( Delay(10) );
    pulse_seq.add( RGPulse(90*0.125,pp,  0) );
    pulse_seq.add( Delay(d19) );
    pulse_seq.add( RGPulse(90*0.375,pp,180) );
    pulse_seq.add( Delay(d19) );
    pulse_seq.add( RGPulse(90*0.375,pp,  0) );
    pulse_seq.add( Delay(d19) );
    pulse_seq.add( RGPulse(90*0.125,pp,180) );
    pulse_seq.add( END() );

    ii=1;
    for o = offsets
        s = Spin( 1e-9, 20, o,   [ 0 0   1  ]);
        sim=BlochSim( s );
        sim.run(pulse_seq);
    
        exp(i,ii) = sqrt((s.Iy^2) + (s.Ix^2));
        ii=ii+1;
    end
    
    i=i+1;
end
clf;
plot(offsets, exp); hold;