
base_path = '/Users/josh/Documents/bruker4/weiqi/022814-20%BSA/';
dirs = [ 1 2 3 4 ];
power= [ 60 60 60 60  ];
ncyc = [ 0 1 2 5];


pwrSer = cell(1,length(dirs));

for i=1:length(dirs)
    pwrSer{i}=CEST( fullfile(base_path, num2str( dirs(i) )), power(i) );
end

s1=Spin( 0.87,      9.9171,   0.0565,   [0 0 3.0774e+07]);  %water
s2=Spin(  1.1,  3.8940e+03,  -3.7994,   [0 0 3.2226e+05]);
s3=Spin(  1.1,  1.9362e+03,   2.5833,   [0 0 6.4019e+05]);
s4=Spin( 0.87,  2.8431e+04,      0.0,   [0 0 8.7493e+05]);

sim=ZSpecBlochSim( s1, s2, s3, s4 );
sim.add_kex(2,1, 15.2256, 2, 50);
sim.add_kex(2,3, 13.4067, 1, 50);
sim.add_kex(3,1, 396.8694,1, 400);

sim.add_kex(4,1, 1.1058e+03, 100, 1e9 );
%sim.add_kex(3,4, 396.8694,1, 400);
%sim.add_kex(2,4, 15.2256, 2, 50);

%sim.add_kex(2,4, 10, 2, 50);
%sim.add_kex(3,4, 60, 1, 400);

s1.opt_vals('R1') = 0; s1.set_lb_ub('R2', 0.5, 1.1); 
s2.opt_vals('R1') = 0; s2.set_lb_ub('R2', 0.8, 2);  
s3.opt_vals('R1') = 0; s3.set_lb_ub('R2', 0.8, 2); 
s4.opt_vals('R1') = 0;

s1.opt_vals('R2') =  1; s1.set_lb_ub('R2',5, 35); 
s2.opt_vals('R2') =  1; s2.set_lb_ub('R2', 100, 5000); 
s3.opt_vals('R2') =  1; s3.set_lb_ub('R2',  100, 1e5);
s4.opt_vals('R2') = 1; s4.set_lb_ub('R2', 1.0e3, 1.0e9);


s1.opt_vals('c') =  1; s1.set_lb_ub('c',  1e4,  1e8 );
s2.opt_vals('c') =  1; s2.set_lb_ub('c',  1e3,  1e6 );
s3.opt_vals('c') =  1; s3.set_lb_ub('c',  1e3,  1e6 );
s4.opt_vals('c') = 1; s4.set_lb_ub('c', 1.0e3, 1.0e9);


s1.opt_vals('x') =  1; s1.set_lb_ub('x',-0.1,0.1);
s2.opt_vals('x') =  1; s2.set_lb_ub('x',-5.0, -2.2);
s3.opt_vals('x') =  1; s3.set_lb_ub('x', 1.2, 3.2);
s4.opt_vals('x') =  1; s4.set_lb_ub('x',-4,1);


fit = FitGlobalp1331(sim, ncyc, 3.0, pwrSer{1:end});

%[x,f] = fit.run
%fit.run_sim_anneal()
%[x,f]=fit.run
%fit.run_lsqcurvefit_with_b1_opt()
fit.run_lsqcurvefit()
%fit.run_unbound_lsqcurvefit_with_b1_opt()

fit.plot_data

