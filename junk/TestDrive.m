clear; clc;


base_path = '/Users/josh/Documents/bruker4/EggWhite_Dec4_2013/';
dirs = [ 6,  7,  8,    9, 10]; %[ 8,   9,  10]  
power= [  77.5, 61, 52, 41.5, 33];   %[ 52, 41.5, 33];


pwrSer = cell(1,length(dirs));

for i=1:length(dirs)
    pwrSer{i}=CEST( fullfile(base_path, num2str( dirs(i) )), power(i) );
end

s1=Spin( 0.87,       21.8777,  -0.0014,   [0 0 20016000] );  %water
s2=Spin( 2.38,    5.4551e+03,  -3.4269,   [0 0 1.4966e+05] ); %narrow now
s3=Spin( 1.78,    1.8620e+03,   3.4500,   [0 0 3.8024e+04]);
s4=Spin( 0.87,    13156,  -0.0014 ,  [0 0 325580]);


sim=ZSpecBlochSim( s1, s2, s3, s4);
sim.add_kex(2,1,  63.0135  );
sim.add_kex(3,1 ,262.4081 );
sim.add_kex(4,1, 42.8773  );


s1.opt_vals('R1') = 0;
s2.opt_vals('R1') = 0;  
s3.opt_vals('R1') = 0;
s4.opt_vals('R1') = 0;

s1.opt_vals('R2') = 0; s1.set_lb_ub('R2',21, 30); 
s2.opt_vals('R2') = 1; s2.set_lb_ub('R2', 4.5e3, 5.0e3); 
s3.opt_vals('R2') = 0; s3.set_lb_ub('R2', 200, 2.8e3);
s4.opt_vals('R2') = 0; s4.set_lb_ub('R2', 1.0e3, 3.0e3);


s1.opt_vals('c') = 0; s1.set_lb_ub('c',1e7,3e7);
s2.opt_vals('c') = 0; s2.set_lb_ub('c',1.5e3, 2.1e3);
s3.opt_vals('c') = 0; s3.set_lb_ub('c',7.0e4,7.7e4);
s4.opt_vals('c') = 0; s4.set_lb_ub('c', 1.0e3, 3.0e6);


s1.opt_vals('x') = 0;
s2.opt_vals('x') = 0; s2.set_lb_ub('x',-3.6,-3.2);
s3.opt_vals('x') = 0; s3.set_lb_ub('x',3.3,3.8);
s4.opt_vals('x') = 0; s4.set_lb_ub('x',-1,1);

seq=gen_cest(1.0,33);


fit=FitGlobalCEST( sim, seq,  pwrSer{1:end} );
fit.run
%fit.run_sim_anneal()
%[x,f]=fit.run
%fit.run_lsqcurvefit();
%fit.run_unbound_lsqcurvefit();

fit.plot_data()
%ylim([-4.5e6, 0])
