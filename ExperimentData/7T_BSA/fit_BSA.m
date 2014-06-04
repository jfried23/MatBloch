ppm = (-2500:100:2500)/(42.576*7.0);

p1331=load('~/Documents/bruker4/7T/phantum-June02-2014/P1331_450/p1331_BSA.mat');
cest =load('~/Documents/bruker4/7T/phantum-June02-2014/Delay_CEST_450/spacer_CEST_BSA.mat');

power= [ 9.6606, 9.6606  ];
ncyc = [ 0, 10 ];


pwrSer{1}=CEST_data( ppm(2:end), cest.c(2:end), power(1) );
pwrSer{2}=CEST_data( ppm(2:end), p1331.c(2:end), power(2) );



s1=Spin( 0.87,     83.5633,   0.0228, [0 0 7.0161e+03]);  %water
s2=Spin(  1.1,  2.7523e+03,  -3.3560, [0 0 1.5191e+03]);
s3=Spin(  1.1,  2.4444e+03,   2.5014, [0 0 1.3308e+03]);
s4=Spin(  1.1,  1.2381e+03,   0.2048, [0 0 1.6267e+03]);


sim=ZSpecBlochSim( s1, s2, s3, s4);
sim.add_kex(2,1,  2.1302,  0.5,  5);
sim.add_kex(3,1, 58.9646,  2, 100);
sim.add_kex(4,1, 158.3464,  0, 1e6);

s1.opt_vals('R1') = 1; s1.set_lb_ub('R1', 0.5, 1.1); 
s2.opt_vals('R1') = 1; s2.set_lb_ub('R1', 0.8, 2);  
s3.opt_vals('R1') = 1; s3.set_lb_ub('R1', 0.8, 2); 
s4.opt_vals('R1') = 1; s3.set_lb_ub('R1', 0.8, 2); 

s1.opt_vals('R2') =  1; s1.set_lb_ub('R2',5, 90); 
s2.opt_vals('R2') =  0; s2.set_lb_ub('R2',  2.0e3,  5e4); 
s3.opt_vals('R2') =  0; s3.set_lb_ub('R2',  1e3,  1.9e4);
s4.opt_vals('R2') =  1; s3.set_lb_ub('R2',  100,  1.9e5);


s1.opt_vals('c') =  1; s1.set_lb_ub('c',  1e2,  1e4 );
s2.opt_vals('c') =  1; s2.set_lb_ub('c',  1e2,  1e4 );
s3.opt_vals('c') =  1; s3.set_lb_ub('c',  1e2,  1e4 );
s4.opt_vals('c') =  1; s3.set_lb_ub('c',  1e2,  1e4 );


s1.opt_vals('x') =  0; s1.set_lb_ub('x',-0.2,0.2);
s2.opt_vals('x') =  0; s2.set_lb_ub('x',-4.6, -3.0);
s3.opt_vals('x') =  0; s3.set_lb_ub('x', 2.5, 2.8);
s4.opt_vals('x') =  1; s3.set_lb_ub('x', -4, 4);

fit = FitGlobalp1331(sim, ncyc, 3.0, pwrSer{1:end});



