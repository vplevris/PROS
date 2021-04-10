% File: main.m
% This file is part of the PROS source code package
% Pure Random Orthogonal Search (PROS):
% A Plain and Elegant Parameterless Algorithm for Global Optimization Instructions

% v1.00, April 10, 2021

clear % Clear memory
clear global % Clear global variables
clc % Clear workspace screen

% Global variables
global counter FunEvalGA bestGA bestGA1
global FunEvalPSO bestPSO bestPSO1

addpath('functions') % Folder of the objective functions
rng default % For reproducibility of results

% Methods  | Num. of Dimensions
% 1. GA   | 1. D=5
% 2. PSO  | 2. D=10
% 3. DE   | 3. D=30
% 4. PRS  | 4. D=50
% 5. PROS |

% 12 problems in total
% 10 runs, to report the average results
% 5*4*12*10=2400 optimization runs in total

NumRuns=1; % How many times to run the optimization problems
NumFunctions=12;
FunctionNames={@sphere_func, @ellipsoid_func, @sumpow_func, ...
    @quintic_func, @drop_wave_func, @weierstrass_func, ...
    @alpine1_func, @ackley_func, @griewank_func, ...
    @rastrigin_func, @happycat_func, @hgbat_func}; % Objective functions
FunBounds=[100 100 10 20 5.12 ...
           0.5  10 32.768 100 ...
           5.12 20 15]; % bounds of the 12 functions used

for iDim=1:4;
    switch iDim % Number of variables (dimensions)
        case 1;
            D = 5; % 5 Dimensions
        case 2;
            D = 10; % 10 Dimensions
        case 3;
            D = 30; % 30 Dimensions
        case 4;
            D = 50; % 50 Dimensions
        otherwise        
            disp('No dimension information found')
            return
    end

    NP=10*D; % Population size for GA, PSO, DE
        % GA MATLAB default: 50 when D <= 5, else 200
        % PSO MATLAB default: min(100,10*D)
    MaxIter=20*D-50; % Max. number of generations/iterations for GA, PSO, DE
        % GA MATLAB default: 100*D
        % PSO MATLAB default: 200*D
    
    % Run all 12 optimization problems
    for FunctionCase=1:NumFunctions; % For every function
        fun = FunctionNames{FunctionCase}; % Function file name
        Bounds=FunBounds(FunctionCase); % Bounds (Upper/Lower)
        BoundsMin=-Bounds; % Lower bound
        BoundsMax=Bounds; % Upper bound
        LB = BoundsMin*ones(1,D); % Lower bound as vector for all D variables
        UB = BoundsMax*ones(1,D); % Upper bound as vector for all D variables

        
        % **************** 1. GA based on MATLAB Optimization
        tic; % Start timer
        optionsGA = optimoptions('ga','OutPutFcn',@gaoutputfcn);
        optionsGA.MaxGenerations=MaxIter-1;
        optionsGA.PopulationSize=NP;
        optionsGA.MaxStallGenerations=MaxIter-1;
            
        clearvars xGA fvalGA exitflagGA outputGA convHistAllGA
        for iRun=1:NumRuns % Number of Runs, to take the average and plot the convergence history
            counter=0; % Start counter
            [xGA(iRun,:),fvalGA(iRun,:),exitflagGA(iRun,:),outputGA{iRun}] = ga(fun,D,[],[],[],[],LB,UB,[],optionsGA);
            convHistAllGA(iRun,:)=bestGA; % NumRuns rows containing all results for all iterations and all Runs
        end
        
        TimeGA = toc; % Stop timer
        xGA; % x vector of best solutions, NumRuns x D
        fvalGA; % the best values for each run, NumRuns x 1
        convHistPlotAvGA=mean(convHistAllGA,1); % Average value of the obj. fun. to plot later on

        
        % **************** 2. PSO based on MATLAB Optimization
        tic; % Start timer
        optionsPSO = optimoptions('particleswarm','OutputFcn',@pswplotranges);
        optionsPSO.MaxIterations=MaxIter-1;
        optionsPSO.SwarmSize=NP;
        optionsPSO.MaxStallIterations=MaxIter-1;
        
        clearvars xPSO fvalPSO exitflagPSO outputPSO convHistAllPSO
        for iRun=1:NumRuns; % Number of Runs, to take the average and plot the convergence history
            counter=0; % Start counter
            [xPSO(iRun,:),fvalPSO(iRun,:),exitflagPSO(iRun,:),outputPSO{iRun}] = particleswarm(fun,D,LB,UB,optionsPSO);
            convHistAllPSO(iRun,:)=bestPSO;
        end
        
        TimePSO = toc; % Stop timer
        xPSO; % x vector of best solutions, NumRuns x D
        fvalPSO; % the best values for each run, NumRuns x 1
        convHistPlotAvPSO=mean(convHistAllPSO,1); % Average value of the obj. fun. to plot later on
        
        
        % **************** 3. DE programmed by Vagelis Plevris, DE/rand/1/bin scheme
        tic; % Start timer
        F=0.6; % DE differential weight
        CR=0.8; % DE crossover probability
        
        clearvars xDE fvalDE convHistAllDE
        for iRun=1:NumRuns; % Number of Runs, to take the average and plot the convergence history
            population = (BoundsMax-BoundsMin).*rand(NP,D) + BoundsMin; %initialize population randomly in the search space
            ui=zeros(1,D);
            funeval=0;
            fvalHistoryDE=[];
            for iter=1:MaxIter; % Run iterations
                for iPart=1:NP; % Run agents
                    funeval=funeval+1;
                    ParticlesIDs=[1:NP]; % All particles' IDs 1, 2, ..., NP
                    ParticlesIDs(iPart)=[]; % Remove current particle iPart from the list
                    Random3=randperm(NP-1,3); % A random permutation of integers 1, 2, ..., NP-1
                    r1=Random3(1); r2=Random3(2); r3=Random3(3); % Get three unique ones randomly
                    xi=population(iPart,:); % Current agent
                    xr1=population(r1,:); xr2=population(r2,:); xr3=population(r3,:);
                    vi = xr1 + F* (xr2-xr3); % Donor vector
                    Change = rand(1,D) <= CR; % Dor all elements
                    Change(randi([1 D])) = 1; % Always change a random dimension
                    ui=xi;
                    ui(Change==1) = vi(Change==1);
                    UpdateUpper = ui > UB;
                    UpdateLower = ui < LB;
                    ui(UpdateUpper)=UB(UpdateUpper); % Keep within UB
                    ui(UpdateLower)=LB(UpdateLower); % Keep within LB
                    if fun(ui)<=fun(xi); population(iPart,:)=ui; end
                    fvalCurrentPopulation(iPart)=fun(population(iPart,:));
                end
                % Finished with all agents for current iteration
                [fvalDE(iRun,:),indexBestDE] = min(fvalCurrentPopulation); %get the best 
                fvalHistoryDE(iter)=fvalDE(iRun,:);
            end
            
            xDE(iRun,:)=population(indexBestDE,:);
            convHistAllDE(iRun,:)=fvalHistoryDE;
        end
        
        TimeDE = toc; % Stop timer
        xDE; % x vector of best solutions, NumRuns x D
        fvalDE; % the best values for each run, NumRuns x 1
        convHistPlotAvDE=mean(convHistAllDE,1); % Average value of the obj. fun. to plot later on
       
        
        % **************** 4. Pure Random Search (PRS), programmed by Vagelis Plevris
        tic; % Start timer
        fe=NP*MaxIter; % Number of objective function evaluations
        convHistALLPRS=zeros(iRun,fe);
        
        clearvars xPRS fvalPRS xPRSAllRuns
        for iRun=1:NumRuns % Number of Runs, to take the average and plot the convergence history
            xPRS1 = (BoundsMax-BoundsMin).*rand(1,D) + BoundsMin;
            xbest=xPRS1;
            xbestval=fun(xbest);
            for i=1:fe;
                yi=(BoundsMax-BoundsMin).*rand(1,D) + BoundsMin; % A random vector in the search space
                if fun(yi)<=xbestval; xbest=yi;xbestval=fun(yi);end
                convHistALLPRS(iRun,i)=xbestval;
            end
            xPRS(iRun,:)=xbest;
            fvalPRS(iRun,:)=fun(xbest);
        end
        
        TimePRS = toc; % Stop timer
        xPRS; % x vector of best solutions, NumRuns x D
        fvalPRS; % the best values for each run, NumRuns x 1
        convHistPlotAvPRS=mean(convHistALLPRS,1); % Average value of the obj. fun. to plot later on
        
        
        % **************** 5. Pure Random Orthogonal Search (PROS), programmed by Vagelis Plevris
        tic; % Start timer
        fe=NP*MaxIter; % Number of objective function evaluations
        convHistAllPros=zeros(iRun,fe);
        
        clearvars xPROS fvalPROS
        for iRun=1:NumRuns % Number of Runs, to take the average and plot the convergence history
            xPROS1 = (BoundsMax-BoundsMin).*rand(1,D) + BoundsMin; % A random vector in the search space
            bestPosition=zeros(fe,D);
            for i=1:fe;
                yi=xPROS1;
                yi(randi([1 D]))=(BoundsMax-BoundsMin).*rand + BoundsMin; % Change one dimension randomly
                funxi=fun(xPROS1);
                if fun(yi)<=funxi; xPROS1=yi; end
                convHistAllPros(iRun,i)=funxi;
                bestPosition(i,:)=xPROS1;
            end
            xPROS(iRun,:)=xPROS1;
            fvalPROS(iRun,:)=fun(xPROS1);
        end
        
        TimePROS = toc; % Stop timer
        xPROS; % x vector of best solutions, NumRuns x D
        fvalPROS; % the best values for each run, NumRuns x 1
        convHistPlotAvPROS=mean(convHistAllPros,1); % Average value of the obj. fun. to plot later on
        
        % Finished with all optimization cases
        % Collect all results for this FunctionCase
        Problems(FunctionCase).xGA=xGA; % GA x vector for each function. Each xGA is [NumRuns x D]
        Problems(FunctionCase).fvalGA=fvalGA; % GA f value for each function. Each fvalGA is [NumRuns x 1]
        Problems(FunctionCase).xPSO=xPSO; % PSO x vector for each function. Each xPSO is [NumRuns x D]
        Problems(FunctionCase).fvalPSO=fvalPSO; % PSO f value for each function. Each fvalPSO is [NumRuns x 1]
        Problems(FunctionCase).xDE=xDE; % DE x vector for each function. Each xDE is [NumRuns x D]
        Problems(FunctionCase).fvalDE=fvalDE; % DE f value for each function. Each fvalDE is [NumRuns x 1]
        Problems(FunctionCase).xPRS=xPRS; % PRS x vector for each function. Each xPRS is [NumRuns x D]
        Problems(FunctionCase).fvalPRS=fvalPRS; % PRS f value for each function. Each fvalPRS is [NumRuns x 1]
        Problems(FunctionCase).xPROS=xPROS; % PROS x vector for each function. Each xPROS is [NumRuns x D]
        Problems(FunctionCase).fvalPROS=fvalPROS; % PROS f value for each function. Each fvalPROS is [NumRuns x 1]

        Times(FunctionCase).GA=TimeGA; % Time needed for GA for each function (for running NumRuns times)
        Times(FunctionCase).PSO=TimePSO; % Time needed for PSO for each function (for running NumRuns times)
        Times(FunctionCase).DE=TimeDE; % Time needed for DE for each function (for running NumRuns times)
        Times(FunctionCase).PRS=TimePRS; % Time needed for PRS for each function (for running NumRuns times)
        Times(FunctionCase).PROS=TimePROS; % Time needed for PROS for each function (for running NumRuns times)
        
        
        % **************** Plot the convergence histories
        figure(iDim)
        subplot(4,3,FunctionCase);
        plot(FunEvalGA, convHistPlotAvGA, ... % GA
            FunEvalPSO, convHistPlotAvPSO, ... % PSO
            [1:MaxIter]*NP, convHistPlotAvDE, ... % DE
            [NP+1:fe], convHistPlotAvPRS(NP+1:size(convHistPlotAvPRS,2)), ... % PRS
            [NP+1:fe], convHistPlotAvPROS(NP+1:size(convHistPlotAvPROS,2)), ... % PROS
            'LineWidth',2);

        
        % Title of the subfigure
        funString=func2str(fun); 
        if FunctionCase<=9;
            TitleString=['F0' num2str(FunctionCase) ' - ' funString(1:end-5)];
        else
            TitleString=['F' num2str(FunctionCase) ' - ' funString(1:end-5)];
        end

        title(TitleString, 'Interpreter', 'none') % Title of the subfigure

        % Axes titles, only for the bottom subfigures to save space
        if FunctionCase == 10 || FunctionCase == 11 || FunctionCase == 12;
            xlabel('Function evaluations')
        end
        if FunctionCase == 1 || FunctionCase == 4 || FunctionCase == 7 || FunctionCase == 10;
            ylabel('Obj. fun.');
        end

        % Legend, only for one subfigure, the top right
        if FunctionCase == 3;
            legend('GA', 'PSO', 'DE', 'PRS', 'PROS', 'Location', 'NorthEast');
        end

        FigName=strcat('Number of dimensions: D=',num2str(D));
        sgtitle(FigName);
    end

    % Store all results in variables and proceed to next number of Dimensions
    AllProblems{iDim}=Problems;
    AllTimes{iDim}=Times;

end