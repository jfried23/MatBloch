if ~exist('a')
    a=GRE('/Users/josh/Documents/bruker4/7T/meas_MID155_Gre_2D_P1331Gauss_10x900d_FID24723.dat');
end
if ~exist('b')
    b=GRE('/Users/josh/Documents/bruker4/7T/meas_MID153_Gre_2D_Gauss_10X900d_FID24721.dat');
end
if ~exist('c')
    control=GRE('/Users/josh/Documents/bruker4/7T/meas_MID158_Gre_2D_TD_ref_Col_160FOVover_10d_FID24726.dat');
end

meme=GRE_CEST_v2(a,b)