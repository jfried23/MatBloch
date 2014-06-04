clear; clc;


base_path = '/Users/josh/Documents/bruker4/EggWhite_Dec4_2013/';
dirs = [    4,     5,    6,  7,  8,  9,   10]; %[ 8,   9,  10]  
power= [122.7, 100.0, 77, 61, 52, 41.5, 33];   %[ 52, 41.5, 33];

pwrSer = cell(1,length(dirs));

for i=1:length(dirs)
    pwrSer{i}=fullfile(base_path, num2str( dirs(i) ));
end

gfc = GlobalFitCEST(pwrSer, power, 1.0);

s1=SpinObj( 1.20,   26,     0,   [0 0 .9  ]);  %water
s2=SpinObj( 2.38,  1e3,   -1500, [0 0 .1  ]); %narrow now
s3=SpinObj( 1.78,  85,    1400,  [0 0 .004]);

s1.set_lb_ub('R1',0.4,2.0); 
s1.set_lb_ub('R2',2,300);
s1.set_lb_ub('w0',-200,200);
s1.set_lb_ub('c',0.9,2.0);


s2.set_lb_ub('R1',0.4,1); 
s2.set_lb_ub('R2',1,5.e3); 
s2.set_lb_ub('w0',-1700,-1120);  
s2.set_lb_ub('c',0.01,0.3);


s3.set_lb_ub('R1',0.4,1); 
s3.set_lb_ub('R2',0,100);
s3.set_lb_ub('w0',500,3000);
s3.set_lb_ub('c',1.e-6,1);



%Fix R1 values of spins
s1.opt_vals('R1') = 1;
s2.opt_vals('R1') = 1;
s3.opt_vals('R1') = 1;

me=Bloch( s1, s2, s3);
me.add_kex(2,1, 5, 1, 20);
me.add_kex(3,1, 5, 1, 80);


%me.add_kex(3,4, 5, 1, 10);

gfc.data_model(me);

gfc.fit2;
gfc.plot_data
