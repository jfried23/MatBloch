clear; clc;


path = '/Users/josh/Documents/bruker4/EggWhite_Dec4_2013/7/';




s1=SpinObj( 0.67,  10,     0,        [0 0 .7 ]);
s2=SpinObj( 1.78,  20,  3.5*400, [0 0 10.e-3 ]);
s3=SpinObj( 2.38,  400, -3.7*400, [0 0 80.e-3 ]);


%Fix peak position of spins 1 and 2
s1.opt_vals('w0') = 0;

s2.set_lb_ub('R2',20,500); 
s3.set_lb_ub('R2',100,1e3); 


s2.set_lb_ub('c',1.e-6,1.e-4);
s3.set_lb_ub('c',1.e-6,10.e-4);

%Fix R1 values of spins
s1.opt_vals('R1') = 0;
s2.opt_vals('R1') = 0;
s3.opt_vals('R1') = 0;

me=Bloch( s1, s2, s3);
me.add_kex(2,1 , 200, 50, 400);
me.add_kex(3,1,20, 0, 20);




opt = FitCEST( path, [61.0, 0], 1.0 );

opt.data_model(me);

opt.fit();

opt.bloch_model.spins(1)