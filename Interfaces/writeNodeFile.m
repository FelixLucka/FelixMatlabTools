function writeNodeFile(filename, nodes)

if(length(filename) < 5 || ~strcmp(filename(end-4:end),'.node'))
    filename = [filename '.node'];
end

precision_str = '%u   %.5e  %.5e  %.5e\n';

N_nodes = size(nodes,1);

fid = fopen(filename, 'w');
fprintf(fid, [num2str(N_nodes) ' 3 0 0\n']);
fprintf(fid,precision_str,[1:N_nodes;nodes']);
fclose(fid);

end
