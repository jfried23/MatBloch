clear; clc;


path = '/Users/josh/Documents/bruker4/EggWhite_Dec4_2013/10/';
B1=[33, 0];



s1=SpinObj( 0.67,  20,     0,  [0 0 .7 ]);
s2=SpinObj( 0.67, 1e3,     0,  [0 0 .3 ]);
s3=SpinObj( 2.38, 120, -1600,     [0 0 80.e-3 ]);
s4=SpinObj( 1.78,  75,  1400,     [0 0 0.3    ]);


s1.set_lb_ub('w0',-20,20);
s2.set_lb_ub('R1',0.1,2.0); 
s1.set_lb_ub('R2',2.0, 25);
s1.set_lb_ub('c',0.9,1.0);

s2.set_lb_ub('w0',-400, 400);
s2.set_lb_ub('R1',0.1,2); 
s2.set_lb_ub('R2',500,1e4); 
s2.set_lb_ub('c',0.01,1.0); 

s3.set_lb_ub('w0',-1700,-1150);
s3.set_lb_ub('R1',2.0,2.8); 
s3.set_lb_ub('R2',50,1.e3); 
s3.set_lb_ub('c',1.e-6,1.e-1); 

s4.set_lb_ub('w0',1100,1720);
s3.set_lb_ub('R1',1.4,2.2);
s4.set_lb_ub('R2',20,90);
s4.set_lb_ub('c',1.e-6,1.e-2); 


%Fix R1 values of spins
s1.opt_vals('R1') = 1;
s2.opt_vals('R1') = 1;
s3.opt_vals('R1') = 1;
s4.opt_vals('R1') = 1;


me=Bloch( s1, s2, s3, s4);
me.add_kex(2,1, 1e4, 50, 5e5);
me.add_kex(3,1 , 10,  1,  25);
me.add_kex(4,1, 300, 20, 500);

me.add_kex(3,2 , 10,  1,  25);
me.add_kex(4,2, 300, 20, 500);

fit = FitCEST( path, B1, 1.0 );

fit.data_model(me);

fit.fit();
ylim([ 0.94 1.01])
fit.bloch_model.spins(1)