clear;


pwr= 70;
k_NOE=1;


tofs=[ 1e6 -3.5*400  3.5*400]; %MEASURE Peak Height at these positions

cest_range=-3200:40:3200;
ncycles=0:5:100;

cest_seq=PulseSequence();
cest_seq.add( Delay(1100) );
cest_seq.add( CW( 1, 30, 0) );
cest_seq.add( END() );

s1=Spin( 0.7,    20,      0.00,     [0 0 1.000]);
s2=Spin( 2.2,    20,      3.50,     [0 0 0.002]);
s3=Spin( 2.2,    20,     -3.50,     [0 0 0.002]);

sim = ZSpecBlochSim( s1, s2, s3 );
sim.add_kex(2, 1, k_NOE*10);
sim.add_kex(3, 1, k_NOE);


cest=zeros(1,length(ncycles));
noe =zeros(1,length(ncycles));

for i=length(ncycles)

    if i==1
        result = sim.run(cest_seq, pwr, tofs);
        result=result(3,:);
        
        cest(i) = 100*(1-(result(3)/result(1)));
        noe(i)  = 100*(1-(result(2)/result(1)));
    else
        result = sim.run(gen_p1331(1.0, ncycles(i)), pwr, tofs);
        result=result(3,:);
            
        cest(i) = 100*(1-(result(3)/result(1)));
        noe(i)  = 100*(1-(result(2)/result(1)));
    end    
    

end

plot(ncycles, noe,'o' );
plot(ncycles, cest,'d' );
