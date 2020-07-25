function [nodes, elements, labels] = readTetgen(filename)
%%% reads tetgen output

% read .ele file

IMPORT = importdata([filename '.ele'],' ',1);
if(iscell(IMPORT))
    elements = nan;
    labels = [];
else
    elements = IMPORT.data(:,2:5);
    labels = IMPORT.data(:,end);
end
clear IMPORT

if(any(isnan(elements(:))) || any(isnan(labels(:))))
    % Matlab importdata function was not successful for elements
    
    fid = fopen([filename '.ele'],'r');
    
    aux = fscanf(fid, '%u', 3);
    N_ele = aux(1);
    elements = zeros(N_ele,4);
    if(aux(3))
        labels = zeros(N_ele,1);
        aux = fscanf(fid, '%u', N_ele*6);
        for i=1:4
            elements(:,i) = aux((i+1):6:end);
            labels        = aux(6:6:end);
        end
    else
        aux = fscanf(fid, '%u', N_ele*5);
        for i=1:4
            elements(:,i) = aux((i+1):5:end);
        end
    end
    
    fclose(fid);
end



% read nodes
IMPORT = importdata([filename '.node'],' ',1);
if(iscell(IMPORT))
    nodes = nan;
else
    nodes = IMPORT.data(:,2:end);
end

clear IMPORT
if(any(isnan(nodes(:))))
    % Matlab importdata function was not successful for nodes
    fid = fopen([filename '.node'],'r');
        
    aux = fscanf(fid, '%u', 4);
    N_nodes = aux(1);
    nodes = zeros(N_nodes,3);
    
    if(any(aux(3:4)))
        error('not implemented yet')
    end
        
    aux = fscanf(fid, '%f', N_nodes*4);
    for i=1:3
        nodes(:,i) = aux((i+1):4:end);
    end
    
    fclose(fid);
end


end
