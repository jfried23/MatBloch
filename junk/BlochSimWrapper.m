function Iz = BlochSimWrapper( guess, xdata )
%Wrapper function for creating/calling BlochSim by optimization routines
%Guess must be data structure with the format
% [ c_1 w_1 r1_1 r2_1 k_1 .... c_n w_n r1_n r2_n k_n ] 
nparams = 5;

w1=[40 0];
t=1.0;

%First initalize empty array of spin object
npeaks = length(guess)/nparams;
spins=SpinObj.empty(0, npeaks);

sim=Bloch();
kex=zeros(1,npeaks);

Iz = zeros('like',xdata);

for p = 1:npeaks 
    
    c = guess( nparams*(p-1) + 1 );
    w = guess( nparams*(p-1) + 2 );
    r1= guess( nparams*(p-1) + 3 );
    r2= guess( nparams*(p-1) + 4 );
    kex(p) = guess( nparams*(p-1) + 5 );
    spins(p) = SpinObj(  r1, r2, w, [ 0 0 1]*c );
    sim.add_spin( spins(p) );
end


for k=1:length(kex)
    sim.add_kex( 1, k, kex(k));
end

for k=1:length(xdata)
    sim.run( xdata(k), w1, t);
    Iz(k) = spins(1).Iz;
    sim.reinitalize();    
end

end


