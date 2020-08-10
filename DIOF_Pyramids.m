% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: [u, v,m,c] = DIOF_Pyramids(img1,img2,lambda,lam_mc,PARA,uvInitial)
% ********** inputs ***********
%   im1,im2: two subsequent frames or images.
%   lambda: smoothing parameter for velocity field
%   lam_mc: smoothing parameter for M and C
%   PARA: settings
% ********** outputs ***********
%   u, v: the velocity components
%   m, c: the coefficients of the DIOF constraint equation
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Shengze Cai
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% %%%%%%%%%% Main function %%%%%%%%%%%%
function [u, v, m, c] = DIOF_Pyramids(img1,img2,...
    lambda,lam_mc, PARA,uvInitial)
% Initialize the velocity field
if nargin<6
    uInitial=zeros(size(img1));
    vInitial=zeros(size(img1));
    uvInitial = cat(3,uInitial,vInitial);
end
% Read original images and transform to grey images
if size(size(img1),2)==3
    img1=rgb2gray(img1);
end
if size(size(img2),2)==3
    img2=rgb2gray(img2);
end
img1=double(img1);
img2=double(img2);
% intensity normalization (IN)
[img1] = itensityNorm(img1); 
[img2] = itensityNorm(img2);
% figure; imshow(img1,[]); axis image;
% figure; imshow(img2,[]); axis image;

% Run DIOF with multi-pyramids
[u, v, m, c] = Estimate (img1, img2, lambda,lam_mc, uvInitial,PARA);


%% Run DIOF on all levels and interpolate %%
function [Dx, Dy,m,c] = Estimate (img1, img2, lambda,lam_mc,uvInitial,PARA)
warp_iter = PARA.warp_iter;
sizeOfMF = PARA.sizeOfMF;
isMedianFilter = PARA.isMedianFilter; 
Dx = uvInitial(:,:,1); 
Dy = uvInitial(:,:,2);
m = zeros(size(Dx));
c = zeros(size(Dx));

%% Construct image pyramid for gnc stage 1
pyramid_level = PARA.pyramid_level;
G1{1} = img1; G2{1} = img2;
for L = 2:pyramid_level           
    % Downsampling
    G1{L} = reduce2 (G1{L-1});                           
    G2{L} = reduce2 (G2{L-1});   
end

%% iteration
level = pyramid_level;
for current_level=level:-1:1 
    disp(['-Pyramid level: ', num2str(current_level)])

    small_img1 = G1{current_level};
    small_img2 = G2{current_level};
    sz = size(small_img1);

    uv =  resample_flow(cat(3,Dx,Dy), sz);
    Dx = uv(:,:,1); Dy = uv(:,:,2);
%     mc =  resample_flow(cat(3,m,c), sz);
%     m = mc(:,:,1); c = mc(:,:,2);
    m = imresize(m, sz, 'bilinear');
    c = imresize(c, sz, 'bilinear');

    for iwarp = 1:warp_iter
        W1 = warp_forward (small_img1, Dx, Dy, PARA.interpolation_method); 
        W2 = warp_inverse (small_img2, Dx, Dy, PARA.interpolation_method); 
        [Dx, Dy,m,c] = DIOF_Estimation(W1,W2,lambda,lam_mc,...
            PARA.ite,Dx,Dy,m,c,PARA.boundaryCondition);

        if (isMedianFilter == true)
            Dx = medfilt2(Dx,sizeOfMF,'symmetric'); 
            Dy = medfilt2(Dy,sizeOfMF,'symmetric');
            m = medfilt2(m,sizeOfMF,'symmetric'); 
            c = medfilt2(c,sizeOfMF,'symmetric');
        end
        

    end

end


