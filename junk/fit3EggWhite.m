

base_path = '/Users/josh/Documents/bruker4/EggWhite_Dec4_2013/';
dirs = [    4,     5,    6,  7,  8,  9,   10];  
power= [122.7, 100.0, 77, 61, 52, 41.5, 33]; 

pwrSer = cell(1,length(dirs));

for i=1:length(dirs)
    pwrSer{i}=CEST( fullfile(base_path, num2str( dirs(i) )), power(i) );
end


s1=Spin( 0.7,      20.6992,     -0.0169,       [0 0 1.9000e+07]);
s2=Spin( 2.2,     865.1587,      3.5000,       [0 0 3.5026e+04]);
s3=Spin( 2.2,   4.1061e+03,     -3.0974,       [0 0 1.2742e+05]);

s4=Spin( 2.2,    200,     0.00,     [0 0  2.0211e6]);


sim = ZSpecBlochSim( s1, s2, s3, s4);

sim.add_kex(2,1,  75.0224 );
sim.add_kex(3,1,  40.0    );

sim.add_kex(4,1,  30.0    );

seq=gen_cest(1.0,33);


mod=FitGlobalCEST( sim, seq,  pwrSer{1:end} );

mod.plot_data()

