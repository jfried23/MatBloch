clear;
clc;
clf;

base_path = '/Users/josh/Documents/bruker4/gelatin_Power_Dependence/';
dirs = [11, 9, 7]; 
power= [52, 82, 127];

pwrSer = cell(1,length(dirs));

for i=1:length(dirs)
    pwrSer{i}=CEST( fullfile(base_path, num2str( dirs(i) )), power(i) );
end

s1=Spin( 0.7,      20.6992,     -0.0169,       [0 0 4.000e+08]);
s2=Spin( 2.2,     200,        2.50,       [0 0 3.5026e+04]);
s3=Spin( 2.2,   4.1061e+03,     -3.75,       [0 0 1.2742e+05]);

s4=Spin( 2.2,    100,     0.00,     [0 0  2.2805e+08]);

sim = ZSpecBlochSim( s1, s2, s3);

sim.add_kex(2,1,  75, 60,120);
sim.add_kex(3,1,  40, 20, 50);
%sim.add_kex(4,1,  30, 20, 50);

s1.opt_vals('R1') = 0;
s2.opt_vals('R1') = 0;  
s3.opt_vals('R1') = 0;
s4.opt_vals('R1') = 0;

s1.opt_vals('R2') = 1; s1.set_lb_ub('R2',5, 30); 
s2.opt_vals('R2') = 1; s2.set_lb_ub('R2',50, 1e3); 
s3.opt_vals('R2') = 1; s3.set_lb_ub('R2',1.e3,1e4);
s4.opt_vals('R2') = 1; s4.set_lb_ub('R2',40,1e3);

s1.opt_vals('c') = 1; s1.set_lb_ub('c',1e3, 1e10);
s2.opt_vals('c') = 1; s2.set_lb_ub('c',1e3, 1e6);
s3.opt_vals('c') = 1; s3.set_lb_ub('c',1e3, 1e6);
s4.opt_vals('c') = 1; s4.set_lb_ub('c',1e3, 1e8);

s1.opt_vals('x') = 1; s1.set_lb_ub('x',-0.3, 0.3);
s2.opt_vals('x') = 0; s2.set_lb_ub('x', 2.3, 2.7);
s3.opt_vals('x') = 1; s3.set_lb_ub('x',-3.8, -3.2);
s4.opt_vals('x') = 1;

seq=gen_cest(1.0,33);


fit=FitGlobalCEST( sim, seq,  pwrSer{1:end} );
%fit.run_sim_anneal()
%[x,f]=fit.run
fit.run_lsqcurvefit();
%fit.run_unbound_lsqcurvefit();

fit.plot_data()
%ylim([-4.5e6, 0])
