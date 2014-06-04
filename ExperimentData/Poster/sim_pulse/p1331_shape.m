peak_loc = 3;

offsets = -12:.1:12;

pp = 10e-9;
d19 = 1/(2*( peak_loc )*400);
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

exp=zeros(1,length(offsets));
expz=zeros(1,length(offsets));
i=1;

for o = offsets
    
    
    s = Spin( 1e-9, 20, o,   [ 0 0   1  ]);

    
    sim=BlochSim( s );
    sim.run(pulse_seq);
    
    exp(i) = sqrt((s.Iy^2) + (s.Ix^2));
    expz(i)= s.Iz;
    i=i+1;
end
clf;
plot(offsets, exp, 'r'); hold;

rates = [1, 2, 5, 10, 20, 40, 60, 100, 200];
v=zeros(length(rates),length(offsets));
v1=zeros(length(rates),length(offsets));

s1=Spin( 2.0,  30,         0,   [ 0 0   1  ]);
s2=Spin( 1.0,  50,  peak_loc,   [ 0 0   2/110 ]);

sim=ZSpecBlochSim( s1, s2);
cest_seq = gen_cest(1, 70);
i=1;
for kex=rates
        sim.add_kex(2,1,  kex);
        
        seq=gen_cest(1.0, 75 );
        v(i,:) = sim.run(seq, 75, offsets*400)+1;
        
        i=i+1;    
end

i=1;
for kex=rates
        sim.add_kex(2,1,  kex);
        
        seq=gen_p1331(1, 75, 10, 5);
        v1(i,:) = sim.run(seq, 75, offsets*400)+1;
        
        i=i+1;    
end


plot(offsets, v1);
xlim([-10,10])

