

base_path = '/Users/josh/Documents/bruker4/gelatin_Power_Dependence/';
dirs = [ 7, 8, 9, 10, 11, 29, 30];
power= [127, 103.09, 81.98, 66.22, 52.00, 41.48, 32.95];   %[ 52, 41.5, 33];



pwrSer = cell(1,length(dirs));

for i=1:length(dirs)
    pwrSer{i}=CEST( fullfile(base_path, num2str( dirs(i) )), power(i) );
end

s1=Spin( 0.87,       28.0986,  -0.2968,     [0 0 2e+07] );  %water
s2=Spin( 0.87,    3.2255e+03,  -0.2968 , [0 0 1.0e+06]);
s3=Spin( 1.5,            800,   2.5 ,   [0 0 1.072e+05]);
s4=Spin( 1.87,      2e3, -3.75 ,   [0 0 1.072e+05]);

sim=ZSpecBlochSim( s1, s2, s3, s4);
sim.add_kex(2,1, 1e6, 1e2, 1e7);
%sim.add_kex(3,1, 100) %, 70, 300);
%sim.add_kex(4,1, 20) %, 5, 50);

s1.opt_vals('R1') = 0;
s2.opt_vals('R1') = 0;  
s3.opt_vals('R1') = 0;
s4.opt_vals('R1') = 0;

s1.opt_vals('R2') = 1; s1.set_lb_ub('R2',5, 35); 
s2.opt_vals('R2') = 1; s2.set_lb_ub('R2',100, 5e4); 
s3.opt_vals('R2') = 0; s3.set_lb_ub('R2', 200, 1.8e3);
s4.opt_vals('R2') = 0; s4.set_lb_ub('R2', 1.0e2, 1.0e9);


s1.opt_vals('c') = 1; s1.set_lb_ub('c',  1e5,1e9);
s2.opt_vals('c') = 1; s2.set_lb_ub('c',  1e4, 1e9);
s3.opt_vals('c') = 0; s3.set_lb_ub('c',  1e3, 1e7);
s4.opt_vals('c') = 0; s4.set_lb_ub('c', 1.0e3, 1.0e9);


s1.opt_vals('x') = 1; s1.set_lb_ub('x',-2.,2);
s2.opt_vals('x') = 0; s2.set_lb_ub('x',-2, 2);
s3.opt_vals('x') = 0; s3.set_lb_ub('x',2.3,2.7);
s4.opt_vals('x') = 0; s4.set_lb_ub('x',-4.2,-3.2);


plseq=gen_cest( 1.0, 33 );
fit = FitGlobalCEST(sim, plseq, pwrSer{1:end});
clf;
fit.run_unbound_lsqcurvefit
%fit.run_lsqcurvefit


fit.plot_data
%%lim([-7, 0])