clear;

t=1.0;

w1={2*pi/2 0};

kca =     300;
kda =   5;
kba = 20000;

sa = { 0.67   8     0     1};
sb = { 0.67   8     0     1};
sc = { 1     15  1500 1}; 
sd = { 1     15 -1500 1}; 

M0 = [ 0 0 0 0     0 0 0 0    55 55 20 20         1]';
g=Bloch_old( w1, sa, sb, sc, sd, kca, kda, kba);

x=-3200:40:3200;
i=1;
y=zeros(1,length(x));
for dw1=-3200:40:3200
    m=g.Sim( M0, t, dw1, w1);
    y(i)=m(9)+m(10);
    i=i+1;
end

plot(x,y)