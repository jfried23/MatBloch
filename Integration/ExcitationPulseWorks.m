clear; clc;

s1=SpinObj( 0.67,  5,     1600, [0 0 110 ]);
s2=SpinObj( 0.67, 1/86.9e-6,     0, [0 0 8.1 ]);
s3=SpinObj( 1.00,  1/15e-3,  1600, [0 0 0.4 ]);    
s4=SpinObj( 1.00,  1/800e-6,-1600, [0 0 4 ]);
    
me=Bloch( s1, s2, s3, s4);
me.add_kex(2,1,50);
me.add_kex(3,1 , 300);
me.add_kex(4,1,300);

time=0:1.e-8:10.e-6;

spec = me.run(0,[0,2*pi/40.e-6], time );


plot(time, spec(1,:))
hold()
plot(time, spec(4,:),'r')
plot(time, spec(7,:),'g')