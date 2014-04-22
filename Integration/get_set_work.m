clear; clc;

s1=SpinObj( 0.67,  5,     0, [0 0 110 ]);
s2=SpinObj( 0.67, 1/86.9e-6,     0, [0 0 8.1 ]);
s3=SpinObj( 1.00,  1/15e-3,  1600, [0 0 .4 ]);
s4=SpinObj( 1.00,  1/800e-6,-1600, [0 0 4 ]);
    
me=Bloch( s1, s2, s3, s4);
me.add_kex(2,1, 50);
me.add_kex(3,1 , 300, 0, 800);
me.add_kex(4,1,20);

me.add_kex(3,4,20);
w1=-3200:40:3200;


spec = me.run_zspec(w1,[0,80],0.5);
plot(w1, spec(3,:))
hold();

[x,lb,ub] = me.get_x0();
x(17)=50;
me.set_x0(x);

spec = me.run_zspec(w1,[0,80],0.5);
plot(w1, spec(3,:),'r')


