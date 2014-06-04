clear; clc;

o1_list = -3200:200:3200;
time=0.0:1.e-6:50e-3;

zspec=zeros( 1, length(o1_list) );
spec =zeros( 1, length(time) ); 

s1=Spin( 0.5,  10,  0,   [ 0 0 1 ]);
s2=Spin( 2,    600,  5,   [ 0 0 .001 ]);
s3=Spin( 2,    600, -5,   [ 0 0 .006 ]);

sim=BlochSim( s1, s2, s3);
sim.add_kex(2,1,  200 );
sim.add_kex(3,1,   0 );

seq=gen_cest(1.0,33);


                
for io=1:length(o1_list)               
    for spn = sim.spins, spn.reset(); end
              
    for pls=seq.sequence                
        if isa(pls{1}, 'CW')               
            pls{1}.B1_ = 100;                
            pls{1}.o1_ = o1_list(io);                
        end    
    end
    M= sim.run(seq);                
    zspec(1,io) = M(3);          
    zspec(1,:) = zspec(1,:) - zspec(1,1);
end
          
plot(o1_list, zspec, 'o')

%{
for t=1:length(time)
    

    for spn = sim.spins, spn.reset(); end


    p90=PulseSequence();
    p90.add(RGPulse( 90, 10.e-6, 0) );
    p90.add(Delay( time(t) ) );
    p90.add(END());
    

    M= sim.run(p90);  
    spec(1,t)=complex(M(1),M(2))+complex(M(4),M(5))+complex(M(7),M(8));

end

plot(real(spec))
%}
