function game_result = game_test(game_matrix)

    minmax = min(game_matrix, [], 2);
    winner_row = max(minmax);
    
    maxmin = max(game_matrix);
    winner_col = min(maxmin);
    
    if winner_row == winner_col
        game_result = find(game_matrix == winner_row);
    else
        game_result = 0;
    end
    
end
