classdef GRE
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Nchannel;
        Nexp;
        imgs;
        
    end
    
    methods
        function obj = GRE( file_path )
           
            [image_obj noise_obj phasecor_obj refscan_obj refscanPC_obj RTfeedback_obj phasestab_obj,Raw] = readVBVD_MP(file_path);
            shape = size( Raw ); 
            
            %Assume =# pts in phase and readout dimensions
            pts1       = shape(1);
            pts2       = shape(1);
            num_chanls = shape(2);
            Nexp       = shape(3)/shape(1);
            
            obj.Nexp = Nexp;
                        
            K = reshape(Raw,[pts1, num_chanls, pts2, Nexp ]);

            %Mindless crap lives below here!
            n=1;
            centric_kspace_dir=[1,0];
            for pe1=0:0
                for pe2=0:0
                    kspace_echo=[pe1,pe2];
                    for j=0:(pts2-1)
                        if mod(j,2)==0; factor=j/2;
                        else factor=-((j+1)/2);
                        end
                        X(:,n) =kspace_echo+centric_kspace_dir.*factor;
                        n = n+1;
                    end 
                end    
            end
            
            Ktotal = zeros(pts1,pts2,num_chanls,Nexp);
            obj.imgs = zeros(pts2,pts2,Nexp);
            n1 = 1;
            tic   
            for c1 = 1:Nexp
                n2 = 1;
                for c2 = 1:length(X)
                    ky = X(1,n2)+pts2/2+1;
                    Ktotal(:,ky,1:num_chanls,c1) = K(:,1:num_chanls,c2,c1);
                    n1 = n1+num_chanls;
                    n2 = n2 +1;
                end
                Kim = squeeze(Ktotal(:,:,:,c1));
                Imtemp = fftshift(fft2(fftshift(Kim)));
                Imtemp = conj(Imtemp).*Imtemp;
                obj.imgs(:,:,c1) = sqrt(sum(Imtemp,3)/num_chanls);
            end   
            toc
        end
      
        function obj = show( obj, indx )
            imagesc(obj.imgs(:,:,indx))
        end
        
    end
    
end

