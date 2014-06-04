function [ B0map, dB ] = fieldmap( data, freq, df, mask, flag )
% fieldmap
%   inputs
%      data - WASSR or two-frequency measurement
%      freq - Frequency offsets in the data assuming [-f:(interval):f]
%      df - Frequency interval for interpolation
%      mask - mask
%      flag - 0 if WASSR or 1 if TF
%   outputs
%      B0map - Estimated B0 map
%      dB - Delta B0 map if flag == 1

size_data = size(data);
B0map = zeros(size_data(1), size_data(2));
freq2 = min(freq):df:max(freq);
count=nnz(mask);
[row, col] = find(mask);

if flag == 0

    for k=1:count
        x = row(k);
        y = col(k);
        temp(1,:) = spline(freq,squeeze(data(x,y,:)),freq2);
        [C I] = min(temp);
        B0map(x,y) = freq2(I);
    end

    dB = 0;

elseif flag == 1
    dB = zeros(size_data(1), size_data(2));
    for k=1:count
        x = row(k);
        y = col(k);
        center = round(length(freq2)/2);
        temp1 = spline(freq,squeeze(data(x,y,:)),freq2);
        [C I1] = min(temp1(1,1:center));
        [C I2] = min(temp1(1,center:end));
        B0map(x,y)=0.5*(freq2(I1)+freq2(I2+center-1));
        dB(x,y)=0.5*(freq2(I1)-freq2(I2+center-1));
    end
end

end