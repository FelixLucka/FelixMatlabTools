function result = meshSlicePlot(nodes, elements, para)

%%%%%%%%%% OUTDATED AND UNDOCUMENTED %%%%%%%%%%%%%%%%%%%%%%%%%


    % what should be plotted?
    %[colors df_fl] = check_and_assign_struc(para,'colors','double',0);
%     if(df_fl)
%         if(isfield(para,'data'))
%             data = check_and_assign_struc(para,'data','double','error');
%             [colors, scaling_fun, cmap] = Data2RGB(data,para);
%             NotImpErr
%         else
%             % plot compartments
%             eval('exist_fl = ~isempty(whos(''-file'', GetMatfilename(model),''color_table''));')
%             if ~exist_fl
%                 color_table = create_color_table(model.mesh.compartments);
%             else
%                 load(GetMatfilename(model),'color_table')
%             end
%             labels = GetLabels(model);
%             ext_color_table = zeros(max(labels),3);
%             for i=1:size(ext_color_table,1)
%                 if(~isempty(model.relabel_fun(i)))
%                     ext_color_table(i,:) = color_table(model.relabel_fun(i),:);
%                 end
%             end
%             colors = ext_color_table(labels,:);
%         end
%     end
    
labels = ones(size(elements,1),1);
colors = ones(size(elements,1),3);
    
    coordinate = checkSetInput(para, 'coordinate', [1,2,3], 1);
    value      = checkSetInput(para, 'value', 'double', mean(nodes(:,coordinate)));
    axismode   = checkSetInput(para, 'axismode', {'upright', 'normal'}, 'normal');
    
    nodes_coordinate = nodes(:,coordinate);
    ele_coordinate = nodes_coordinate(elements);
    ele_coordinate_min = min(ele_coordinate,[],2);
    ele_coordinate_max = max(ele_coordinate,[],2);
    log_ind = ele_coordinate_min <= value & ele_coordinate_max >= value;
    slice_indizes = find(log_ind);
    clear nodes_coordinate ele_coordinate ele_coordinate_min ele_coordinate_max log_ind
    
    N_slice_ele = length(slice_indizes);
    N_faces = 0;
    N_plane_verts = 0;
    cdata = zeros(N_slice_ele,3);
    
    %switch model.mesh.element_type
    %    case 'tetrahedron'
            faces = zeros(N_slice_ele,4);
            plane_verts  = zeros(4*N_slice_ele,2);
            
            for i = 1:N_slice_ele
                c_ind = slice_indizes(i);
                curr_nodes = nodes(elements(c_ind,:),:);
                left = curr_nodes((curr_nodes(:,coordinate) < value),:);
                right = curr_nodes((curr_nodes(:,coordinate) >= value),:);
                
                switch size(left,1)
                    case 1
                        for j =1:3
                            lam = (value - left(1,coordinate))/(right(j,coordinate)-left(1,coordinate));
                            intersec_point_3d = left(1,:) + lam * (right(j,:)-left(1,:));
                            intersec_point_2d = intersec_point_3d(1:3 ~= coordinate);
                            N_plane_verts = N_plane_verts + 1;
                            plane_verts(N_plane_verts,:) = intersec_point_2d;
                        end
                        N_faces = N_faces + 1;
                        faces(N_faces,:) = [N_plane_verts-2,N_plane_verts-1,N_plane_verts, NaN];
                        cdata(N_faces,:) = colors(c_ind,:);
                    case 2
                        for j =1:2
                            lam = (value - left(1,coordinate))/(right(j,coordinate)-left(1,coordinate));
                            intersec_point_3d = left(1,:) + lam * (right(j,:)-left(1,:));
                            intersec_point_2d = intersec_point_3d(1:3 ~= coordinate);
                            N_plane_verts = N_plane_verts + 1;
                            plane_verts(N_plane_verts,:) = intersec_point_2d;
                            
                            lam = (value - left(2,coordinate))/(right(j,coordinate)-left(2,coordinate));
                            intersec_point_3d = left(2,:) + lam * (right(j,:)-left(2,:));
                            intersec_point_2d = intersec_point_3d(1:3 ~= coordinate);
                            N_plane_verts = N_plane_verts + 1;
                            plane_verts(N_plane_verts,:) = intersec_point_2d;
                        end
                        N_faces = N_faces + 1;
                        faces(N_faces,:) = [N_plane_verts-3,N_plane_verts-2,N_plane_verts, N_plane_verts-1];
                        cdata(N_faces,:) = colors(c_ind,:);
                    case 3
                        for j =1:3
                            lam = (value - left(j,coordinate))/(right(1,coordinate)-left(j,coordinate));
                            intersec_point_3d = left(j,:) + lam * (right(1,:)-left(j,:));
                            intersec_point_2d = intersec_point_3d(1:3 ~= coordinate);
                            N_plane_verts = N_plane_verts + 1;
                            plane_verts(N_plane_verts,:) = intersec_point_2d;
                        end
                        N_faces = N_faces + 1;
                        faces(N_faces,:) = [N_plane_verts-2,N_plane_verts-1,N_plane_verts, NaN];
                        cdata(N_faces,:) = colors(c_ind,:);
                end
                
            end
%         case 'hexahedron'
%             faces = zeros(N_slice_ele,4);
%             plane_verts  = zeros(4*N_slice_ele,2);
%             N_plane_verts = 0;
%             
%             for i=1:N_slice_ele
%                 c_ind = slice_indizes(i);
%                 curr_nodes = nodes(elements(c_ind,:),:);
%                 % Let the one dimension collaps
%                 curr_nodes(:,coordinate) = [];
%                 curr_nodes = unique(curr_nodes,'rows');
%                 K = convhull(curr_nodes);
%                 plane_verts_to_add = curr_nodes(K(2:end),:);
%                 plane_verts(N_plane_verts+1:N_plane_verts+4,:) = plane_verts_to_add;
%                 faces(i,1:4) = N_plane_verts+1:N_plane_verts+4;
%                 cdata(i,:) = colors(c_ind,:);
%                 N_plane_verts  = N_plane_verts + 4;
%                 N_faces = N_faces + 1;
%             end
%         case 'geo_adapt_hexahedron'
%             faces = NaN*zeros(N_slice_ele,12);
%             plane_verts  = zeros(8*N_slice_ele,2);
%             N_plane_verts = 0;
%             
%             for i = 1:N_slice_ele
%                 c_ind = slice_indizes(i);
%                 curr_nodes = nodes(elements(c_ind,:),:);
%                 % break into tedraeder
%                 DT = DelaunayTri(curr_nodes(:,1),curr_nodes(:,2),curr_nodes(:,3));
%                 
%                 % compute intersection of DT with the plane
%                 N_plane_verts_DT = 0;
%                 faces_DT = zeros(6,4);
%                 plane_verts_DT  = zeros(4*6,2);
%                 
%                 for ii=1:size(DT.Triangulation,1)
%                     curr_nodes_DT  = DT.X(DT.Triangulation(ii,:),:);
%                     left = curr_nodes_DT((curr_nodes_DT(:,coordinate) < value),:);
%                     right = curr_nodes_DT((curr_nodes_DT(:,coordinate) >= value),:);
%                     switch size(left,1)
%                         case 1
%                             for j =1:3
%                                 lam = (value - left(1,coordinate))/(right(j,coordinate)-left(1,coordinate));
%                                 intersec_point_3d = left(1,:) + lam * (right(j,:)-left(1,:));
%                                 intersec_point_2d = intersec_point_3d(1:3 ~= coordinate);
%                                 N_plane_verts_DT = N_plane_verts_DT + 1;
%                                 plane_verts_DT(N_plane_verts_DT,:) = intersec_point_2d;
%                             end
%                             faces_DT(ii,:) = [N_plane_verts_DT-2,N_plane_verts_DT-1,N_plane_verts_DT, NaN];
%                         case 2
%                             for j =1:2
%                                 lam = (value - left(1,coordinate))/(right(j,coordinate)-left(1,coordinate));
%                                 intersec_point_3d = left(1,:) + lam * (right(j,:)-left(1,:));
%                                 intersec_point_2d = intersec_point_3d(1:3 ~= coordinate);
%                                 N_plane_verts_DT = N_plane_verts_DT + 1;
%                                 plane_verts_DT(N_plane_verts_DT,:) = intersec_point_2d;
%                                 
%                                 lam = (value - left(2,coordinate))/(right(j,coordinate)-left(2,coordinate));
%                                 intersec_point_3d = left(2,:) + lam * (right(j,:)-left(2,:));
%                                 intersec_point_2d = intersec_point_3d(1:3 ~= coordinate);
%                                 N_plane_verts_DT = N_plane_verts_DT + 1;
%                                 plane_verts_DT(N_plane_verts_DT,:) = intersec_point_2d;
%                             end
%                             faces_DT(ii,:) = [N_plane_verts_DT-3,N_plane_verts_DT-2,N_plane_verts_DT, N_plane_verts_DT-1];
%                         case 3
%                             for j =1:3
%                                 lam = (value - left(j,coordinate))/(right(1,coordinate)-left(j,coordinate));
%                                 intersec_point_3d = left(j,:) + lam * (right(1,:)-left(j,:));
%                                 intersec_point_2d = intersec_point_3d(1:3 ~= coordinate);
%                                 N_plane_verts_DT = N_plane_verts_DT + 1;
%                                 plane_verts_DT(N_plane_verts_DT,:) = intersec_point_2d;
%                             end
%                             faces_DT(ii,:) = [N_plane_verts_DT-2,N_plane_verts_DT-1,N_plane_verts_DT, NaN];
%                     end
%                 end
%                 plane_verts_DT = plane_verts_DT(1:N_plane_verts_DT,:);
%                 K  = convhull(plane_verts_DT(:,1),plane_verts_DT(:,2));
%                 plane_verts_to_add = plane_verts_DT(K(2:end),:);
%                 N_plane_verts_to_add = length(K)-1;
%                 plane_verts(N_plane_verts+1:N_plane_verts+N_plane_verts_to_add,:) = plane_verts_to_add;
%                 faces(i,1:N_plane_verts_to_add) = N_plane_verts+1:N_plane_verts+N_plane_verts_to_add;
%                 cdata(i,:) = colors(c_ind,:);
%                 N_plane_verts  = N_plane_verts + N_plane_verts_to_add;
%                 N_faces = N_faces + 1;
%             end
%         otherwise
%             error('Currently, only element type "tetrahedron" is supported for plotting function slice_view')
%             
%     end
    
    faces = faces(1:N_faces,:);
    cdata = cdata(1:N_faces,:);
    plane_verts = plane_verts(1:N_plane_verts,:);
    
    
    
    switch coordinate
        case 1
            plot_title =  ['slice view at x = ' num2str(value)];
        case 2
            plot_title =  ['slice view at y = ' num2str(value)];
        case 3
            plot_title =  ['slice view at z = ' num2str(value)];
    end
    

    axis_handle = createAxis([]);

    
    
%     switch PlotLevel
%         case {1,2}
            if~(isempty(faces))
                unique_cdata = unique(cdata,'rows');
                for i=1:size(unique_cdata,1)
                    curr_faces = faces(all(bsxfun(@eq,cdata,unique_cdata(i,:)),2),:);
                    if~isempty(curr_faces)
                        result = patch('Faces',curr_faces,'Vertices',plane_verts,'FaceColor',...
                            unique_cdata(i,:),'Parent',axis_handle);
                    end
                end
            else
                result = [];
            end
            
            title(axis_handle,plot_title)
            legend1 = legend(axis_handle,'show');
            set(legend1,'Interpreter','none');
            set(axis_handle,'DataAspectRatio',[1 1 1])
            box(axis_handle,'on');
            index = find(1:3 ~= coordinate);
            
            
            lim = [min(nodes(:,index(1))) max(nodes(:,index(1)))];
            lim = [lim(1)-0.01*(lim(2)-lim(1)) , lim(2)+0.01*(lim(2)-lim(1))];
            xlim(gca,lim);
            
            lim = [min(nodes(:,index(2))) max(nodes(:,index(2)))];
            lim = [lim(1)-0.01*(lim(2)-lim(1)) , lim(2)+0.01*(lim(2)-lim(1))];
            ylim(gca,lim);
            
            if(strcmp(axismode,'upright'))
                if(coordinate == 1|coordinate == 2)
                    set(axis_handle,'YDir','reverse');
                end
            end
            
            drawnow()
%             
%         case  3
%             result  = [];
%             unique_lables = unique(labels);
%             for i=1:length(unique_lables)
%                 color_ind = model.relabel_fun(unique_lables(i));
%                 curr_faces = faces(all(bsxfun(@eq,cdata,color_table(color_ind,:)),2),:);
%                 if~isempty(curr_faces)
%                     result{i}.faces = curr_faces;
%                     result{i}.vertices  = plane_verts;
%                     result{i}.color = color_table(color_ind,:);
%                     result{i}.label = model.mesh.compartments{i};
%                 end
%             end
%     end


end
