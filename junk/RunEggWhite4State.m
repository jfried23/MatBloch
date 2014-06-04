clear; clc;


base_path = '/Users/josh/Documents/bruker4/EggWhite_Dec4_2013/';
dirs = [    4,     5,    6,  7,  8,  9,   10]; %[ 8,   9,  10]  
power= [122.7, 100.0, 77, 61, 52, 41.5, 33];   %[ 52, 41.5, 33];

pwrSer = cell(1,length(dirs));

for i=1:length(dirs)
    pwrSer{i}=CEST( fullfile(base_path, num2str( dirs(i) )), power(i) );
end



s1=Spin( 0.87,   30,   -0.0014,   [0 0 1.9e7  ] );  %water
s2=Spin( 2.38,  4.4e3,   -3.45,   [0 0 2.2e5  ] ); %narrow now

s3=Spin( 1.78,  300,    3.75,   [0 0 1e4 ]);
s4=Spin( 1.78,  1e5,     3.75,  [0 0 1e4 ]);

s1.opt_vals('R1') = 0; s1.set_lb_ub('R1',0.4,2.0); 
s1.opt_vals('R2') = 0; s1.set_lb_ub('R2',10,30);
s1.opt_vals('x')  = 0; s1.set_lb_ub('x',-0.3,0.3);
s1.opt_vals('c')  = 0; s1.set_lb_ub('c',1e3,Inf);


s2.opt_vals('R1') = 0; s2.set_lb_ub('R1',0.4,1); 
s2.opt_vals('R2') = 1; s2.set_lb_ub('R2',2e3,8e3); 
s2.opt_vals('x')  = 1; s2.set_lb_ub('x',-3.8,-3.3);  
s2.opt_vals('c')  = 1; s2.set_lb_ub('c',1e3,1e7);

s3.opt_vals('R1') = 0; s3.set_lb_ub('R1',0.4,1); 
s3.opt_vals('R2') = 1; s3.set_lb_ub('R2',.5e3,1e6); 
s3.opt_vals('x')  = 1; s3.set_lb_ub('x',-3.75,-3.30);
s3.opt_vals('c') =  1; s3.set_lb_ub('c',1.e3,1e8);

s4.opt_vals('R1') = 0; s4.set_lb_ub('R1',0.4,1); 
s4.opt_vals('R2') = 1; s4.set_lb_ub('R2',1e3,1e9);
s4.opt_vals('x')  = 1; s4.set_lb_ub('x',-7,7);
s4.opt_vals('x')  = 1; s4.set_lb_ub('c',1.e3,1e9);



%Fix R1 values of spins
s1.opt_vals('R1') = 0;

s3.opt_vals('R1') = 0;
s4.opt_vals('R1') = 0;

me=ZSpecBlochSim( s1, s2, s3);
me.add_kex(2,1, 30);
me.add_kex(3,1 ,80);

plseq=gen_cest( 1.0, 33 );
gfc = FitGlobalCEST(me, plseq, pwrSer{1:end});


gfc.run_lsqcurvefit

gfc.plot_data
