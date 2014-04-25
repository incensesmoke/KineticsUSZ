%empty workspace
close all
clear cll
clc

%% Load data

Pname = uigetdir('Please choose analysis directory');
currentFolder = pwd;
cd (Pname);
files2load = dir([Pname '/*.txt']);
scn = get(0,'ScreenSize');


for file = 1 : length(files2load)
    
A = importdata(files2load(file).name, '\t', 13);


%% find basic step sequences

hitL = find (A.data(:, 3));
hitR = find (A.data(:, 4));

endStepL = find( diff(hitL) > 1);
endStepR = find( diff(hitR) > 1);

    %create figure containers
    fig1 = figure;
    set(fig1, 'position', [15 scn(4)/2 scn(3)-30 (scn(4)/2)-100])
    
    fig2 = figure;
    set(fig2, 'position', [15 10 scn(3)-30 (scn(4)/2)-100])


if hitR(1) < hitL(1)
    %% Right Side starts

    % Analyse first left step

    stepL = hitL(1): hitL(endStepL(1));
    loadL = hitL(1): hitR(endStepR(1));
    singL = hitR(endStepR(1))+1 : hitR(endStepR(1)+1)-1;
    pushL = hitR(endStepR(1)+1) : hitL(endStepL(1));
    pushR = hitL(1) : hitR(endStepR(1));
    stepL = stepL';
    loadL = loadL';
    singL = singL';
    pushL = pushL';
    pushR = pushR';
    B(1).stepL = A.data(stepL, 3);
    B(1).loadL = A.data(loadL, 3);
    B(1).singL = A.data(singL, 3);
    B(1).pushL = A.data(pushL, 3);
    B(1).pushR = A.data(pushR, 4);
    figure(fig1)
    hold on
    plot(1:length(B(1).stepL), B(1).stepL);
    title (' Left Foot ');
    
    % Analyse all right steps from first valid right step on

    for i=1:length(endStepR)-1
        stepR = hitR(endStepR(i)+1): hitR(endStepR(i+1));
        loadR = hitR(endStepR(i)+1) : hitL(endStepL(i));
        singR = hitL(endStepL(i))+1 : hitL(endStepL(i)+1)-1;
        pushR = hitL(endStepL(i)+1) : hitR(endStepR(i+1));
        stepR = stepR';
        loadR = loadR';
        singR = singR';
        pushR = pushR';
        B(i+1).stepR = A.data(stepR, 4);
        B(i+1).loadR = A.data(loadR, 4);
        B(i+1).singR = A.data(singR, 4);
        B(i+1).pushR = A.data(pushR, 4);
        figure(fig2)
        hold on
        plot(1:length(B(i).stepR), B(i).stepR);
        title (' Right Foot ');        
    end

    % Analyse all left steps from second left step on

    for i=1:length(endStepL)-1
        stepL = hitL(endStepL(i)+1): hitL(endStepL(i+1));
        loadL = hitL(endStepL(i)+1) : hitR(endStepR(i+1)); 
        singL = hitR(endStepR(i+1))+1 : hitR(endStepR(i+1)+1)-1;
        pushL = hitR(endStepR(i+1)+1) : hitL(endStepL(i+1));
        stepL = stepL';
        loadL = loadL';
        singL = singL';
        pushL = pushL';
        B(i+1).stepL = A.data(stepL, 3);
        B(i+1).loadL = A.data(loadL, 3);
        B(i+1).singL = A.data(singL, 3);
        B(i+1).pushL = A.data(pushL, 3);
        figure(fig1)
        hold on
        plot(1:length(B(i).stepL), B(i).stepL)
    end

    % Check which side does the last step
    if hitR(end) > hitL(end)
        %If the last step is right then take the last left step
        stepL = hitL(endStepL(end)+1): hitL(end);
        loadL = hitL(endStepL(end)+1) : hitR(endStepR(end)); 
        singL = hitR(endStepR(end))+1 : hitR(endStepR(end)+1)-1;
        pushL = hitR(endStepR(end)+1) : hitL(end);
        stepL = stepL';
        loadL = loadL';
        singL = singL';
        pushL = pushL';
        final = length(B)+1;
        B(final).stepL = A.data(stepL, 3);
        B(final).loadL = A.data(loadL, 3);
        B(final).singL = A.data(singL, 3);
        B(final).pushL = A.data(pushL, 3);
        B(final).loadR = A.data(pushL, 4);
        figure(fig1)
        hold on
        plot(1:length(B(final).stepL), B(final).stepL)
        
    elseif hitL(end) > hitR(end)
        %If the last step is left then take the last left step
        stepR = hitR(endStepR(end)+1): hitR(end);
        loadR = hitR(endStepR(end)+1) : hitL(endStepL(end)); 
        singR = hitL(endStepL(end))+1 : hitL(endStepL(end)+1)-1;
        pushR = hitL(endStepL(end)+1) : hitR(end);
        stepR = stepR';
        loadR = loadR';
        singR = singR';
        pushR = pushR';
        final = length(B)+1;
        B(final).stepR = A.data(stepR, 4);
        B(final).loadR = A.data(loadR, 4);
        B(final).singR = A.data(singR, 4);
        B(final).pushR = A.data(pushR, 4);
        B(final).loadL = A.data(pushR, 3);
        figure(fig2)
        hold on
        plot(1:length(B(final).stepR), B(final).stepR)
        
    else
        errordlg(['Please trim the end of File ' files2load(file).name], 'File Error');
        B = [];
        A = [];
        close all
        continue
        
    end



elseif hitR(1) > hitL(1)
        %left side starts
        
        % Analyse first right step

    stepR = hitR(1): hitR(endStepR(1));
    loadR = hitR(1): hitL(endStepL(1));
    singR = hitL(endStepL(1))+1 : hitL(endStepL(1)+1)-1;
    pushR = hitL(endStepL(1)+1) : hitR(endStepR(1));
    pushL = hitR(1) : hitL(endStepL(1));
    stepR = stepR';
    loadR = loadR';
    singR = singR';
    pushR = pushR';
    pushL = pushL';
    B(1).stepR = A.data(stepR, 4);
    B(1).loadR = A.data(loadR, 4);
    B(1).singR = A.data(singR, 4);
    B(1).pushR = A.data(pushR, 4);
    B(1).pushL = A.data(pushL, 3);
    figure(fig2)
    hold on
    plot(1:length(B(1).stepR), B(1).stepR)

    % Analyse all left steps from first valid left step on 
    for i=1:length(endStepL)-1
        stepL = hitL(endStepL(i)+1): hitL(endStepL(i+1));
        loadL = hitL(endStepL(i)+1) : hitR(endStepR(i));
        singL = hitR(endStepR(i))+1 : hitR(endStepR(i)+1)-1;
        pushL = hitR(endStepR(i)+1) : hitL(endStepL(i+1));
        stepL = stepL';
        loadL = loadL';
        singL = singL';
        pushL = pushL';
        B(i+1).stepL = A.data(stepL, 3);
        B(i+1).loadL = A.data(loadL, 3);
        B(i+1).singL = A.data(singL, 3);
        B(i+1).pushL = A.data(pushL, 3);
        figure(fig1)
        hold on
        plot(1:length(B(i).stepL), B(i).stepL);
        title (' Left Foot ');
    end

    % Analyse all right steps from second left step on

    for i=1:length(endStepR)-1
        stepR = hitR(endStepR(i)+1): hitR(endStepR(i+1));
        loadR = hitR(endStepR(i)+1) : hitL(endStepL(i+1)); 
        singR = hitL(endStepL(i+1))+1 : hitL(endStepL(i+1)+1)-1;
        pushR = hitL(endStepL(i+1)+1) : hitR(endStepR(i+1));
        stepR = stepR';
        loadR = loadR';
        singR = singR';
        pushR = pushR';
        B(i+1).stepR = A.data(stepR, 4);
        B(i+1).loadR = A.data(loadR, 4);
        B(i+1).singR = A.data(singR, 4);
        B(i+1).pushR = A.data(pushR, 4);
        figure(fig2)
        hold on
        plot(1:length(B(i).stepR), B(i).stepR)
    end

    % Check which side does the last step
    if hitL(end) > hitR(end)
        %If the last step is left then take the last right step
        stepR = hitR(endStepR(end)+1): hitR(end);
        loadR = hitR(endStepR(end)+1) : hitL(endStepL(end)); 
        singR = hitL(endStepL(end))+1 : hitL(endStepL(end)+1)-1;
        pushR = hitL(endStepL(end)+1) : hitR(end);
        stepR = stepR';
        loadR = loadR';
        singR = singR';
        pushR = pushR';
        final = length(B)+1;
        B(final).stepR = A.data(stepR, 4);
        B(final).loadR = A.data(loadR, 4);
        B(final).singR = A.data(singR, 4);
        B(final).pushR = A.data(pushR, 4);
        B(final).loadL = A.data(pushR, 3);
        figure(fig2)
        hold on
        plot(1:length(B(final).stepR), B(final).stepR)
        
    elseif hitR(end) > hitL(end)
        %If the last step is right then take the last left step
        stepL = hitL(endStepL(end)+1): hitL(end);
        loadL = hitL(endStepL(end)+1) : hitR(endStepR(end)); 
        singL = hitR(endStepR(end))+1 : hitR(endStepR(end)+1)-1;
        pushL = hitR(endStepR(end)+1) : hitL(end);
        stepL = stepL';
        loadL = loadL';
        singL = singL';
        pushL = pushL';
        final = length(B)+1;
        B(final).stepL = A.data(stepL, 3);
        B(final).loadL = A.data(loadL, 3);
        B(final).singL = A.data(singL, 3);
        B(final).pushL = A.data(pushL, 3);
        B(final).loadR = A.data(pushL, 4);
        figure(fig1)
        hold on
        plot(1:length(B(final).stepL), B(final).stepL)
        
    else
        errordlg(['Please trim the end of File ' files2load(file).name], 'File Error');
        B = [];
        A = [];
        close all
        continue
        
    end


else
    % In case the file beginns in a double stance phase call for
    % correction!!
        errordlg(['Please trim the beginning of File ' files2load(file).name], 'File Error');
        B = [];
        A = [];
        close all
        continue
    
end
   
   
   
   %% Create output variables for xlswrite
   for i = 1 : length(B)
       mLoadR(i,1) = mean (B(i).loadR);
       sLoadR(i,1) = sum (B(i).loadR);
       mSingR(i,1) = mean (B(i).singR);
       sSingR(i,1) = sum (B(i).singR);
       mPushR(i,1) = mean (B(i).pushR);
       sPushR(i,1) = sum (B(i).pushR);
       mLoadL(i,1) = mean (B(i).loadL);
       sLoadL(i,1) = sum (B(i).loadL);
       mSingL(i,1) = mean (B(i).singL);
       sSingL(i,1) = sum (B(i).singL);
       mPushL(i,1) = mean (B(i).pushL);
       sPushL(i,1) = sum (B(i).pushL);
       spacer(i,1) = 0;
   end
       
   n = helpdlg(['If the figures for ' files2load(file).name ' are acceptebale please press OK to continue'],'Continue?');
   
   xlswrite('Results.xls', [cellstr('mSingL'), cellstr('sSingL'), cellstr('mSingR'), cellstr('sSingR'), cellstr('  '), cellstr('mLoadL'), cellstr('sLoadL'), cellstr('mPushR'), cellstr('sPushR'),cellstr('  '), cellstr('mLoadR'), cellstr('sLoadR'), cellstr('mPushL'), cellstr('mPushL')], num2str(file), 'C2');
   xlswrite('Results.xls', [mSingL, sSingL, mSingR, sSingR, spacer, mLoadL, sLoadL, mPushR, sPushR, spacer, mLoadR, sLoadR, mPushL, sPushL], num2str(file), 'C4');

   uiwait(n); 
   
   close all;
   B = [];
   A = [];

   
end

cd (pwd);
    
   