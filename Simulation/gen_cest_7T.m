function cest_seq = gen_cest_7T( time, pwr )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    
    cest_seq=PulseSequence(7.0);
    %cest_seq.add( Delay(10) );
    cest_seq.add( CW( time, pwr, 0) );
    cest_seq.add( END() );

end

