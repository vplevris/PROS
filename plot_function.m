% File: plot_function.m
% This file is part of the PROS source code package
% It plots an objective function in 2 dimensions

% v1.00, April 10, 2021

clear % Clear memory
clear global % Clear global variables
clc % Clear workspace screen

addpath('mainprog\functions') % Folder of the objective functions

% USER SELECTIONS
fun=@sphere_func; % *** SELECT THE FUNCTION TO PLOT HERE ***

OptiLocation=[0 0]; % *** SELECT THE LOCATION OF THE OPTIMUM HERE ***
% Location of the optimum, to highlight in the figure
% For the case of F04 it is OptiLocation=[-1 -1 ; 2 2] as this function
% has two optima. Both points are plotted this way

Optimum=0; % Value of the optimum, specified manually
% It is zero for all 12 function considered

Bounds=10; % *** SELECT THE BOUNDS OF THE PLOT HERE FOR X1, X2 ***

UB=Bounds; % Upper bound
LB=-UB; % Lower bound

stepx=(UB-LB)/50; % Step of the plot in x-direction
stepy=stepx; % Step of the plot in y-direction

x=LB:stepx:UB;
y=LB:stepy:UB;
[X,Y]=meshgrid(x,y);

for ix=1:size(X,1)
    for iy=1:size(X,2)
        Z(ix,iy)=fun([X(ix,iy) Y(ix,iy)]);
    end
end

surfc(X,Y,Z, 'FaceColor','interp', 'edgecolor',[0.2 0.2 0.2]);
grid on
hold on

h = scatter3(OptiLocation(1,1),OptiLocation(1,2),Optimum,'filled', ...
    'MarkerEdgeColor','k','MarkerFaceColor','r');
if size(OptiLocation,1)==2
    h = scatter3(OptiLocation(2,1),OptiLocation(2,2),Optimum,'filled', ...
    'MarkerEdgeColor','k','MarkerFaceColor','r');
end

h.SizeData = 50;
hold off
xlabel('x1')
ylabel('x2')
zlabel('f','Rotation',0)