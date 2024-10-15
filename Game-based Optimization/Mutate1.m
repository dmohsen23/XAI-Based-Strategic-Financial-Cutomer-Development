function xnew=Mutate1(x,pm,VarMin,VarMax)
    for i=1:2
        for z=1:2
                nVar=numel(x);
                j=randi([1 nVar]);

                dx=pm*(VarMax-VarMin);
    
                lb=x(j)-dx;
                if lb<VarMin
                    lb=VarMin;
                end
    
                ub=x(j)+dx;
                if ub>VarMax
                    ub=VarMax;
                end

                xnew=x;
                if lb>ub
                    xnew(j)=unifrnd(ub,lb);
                else
                    xnew(j)=unifrnd(lb,ub);
                end
        end
    end
end