ppm = (-2500:100:2500)/(42.576*7.0);

p1331=load('~/Documents/bruker4/7T/phantum-June02-2014/P1331_450/p1331_BSA.mat');
cest =load('~/Documents/bruker4/7T/phantum-June02-2014/Delay_CEST_450/spacer_CEST_BSA.mat');

power= [ 6.7627, 6.7627  ];
ncyc = [ 0, 10 ];


pwrSer{1}=CEST_data( ppm(2:end), cest.c(2:end), power(1) );
pwrSer{2}=CEST_data( ppm(2:end), p1331.c(2:end), power(2) );



s1=Spin( 0.87,    208.1518,   0.0160, [0 0 8.9121e+03]);  %water
s2=Spin(  1.1,  2.7523e+03,  -3.3560, [0 0 7.1764e+03]);
s3=Spin(  1.1,  2.9409e+03,   2.3500, [0 0 4.1366e+03]);


sim=ZSpecBlochSim( s1, s2, s3);
sim.add_kex(2,1,   0.4159,  0.1,  5);
sim.add_kex(3,1, 324.2453,  2, 400);


s1.opt_vals('R1') = 0; s1.set_lb_ub('R1', 0.5, 1.1); 
s2.opt_vals('R1') = 0; s2.set_lb_ub('R1', 0.8, 2);  
s3.opt_vals('R1') = 0; s3.set_lb_ub('R1', 0.8, 2); 

s1.opt_vals('R2') =  1; s1.set_lb_ub('R2',5, 500); 
s2.opt_vals('R2') =  0; s2.set_lb_ub('R2',  2.5e3, 3.8e3); 
s3.opt_vals('R2') =  1; s3.set_lb_ub('R2',  1e3,  1.9e4);


s1.opt_vals('c') =  1; s1.set_lb_ub('c',  1e3,  8e4 );
s2.opt_vals('c') =  1; s2.set_lb_ub('c',  1e2,  1e5 );
s3.opt_vals('c') =  1; s3.set_lb_ub('c',  1e2,  1e4 );


s1.opt_vals('x') =  1; s1.set_lb_ub('x',-0.2,0.2);
s2.opt_vals('x') =  0; s2.set_lb_ub('x',-5.0, -3.2);
s3.opt_vals('x') =  1; s3.set_lb_ub('x', 2.4, 2.8);

fit = FitGlobalp1331(sim, ncyc, 3.0, pwrSer{1:end});



