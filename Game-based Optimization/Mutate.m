function xnew=Mutate(x,pm,VarMin,VarMax)

    nVar=numel(x);
    [row, column] = size(x);
    j=randi([1, nVar], [row column]);

    dx=pm*(VarMax-VarMin);

    lb = zeros(row,column);
    ub = zeros(row,column);
    
    for i = 1:row
        for z = 1:column

            lb(i,z)=j(i,z)-dx(i,z);
            if lb(i,z)<VarMin(i,z)
                lb(i,z)=VarMin(i,z);
            end
            
            ub(i,z)=j(i,z)+dx(i,z);
            if ub(i,z)>VarMax(i,z)
                ub(i,z)=VarMax(i,z);
            end
            
            xnew=x;
            if lb(i,z)>ub(i,z)
                xnew(i,z)=unifrnd(ub(i,z),lb(i,z));
            else
                xnew(i,z)=unifrnd(lb(i,z),ub(i,z));
            end

        end
    end
   
end