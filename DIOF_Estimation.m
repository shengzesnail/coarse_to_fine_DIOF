function [u, v,m,c,fx, fy, ft] = DIOF_Estimation(im1, im2, lambda, lam_mc, ite, ...
    uLast,vLast, mLast,cLast,boundaryCondition)
%% dynamic illumination optical flow method at a pyramid level
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage:
% [u, v, m, c] = DIOF_Estimation(im1, im2, lambda, ite, uLast,vLast)
% -im1,im2: two subsequent frames or images.
% -lambda: smoothing parameter for velocity field
% -lam_mc: smoothing parameter for M and C
% -uLast, vLast : the flow field estimates of last pyramid; default is zero
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Shengze Cai test in March 2016
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Default parameters
if nargin<4
    lambda=1; lam_mc=100;
end 
if nargin<5
    ite=2000;
end
if nargin<10
    boundaryCondition = 'periodical';
end

%%
% Set initial value for the flow vectors
uInitial = uLast;
vInitial = uLast;
u = uInitial;
v = vInitial;
m = mLast;
c = cLast;

% Estimate spatiotemporal derivatives
[fx, fy, ft] = computeDerivatives_f(im1, im2, boundaryCondition);

% Averaging kernel
% kernel_1=[1/12 1/6 1/12;1/6 0 1/6;1/12 1/6 1/12];
kernel_1=[0 1/4 0;1/4 0 1/4;0 1/4 0];


for i=1:ite
    % Compute local averages of the flow vectors
    [uAvg] = computeAvg(u,kernel_1,boundaryCondition);
    [vAvg] = computeAvg(v,kernel_1,boundaryCondition);
    [mAvg] = computeAvg(m,kernel_1,boundaryCondition);
    [cAvg] = computeAvg(c,kernel_1,boundaryCondition);
    
    
    % Compute flow vectors 
    % Newton gradient decent
    dJdu = fx.*( fx.*(u-uLast)+fy.*(v-vLast)+ft - im1.*m - c ) + lambda.*(u-uAvg);
    dJ2du2 = fx.^2 + lambda;
    u = u - 0.8* dJdu ./ dJ2du2;
    dJdv = fy.*( fx.*(u-uLast)+fy.*(v-vLast)+ft - im1.*m - c ) + lambda.*(v-vAvg);
    dJ2dv2 = fy.^2 + lambda;
    v = v - 0.8* dJdv ./ dJ2dv2;
    dJdm = - im1.*( fx.*(u-uLast)+fy.*(v-vLast)+ft - im1.*m - c ) + lam_mc.*(m-mAvg);
    dJ2dm2 = im1.^2 + lam_mc;
    m = m - 0.8* dJdm ./ dJ2dm2;
    dJdc = - 1.*( fx.*(u-uLast)+fy.*(v-vLast)+ft - im1.*m - c ) + lam_mc.*(c-cAvg);
    dJ2dc2 = 1.^2 + lam_mc;
    c = c - 0.8* dJdc ./ dJ2dc2;
    
end

u(isnan(u))=0;
v(isnan(v))=0;

