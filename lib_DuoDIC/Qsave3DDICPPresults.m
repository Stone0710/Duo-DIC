function [saveLogic,savePath]=Qsave3DDICPPresults(structPath)
%% function for asking the user for saving options for the 3D-DIC results in STEP3.
% Including overwriting options
%
% INPUTS:
% * structPaths: 1-by-Npairs cell array, containing in each
%   cell the path to the DIC2DpairResults_C_#1_C_#2 structure file
%
% OUTPUTS:
% * saveLogic: logic true=save, false=not save
% * savePath: a path were to save the results. [] if saveLogic=false.

%%
saveButton = questdlg('Save 3D-DIC Post-Processing results?', 'Save?', 'Yes', 'No', 'Yes');

switch saveButton
    case 'Yes'
        saveLogic=true(1);
        continueLog=false(1);
        
        while ~continueLog
            % Path where to save the camera parameters
            savePath = uigetdir(fileparts(structPath),'Select a folder for saving the results');
            
%             % check if DIC3DpairResults in this folder already exist
%             fileExist=false;
%             [~,name,~]=fileparts(structPath);
%             filenames=[savePath '\DIC3DPPresults.mat'];
%             if exist(filenames,'file')
%                 fileExist=true;
%             end
%             
%             if fileExist                
%                 promptMessage=cell(2,1);
%                 promptMessage{1}='The following output file already exists: ';
%                 promptMessage{5}='Do you want to overwrite?';
%                 [~,fileName,ext]=fileparts(filenames);
%                 promptMessage{3}=[fileName ext];
% 
%                 titleBarCaption = 'Overwrite?';
%                 buttonText = questdlg(promptMessage, titleBarCaption, 'Yes', 'No', 'Yes');
%                 switch buttonText
%                     case 'Yes'
%                         % User wants to overwrite. % Set flag to continue
%                         continueLog=true(1);
%                     case 'No'
%                         % User does not want to overwrite. % Set flag to not do the write.
%                         waitfor(warndlg('Choose another folder to save the results','OK'));
%                         % let user choose a different folder to save the file
%                 end
%             else
%                 % if file doesn't esixt, cotinue.
                continueLog=true(1);
%             end
        end
    
    case 'No'
        saveLogic=false(1);
        savePath=[];
end



end
 

%% DuoDIC: 2-camera 3D-DIC toolbox
%% Copyright (C) 2022 Dana Solav - All rights reserved.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%
%% If used in published OR commercial work, please contact [danas@technion.ac.il] for citation and license information
