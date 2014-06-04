clear;

g=CEST('/Users/josh/Documents/bruker4/EggWhite_Dec4_2013/7/');

r1_1 = 0.67; r2_1 = 5    ; w_1 =    0; c_1 = 1.10; k_1= 0;
r1_2 = 0.67; r2_2 = 1.1e4; w_2 =    0; c_2 = 0.08; k_2=20000;
r1_3 = 1.00; r2_3 =    67; w_3 = 1600; c_3 = 4e-3; k_3=300;
r1_4 = 1.00; r2_4 =  1250; w_4 =-1600; c_4 = 0.04; k_4= 5;

s1=SpinObj( 0.67,  5,     0,         [0 0 1.1 ]);
s2=SpinObj( 0.67, 1/86.9e-6,     0, [0 0 .081 ]);
s3=SpinObj( 1.00,  1/15e-3,  1600, [0 0 0.004 ]);
s4=SpinObj( 1.00,  1/800e-6,-1600,  [0 0 0.04 ]);

guess=[ c_1 w_1 r1_1 r2_1 k_1    c_2 w_2 r1_2 r2_2 k_2   c_3 w_3 r1_3 r2_3 k_3   c_4 w_4 r1_4 r2_4 k_4];

[x,resnorm,residual] = lsqcurvefit(@BlochSimWrapper, guess, g.fullppm, g.zspec')

sim=Bloch();
nspins=length(x)/5;
kex=zeros(1,nspins)
s=SpinObjs.empty(0, nspins);
for p = 1:nspins
    i=(p-1);
    s(p)=SpinObj( x(i+3), x(i+4), x(i+2), x(i+1) );
    kex(p) = x(i+5);
    sim.add_spin(s(p));
end

sim.add_kex(2,1, kex(2) );
sim.add_kex(3,1, kex(3) );
sim.add_kex(4,1, kex(4) );

w1=-4000:40:4000;
