function matrix = RandPosition1(VarSize,VarMin,VarMax)

   matrix = zeros(VarSize);
   [row, column] = size(matrix);
    for i=1:row
        for j=1:column
            matrix(i, j)=unifrnd(VarMin(i,j),VarMax(i,j));        
        end
    end
end

