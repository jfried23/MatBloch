function [ before, after ] = remapCEST( data, norm_data, freq1, freq2, range, B0map, mask, flag )
% CESTmap
%    Input
%       data - images after normalized
%       freq1 - Frequency offsets measured
%       freq2 - Frequency offsets used in interpolation
%       range - the frequency offsets where CEST maps will be created
%       (begin:step:end)
%       B0map
%       mask
%       flag - 0 if single-frequency, modulation frequency (>0) if two-frequency
%    Output
%       before - CEST map before the B0 correction
%       after - CEST map after the B0 correction
%

[d1 d2 d3] = size(data);
ncestmap = length(range);

before = zeros(d1,d2,3,ncestmap);
after = zeros(d1,d2,3,ncestmap);

count=nnz(mask);
[row col] = find(mask);

norm_data = repmat(norm_data,[1 1 d3]);
data = data./norm_data;
clear norm_data

h = waitbar(0,'Please wait...');

for k=1:count
    waitbar(k/count)

    x = row(k);
    y = col(k);

    temp1 = spline(freq1,data(x,y,:),freq2);
    temp2 = spline(freq2,temp1,freq2+B0map(x,y));

    for m=1:ncestmap

        if flag==0
            ind1 = find(freq2==range(m));
            ind2 = find(freq2==-range(m));
        else
            ind1 = find(freq2==(range(m)-flag));
            ind2 = find(freq2==(flag-range(m)));
        end

        before(x,y,1,m) = temp1(ind1);
        before(x,y,2,m) = temp1(ind2);
        after(x,y,1,m) = temp2(ind1);
        after(x,y,2,m) = temp2(ind2);

    end

    before(:,:,3,:) = before(:,:,2,:) - before(:,:,1,:);
    after(:,:,3,:) = after(:,:,2,:) - after(:,:,1,:);

end

close(h)

end