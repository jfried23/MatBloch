
base_path = '/Users/josh/Documents/bruker4/weiqi/022814-20%BSA/';
dirs = [ 1 2 3 4 ];
power= [ 63 63 63 63  ];
ncyc = [ 0 1 2 5];


pwrSer = cell(1,length(dirs));

for i=1:length(dirs)
    pwrSer{i}=CEST( fullfile(base_path, num2str( dirs(i) )), power(i) );
end

s1=Spin( 0.87,      25.4732,   0.0572,  [0 0 2.9230e+07] );  %water
s2=Spin( 1.10,   2.2126e+03,  -3.7913,  [0 0 2.8538e+05] );
s3=Spin( 1.10,   1.8039e+03,   2.5955,  [0 0 7.6583e+05] );
s4=Spin( 0.87,   2.8439e+04,  -2,  [0 0 8.7391e+05] );

sim=ZSpecBlochSim( s1, s2, s3, s4);

sim.add_kex(2,1,  14.1790, 0, 20);
sim.add_kex(2,3,   1.4739, 0, 20);
sim.add_kex(3,1, 200,50,500);
sim.add_kex(4,1, 1e3, 100, 1e9 );

s1.opt_vals('R1') = 0; s1.set_lb_ub('R1', 0.5, 1.1); 
s2.opt_vals('R1') = 0; s2.set_lb_ub('R1', 0.8, 2);  
s3.opt_vals('R1') = 0; s3.set_lb_ub('R1', 0.8, 2); 
s4.opt_vals('R1') = 0;

s1.opt_vals('R2') =  1; s1.set_lb_ub('R2',5, 35); 
s2.opt_vals('R2') =  1; s2.set_lb_ub('R2',  1e3, 5e3); 
s3.opt_vals('R2') =  1; s3.set_lb_ub('R2',  100, 4e3);
s4.opt_vals('R2') =  1; s4.set_lb_ub('R2', 1.e3, 8e3);


s1.opt_vals('c') =  1; s1.set_lb_ub('c',  1e4,  1e8 );
s2.opt_vals('c') =  1; s2.set_lb_ub('c',  1e3,  1e6 );
s3.opt_vals('c') =  1; s3.set_lb_ub('c',  1e3,  1e6 );
s4.opt_vals('c') =  1; s4.set_lb_ub('c', 1.0e3, 1.0e9);


s1.opt_vals('x') =  1; s1.set_lb_ub('x',-0.1,0.1);
s2.opt_vals('x') =  1; s2.set_lb_ub('x',-5.0, -2.2);
s3.opt_vals('x') =  1; s3.set_lb_ub('x', 1.2, 3.2);
s4.opt_vals('x') =  1; s4.set_lb_ub('x',-5,0.1);



fit = FitGlobalp1331(sim, ncyc, 3.0, pwrSer{1:end});

%[x,f] = fit.run
%fit.run_sim_anneal()
%[x,f]=fit.run
%fit.run_lsqcurvefit_with_b1_opt()
%fit.run_lsqcurvefit()
%fit.run_unbound_lsqcurvefit_with_b1_opt()
fit.run_unbound_lsqcurvefit

fit.plot_data

