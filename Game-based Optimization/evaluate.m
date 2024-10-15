VarMax = [9, 51, 50, 180];
Solution = [3, 46, 40, 160];
x = sum(Solution) / sum(VarMax);

if x < 0.5

    d = sum(VarMax) - sum(Solution);
    e = sum(Solution);
    
else

    d = sum(Solution);
    e = sum(VarMax) - sum(Solution);

end



