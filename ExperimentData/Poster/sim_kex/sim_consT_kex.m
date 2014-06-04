%o1=[-3200:20:3200];
ncyc=15;

o1=[-5, 0, 5, 10]*400;
b1=[75];

s1=Spin( 1.0,  30,  0,   [ 0 0 110  ]);
s2=Spin( 1.0,  50,  5,   [ 0 0   2  ]);

sim=ZSpecBlochSim( s1, s2);

sat_time= linspace(.005,1,20);
rates = [1, 2, 5, 10, 20, 40, 60, 100, 200];
v=zeros(length(sat_time),length(rates));
i=1;ii=1;

for t=sat_time
    i=1;
    max=0;
    for kex=rates
        sim.add_kex(2,1,  kex);
    
        %%First do cest
        seq=gen_cest(ncyc*t,b1(1));
        cest_spec = -1*sim.run(seq, b1, o1);
        %plot(o1/400,cest_spec)


        %%Then do p1331
        seq =gen_consT_p1331(t, b1(1), ncyc, 5);
        p1_spec = -1*sim.run(seq, b1, o1);
        %plot(o1/400,p1_spec,'r')

        ls1 = find( (o1/400)==0 );  %loacation of spin 1
        ls2 = find( (o1/400)==5 );  %loacation of spin 2
        ls  = find( (o1/400)==-5 ); %assymetry
        
        c_p = (cest_spec(ls2) - cest_spec(ls))/cest_spec(ls1);
        p_p = (p1_spec(ls2) - p1_spec(ls))/p1_spec(ls1);
        
        v(ii,i) = p_p/c_p;
        i=i+1;
    end
    
ii=ii+1;
end
plot(sat_time,v)
ylim([0,1])