classdef PulseElement < handle
    %PulseElement Member of PulseSeqence
    %   Detailed explanation goes here
    
    properties
        nuclei; %Nucli name defined in GyromagneticRatio class
        time_;  %Durration of this pulse element in seconds        
        phase_; %Phase of pulse in degrees
        B1_;    %B1 Field strength in Hz
        o1_;    %Pulse offset freqency in Hz    
    end
    
    properties ( Hidden = true )           
            %Interger pointers to elements of:
        pt; % time_(element) 
        pp; % phase_(element)
        pb; % B1_(element)
        po; % o1_(element)
    end
    
    methods
        function obj = PulseElement( nuc, time, B1, phase, off )
            assert( ismember( nuc, properties( GyromagneticRatio ) ),sprintf('%s is not a recognized nucli!', nuc));
            assert( time >= 0, 'Pulse element durration cannot be less than 0!');
            
            obj.nuclei = nuc;
            obj.time_ = time; obj.pt=1;
            obj.phase_ = phase; obj.pp=1;
            obj.B1_ = B1; obj.pb=1;
            obj.o1_ = off; obj.po=1;
        end
        
        function obj = inc_t(obj) 
            if obj.pt == length(obj.phase_), obj.pt=1;
            else
                obj.pt = obj.pt + 1;
            end
        end
        
        function obj = inc_B1(obj)
            if obj.pb == length(obj.B1_), obj.pb=1;
            else
                obj.pb = obj.pb + 1;
            end
        end
        
        function obj = inc_ph(obj)
            if obj.pp == length( obj.phase_), obj.pp=1;
            else
                obj.pp = obj.pp + 1;
            end
        end
        
        function obj = inc_o1(obj)
            if obj.po == length( obj.o1_), obj.po=1;
            else
                obj.po = obj.po + 1; 
            end
        end
        
        %% Acessor Functions
        function B1 = B1( obj )      
            if length( obj.B1_ ) > 1
                b1 = obj.B1_( obj.pb );
            else
                b1 = obj.B1_;
            end
      
            ph_rad = 2*pi*(obj.phase_/360.);
            B1 = 2*pi*[ cos(ph_rad)*b1, sin(ph_rad)*b1 ];
        end
        
        function o1 = o1( obj )            
            if length( obj.o1_ ) > 1
                o1 = obj.o1_( obj.po );
            else
                o1 = obj.o1_;
            end
        end
        
        function t = t(obj)
            if length( obj.time_ ) > 1
                t = obj.time_(obj.pt);
            else
                t=obj.time_;
            end
            
        end
        
        
    end
end

