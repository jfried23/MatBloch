

base_path = '/Users/josh/Documents/bruker4/weiqi/022814-20%BSA/';
dirs = [ 1 ];
power= [ 71.1581 ];



pwrSer = cell(1,length(dirs));

for i=1:length(dirs)
    pwrSer{i}=CEST( fullfile(base_path, num2str( dirs(i) )), power(i) );
end

s1=Spin( 0.87,      29.9217,   0.0677,  [0 0 2.9498e+07] );  %water
s2=Spin( 1.10,   2.3117e+03,  -3.8539,  [0 0 4.7394e+05] );
s3=Spin( 1.10,   1.9315e+03,   2.4919,  [0 0 5.9223e+05] );


sim=ZSpecBlochSim( s1, s2, s3 );

sim.add_kex(2,1,   9.7648);
sim.add_kex(2,3,   4.3205);
sim.add_kex(3,1, 119.7782);


plseq=gen_cest( 1.0, 71.1581 );
fit = FitGlobalCEST(sim, plseq, pwrSer{1:end});

fit.plot_data

    