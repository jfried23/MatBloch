base_path = '/Users/josh/Documents/bruker4/EggWhite_Dec4_2013/';
dirs = [ 4, 6,   15 ];
ncycle=[ 0, 0,  20 ];
cest_pwr=[ 122.7, 77.5, 77.5]
pwr=61.0;

pwrSer = cell(1,length(dirs));
pulseq = cell(1,length(dirs));
for i=1:length(dirs)
    
    if ncycle(i) == 0
        pulseq{i}=gen_cest( 1.0, cest_pwr(i));
    else
        pulseq{i}=gen_p1331( 1.0, pwr, ncycle(i) );
    end
    
    pwrSer{i}=CEST( fullfile(base_path, num2str( dirs(i) )), cest_pwr(i) );
    
end

s1=Spin( 0.87,       28.0986,  -0.0014,   [0 0 1.8573e+07] );  %water
s2=Spin( 2.38,    6.3421e+03,  -3.2257,   [0 0 1.9499e+05] ); %narrow now
s3=Spin( 1.78,    1.0492e+03,   3.5384,    [0 0 6.1377e+04]);
s4=Spin( 0.87,    1.1873e+03,  -0.0014 ,   [0 0 1.7722e+05]);

sim=ZSpecBlochSim( s1, s2, s3, s4);

sim.add_kex(2,1,  54.0255, 10, 80  );
sim.add_kex(3,1 ,117.8751, 80, 300 );
sim.add_kex(4,1, 1e5  );


s1.opt_vals('R1') = 0;
s2.opt_vals('R1') = 0;  
s3.opt_vals('R1') = 0;
s4.opt_vals('R1') = 0;

s1.opt_vals('R2') = 0; s1.set_lb_ub('R2',21, 30); 
s2.opt_vals('R2') = 1; s2.set_lb_ub('R2', 3e3, 1e4); 
s3.opt_vals('R2') = 1; s3.set_lb_ub('R2', 900, 6e3);
s4.opt_vals('R2') = 1; s4.set_lb_ub('R2', 1e3, 1e7);


s1.opt_vals('c') = 0; s1.set_lb_ub('c',1e7,3e7);
s2.opt_vals('c') = 1; s2.set_lb_ub('c', 1.e4, 1e7);
s3.opt_vals('c') = 1; s3.set_lb_ub('c', 1.e4, 1e7);
s4.opt_vals('c') = 1; s4.set_lb_ub('c', 1.e4, 1.0e7);


s1.opt_vals('x') = 0;
s2.opt_vals('x') = 1; s2.set_lb_ub('x',-4.0,-2.75);
s3.opt_vals('x') = 1; s3.set_lb_ub('x',3,4);
s4.opt_vals('x') = 0; s4.set_lb_ub('x',-1,1);


fit = FitGlobalp1331( sim, pulseq, pwrSer{1:end} );
fit.run_lsqcurvefit
fit.plot_data();