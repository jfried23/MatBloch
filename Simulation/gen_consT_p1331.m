function pulse_seq = gen_consT_p1331( sat_time, power, ncycles, varargin )

cent=5;
if ~isempty(varargin)
    cent = varargin{1};
end

pp = 10e-9;
d19 = 1/(2*( cent )*400);

pulse_seq = PulseSequence();
pulse_seq.add( Delay(10) );
pulse_seq.add( RGPulse(90*0.125,pp,  0) );
pulse_seq.add( Delay(d19) );
pulse_seq.add( RGPulse(90*0.375,pp,180) );
pulse_seq.add( Delay(d19) );
pulse_seq.add( RGPulse(90*0.375,pp,  0) );
pulse_seq.add( Delay(d19) );
pulse_seq.add( RGPulse(90*0.125,pp,180) );
pulse_seq.add( CW(sat_time, power, 0.0) );
pulse_seq.add( Loop(2,ncycles) );
pulse_seq.add( END() );

end

