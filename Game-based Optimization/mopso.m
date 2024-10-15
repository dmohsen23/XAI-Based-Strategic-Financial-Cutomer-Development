tic
clc;
clear;
close all;
format longG

%% Problem Definition

open_file = xlsread('Clean_Dataset.csv');
file = [open_file(:, 1), normalize(open_file(:, 2:end), 'range')];

% Importing the Observed and Prospective Customers
z = 1;
o = 426;                             % Index of Observed Customer
p = 361;                             % Index of Prospective Customer

Cuo = file(z+o, [2 4]);              % Observed Customer
Cup = file(z+p, [2 4]);              % Prospective Customer

stra = 2;                           % Benchmark features
nfeat = 2;                          % Alpha1 and Alpha2
VarSize=[1, stra+nfeat];            % Size of Decision Variables Matrix
column = VarSize(2);

coeff = [0.1947, 0.0508];

% Cost Function
% CostFunction = @(x, Cuo, Cup, coeff)    MyCost(x, Cuo, Cup, coeff);
CostFunction = @(x, Cuo, Cup, coeff)    MyCost2(x, Cuo, Cup, coeff);

VarMinM = 0;
VarMaxM = 0.009;

VarMin = [0, 0, 0, 0, 50, 81];
VarMax = [abs(Cup - Cuo), 80, 100];
%% MOPSO Parameters

MaxIt=500;          % Maximum Number of Iterations
nPop=100;           % Population Size
nRep=30;           % Repository Size
b_size=1;          % Batch size

w=1;                % Inertia Weight
wdamp=0.4;          % Intertia Weight Damping Rate
c1=0.2;             % Personal Learning Coefficient
c2=0.1;             % Global Learning Coefficient

nGrid=5;            % Number of Grids per Dimension
alpha=0.2;          % Inflation Rate

beta=1;             % Leader Selection Pressure
gamma=2;            % Deletion Selection Pressure

mu=0.1;             % Mutation Rate
%% Initialization

empty_particle.Position=[];
empty_particle.Velocity=[];
empty_particle.Cost=[];
empty_particle.Rho=[];
empty_particle.PD=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];
empty_particle.IsDominated=[];
empty_particle.GridIndex=[];
empty_particle.GridSubIndex=[];
empty_particle.ZSum=[];

pop=repmat(empty_particle, nPop, 1);

empty_batch.f=[];
empty_batch.Optimal=[];
empty_batch.ZSum=[];
empty_batch.delta=[];
empty_batch.game_matrix=[];
empty_batch.PD_Condition1=[];
empty_batch.PD_Condition2=[];

batch = repmat(empty_batch, b_size, 1);

game = zeros(b_size, 1);

for cv = 1: b_size

    % Show Iteration Information
    disp(['Epoch: ' num2str(cv), '/' num2str(b_size)]);

    for i=1:nPop
        pop(i).Position=RandPosition1(VarSize, VarMin, VarMax);
        pop(i).Velocity=zeros(VarSize);
        pop(i).Cost=CostFunction(pop(i).Position, Cuo, Cup, coeff);
%         pop(i).Rho=pop(i).Cost(4:7);
%         pop(i).PD=pop(i).Cost(8:11);
%         pop(i).ZSum=sum(pop(i).Cost(1:3));

        pop(i).Rho=pop(i).Cost(3:6);
        pop(i).PD=pop(i).Cost(7:10);
        pop(i).ZSum=sum(pop(i).Cost(1:2));

        % Update Personal Best
        pop(i).Best.Position=pop(i).Position;
        pop(i).Best.Cost=pop(i).Cost;  
%         pop(i).Best.Rho=pop(i).Best.Cost(4:7);
%         pop(i).Best.PD=pop(i).Best.Cost(8:11);
%         pop(i).Best.ZSum=sum(pop(i).Best.Cost(1:3));

        pop(i).Best.Rho=pop(i).Best.Cost(3:6);
        pop(i).Best.PD=pop(i).Best.Cost(7:10);
        pop(i).Best.ZSum=sum(pop(i).Best.Cost(1:2));

    end
    
    % Determine Domination
    pop=DetermineDomination(pop);
    rep=pop(~[pop.IsDominated]);
    Grid=CreateGrid(rep,nGrid,alpha);
    
    for i=1:numel(rep)
        rep(i)=FindGridIndex(rep(i),Grid);
    end
    
    %% MOPSO Main Loop
    
        for it=1:MaxIt
            for i=1:nPop

                leader=SelectLeader(rep,beta);
            
                pop(i).Velocity = w*pop(i).Velocity ...
                    +c1*rand(VarSize).*(pop(i).Best.Position-pop(i).Position) ...
                    +c2*rand(VarSize).*(leader.Position-pop(i).Position);
                
                pop(i).Position = pop(i).Position + pop(i).Velocity;
                pop(i).Cost = CostFunction(pop(i).Position, Cuo, Cup, coeff);
%                 pop(i).Rho=pop(i).Cost(4:7);
%                 pop(i).PD=pop(i).Cost(8:11);
%                 pop(i).ZSum=sum(pop(i).Cost(1:3));

                pop(i).Rho=pop(i).Cost(3:6);
                pop(i).PD=pop(i).Cost(7:10);
                pop(i).ZSum=sum(pop(i).Cost(1:2));
                
                % Apply Mutation
                pm=(1-(it-1)/(MaxIt-1))^(1/mu);
                
                NewSol.Position=Mutate1(pop(i).Position, pm, VarMinM, VarMaxM);
                NewSol.Cost=CostFunction(NewSol.Position, Cuo, Cup, coeff);
%                 NewSol.Rho=NewSol.Cost(4:7);
%                 NewSol.PD=NewSol.Cost(8:11);
%                 NewSol.ZSum=sum(NewSol.Cost(1:3));

                NewSol.Rho=NewSol.Cost(3:6);
                NewSol.PD=NewSol.Cost(7:10);
                NewSol.ZSum=sum(NewSol.Cost(1:2));

                if Dominates(NewSol,pop(i))
                    pop(i).Position=NewSol.Position;
                    pop(i).Cost=NewSol.Cost;
                    pop(i).Rho=NewSol.Rho;
                    pop(i).PD=NewSol.PD;
                    pop(i).ZSum=NewSol.ZSum;
                    Optimal=pop(i).Position(pop(i).ZSum==max([pop(i).ZSum]));

                elseif Dominates(pop(i),NewSol)
                    %Do Nothing
                else
                    if rand<0.5
                        pop(i).Position=NewSol.Position;
                        pop(i).Cost=NewSol.Cost;
                        pop(i).Rho=NewSol.Rho;
                        pop(i).PD=NewSol.PD;
                        pop(i).ZSum=NewSol.ZSum;
                    end
                end
    
                if Dominates(pop(i),pop(i).Best)
                   pop(i).Best.Position=pop(i).Position;
                   pop(i).Best.Cost=pop(i).Cost;
%                    pop(i).Best.Rho=pop(i).Best.Cost(4:7);
%                    pop(i).Best.PD=pop(i).Best.Cost(8:11);
%                    pop(i).Best.ZSum=sum(pop(i).Best.Cost(1:3));

                   pop(i).Best.Rho=pop(i).Best.Cost(3:6);
                   pop(i).Best.PD=pop(i).Best.Cost(7:10);
                   pop(i).Best.ZSum=sum(pop(i).Best.Cost(1:2));

                elseif Dominates(pop(i).Best,pop(i))
                   %Do Nothing  
                else
                   if rand < 0.5
                       pop(i).Best.Position=pop(i).Position;
                       pop(i).Best.Cost=pop(i).Cost;
%                        pop(i).Best.Rho=pop(i).Best.Cost(4:7);
%                        pop(i).Best.PD=pop(i).Best.Cost(8:11);
%                        pop(i).Best.ZSum=sum(pop(i).Best.Cost(1:3));

                       pop(i).Best.Rho=pop(i).Best.Cost(3:6);
                       pop(i).Best.PD=pop(i).Best.Cost(7:10);
                       pop(i).Best.ZSum=sum(pop(i).Best.Cost(1:2));
                   end
                end

            end

        % Add Non-Dominated Particles to REPOSITORY
        rep=[rep; pop(~[pop.IsDominated])];
        
        % Determine Domination of New Resository Members
        rep=DetermineDomination(rep);
        
        % Keep only Non-Dminated Memebrs in the Repository
        rep=rep(~[rep.IsDominated]);
        
        % Update Grid
        Grid=CreateGrid(rep,nGrid,alpha);
    
        % Update Grid Indices
        for i=1:numel(rep)
            rep(i)=FindGridIndex(rep(i),Grid);
        end
        
        % Check if Repository is Full
        if numel(rep)>nRep
            Extra=numel(rep)-nRep;
            for e=1:Extra
                rep=DeleteOneRepMemebr(rep,gamma);
            end
        end
        
        % Plot Costs
        fig = gcf;
        fig.PaperUnits = 'inches';
        fig.PaperPosition = [0 0 40 25];
        figure(1);
        PlotCosts2(pop,rep);

        % Show Iteration Information
        disp(['Iteration ' num2str(it) ': Number of Rep Members = ' num2str(numel(rep))]);
        
        % Damping Inertia Weight
        w=w*wdamp;
            
        end
    
        batch(cv).f = find([rep.ZSum] == max([rep.ZSum]));
        batch(cv).Optimal = round(rep(batch(cv).f).Position, 3);
        batch(cv).ZSum = round(rep(batch(cv).f).ZSum, 3);

        for k=1:numel(Cup)
            if Cup(k) > Cuo(k)
                batch(cv).delta(k) = round(batch(cv).Optimal(k) + Cuo(k), 3);
            else
                batch(cv).delta(k) = round(Cuo(k) - batch(cv).Optimal(k), 3);
            end
        end
        
        batch(cv).game_matrix = round([rep(batch(cv).f).Rho(1:2, :)'; rep(batch(cv).f).Rho(3:4, :)'], 2);

        if (batch(cv).game_matrix(2,1) > batch(cv).game_matrix(1,1)) && (batch(cv).game_matrix(1,1) > batch(cv).game_matrix(2,2)) && ...
                (batch(cv).game_matrix(2,2) > batch(cv).game_matrix(1,2))
            batch(cv).PD_Condition1 = 'True';
        else
            batch(cv).PD_Condition1 = 'False';
        end

        if rep(batch(cv).f).PD > 0
            batch(cv).PD_Condition2 = 'True';
        else
            batch(cv).PD_Condition2 = 'False';
        end

        saveas(fig, sprintf('E:/External Projects/XAI/Second Paper/Pareto solutions/Case 426-361/myFig%d.jpg', cv)); 
end

disp(['The best solution on Pareto frontier: ' num2str(find([batch.ZSum] == min([batch.ZSum])))]);

toc