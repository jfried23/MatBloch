

base_path = '/Users/josh/Documents/bruker4/EggWhite_Dec4_2013/';
dirs = [ 5,  6,  7,  8,  9,   10]; %[ 8,   9,  10]  
power= [ 100, 77, 61, 52, 41.5, 33];   %[ 52, 41.5, 33];



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

plseq=gen_cest( 1.0, 33 );
gfc = FitGlobalCEST(sim, plseq, pwrSer{1:end});

gfc.plot_data
%ylim([-6e6, 0])
%lim([-7, 0])