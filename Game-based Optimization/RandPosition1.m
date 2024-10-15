function [matrix] = RandPosition1(VarSize, VarMin, VarMax)
    
    matrix=zeros(VarSize);
    column=VarSize(2);
    
    for i = 1: column
        [matrix(i)] = VarMin(i) + (VarMax(i) - VarMin(i)) * rand;
    end

end


