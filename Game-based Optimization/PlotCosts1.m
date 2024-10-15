function PlotCosts1(pop,rep)

%     pop_costs=[pop.Cost];
%     plot3(pop_costs(1,:),pop_costs(2,:),pop_costs(3,:), 'o', 'Color', [0 0.4470 0.7410]);
    
%     hold on;
    
    rep_costs=[rep.Cost];

    scatter3(rep_costs(1,:), rep_costs(2,:), rep_costs(3,:), 40, rep_costs(4,:), '*', 'LineWidth', 8)    % draw the scatter plot

    ax = gca; % current axes
    ax.FontSize = 30;
    ax.TickDir = 'in';
    ax.LineWidth = 3;
%     ax.View = [35 35];
    ax.GridAlpha = 0.25;
    ax.XDir = 'reverse';
    view(-31,14)
    xlabel('1st Objective Function', 'FontSize', 30)
    ylabel('2nd Objective Function', 'FontSize', 30)
    zlabel('3rd Objective Function', 'FontSize', 30)

    cb = colorbar;                                     % create and label the colorbar
    cb.Label.String = '4st Objective Function';

end