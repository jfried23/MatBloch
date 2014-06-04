base='/Users/josh/Documents/bruker4/7T/phantum-June02-2014/';
base_freq = 42.576*7;

%% CEST 450
cest_path = fullfile( base,'CEST_450/meas_MID570_Gre_2D_Gauss_10X450d_185V_FID25413.dat');
cest_ref_path  = fullfile( base,'CEST_450/meas_MID571_Gre_2D_TD_ref_12ms_9d_FID25414.dat');

%% Spacer CEST
cest_path = fullfile( base,'Delay_CEST_450/meas_MID574_Gre_2D_P_delayGauss_10x450d_185V_FID25417.dat');
cest_ref_path  = fullfile( base,'Delay_CEST_450/meas_MID575_Gre_2D_TD_ref_12ms_9d_FID25418.dat');

%% P1331 CEST
cest_path = fullfile( base,'P1331_450/meas_MID572_Gre_2D_P1331Gauss_10x450d_FID25415.dat');
cest_ref_path  = fullfile( base,'P1331_450/meas_MID573_Gre_2D_TD_ref_12ms_9d_FID25416.dat');

%% WASSER
wassr_path= fullfile( base,'WASSAR/meas_MID576_Gre_2D_GauWASSR_2X180d_+_500Hz_FID25419.dat');
wassr_ref_path=fullfile( base,'WASSAR/meas_MID577_Gre_2D_TD_ref_12ms_9d_FID25420.dat');

%% Offsets
wsr_offs= -500:20:500;
cst_offs= -2500:100:2500;

cst_refac=-2500:10:2500;
cst_calc=-2500:100:2500;


%% Calulcate B0 Map
wasr=GRE_CEST(wassr_path);
wasr_ref=GRE(wassr_ref_path);

wasr.norm( wasr_ref );

refac_hz=  1;
B0_map = fieldmap( wasr.imgs, wsr_offs, refac_hz, ones(192,192), 0);

%% Prcoess CEST
refac_hz = 5;
cest = GRE_CEST(cest_path);
denst= GRE(cest_ref_path);



final = remapCEST(cest.imgs, cst_offs, B0_map, ones(192,192) );
cest.imgs=final;

cest.norm(denst);

%cest.zero_offset;

cest.norm(denst);

%imagesc