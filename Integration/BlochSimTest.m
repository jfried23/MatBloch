classdef BlochSimTest < matlab.unittest.TestCase
    % Inetegration Tests for Bloch simulation class
    
    methods (Test)
        
        function testFreePrecess(testCase)
            s1=Spin( 1,  7,  10,   [1 0 0]);
            times=[ 1.e-2 0.05 0.15 0.5];
            sim = BlochSim( s1 );
            Mt = zeros( 4, length(times) );
            i=1;
            for t=times
                seq=PulseSequence();
                seq.add( Delay(t) );
                seq.add( END() );
                Mt(:,i) = sim.run( seq );
                i=i+1;
            end

            expected = [    0.9239    0.4539   -0.2188   -0.0069;
                            0.1252    0.4751    0.0707   -0.0010;
                            0.0100    0.0582    0.1894    0.5084;
                            1.0000    1.0000    1.0000    1.0000; ];
            
            err = sum(sum(abs(Mt-expected),2))/12;
            testCase.verifyLessThan( err, 0.001 );
        end
        
        function test90Pulse(testCase)
            s1=Spin( 4,  7,   0,   [0 0 1]);
            s2=Spin( 4,  7,  10,   [0 0 1]);
            
            sim = BlochSim( s1, s2 );
            sim.add_kex(2,1, 0);
            seq=PulseSequence();

            seq.add( Delay(10) );
            seq.add( RGPulse(90, 9e-6,   90) );
            seq.add( END() );
     
            Mt = sim.run( seq );
            diff = sum(abs( Mt - [ 1.000 0.000 0.000 0.9896 0.1434 0.0045 1.000]'))/6;
            testCase.verifyLessThan( diff, 0.001 );
        end
        
        function test1331Pulse(testCase)
            s1=Spin( 4,  7,   0,   [0 0 1]);
            s2=Spin( 4,  7,   5,   [0 0 1]);

            sim = BlochSim( s1, s2 );
            sim.add_kex(2,1, 0);
            seq=PulseSequence();

            d19 = 1/(2*5*400);

            seq.add( Delay(10) );
            seq.add( RGPulse(90*.125,9e-6,   0) );
            seq.add( Delay(d19) );
            seq.add( RGPulse(90*.375,9e-6, 180) );
            seq.add( Delay(d19) );
            seq.add( RGPulse(90*.375,9e-6,   0) );
            seq.add( Delay(d19) );
            seq.add( RGPulse(90*.125,9e-6, 180) );
            seq.add( END() );

            Mt = sim.run( seq );
            diff = (sum(abs( Mt - [0.0000 0.000 0.999 -0.2726 0.9596 0.0138 1.0000]'))/6 );
            testCase.verifyLessThan( diff, 0.001 );
        end
        
    end
    
end
