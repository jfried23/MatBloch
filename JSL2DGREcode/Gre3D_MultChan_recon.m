%% Script to open 2D data for JSL
% Makis: 18 April 2012
% Updated by Jae-Seung on 8/13/2012
% Ding Nov-2012

clear all
close all     

%%
[FileName PathName]  = uigetfile('*.dat','MultiSelect','on');

%Nexp = 1;
Nexp = length(-1800:1800:1800);
Nexp = length(-3000:100:3000);
%Nexp = length(-3600:100:3600);
%Nexp = length(-540:15:540);
Nchannel = 28;
[image_obj noise_obj phasecor_obj refscan_obj refscanPC_obj RTfeedback_obj phasestab_obj,Raw] = readVBVD_MP([PathName,FileName]);
% [image_obj noise_obj phasecor_obj refscan_obj refscanPC_obj RTfeedback_obj phasestab_obj] = readVBVD([PathName,FileName]);
%DimSize = [192 192];
DimSize = [192 192 8];%3D
%imagesc(abs(Raw))

%% Reshape data for different channels
%K = reshape(Raw,[DimSize(1), size(Raw,2)/(DimSize(2)*Nexp),DimSize(2),Nexp]);
%K = reshape(Raw,[DimSize(1), Nchannel,DimSize(2),Nexp]);
K = reshape(Raw,[DimSize(1), Nchannel,DimSize(2),DimSize(3),Nexp]);

%%
Ktemp = K(:,1,:,1,1);
Ktemp = squeeze(Ktemp);
imagesc(abs(Ktemp))
%%
slc=DimSize(3);%3D
num_echoes=192;%sigle shot
%num_echoes=96;%two shot
n=1;
centric_kspace_dir=[DimSize(2)/num_echoes,0];

for pe2=0:slc-1%3D
    if mod(pe2,2)==0;
        ipe2=pe2/2;
    else
        ipe2=-(pe2+1)/2;
    end
    
   for pe1=0:0;
        
%     ipe1=0;
%     if mod(pe1,2)==0;
%         ipe1=pe1/2;
%     else
%         ipe1=-(pe1+1)/2;
%     end

        kspace_echo=[pe1,ipe2];
%         factor=0;
        for j=0:(num_echoes-1)
            if mod(j,2)==0;
                factor=j/2;
            else
                factor=-((j+1)/2);
            end
%             factor
           X(:,n) =kspace_echo+centric_kspace_dir.*factor;
           n = n+1;
        end
   end
    
end

figure(1);
plot(X(1,:)+10.*X(2,:));
%%
Ktotal = zeros(DimSize(1),DimSize(2),DimSize(3),Nchannel,Nexp);
ImTotal = zeros(DimSize(1),DimSize(2),DimSize(3),Nexp);
tic   
for c1 = 1:Nexp
    n2 = 1;
    for c3 = 1: DimSize(3);
        
        for c2 = 1:DimSize(2)
        ky = X(1,n2)+DimSize(2)/2+1;
        kz = X(2,n2)+DimSize(3)/2+1;%3D
        Ktotal(:,ky,kz,1:Nchannel,c1) = K(:,1:Nchannel,c2,c3,c1);

        n2 = n2 +1;
        end
    end
    
    Kim = squeeze(Ktotal(:,:,:,:,c1));
    
    Imtemp = fftshift(fftn(fftshift(Kim)));
    
    Imtemp = conj(Imtemp).*Imtemp;
    ImTotal(:,:,:,c1) = sum(Imtemp,4);

end
toc
%%

SliceBrowser(ImTotal);colormap(jet);

%%
close all

Max = max(ImTotal(:));
ImSc = ImTotal./Max*128;
nn = ceil(sqrt(Nexp));
for j = 1:1:size(ImTotal,3)
    
    figure(1)
    subplot(nn,nn,j)
    image(ImSc(:,:,j))
%     set(gca,'Xdir','reverse','Ydir','normal')
    axis image
    axis off
    jet(64);
    
end
%%
save('1shot_ref','ImTotal1')














%%
%%
Im = abs(ifftshift(ifft2(Ktotal(:,:,1))));
figure(1)
imagesc(abs(ifftshift(ifft2(Ktotal(:,:,1)))))
colormap(gray)

%% Frequency Sweep %%%%%%%%%%%%%%

FileName = uigetfile('*.dat','MultiSelect','on');

Nexp = 27;%length(-100:100:100);

Raw = read_meas_vb13_seqtree(FileName);
DimSize = [64 64];

imagesc(abs(Raw))
K = Raw;%reshape(Raw_temp,[size(Raw_temp,1),size(Raw_temp,2)/NAVG,NAVG]);

%% Get the sampling pattern
num_echoes=8;
n=1;
centric_kspace_dir=[DimSize(2)/num_echoes,0];

for pe1=0:DimSize(2)/num_echoes-1
%     ipe1=0;
%     if mod(pe1,2)==0;
%         ipe1=pe1/2;
%     else
%         ipe1=-(pe1+1)/2;
%     end
    for pe2=0:0
        kspace_echo=[pe1,pe2];
%         factor=0;
        for j=0:(num_echoes-1)
            if mod(j,2)==0;
                factor=j/2;
            else
                factor=-((j+1)/2);
            end
%             factor
           X(:,n) =kspace_echo+centric_kspace_dir.*factor;
           n = n+1;
        end
    end
end
figure(1);
plot(X(1,:));
%%

Nim = Nexp;
Ktotal = zeros(64,64,Nim);
ImTotal = Ktotal;
    n1 = 1;
   
for c1 = 1:Nim
 n2 = 1;
    for c2 = 1:length(X)
            
        ky = X(1,n2);
        n2 = n2 +1;
        Ktotal(:,ky+33,c1) = Raw(:,n1);
        
        
        n1 = n1+1;
    end
    
    
    ImTotal(:,:,c1) = ifftshift(ifft2(Ktotal(:,:,c1)));

end
%%
close all
SliceBrowser(abs(ImTotal))

%% Segmentation
close all
BW = zeros(64,64)
figure(1)
imagesc(abs(ImTotal(:,:,1)))
BW = roipoly;
%%
ImMasked = zeros(size(ImTotal));
for j = 1:size(ImTotal,3)
    
    ImTemp = ImTotal(:,:,j).*BW;
    ImMasked(:,:,j) = abs(ImTemp);
    
    
    figure(1)
    subplot(8,8,j)
    imagesc(abs(ImTemp));
    
    S(j) = sum(abs(ImTemp(:)));
    
end



figure
plot(S)

%%
ImSc = ImMasked./max(ImMasked(:));
for j = 1:size(ImTotal,3)
    
    ImTemp = ImSc(:,:,j);    
    
    figure(1)
    subplot(8,8,j)
    pcolor(abs(ImTemp));
 
   caxis([0.2 .7])
set(gca,'XTick',[])
set(gca,'YTick',[])
    shading flat

   
    S(j) = sum(abs(ImTemp(:)));
    
end
