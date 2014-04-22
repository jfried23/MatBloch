function params = parse_acqus( path )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

acqus = fileread( path );

splt=strsplit(acqus, '\n');

keys=[];
values=[];

for i = 1:length(splt)
        p = regexp( splt(i), '=', 'split');
        if length(p{1}) == 2
            key = strtrim( strrep( strrep(p{1}(1), '#',''),'$','') );
            val = strtrim( strrep(p{1}(2), '=','') );
            
            try 
                val = str2num(val);
            catch
                val=val;
            end
                
            keys=[keys, key];
            values=[values, val];
        end
        
end

params = containers.Map(keys,values);

end

