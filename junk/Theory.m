clear;

pwr_levels = [30, 40, 50, 60, 70, 80, 90, 100, 120];
cest_range=[3200,0,-3200];
ncycle=[ 1 5 10 20 40 80];

results=zeros(length(ncycle),length(cest_range));

for pwr=pwr_levels

    cest_seq=PulseSequence();
    cest_seq.add( Delay(10) );
    cest_seq.add( CW( 1, 30, 0) );
    cest_seq.add( END() );

    s1=Spin( 0.7,   17.1971,     0.00,      [0 0 1.00]);
    sim = ZSpecBlochSim( s1 );
    
    i=1;
    
    
    for cyc=ncycle
        p  = gen_p1331( 1.0, pwr, cyc);
        run = sim.run(p, pwr, cest_range);
        results(i,:)= run;
        i=i+1;
    end
end

