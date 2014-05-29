%% Script to open 2D data for JSL
% Makis: 18 April 2012
% Updated by Jae-Seung on 8/13/2012

% clear all
% close all
%%
%addpath(genpath('/Users/jaeseunglee/Documents/MATLAB/DataProcessing'))
%% Specify dataset to be opened (need to specify number of shots and number of partitions
clear all
close all     

[filename, pathname] = uigetfile('~/Downloads/May09-2014/*.dat','MultiSelect','on');
FileName = fullfile(pathname, filename);
Nexp = 1;
Nexp = length(-2500:100:2500);
Nchannel = 28; % 7T Knee

[image_obj noise_obj phasecor_obj refscan_obj refscanPC_obj RTfeedback_obj phasestab_obj,Raw] = readVBVD_MP(FileName);

DimSize = [192 192];

K = reshape(Raw,[DimSize(1), Nchannel,DimSize(2),Nexp]);

num_echoes=192;
n=1;
centric_kspace_dir=[DimSize(2)/num_echoes,0];

for pe1=0:0 %DimSize(2)/num_echoes-1

    for pe2=0:0
        kspace_echo=[pe1,pe2];
        for j=0:(num_echoes-1)
            if mod(j,2)==0;
                factor=j/2;
            else
                factor=-((j+1)/2);
            end
           X(:,n) =kspace_echo+centric_kspace_dir.*factor;
           n = n+1;
        end
    end
end

Nim = 1;
Ktotal = zeros(DimSize(1),DimSize(2),Nchannel,Nexp);
ImTotal = zeros(DimSize(1),DimSize(2),Nexp);
n1 = 1;
tic   
for c1 = 1:Nexp
    n2 = 1;
    
    for c2 = 1:length(X)
        ky = X(1,n2)+DimSize(2)/2+1;
        Ktotal(:,ky,1:Nchannel,c1) = K(:,1:Nchannel,c2,c1);
        n1 = n1+Nchannel;
        n2 = n2 +1;
    end
    Kim = squeeze(Ktotal(:,:,:,c1));
    Imtemp = fftshift(fft2(fftshift(Kim)));
    Imtemp = conj(Imtemp).*Imtemp;
    ImTotal(:,:,c1) = sqrt(sum(Imtemp,3)/Nchannel);
end
toc

Max = max(ImTotal(:));
ImSc = ImTotal./Max*64;
nn = ceil(sqrt(Nexp));
for j = 1:1:size(ImTotal,3)
    
    figure(1)
    subplot(nn,nn,j)
    image(ImSc(:,:,j))
    axis image
    axis off
    jet(64);
    
end



