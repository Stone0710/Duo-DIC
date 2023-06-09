function [] = anim8_DIC_images_corr_faces_n_n(IMset,DIC_2Dpair_results,varargin)
%% function for plotting 2D-DIC results imported from Ncorr in step 2
% called inside plotNcorrPairResults
% plotting the images chosen for stereo DIC (2 views) with the
% triangular faces results plotted on top, colored as their correlation
% coefficient.
% on the left side the images from the reference camera (reference image and current images), and on the right side the 
% images from the deformed camera
% requirements: GIBBON toolbox
%
% calling options:
% [] = anim8_DIC_images(IMset,DIC_2Dpair_results);
% [] = anim8_DIC_images(IMset,DIC_2Dpair_results,CorCoeffCutOff,CorCoeffDispMax);
%
% INPUT:
% * IMset - a 2nX1 cell array containing 2n grayscale images. The first n
% images are from camera A (the "reference" camera), and the last n images
% are from camera B (the "deformed" camera). The first image in the set is
% considered as the reference image, on which the reference grid of points
% is defined, and all the correlated points and consequent displacements
% and strains, are relative to this image.
% * DIC_2Dpair_results - containig the correlated points, correlation
% coefficients, faces..
% * optional: CorCoeffCutOff - - maximal correlation coefficient to plot
% points
% * optional: CorCoeffDispMax - maximal correlation coefficient in colorbar

%%
fs=14; % font size

%%
nCur=numel(IMset); % number of frames

nSteps=nCur/2; %Number of animation steps
if  rem(nSteps,1)~=0
    error('Number of images in the set should be even');
end

%%
Points=DIC_2Dpair_results.Points;
CorCoeffVec=DIC_2Dpair_results.CorCoeffVec;
nCamRef=DIC_2Dpair_results.nCamRef;
nCamDef=DIC_2Dpair_results.nCamDef;
nImages=DIC_2Dpair_results.nImages;
F=DIC_2Dpair_results.Faces;

Original=struct;
Original.Points=Points;
Original.CorCoeffVec=CorCoeffVec;

nVars = length(varargin);
switch nVars
    case 2
        CorCoeffCutOff=varargin{1};
        if isnan(CorCoeffCutOff)
            CorCoeffCutOff=max(max([CorCoeffVec{:}]));
        end      
    case 1
        CorCoeffCutOff=varargin{1};
        if isnan(CorCoeffCutOff)
            CorCoeffCutOff=max(max([CorCoeffVec{:}]));
        end    
    case 0
        CorCoeffCutOff=max(max([CorCoeffVec{:}]));
    otherwise
        error('Wrong number of input arguments');
end

%%
hf=cFigure;
hf.Units='normalized'; hf.OuterPosition=[.05 .05 .9 .9]; hf.Units='pixels';

% Ref
ii=1;
subplot(1,2,1)
CFcorr=mean(CorCoeffVec{1}(F),2);
CFcorr(CFcorr>CorCoeffCutOff)=NaN;
hp1=imagesc(repmat(IMset{ii},1,1,3)); hold on;
hp2=gpatch(F,Points{1},CFcorr,'k',0.4); 
set(hp2,'EdgeAlpha',0.4);
colormap jet
pbaspect([size(IMset{ii},2) size(IMset{ii},1) 1])
hs1=title(['Ref (Cam ' num2str(nCamRef) ' frame ' num2str(1) ')']);
hc1=colorbar; %caxis([0 CorCoeffDispMax]);
hc1.FontSize=fs;
hc1.Title.String='Corr-Coeff';
hc1.Title.Units='normalized';
hc1.Title.Position(2)=1.09;
axis off

% Cur
ii=nImages+1;
subplot(1,2,2)
CFcorr=mean(CorCoeffVec{1+nCur/2}(F),2);
CFcorr(CFcorr>CorCoeffCutOff)=NaN;
hp3=imagesc(repmat(IMset{ii},1,1,3)); hold on
hp4=gpatch(F,Points{ii},CFcorr,'k',0.4); %colormap jet
colormap jet
pbaspect([size(IMset{ii},2) size(IMset{ii},1) 1])
hs2=title(['Cur ' num2str(ii) ' (Cam ' num2str(nCamDef) ' frame ' num2str(1) ')']);
hc2=colorbar; %caxis([0 CorCoeffDispMax]);
hc2.FontSize=fs;
hc2.Title.String='Corr-Coeff';
hc2.Title.Units='normalized';
hc2.Title.Position(2)=1.09;
axis off

drawnow

%Create the time vector
animStruct.Time=linspace(0,1,nImages);

for ii=1:nImages  
    Pnow1=Points{ii};
    Pnow2=Points{ii+nImages};

    cNow1=CorCoeffVec{ii};
    cNow1(cNow1>CorCoeffCutOff)=NaN;
    cNow2=CorCoeffVec{ii+nImages};
    cNow2(cNow2>CorCoeffCutOff)=NaN;
    
    TitleNow1=['Cur ' num2str(ii) ' (Cam ' num2str(nCamRef) ' frame ' num2str(ii) ')'];
    TitleNow2=['Cur ' num2str(ii) ' (Cam ' num2str(nCamDef) ' frame ' num2str(ii) ')'];
    
   %Set entries in animation structure
    animStruct.Handles{ii}=[hp1,hp3,hp2,hp2,hp4,hp4,hs1,hs2]; %Handles of objects to animate
    animStruct.Props{ii}={'CData','CData','Vertices','CData','Vertices','CData','String','String'}; %Properties of objects to animate
    animStruct.Set{ii}={repmat(IMset{ii},1,1,3),repmat(IMset{ii+nImages},1,1,3),Pnow1,cNow1,Pnow2,cNow2,TitleNow1,TitleNow2}; %Property values for to set in order to animate
   
end

anim8(hf,animStruct);

addColorbarLimitsButton(hf);
addColormapButton(hf);
addEdgeColorButton(hf);
addFaceAlphaButton(hf);
addCorCoStep2(hf,animStruct,Original,'faces_n_n');

end

%% 
% MultiDIC: a MATLAB Toolbox for Multi-View 3D Digital Image Correlation
% 
% License: <https://github.com/MultiDIC/MultiDIC/blob/master/LICENSE.txt>
% 
% Copyright (C) 2018  Dana Solav
% 
% Modified by Rana Odabas 2018
% 
% If you use the toolbox/function for your research, please cite our paper:
% <https://engrxiv.org/fv47e>