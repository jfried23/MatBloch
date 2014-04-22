function FID = read_bruker( exp_path )
%BRUKER Summary of this function goes here
%   Detailed explanation goes here

%% Determin dimentionality of the data
if exist( fullfile(exp_path, 'acqu3s') )
    acqu3s = parse_acqus( fullfile(exp_path, 'acqu3s')  );
    acqu2s = parse_acqus( fullfile(exp_path, 'acqu2s')  );
    arraydim =  str2num(acqu3s('TD'))* str2num(acqu2s('TD'));
    fidPath = fullfile(exp_path, 'ser');
    
elseif exist( fullfile(exp_path, 'acqu2s') )
    acqu2s = parse_acqus( fullfile(exp_path, 'acqu2s')  );
    arraydim =  str2num(acqu2s('TD'));
    fidPath = fullfile(exp_path, 'ser');
else
    arraydim = 1;
    fidPath = fullfile(exp_path, 'fid');
end
acqus = parse_acqus( fullfile(exp_path, 'acqus')  );

switch str2num(acqus('BYTORDA'))
    case 0, byte_format='l';         %little endian       
    case 1, byte_format='b';         %big endian
    otherwise, error('unknown data format (BYTORDA)')
end

switch str2num(acqus('DTYPA'))
    case 0, byte_size='int32';
    case 1, byte_size='double';
    otherwise, error('unknown data format (BYTORDA)')
end

%Check that np is a multiple of 256 - otherwise correct
% In a ser file each 1D fid will start at a 1024 byte block boundary even
% if its size is not a multiple of 1k (256 points)
np = str2num(acqus('TD'));
corrpoints=rem(np,256);
if corrpoints>0
    corrpoints=256-corrpoints;
    np=np+corrpoints;
end

%% Read In FID
file_FID=fopen(fidPath,'r',byte_format);
unfilt_FID = zeros(arraydim, np/2);

impfid=fread(file_FID, np*arraydim, byte_size);
compfid=complex(impfid(1:2:end),-impfid(2:2:end));

for k=1:arraydim
    unfilt_FID(k,:)=compfid( (k-1)*(np/2)+1:k*(np/2) );
end

np=(np/2)-corrpoints/2;
unfilt_FID=unfilt_FID(:,1:np);
fclose(file_FID);


%% Remove Digital Filter

BrukDigital=[   2       44.750       46.000       46.311;
                3       33.500       36.500       36.530;
                4       66.625       48.000       47.870;
                6       59.083       50.167       50.229;
                8       68.563       53.250       53.289;
                12      60.375       69.500       69.551;
                16      69.531       72.250       71.600;
                24      61.021       70.167       70.184;
                32      70.016       72.750       72.138;
                48      61.344       70.500       70.528;
                64      70.258       73.000       72.348;
                96      61.505       70.667       70.700;
                128     70.379       72.500       72.524;
                192     61.586       71.333            0;
                256     70.439       72.250            0;
                384     61.626       71.667            0;
                512     70.470       72.125            0;
                768     61.647       71.833            0;
                1024    70.485       72.063            0;
                1536    61.657       71.917            0;
                2048    70.492       72.031            0];

% first check if GRPDLY exists and use that if so
decim=1;
dspfvs=1;

if isKey(acqus,'GRPDLY') && str2num(acqus('GRPDLY')) ~= -1
    digshift = str2num(acqus('GRPDLY'));
else
    if isKey( acqus, 'DECIM' )
        decim=str2num(acqus('DECIM'));
        switch decim
                case 2
                    decimrow=1;
                case 3
                    decimrow=2;
                case 4
                    decimrow=3;
                case 6
                    decimrow=4;
                case 8
                    decimrow=5;
                case 12
                    decimrow=6;
                case 16
                    decimrow=7;
                case 24
                    decimrow=8;
                case 32
                    decimrow=9;
                case 48
                    decimrow=10;
                case 64
                    decimrow=11;
                case 96
                    decimrow=12;
                case 128
                    decimrow=13;
                case 192
                    decimrow=14;
                case 256
                    decimrow=15;
                case 384
                    decimrow=16;
                case 512
                    decimrow=17;
                case 768
                    decimrow=18;
                case 1024
                    decimrow=19;
                case 1536
                    decimrow=20;
                case 2048
                    decimrow=21;
                otherwise
                    disp('unknown value of DECIM parameter in acqus - cannot set compensation for digital filtering')
                    decim=0;
                    decimrow=Inf;
        end
        
        else
            disp('no DECIM parameter in acqus - cannot set compensation for digital filtering')
            decim=0;
            decimrow=Inf;
    end
    
        if isKey( acqus,'DSPFVS' )
            dspfvs=str2num(acqus('DSPFVS'));
            switch dspfvs
                case 10
                    dspfvsrow=2;
                case 11
                    dspfvsrow=3;
                case 12
                    dspfvsrow=4;
                otherwise
                    disp('unknown value of DSPVFS parameter in acqus - cannot set compensation for digital filtering')
                    dspfvs=0;
                    dspfvsrow=0;
            end
        else
            disp('no DSPFVS parameter in acqus - cannot set compensation for digital filtering')
            dspfvs=0;
        end
        if (decimrow>14) && (dspfvsrow==4)
            disp('unknown combination of DSPVFS and DECIM parameters in acqus - cannot set compensation for digital filtering')
            dspfvs=0;
            decim=0;
        end
        
end

if (decim==0) || (dspfvs==0)
        %No digital filtering
        disp('Parameters for digital filtering unknown - assumed to be data without digital filtering')
        digshift=0;
elseif (decim==1) && (dspfvs==1)
        %digital filtering set by GRPDLY
        %do nothing
else digshift=round(BrukDigital(decimrow,dspfvsrow));
end

FID = circshift(unfilt_FID,[0, -digshift]);


end

