% File: testfunctions_time.m
% This file is part of the PROS source code package
% It calculates the values of the 12 objective functions 100,000 times for
% D = 5, 10, 30 and 50 and plots the results in a figure

% v1.00, April 10, 2021

clear % Clear memory
clear global % Clear global variables
clc % Clear workspace screen

addpath('mainprog/functions') % Folder containing the 12 objective functions

NumFunctions=12;
    FunctionNames={@sphere_func, @ellipsoid_func, @sumpow_func, ...
        @quintic_func, @drop_wave_func, @weierstrass_func, ...
        @alpine1_func, @ackley_func, @griewank_func, ...
        @rastrigin_func, @happycat_func, @hgbat_func};

NumRuns=1e3; %Times to calculate each function
%The PROS paper uses NumRuns=1e5 (100,000 times)

X = categorical({'F01','F02','F03','F04','F05','F06','F07','F08','F09','F10','F11','F12'});
X = reordercats(X,{'F01','F02','F03','F04','F05','F06','F07','F08','F09','F10','F11','F12'});

elapsedTime=zeros(4,NumFunctions);

figure(1)

for iDim=1:4 % for the 4 dimensions (5, 10, 30, 50)
    switch iDim 
        case 1;
            D = 5; % Number of variables (dimensions)
            mytitle='D=5';
        case 2;
            D = 10; % Number of variables (dimensions)
            mytitle='D=10';
        case 3;
            D = 30; % Number of variables (dimensions)
            mytitle='D=30';
        case 4;
            D = 50; % Number of variables (dimensions)
            mytitle='D=50';
        otherwise        
            disp('No dimension information found')
            return
    end
    
    for FunctionCase=1:NumFunctions % Run all functions
        funName = FunctionNames{FunctionCase};
        tic % Start timer
        for ii=1:NumRuns
            RanVec=rand(1,D); % A random vector of dimension D
            TempVal=funName(RanVec); % Value of the objective function
        end
        elapsedTime(iDim,FunctionCase) = toc; % Stop timer and record time
    end 
    
    subplot(4,1,iDim)
    
    b=bar(X,elapsedTime(iDim,:)')
    ylabel('Time (sec)');
    if iDim==4; xlabel('Objective function'); end
    text([1:length(elapsedTime(iDim,:))], elapsedTime(iDim,:)', num2str(elapsedTime(iDim,:)','%0.4f'),'HorizontalAlignment','center','VerticalAlignment','bottom')
    set(gca,'YScale','log')
    title(mytitle, 'Interpreter', 'none') % Title of the subfigure
end