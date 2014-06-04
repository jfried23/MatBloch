%o1=[-3200:20:3200];
o1=[-8:.05:8]*400;
b1=[75];

s1=Spin( 2.0,  30,  0,   [ 0 0 110  ]);
s2=Spin( 1.0,  50,  5,   [ 0 0  .05  ]);
s3=Spin( 1.0, 500, -5,   [ 0 0   1  ]);

sim=ZSpecBlochSim( s1, s2, s3);
sim.add_kex(3,1,  5);

ncycle= [1:1:20];
rates = [40];
cyc=1;
v=zeros(length(rates),length(o1));


i=1;
    
for kex=rates
        sim.add_kex(2,1,  kex);
        
        seq=gen_cest(1.0,b1(1));
        v(i,:) = sim.run(seq, b1, o1);
        
        %seq =gen_p1331(1.0, b1(1), cyc);
        %v(i,:) = sim.run(seq, b1, o1);
        
        i=i+1;    
end
    

plot(o1,v)
%ylim([0,1])