clear; clc;


path = '/Users/josh/Documents/bruker4/EggWhite_Dec4_2013/10/';
B1=[33, 0];



s1=SpinObj( 0.67,   5,     0,   [0 0 .7 ]);  %water
s2=SpinObj( 2.38,  3e3,  -1400, [0 0 .3 ]);     %braod noe
s3=SpinObj( 2.38,  66,   -1400, [0 0 10.e-3 ]); %narrow now
s4=SpinObj( 1.78,  3e+3,  1400, [0 0 80.e-3 ]);
s5=SpinObj( 1.78,  66,    1400, [0 0 0.3 ]);


s1.set_lb_ub('w0',-200,200); 
s2.set_lb_ub('w0',-3200,-0);
s3.set_lb_ub('w0',-1700,-1120);  
s4.set_lb_ub('w0',000,3200);
s5.set_lb_ub('w0',800,3000);

s2.set_lb_ub('R2',100,5e3);
s3.set_lb_ub('R2',50,500); 
s4.set_lb_ub('R2',.5e3,1e4); 
s5.set_lb_ub('R2',0,75);

%Fix R1 values of spins
s1.opt_vals('R1') = 0;
s5.opt_vals('R1') = 0;
s3.opt_vals('R1') = 0;
s4.opt_vals('R1') = 0;

me=Bloch( s1, s2, s3, s4, s5);
me.add_kex(2,1, 5, 1, 20);
me.add_kex(3,1 ,5, 1, 80);
me.add_kex(4,1, 5, 1, 80);
me.add_kex(5,1,200, 10, 300);



fit = FitCEST( path, B1, 1.0 );

fit.data_model(me);

fit.fit();

fit.bloch_model.spins(1)