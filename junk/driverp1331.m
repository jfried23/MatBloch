if 1
    clear;clc;
    %cest450=GRE_CEST('/Users/josh/Documents/bruker4/7T/450/meas_MID157_Gre_2D_Gauss_10X450d_FID24725.dat');
    %p450   =GRE_CEST('/Users/josh/Documents/bruker4/7T/450/meas_MID159_Gre_2D_P1331Gauss_10x450d_FID24727.dat');
    cest =GRE_CEST('/Users/josh/Documents/bruker4/7T/Eggs_May27-2014/meas_MID292_Gre_2D_Gauss_10X450d_FID25144.dat');
    p1331=GRE_CEST('/Users/josh/Documents/bruker4/7T/Eggs_May27-2014/meas_MID294_Gre_2D_P1331Gauss_10x450d_FID25146.dat');

    norm_cest = zeros(192,192,51);
    norm_p1331= zeros(192,192,51);

    for i=1:cest.Nexp
        norm_cest(:,:,i) = ( (cest.imgs(:,:,i) - cest.imgs(:,:,end)) );
        norm_cest(:,:,i) = norm_cest(:,:,i)./max(max(max(norm_cest(:,:,:))));
        norm_p1331(:,:,i) = ( (p1331.imgs(:,:,i) - p1331.imgs(:,:,end)) );
        norm_p1331(:,:,i) = norm_p1331(:,:,i)./max(max(max(norm_p1331(:,:,:))));
    end
    
    cest.imgs = norm_cest;
    p1331.imgs = norm_p1331;    
end


[sCEST,v]=cest.get_area();
sp1331   =p1331.get_area(v);

ppm=-8:(16/50):8;


plot(ppm,sp1331,'r'); hold; plot(ppm,sCEST,'k')

p1331_data=CEST_data(ppm, sp1331, gen_p1331_7T(1,12.5,10) );
cest_data =CEST_data(ppm, sCEST, gen_cest_7T(1,12.5) ); 

%%
s1=Spin( 0.87,          230,   0.0,  [0 0 40] );  %water
s2=Spin( 1.10,          3.3e3,   3.52,  [0 0  4] );
s3=Spin( 1.10,          4.8e3,  -3.85,  [0 0  6] );


sim=ZSpecBlochSim( s1, s2, s3 );

sim.add_kex(2,1,   60, 10, 200);
sim.add_kex(3,1,   10, .1,  20);

s1.opt_vals('R1') = 1;
s2.opt_vals('R1') = 1;  
s3.opt_vals('R1') = 1;

s1.opt_vals('R2') = 1; s1.set_lb_ub('R2',   5, 40); 
s2.opt_vals('R2') = 1; s2.set_lb_ub('R2',  50, 1e3); 
s3.opt_vals('R2') = 1; s3.set_lb_ub('R2',  50, 1e3);


s1.opt_vals('c') = 1; s1.set_lb_ub('c',     0,  100 );
s2.opt_vals('c') = 1; s2.set_lb_ub('c',     0,   20 );
s3.opt_vals('c') = 1; s3.set_lb_ub('c',     0,   40 );


s1.opt_vals('x') = 1; s1.set_lb_ub('x',-0.25, 0.25);
s2.opt_vals('x') = 1; s2.set_lb_ub('x', 2.56, 4.48);
s3.opt_vals('x') = 1; s3.set_lb_ub('x',-4.8, -2.2 );

fit = FitGlobalCEST(sim, gen_cest_7T(1,12.5), cest_data);
fit.plot_data