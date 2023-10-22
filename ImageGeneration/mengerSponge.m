function mask = mengerSponge(gen_size, max_iter)

switch gen_size
    case 3
        gen_mat = true(3,3,3);
        gen_mat(2,2,1) = false;
        gen_mat(2,2,3) = false;
        gen_mat(2,:,2) = false;
        gen_mat(:,2,2) = false;
    case 4
        gen_mat = true(4,4,4);
        gen_mat(2:3,2:3,1) = false;
        gen_mat(2:3,2:3,4) = false;
        gen_mat(2:3,:,2:3) = false;
        gen_mat(:,2:3,2:3) = false;       
    case 5
        gen_mat = true(5,5,5);
        gen_mat(2:4,2:4,1) = false;
        gen_mat(2:4,2:4,5) = false;
        gen_mat(2:4,:,2:4) = false;
        gen_mat(:,2:4,2:4) = false;           
    otherwise
        error('not implemented yet')
end

% M1
mask = gen_mat;

for iter = 2:max_iter
    new_mask_cell = cell(size(mask));
    for i=1:size(new_mask_cell,1)
        for j=1:size(new_mask_cell,1)
            for k=1:size(new_mask_cell,1)
                if(mask(i,j,k))
                    new_mask_cell{i,j,k} = gen_mat;
                else
                    new_mask_cell{i,j,k} = false(size(gen_mat));
                end
                
            end
        end
    end
    
    % assemble
    mask = cell2mat(new_mask_cell);
end



end