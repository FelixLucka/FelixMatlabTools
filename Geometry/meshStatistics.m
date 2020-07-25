function [results, text] = meshStatistics(nodes, elements,disp_flag)


N_nodes = size(nodes,1);
N_elements = size(elements,1);
results.N_nodes = N_nodes;
results.N_elements = N_elements;

e12 = (nodes(elements(:,2),:)) - (nodes(elements(:,1),:));
e13 = (nodes(elements(:,3),:)) - (nodes(elements(:,1),:));
e14 = (nodes(elements(:,4),:)) - (nodes(elements(:,1),:));
e23 = (nodes(elements(:,3),:)) - (nodes(elements(:,2),:));
e24 = (nodes(elements(:,4),:)) - (nodes(elements(:,2),:));
e34 = (nodes(elements(:,4),:)) - (nodes(elements(:,3),:));
norm_e12 = sqrt(sum(e12.^2,2));
norm_e13 = sqrt(sum(e13.^2,2));
norm_e14 = sqrt(sum(e14.^2,2));
norm_e23 = sqrt(sum(e23.^2,2));
norm_e24 = sqrt(sum(e24.^2,2));
norm_e34 = sqrt(sum(e34.^2,2));
edge_length = [norm_e12,norm_e13,norm_e14,...
        norm_e23,norm_e24,norm_e34];
shortest_edge = min(edge_length,[],2);
%longest_edge = max(edge_length,[],2);
clear norm_e23 norm_e24 norm_e24 edge_length
cr_12_13 = multipleCross(e12,e13);
cr_13_14 = multipleCross(e13,e14);
cr_14_12 = multipleCross(e14,e12);
clear e13 e14 e23 e24 e34 
volume = abs(sum(e12.*cr_13_14,2))/6;
clear e12
aux1 = repmat(norm_e12.^2,1,3) .* cr_13_14;
aux2 = repmat(norm_e13.^2,1,3) .* cr_14_12;
aux3 = repmat(norm_e14.^2,1,3) .* cr_12_13;
clear cr_* norm_e*
radius_circum_sphere = sqrt(sum((aux1+aux2+aux3).^2,2))./(12*volume);
clear aux*

%shortest_face_height = min(face_height,[],2);
%shortest_heigth = min(height,[],2);

results.radius_shortest_edge_ratio = radius_circum_sphere./shortest_edge;
%results.aspect_ratio = longest_edge./shortest_face_height;
results.volume  = volume;

% remove 0 volume tets
nZeroVol = nnz(volume == 0);
volume(volume == 0) = [];

text = [{'Mesh statistics:'};
    {['Number of nodes   : ' sprintf('%10i',N_nodes)]};
    {['Number of elements: ' sprintf('%10i',N_elements)]};
    {'Volume statistics:'};
    {['Zero volume: ' int2str(nZeroVol) ' | Smallest volume:   ' num2str(min(volume)) ' |  Largest volume:   ' num2str(max(volume))];
    'Volume histogram:'};
    ];
vol_hist_min = min(log10(volume));
vol_hist_max = max(log10(volume));
vol_hist_edges = floor(vol_hist_min):1:ceil(vol_hist_max);
vol_hist = histc(log10(volume),vol_hist_edges);
for i=1:(length(vol_hist)-1)
    text = [text;{[num2str(vol_hist_edges(i),'%+i') ' < vol < ' num2str(vol_hist_edges(i+1),'%+i')...
        ' : ' sprintf('%10i',vol_hist(i))]}];
end

text = [text;
    {'Mesh quality statistics:'};
    {['Smallest radius_to_edge_ratio: ' num2str(min(results.radius_shortest_edge_ratio))...
    '| Largest radius_to_edge_ratio: ' num2str(max(results.radius_shortest_edge_ratio))]};
    {'Radius_to_edge_ratio histogram:'}];

re_hist_edges = [sqrt(6)/4,0.9,1.2,1.6,2.0,3.0,5.0,7.5];
re_hist = histc(results.radius_shortest_edge_ratio,re_hist_edges);

for i=1:(length(re_hist)-1)
    text = [text;{[num2str(re_hist_edges(i),'%.1f') ' < rer < ' num2str(re_hist_edges(i+1),'%.1f')...
        ' : ' sprintf('%10i',re_hist(i))]}];
end
text = [text;{[num2str(re_hist_edges(end),'%.1f') ' < rer      ' ...
    ' : ' sprintf('%10i',re_hist(end))]}];


% text = [text;{['Smallest aspect_ratio: ' num2str(min(results.aspect_ratio))...
%     '| Largest aspect_ratio: ' num2str(max(results.aspect_ratio))]};
%     {'aspect_ratio histogram:'}];
% 
% ar_hist_edges = [0,1.5,2,2.5,3,4,6,10,15,25,50,100];
% ar_hist = histc(results.aspect_ratio,ar_hist_edges);
% 
% for i=1:(length(ar_hist)-1)
%     text = [text;{[num2str(ar_hist_edges(i),'%4.1f') ' < vol < ' num2str(ar_hist_edges(i+1),'%4.1f')...
%         ' : ' num2str(ar_hist(i))]}];
% end
% text = [text;{[num2str(ar_hist_edges(end),'%4.1f') ' < vol ' ...
%     ' : ' num2str(ar_hist(end))]}];




if(disp_flag)
    for i=1:length(text)
        fprintf('%s\n',text{i})
    end
end

end
