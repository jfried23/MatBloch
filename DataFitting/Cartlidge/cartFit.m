

base_path = '/Users/josh/Documents/bruker4/Cart_Feb20/';
dirs = [ 2 ];
power= [ 190 ];



pwrSer = cell(1,length(dirs));

for i=1:length(dirs)
    pwrSer{i}=CEST( fullfile(base_path, num2str( dirs(i) )), power(i) );
end

s1=Spin( 0.87,      16.6340,  0.0,   [0 0 2.8792e+07] );  %water
s2=Spin( 0.87,        0.2e3,   -3.4,       [0 0 5.0e5]);
s3=Spin(  1.1,        1.1521e+04,    0.0,       [0 0 7.4783e+05]);


sim=ZSpecBlochSim( s1, s2, s3 );
sim.add_kex(2,1, 20, 2, 50);
sim.add_kex(3,1, 68.3092, 1, 100);

s1.opt_vals('R1') = 0;
s2.opt_vals('R1') = 1;  
s3.opt_vals('R1') = 1;
%s4.opt_vals('R1') = 0;

s1.opt_vals('R2') =  1; s1.set_lb_ub('R2',5, 35); 
s2.opt_vals('R2') =  1; s2.set_lb_ub('R2', 100, 5000); 
s3.opt_vals('R2') =  1; s3.set_lb_ub('R2',  100, 1e5);
%s4.opt_vals('R2') = 1; s4.set_lb_ub('R2', 1.0e3, 1.0e9);


s1.opt_vals('c') =  1; s1.set_lb_ub('c',  1e2,  1e8 );
s2.opt_vals('c') =  1; s2.set_lb_ub('c',  1e5,  1e6 );
s3.opt_vals('c') =  1; s3.set_lb_ub('c',  1e3,  1e6 );
%s4.opt_vals('c') = 1; s4.set_lb_ub('c', 1.0e3, 1.0e9);


s1.opt_vals('x') =  0; s1.set_lb_ub('x',-0.25,0.25);
s2.opt_vals('x') =  1; s2.set_lb_ub('x',-3.7, -3.0);
s3.opt_vals('x') =  0; s3.set_lb_ub('x',  0.0, 7.0);
%s4.opt_vals('x') = 0; s4.set_lb_ub('x',-0.5,7);


plseq=gen_cest( 1.0, 33 );
fit = FitGlobalCEST(sim, plseq, pwrSer{1:end});

%[x,f] = fit.run
%fit.run_sim_anneal()
%[x,f]=fit.run
%fit.run_lsqcurvefit();
fit.run_lsqcurvefit_with_b1_opt()
%fit.run_unbound_lsqcurvefit();

fit.plot_data

