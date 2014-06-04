

base_path = '/Users/josh/Documents/bruker4/EggWhite_Dec4_2013/';
dirs = [ 4,       5,  6,  7,  8,  9,   10]; %[ 8,   9,  10]  
power= [ 122.7, 100, 77, 61, 52, 41.5, 33];   %[ 52, 41.5, 33];



pwrSer = cell(1,length(dirs));

for i=1:length(dirs)
    pwrSer{i}=CEST( fullfile(base_path, num2str( dirs(i) )), power(i) );
end

s1=Spin( 0.87,       13.3035, -0.0190,   [0 0 1.8884e+07] );  %water
s2=Spin( 2.38,    5.0000e+03, -3.3000,   [0 0 2.4938e+05] ); %narrow now
s3=Spin( 1.78,    2.4974e+03,  3.4568,   [0 0 1.1435e+05] );
s4=Spin( 0.87,    2.2536e+04, -0.0190,   [0 0 1.3656e+04] );


s3=Spin( 1.78,    2.4974e+03,  3.4568,   [0 0 1.1435e+04] );
s4=Spin( 0.87,    2.2536e+04, -0.0190,   [0 0 1.3656e+06] );


sim=ZSpecBlochSim( s1, s2, s3, s4);
sim.add_kex(2,1,  35.7098, 0,   40);
sim.add_kex(3,1,  70.0342, 50, 200);
sim.add_kex(4,1,  2.1608e4, 1e2, 1e6);

sim.add_kex(2,4, 5.9019, 0, 10);
sim.add_kex(3,4, 5.9019, 0, 10);


s1.opt_vals('R1') = 0;
s2.opt_vals('R1') = 0;  
s3.opt_vals('R1') = 0;
s4.opt_vals('R1') = 0;

s1.opt_vals('R2') = 1; s1.set_lb_ub('R2',5, 35); 
s2.opt_vals('R2') = 1; s2.set_lb_ub('R2', 1e3, 5.5e3); 
s3.opt_vals('R2') = 1; s3.set_lb_ub('R2', 200, 2.5e3);
s4.opt_vals('R2') = 1; s4.set_lb_ub('R2', 1.0e3, 1.0e9);


s1.opt_vals('c') = 1; s1.set_lb_ub('c',  1e7,  5e7 );
s2.opt_vals('c') = 1; s2.set_lb_ub('c', 1.0e3, 2.9e5 );
s3.opt_vals('c') = 1; s3.set_lb_ub('c', 1.0e3, 1e6 );
s4.opt_vals('c') = 1; s4.set_lb_ub('c', 1.0e3, 1.0e9);


s1.opt_vals('x') = 0; s1.set_lb_ub('x',-0.25,0.25);
s2.opt_vals('x') = 0; s2.set_lb_ub('x',-3.70,-3.20);
s3.opt_vals('x') = 0; s3.set_lb_ub('x',3.45,3.5);
s4.opt_vals('x') = 0; s4.set_lb_ub('x',-0.5,7);


plseq=gen_cest( 1.0, 33 );
fit = FitGlobalCEST(sim, plseq, pwrSer{1:end});

%[x,f] = fit.run
%fit.run_sim_anneal()
%fit.run_sim_anneal_with_b1_opt()
%[x,f]=fit.run
fit.run_lsqcurvefit();
%fit.run_unbound_lsqcurvefit_with_b1_opt()
%fit.run_unbound_lsqcurvefit();

fit.plot_data
ylim([-6e6, 0])
%lim([-7, 0])