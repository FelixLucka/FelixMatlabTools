function mask = mengerSponge4(max_iter)

gen_mat = false(4,4,4);
gen_mat(:,:,1) = [1     1     1     1
                  1     0     0     1
                  1     0     0     1
                  1     1     1     1];
gen_mat(:,:,2) = [1     0     0     1
                  0     0     0     0
                  0     0     0     0
                  1     0     0     1];
gen_mat(:,:,3) = [1     0     0     1
                  0     0     0     0
                  0     0     0     0
                  1     0     0     1];
gen_mat(:,:,4) = [1     1     1     1
                  1     0     0     1
                  1     0     0     1
                  1     1     1     1];
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