function [Im1,Im2]  = ITRACK_TwoImageLoad(TestType, FigNum)
% Loads two images for testing camera views

%-----------------------------------------------------
% Ver   Date        Who   What
%-----------------------------------------------------
% 0100  18.02.13    UD   using camera parameter estimation
%-----------------------------------------------------

if nargin < 1,  TestType = 2; end;
if nargin < 2,  FigNum = 1; end;

switch TestType,
    
    case 1, % 4 different neighborhoods 4- 4 match
        Im1     = double(rand(128));
        Im1(30,30) = 128;
        Im1(30,50) = 128;
        Im1(70,30) = 128;
        Im1(70,80) = 128;
        Im1      = imfilter(Im1,fspecial('gaussian'),'same');
        
        
        % shift
        Im2     = rot90(Im1,-1);
        
    case 2, % one point is match -- requires flip
        Im1         = double(rand(128));
        Im1(30,30) = 128;
        Im1(30,70) = 128;
        Im1(70,30) = 128; Im2 = Im1;
        Im1(70,50) = 128; Im2(50,70) = 128;
        Im1         = imfilter(Im1,fspecial('gaussian'),'same');
        Im2         = imfilter(Im2,fspecial('gaussian'),'same');
        
        
        
    case 3, % number of points
        Im1     = double(rand(128));
        Im2     = double(rand(128));
        indx    = floor(rand(1,9)*128^2);
        Im1(indx(2:end)) = 128;
        Im1      = imfilter(Im1,fspecial('gaussian'),'same');
        Im2(indx(1:end)) = 128;
        Im2      = imfilter(Im2,fspecial('gaussian'),'same');
        
     case 4, % missing points
        Im1     = double(rand(128));
        Im2     = double(rand(128));
        indx    = floor(rand(1,15)*128^2);
        Im1(indx(2:end)) = 128;
        Im1      = imfilter(Im1,fspecial('gaussian'),'same');
        Im2(indx(1:end)) = 128;
        Im2      = imfilter(Im2,fspecial('gaussian'),'same');
       
        
    case 5, % missing 3 point
        
        Im1     = double(rand(128));
        Im2     = double(rand(128));
        indx    = floor(rand(1,25)*128^2);
        Im1(indx(4:end)) = 128;
        Im1      = imfilter(Im1,fspecial('gaussian'),'same');
        Im2(indx(1:end)) = 128;
        Im2      = imfilter(Im2,fspecial('gaussian'),'same');
        
        
    case 6, % missing 10 points
        
        Im1     = double(rand(128));
        Im2     = double(rand(128));
        indx    = floor(rand(1,70)*128^2);
        Im1(indx(11:end)) = 128;
        Im1      = imfilter(Im1,fspecial('gaussian'),'same');
        Im2(indx(1:end)) = 128;
        Im2      = imfilter(Im2,fspecial('gaussian'),'same');

    case 7,
        
        Im1      = double(rand(128,128) > 0.995)*128;
        Im1      = imfilter(Im1,fspecial('gaussian'),'same');
        
        % shift
        Im2     = circshift(Im1,[5 5]);
        
    case 8, % special type of points
        Im1         = double(rand(128));
        Im1(30,30) = 128;
        Im1(30,70) = 128;
        Im1(50,30) = 128;
        Im1(50,70) = 128;
        Im1(40,50) = 128;
        Im1         = imfilter(Im1,fspecial('gaussian'),'same');
        
        % shift
        Im2     = rot90(Im1,-1);
        
 
      case 9, % special type of points - circle with center
        Im1     = double(rand(128));
        Im1(30,30) = 128;
        Im1(30,70) = 128;
        Im1(70,30) = 128;
        Im1(70,70) = 128;
        Im1(50,50) = 128;
        Im1      = imfilter(Im1,fspecial('gaussian'),'same');
        
        % shift
        Im2     = rot90(Im1,0);
      
      case 10, % special type of points - circle with point outside
        Im1     = double(rand(128));
        xy1     = [30 30;50 50;50 40;30 50;90 80]; 
        Im1(sub2ind([128 128],xy1(:,1),xy1(:,2))) = 128;
        Im1      = imfilter(Im1,fspecial('gaussian'),'same');
        
        Im2     = double(rand(128));
        xy2     = [30 30;50 50;50 40;30 50;80 90]; 
        Im2((sub2ind([128 128],xy2(:,1),xy2(:,2)))) = 128;
        Im2      = imfilter(Im2,fspecial('gaussian'),'same');
      
        
    case 11,
        
        [x,y]   = meshgrid(linspace(-1,1,128));
        Im1     = cos(10*pi*x+6*pi*y)*64 + 128;
        
        % shift
        Im2     = circshift(Im1,[5 5]);
        
        
    case 12,
        % patterns for correlation
        ImPatch = ones(16);  ImPatch(5:12,5:12) = 0;
        %ImPatch = rand(32);
        %
        Im = repmat(ImPatch,[8 8]);
        Im1 = Im * 128 + 10 + randn(size(Im))*8;
        % shift
        Im2 = circshift(Im1,[0 0]);
        
    case 21,
        
        Im1 = double(imread('cameraman.tif'));
        % shift
        %Im2 = circshift(Im1,[0 0]);
        Im2 = fftshift(Im1);
        
    case 31,
         Im  = imread('C:\Uri\Data\Images\People\lena.tif');
         Im1 = imresize(Im, 0.25);
         Im2 = circshift(Im1,[5 5]);
         
    case 32,
         Im  = imread('C:\Uri\Data\Images\People\lena.tif');
         Im1 = imresize(Im, 0.25);
         Im2 = fftshift(Im1);
         
    case 50,
        Im1 = double(rgb2gray(imread('C:\Uri\Data\Images\MultipleViews\ElbitPaperCup\2010-11-04 10.54.39.jpg')));
        Im1 = imresize(Im1, 0.15);
        
        Im2 = double(rgb2gray(imread('C:\Uri\Data\Images\MultipleViews\ElbitPaperCup\2010-11-04 10.55.10.jpg')));
        Im2 = imresize(Im2, 0.15);
        
         
    case 51, % 3D scence camera motion
        Im1 = double(rgb2gray(imread('C:\Uri\Data\Images\Matching\tsukuba\scene1.row3.col1.ppm')));
        % shift
        Im2 = double(rgb2gray(imread('C:\Uri\Data\Images\Matching\tsukuba\scene1.row3.col3.ppm')));
        

    case 52, % multiview : zoom
        Im1 = double((imread('C:\Uri\Data\Images\Matching\Corridor\bt.000.png')));
        % shift
        Im2 = double((imread('C:\Uri\Data\Images\Matching\Corridor\bt.002.png')));
  
    case 53, % multiview : maze
        Im1 = double((imread('C:\Uri\Data\Images\MultipleViews\Maze\maze1.png')));
        % shift
        Im2 = double((imread('C:\Uri\Data\Images\MultipleViews\Maze\maze2.png')));
        
    case 54, % E figure
        Im1 = double((imread('C:\Uri\Data\Images\Invariance\E_fig1.jpg')));
        % 
        Im2 = Im1(1600:1900,750:1050);
        Im1 = Im1(1600:1900,1050:1350);
        
    case 61, % multiview : ears
        Im1 = rgb2gray(imread('C:\Uri\Data\Images\MultipleViews\Ear\2013-03-11 15-49-45.217.jpg'));
        % shift
        Im2 = rgb2gray(imread('C:\Uri\Data\Images\MultipleViews\Ear\2013-03-11 15-49-47.795.jpg'));
        
     case 65, % Fingertip - not working good
        Im = imread('C:\Uri\Data\Images\Fingerprints\DB1_B\101_1.tif');
        Im1 = imresize(Im, 0.5);
        Im = imread('C:\Uri\Data\Images\Fingerprints\DB1_B\101_2.tif');
        Im2 = imresize(Im, 0.5);
        
    case 67, % objects Maze - not working good (good with 13)
        Im = imread('C:\Uri\Data\Images\MultipleViews\Maze\maze1.png');
        Im1 = imresize(Im, 0.7);
        Im = imread('C:\Uri\Data\Images\MultipleViews\Maze\maze2.png');
        Im2 = imresize(Im, 0.7);
        
    case 69, % corridor
        Im = imread('C:\Uri\Data\Images\Matching\Corridor\bt.000.png');
        Im1 = imresize(Im,1/4);
        Im = imread('C:\Uri\Data\Images\Matching\Corridor\bt.002.png');
        Im2 = imresize(Im,1/4);
        
                
    case 101,
         Im = imread('C:\Uri\Data\Images\People\lena.tif');
         Im1 = imresize(Im, 0.5);
        %Im1 = rand(128,128)*128;
        
%         Im1     = double(rand(128));
%         indx    = floor(rand(1,11)*128^2);
%         Im1(indx(2:end)) = 128;
%         Im1      = imfilter(Im1,fspecial('gaussian'),'same');
        
        
        
        % Try varying these 4 parameters.
        scale   = 1.0;       % scale factor
        angle   = pi/9; %40*pi/180; % rotation angle
        tx      = 0;            % x translation
        ty      = 0;            % y translation
        
        sc = scale*cos(angle);
        ss = scale*sin(angle);
        
        T = [ sc -ss;
              ss  sc;
              tx  ty];
        t_nonsim = maketform('affine',T);
        %Im2 = imtransform(Im1,t_nonsim,'XData',[1 size(Im1,2)], 'YData',[1 size(Im1,1)],'FillValues',0);
        %Im2 = imtransform(Im1,t_nonsim,'size',size(Im1),'FillValues',0);
        Im2 = imtransform(Im1,t_nonsim,'FillValues',0);
        Im2 = imcrop(Im2,[1 1 size(Im1,2)-1 size(Im1,1)-1]);
        
    otherwise
        error('Unknown TestType')
end;

if any(size(Im1) ~= size(Im2))
    error('Images must be of same size')
end;

if FigNum < 1, return; end;


%%%%%%%%%%%%%%
% show
%%%%%%%%%%%%%%
figure(FigNum),
imagesc(Im1),colormap(gray), axis image;
title('Original Image')

figure(FigNum+1),
imagesc(Im2),colormap(gray), axis image;
title('Transformed Image')


