

base_path = '/Users/josh/Documents/bruker4/EggWhite_Dec4_2013/';
dirs = [ 4, 5,  6,  7,  8,  9,   10]; %[ 8,   9,  10]  
power= [ 122.7, 100, 77, 61, 52, 41.5, 33];   %[ 52, 41.5, 33];



pwrSer = cell(1,length(dirs));

for i=1:length(dirs)
    pwrSer{i}=CEST( fullfile(base_path, num2str( dirs(i) )), power(i) );
end

sA=Spin( 0.87,       13.3035, -0.0190,   [0 0 1.8884e+07] );  %water
sB=Spin( 2.38,    5.0000e+03, -3.3000,   [0 0 2.4938e+05] ); %narrow now
sC=Spin( 1.78,    2.4974e+03,  3.4568,   [0 0 1.1435e+05] );
sD=Spin( 0.87,    2.2536e+04,  -0.0190,   [0 0 1.3656e+04] );

%sD=Spin( 0.87,    2.2536e+04,  6.1499,   [0 0 1.3656e+04] );



sim1=ZSpecBlochSim( sA, sB, sC, sD);
sim1.add_kex(2,1,  35.7096 );
sim1.add_kex(3,1,  70.0342 );
sim1.add_kex(4,1,  2.1608e4);

sim1.add_kex(2,4, 5.9019);


plseq=gen_cest( 1.0, 33 );
model = FitGlobalCEST(sim1, plseq, pwrSer{1:end});

model.plot_data
%ylim([-6e6, 0])
%lim([-7, 0])