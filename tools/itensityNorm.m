%% Itensity Normalization
% To cope with the brightness variations, the intensity of the images
% should be normalized prior to the applicaiton of the 
% optical flow method with a digital filter sequence
% Ref:
% Kapulla, R., et al.
% Parameter Sensitivity of Optical Flow Applied to PIV Images. 2011.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Shengze Cai 2016/03
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [I_result] = itensityNorm(I_ori)
ls = 2;
I_map = 255;
% first step: sliding minimum filter (SMF)
I_smf = SMF(I_ori,ls);
% difference 
I_diff = I_ori - I_smf;
% strict sliding maximum filter (SSMF)
I_ssmf = SSMF(I_ori,ls);
% ratio
I_ra = I_map./I_ssmf;
% result 
I_n = I_diff.*I_ra;
% clip
for i = 1:size(I_n,1)
    for j = 1:size(I_n,2)
        if I_n(i,j)<0
            I_n(i,j) = 0;
        elseif I_n(i,j)>I_map
            I_n(i,j) = I_map;
        end
    end
end
I_result = I_n;

%% sliding minimum filter (SMF)
function I_smf = SMF(I,ls)
[M,N] = size(I);
Iavg = zeros(M,N);
% first step
for j = 1:N          
    Imin = I(1,j);
    Iavg(1,j) = I(1,j);
    for i = 2:M
        if I(i,j)>Imin
            Imin = (ls/2-1)/(ls/2)*Imin + 1/(ls/2)*I(i,j);
        else
            Imin = I(i,j);
        end
        Iavg(i,j) = (ls-1)/ls*Iavg(i-1,j) + 1/ls*Imin;
    end
end

for j = 1:N
    for i = M-1:-1:1
        Iavg(i,j) = (ls-1)/ls*Iavg(i+1,j) + 1/ls*Iavg(i,j);
    end
end

for i = 1:M
    for j = 2:N
        Iavg(i,j) = (ls-1)/ls*Iavg(i,j-1) + 1/ls*Iavg(i,j);
    end
end

for i = 1:M
    for j = N-1:-1:1
        Iavg(i,j) = (ls-1)/ls*Iavg(i,j+1) + 1/ls*Iavg(i,j);
    end
end
I_smf = Iavg;
        

%% strict sliding maximum filter (SSMF)
function I_ssmf = SSMF(I,ls)
[M,N] = size(I);
Iavg = zeros(M,N);
% first step
for j = 1:N        
    Iavg(1,j) = I(1,j);
    for i = 2:M
        if Iavg(i,j) < Iavg(i-1,j)
            Iavg(i,j) = (ls/2-1)/(ls/2)*Iavg(i-1,j) + 1/(ls/2)*I(i,j);
        else
            Iavg(i,j) = I(i,j);
        end
    end
end

for j = 1:N
    for i = M-1:-1:1
        Iavg(i,j) = max([Iavg(i,j), (ls-1)/ls*Iavg(i+1,j) + 1/ls*Iavg(i,j) ]);
    end
end

for i = 1:M
    for j = 2:N
        Iavg(i,j) = max([Iavg(i,j), (ls-1)/ls*Iavg(i,j-1) + 1/ls*Iavg(i,j) ]);
    end
end

for i = 1:M
    for j = N-1:-1:1
        Iavg(i,j) = max([Iavg(i,j), (ls-1)/ls*Iavg(i,j+1) + 1/ls*Iavg(i,j) ]);
    end
end
I_ssmf = Iavg;







