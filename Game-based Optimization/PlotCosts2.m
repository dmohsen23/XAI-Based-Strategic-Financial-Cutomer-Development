function PlotCosts2(pop,rep)
    
    rep_costs=[rep.Cost];
    scatter(rep_costs(1,:), rep_costs(2,:), '*', 'MarkerFaceColor', '#0D47A1', 'MarkerEdgeColor', '#0D47A1', 'LineWidth', 15);

    ax = gca; % current axes
    ax.FontSize = 30;
    ax.TickDir = 'in';
    ax.LineWidth = 3;
%     ax.View = [35 35];
    ax.GridAlpha = 0.25;
    
    xlabel('1st Objective','FontSize', 30);
    ylabel('2nd Objective','FontSize', 30);
    
    grid on;
    
    hold off;

end