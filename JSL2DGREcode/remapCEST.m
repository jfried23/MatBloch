function refactor = remapCEST( data, offsets, B0map, mask )
% CESTmap
%    Input
%       data    - images after normalization
%       offsets - Frequency offsets measured
%       B0map   - B0map computed from WASSR
%       mask 


[d1, d2, d3] = size(data);
refactor = zeros(d1, d2, d3);

[row, col] = find(mask);

h = waitbar(0,'Please wait...');


    for k=1:nnz(mask)
        waitbar(k/length(row))
        x = row(k);
        y = col(k);
        
        refactor(x,y,:) = transpose(squeeze(spline( offsets, data(x,y,:), offsets+B0map(x,y) )));
        
    end
    
close(h);
end