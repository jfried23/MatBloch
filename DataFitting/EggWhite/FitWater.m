

base_path = '/Users/josh/Documents/bruker4/EggWhite_Dec4_2013/';
dirs = [ 5,  6,  7,  8,  9,   10]; %[ 8,   9,  10]  
power= [ 100, 77, 61, 52, 41.5, 33];   %[ 52, 41.5, 33];



pwrSer = cell(1,length(dirs));

for i=1:length(dirs)
    pwrSer{i}=CEST( fullfile(base_path, num2str( dirs(i) )), power(i) );
end

s1=Spin( 0.87,       28.0986,  -0.0014,   [0 0 1.8573e+07] );  %water
s2=Spin( 0.87,    3.2255e+03,  -0.0014 ,   [0 0 1.072e+05]);


sim=ZSpecBlochSim( s1, s2);
sim.add_kex(2,1, 1e5);


plseq=gen_cest( 1.0, 33 );
gfc = FitGlobalCEST(sim, plseq, pwrSer{1:end});

gfc.plot_data
ylim([-6e6, 0])
%lim([-7, 0])