%% function MAIN for testing DIOF
% i.e., dynamic illumination optical flow (DIOF)
% *************************************
% The formulation of DIOF is modified from the variational HS method
% The brightness constancy assumption is formulated as:
%       f(x+dx,y+dy,t+dt) = M*f(x,y,t) + C
% This results in an optical flow constraint:
%       f_t + f_x u + f_y v + f m + c = 0
% *************************************
% More details can be referred to:
% Cai, S., Huang, Y., Ye, B., & Xu, C. (2018). 
% Dynamic illumination optical flow computing for sensing 
%       multiple mobile robots from a drone. 
% IEEE Transactions on Systems, Man, and Cybernetics: Systems, 
%       48(8), 1370-1382.
% *************************************
%   Edited by Shengze Cai 2018
% *************************************

clear all;
close all;
clc
addpath(genpath('tools'));
addpath(genpath('data'));

%% Parameters settings
PARA.pyramid_level = 5;
PARA.warp_iter = 2;
PARA.ite = 4e3;
% conditions
PARA.boundaryCondition = 'periodical';  % replicated  periodical  slip
PARA.interpolation_method = 'spline';
% is median filtering
PARA.isMedianFilter = true;
PARA.sizeOfMF = [5,5];
% initialize the velocity field
uInitial=zeros(256,256);    % 
vInitial=zeros(256,256);
uvInitial = cat(3,uInitial,vInitial);


%% load images
imFileDir   = ['data' filesep];
flowName = 'run010050200';     % 
im1         = imread([imFileDir flowName '_img1.tif']);
im2         = imread([imFileDir flowName '_img2.tif']);


figure('color',[1,1,1]); 
subplot(131);   imshow(im1,[]); title('First frame');

% synthetic illumination changes
illuminationCase = 3;
switch illuminationCase
    case 0      % nothing
        
    case 1      % small constant
        K = 1.1;
        C = 3; 
        im2 = K*im2+C;
        subplot(132); imshow(C*ones(256,256),[0,15]);
    case 2      % large constant
    	K = 1.1;
        C = 10; 
        im2 = K*im2+C;
        subplot(132); imshow(C*ones(256,256),[0,15]);
    case 3      % linear function
        c = 1/256:1/256:1;
        C = 15 * repmat(c,256,1);
        im2 = double(im2) + C;
        subplot(132); imshow(C, []);
    case 4      % sin function
        c = sin( 2*pi/256* (0:0.05:256) );
        C = 10 * repmat(c(21:20:end),256,1);
        im2 = double(im2) + C;
        subplot(132); imshow(C,[]);
end

subplot(133);   imshow(im2,[]); title('Second frame');


%% compute the optical flow
lambda = 1000;        % smoothing parameter for velocity field
lam_mc = 300000000;      % smoothing parameter for M and C
tic
[u, v, m, c] = DIOF_Pyramids(im1,im2,lambda,lam_mc,PARA);
toc
uv = cat(3,u,v);


%% Display estimated flow fields
% figure; 
% imshow(uint8(flowToColor(uv)));
vort = computeCurl(uv);       % compute the vorticity
plotFlow_Cai(u, v, vort);    % Plot estimated flow field (vector)
title('Estimated Flow Field')

%% if GT flow is available
isGT = true;
if isGT == true
    % read the ground-truth
%     gt_filename = [imFileDir flowName '_flow.flo'];
%     uv_gt = readFlowFile(gt_filename);
    flowFilename = ['data' filesep 'run010050200.mat'];
    load(flowFilename);
    uv_gt = cat(3,U,V);
    
    % display the ground-truth
    vort_gt = computeCurl(uv_gt);
    plotFlow_Cai(uv_gt(:,:,1), uv_gt(:,:,2), vort_gt);    % Plot true flow field (vector)
    title('Ground-truth Flow Field');

	%% Compute AAE, endpoint error
    margin = 0;
    [aae, stdae, aepe, rmse] = ...
        flowAngErr(uv_gt(:,:,1), uv_gt(:,:,2), uv(:,:,1), uv(:,:,2),margin);
    fprintf('All pixels considered AAE %3.3f STD %3.3f \n', aae, stdae);
    fprintf('All pixels considered EPE %3.3f RMSE %3.3f \n', aepe, rmse);
end

