


s1=Spin( 0.7,     15,     0.00,   [0 0 1]);
s2=Spin( 2.2,    500,     0.00,   [0 0 1]);
s3=Spin( 2.2,    2.6328e3,     -3.50,  [0 0 1e-3]);

sim = ZSpecBlochSim( s1, s2, s3 );

sim.add_kex(2,1, 0);
sim.add_kex(3,1,  33, 1, 70);


cest_range=-3200:40:3200;
pulse_seq = gen_cest(1.0, 9.4);
base_path = '/Users/josh/Documents/bruker4/EggWhite_Dec4_2013/';
dirs = [4,        6, 10];        % [    4,     5,    6,  7,  8,  9,   10]; %[ 8,   9,  10]  
power= [33, 77.5, 122.7];  %[122.7, 100.0, 77, 61, 52, 41.5, 33];   %[ 52, 41.5, 33];


exp_data = cell(1,length(dirs));
for i=1:length(dirs)
    path = fullfile(base_path, num2str( dirs(i) ));
    exp_data{i}= CEST(path, power(i) );
end

model=zeros( length(exp_data), length( cest_range));
exp  =zeros( length(exp_data), length( exp_data{1}.fullppm ));

clf;
for i=1:length(dirs)
    subplot( length(dirs), 1, i );
    hold();
    plot(cest_range/400, sim.run(pulse_seq, power(i), cest_range));
    plot( exp_data{i}.fullppm, 1-exp_data{1}.zspec/min(exp_data{1}.zspec)-1,'o');
    %ylim([-0.1, 0]);
    %model(i,:) = sim.run(pulse_seq, exp_data{i}.B1, cest_range);
    %exp(i,:)   = exp_data{i}.zspec;
end
