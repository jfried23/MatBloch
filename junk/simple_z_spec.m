o1=-12:.1:12;
s1=Spin( 2.0,  20,  0,   [ 0 0   1  ]);
s2=Spin( 1.0,  50,  5,   [ 0 0   1 ]);

sim=ZSpecBlochSim( s1, s2 );
sim.add_kex(2,1,  10);

cest_seq = gen_cest(1, 70);
z=sim.run( cest_seq, [120], o1*400);

plot(o1, z); 
