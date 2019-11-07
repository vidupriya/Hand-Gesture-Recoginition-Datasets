clear all;
close all;
clc;

% load FurElise.mat song fs

[filename pathname]=uigetfile('.wav','choose any audio file');
[audio fs]=audioread([pathname filename]);
%% 
[f0,loc] = pitch(audio,fs, ...
    'Method','NCF', ...
    'Range',[50 800], ...
    'WindowLength',round(fs*0.08), ...
    'OverlapLength',round(fs*0.05));

t = loc/fs;
plot(t,f0)
ylabel('Pitch (Hz)')
xlabel('Time (s)')
load TruePitch
numSamples = size(audio,1);
testSignals = zeros(numSamples,4);
turbine = audioread('Turbine-16-44p1-mono-22secs.wav');
testSignals(:,1) = mixSNR(audio,turbine,20);
whiteNoiseMaker = dsp.ColoredNoise('Color','white','SamplesPerFrame',size(audio,1));
testSignals(:,3) = mixSNR(audio,whiteNoiseMaker(),20);
noiseConditions = {'Turbine (20 dB)'};
algorithms = {'NCF'};
f0 = zeros(numel(truePitch),numel(algorithms),numel(noiseConditions));
algorithmTimer = zeros(numel(noiseConditions),numel(algorithms));
k = numel(noiseConditions)
    x = testSignals(:,k);
   i = numel(algorithms)
        tic
        f0temp = pitch(x,fs, ...
            'Range',[50 300], ...
            'Method',algorithms{i}, ...
            'MedianFilterLength',3);
        algorithmTimer(k,i) = toc;
        f0(1:max(numel(f0temp),numel(truePitch)),i,k) = f0temp;
        
        idxToCompare = ~isnan(truePitch);
truePitch = truePitch(idxToCompare);
f0 = f0(idxToCompare,:,:);

p = 0.20;
GPE = mean( abs(f0(numel(truePitch),:,:) - truePitch) > truePitch.*p).*100;

ik = numel(noiseConditions)
    fprintf('\nGPE (p = %0.2f), Noise = %s.\n',p,noiseConditions{ik});
   i = size(GPE,2)
        fprintf('- %s : %0.1f %%\n',algorithms{i},GPE(1,i,ik))
    

   %% CEP
   
[f0,loc] = pitch(audio,fs, ...
    'Method','CEP', ...
    'Range',[50 800], ...
    'WindowLength',round(fs*0.08), ...
    'OverlapLength',round(fs*0.05));

t = loc/fs;
plot(t,f0)
ylabel('Pitch (Hz)')
xlabel('Time (s)')
load TruePitch
numSamples = size(audio,1);
testSignals = zeros(numSamples,4);
turbine = audioread('Turbine-16-44p1-mono-22secs.wav');
testSignals(:,1) = mixSNR(audio,turbine,20);
whiteNoiseMaker = dsp.ColoredNoise('Color','white','SamplesPerFrame',size(audio,1));
testSignals(:,3) = mixSNR(audio,whiteNoiseMaker(),20);
turbine = audioread('Turbine-16-44p1-mono-22secs.wav');
testSignals(:,1) = mixSNR(audio,turbine,20);
whiteNoiseMaker = dsp.ColoredNoise('Color','white','SamplesPerFrame',size(audio,1));
testSignals(:,3) = mixSNR(audio,whiteNoiseMaker(),20);
noiseConditions = {'Turbine (20 dB)'};
algorithms = {'CEP'};
f0 = zeros(numel(truePitch),numel(algorithms),numel(noiseConditions));
algorithmTimer = zeros(numel(noiseConditions),numel(algorithms));
k = numel(noiseConditions)
    x = testSignals(:,k);
   i = numel(algorithms)
        tic
        f0temp = pitch(x,fs, ...
            'Range',[50 300], ...
            'Method',algorithms{i}, ...
            'MedianFilterLength',3);
        algorithmTimer(k,i) = toc;
        f0(1:max(numel(f0temp),numel(truePitch)),i,k) = f0temp;
        
        idxToCompare = ~isnan(truePitch);
truePitch = truePitch(idxToCompare);
f0 = f0(idxToCompare,:,:);

p = 0.20;
GPE = mean( abs(f0(numel(truePitch),:,:) - truePitch) > truePitch.*p).*100;

ik = numel(noiseConditions)
    fprintf('\nGPE (p = %0.2f), Noise = %s.\n',p,noiseConditions{ik});
   i = size(GPE,2)
        fprintf('- %s : %0.1f %%\n',algorithms{i},GPE(1,i,ik))
    
%% LHS
[f0,loc] = pitch(audio,fs, ...
    'Method','LHS', ...
    'Range',[50 800], ...
    'WindowLength',round(fs*0.08), ...
    'OverlapLength',round(fs*0.05));

t = loc/fs;
plot(t,f0)
ylabel('Pitch (Hz)')
xlabel('Time (s)')
load TruePitch
numSamples = size(audio,1);
testSignals = zeros(numSamples,4);
turbine = audioread('Turbine-16-44p1-mono-22secs.wav');
testSignals(:,1) = mixSNR(audio,turbine,20);
whiteNoiseMaker = dsp.ColoredNoise('Color','white','SamplesPerFrame',size(audio,1));
testSignals(:,3) = mixSNR(audio,whiteNoiseMaker(),20);
noiseConditions = {'Turbine (20 dB)'};
algorithms = {'LHS'};
f0 = zeros(numel(truePitch),numel(algorithms),numel(noiseConditions));
algorithmTimer = zeros(numel(noiseConditions),numel(algorithms));
k = numel(noiseConditions)
    x = testSignals(:,k);
   i = numel(algorithms)
        tic
        f0temp = pitch(x,fs, ...
            'Range',[50 300], ...
            'Method',algorithms{i}, ...
            'MedianFilterLength',3);
        algorithmTimer(k,i) = toc;
        f0(1:max(numel(f0temp),numel(truePitch)),i,k) = f0temp;
        
        idxToCompare = ~isnan(truePitch);
truePitch = truePitch(idxToCompare);
f0 = f0(idxToCompare,:,:);

p = 0.20;
GPE = mean( abs(f0(numel(truePitch),:,:) - truePitch) > truePitch.*p).*100;

ik = numel(noiseConditions)
    fprintf('\nGPE (p = %0.2f), Noise = %s.\n',p,noiseConditions{ik});
   i = size(GPE,2)
        fprintf('- %s : %0.1f %%\n',algorithms{i},GPE(1,i,ik))
    
%% SRH
[f0,loc] = pitch(audio,fs, ...
    'Method','SRH', ...
    'Range',[50 800], ...
    'WindowLength',round(fs*0.08), ...
    'OverlapLength',round(fs*0.05));

t = loc/fs;
plot(t,f0)
ylabel('Pitch (Hz)')
xlabel('Time (s)')
load TruePitch
numSamples = size(audio,1);
testSignals = zeros(numSamples,4);
turbine = audioread('Turbine-16-44p1-mono-22secs.wav');
testSignals(:,1) = mixSNR(audio,turbine,20);
whiteNoiseMaker = dsp.ColoredNoise('Color','white','SamplesPerFrame',size(audio,1));
testSignals(:,3) = mixSNR(audio,whiteNoiseMaker(),20);
noiseConditions = {'Turbine (20 dB)'};
algorithms = {'SRH'};
f0 = zeros(numel(truePitch),numel(algorithms),numel(noiseConditions));
algorithmTimer = zeros(numel(noiseConditions),numel(algorithms));
k = numel(noiseConditions);
    x = testSignals(:,k);
   i = numel(algorithms);
        tic
        f0temp = pitch(x,fs, ...
            'Range',[50 300], ...
            'Method',algorithms{i}, ...
            'MedianFilterLength',3);
        algorithmTimer(k,i) = toc;
        f0(1:max(numel(f0temp),numel(truePitch)),i,k) = f0temp;
        
        idxToCompare = ~isnan(truePitch);
truePitch = truePitch(idxToCompare);
f0 = f0(idxToCompare,:,:);

p = 0.20;
GPE = mean( abs(f0(numel(truePitch),:,:) - truePitch) > truePitch.*p).*100;

ik = numel(noiseConditions)
    fprintf('\nGPE (p = %0.2f), Noise = %s.\n',p,noiseConditions{ik});
   i = size(GPE,2)
        fprintf('- %s : %0.1f %%\n',algorithms{i},GPE(1,i,ik))
    
%% PEF
[f0,loc] = pitch(audio,fs, ...
    'Method','PEF', ...
    'Range',[50 800], ...
    'WindowLength',round(fs*0.08), ...
    'OverlapLength',round(fs*0.05));

t = loc/fs;
plot(t,f0)
ylabel('Pitch (Hz)')
xlabel('Time (s)')
load TruePitch
numSamples = size(audio,1);
testSignals = zeros(numSamples,4);
turbine = audioread('Turbine-16-44p1-mono-22secs.wav');
testSignals(:,1) = mixSNR(audio,turbine,20);
whiteNoiseMaker = dsp.ColoredNoise('Color','white','SamplesPerFrame',size(audio,1));
testSignals(:,3) = mixSNR(audio,whiteNoiseMaker(),20);
noiseConditions = {'Turbine (20 dB)'};
algorithms = {'PEF'};
f0 = zeros(numel(truePitch),numel(algorithms),numel(noiseConditions));
algorithmTimer = zeros(numel(noiseConditions),numel(algorithms));
k = numel(noiseConditions)
    x = testSignals(:,k);
   i = numel(algorithms)
        tic
        f0temp = pitch(x,fs, ...
            'Range',[50 300], ...
            'Method',algorithms{i}, ...
            'MedianFilterLength',3);
        algorithmTimer(k,i) = toc;
        f0(1:max(numel(f0temp),numel(truePitch)),i,k) = f0temp;
        
        idxToCompare = ~isnan(truePitch);
truePitch = truePitch(idxToCompare);
f0 = f0(idxToCompare,:,:);

p = 0.20;
GPE = mean( abs(f0(numel(truePitch),:,:) - truePitch) > truePitch.*p).*100;

ik = numel(noiseConditions)
    fprintf('\nGPE (p = %0.2f), Noise = %s.\n',p,noiseConditions{ik});
   i = size(GPE,2)
        fprintf('- %s : %0.1f %%\n',algorithms{i},GPE(1,i,ik))
    
%% PEF+CEP
y=audio;
y=y(:,1);
auto_corr_y=pitch(y,fs, ...
    'Method','PEF', ...
    'Range',[50 800], ...
    'WindowLength',round(fs*0.08), ...
    'OverlapLength',round(fs*0.05))+pitch(y,fs, ...
    'Method','CEP', ...
    'Range',[50 800], ...
    'WindowLength',round(fs*0.08), ...
    'OverlapLength',round(fs*0.05));

subplot(2,1,1),plot(y) 
subplot(2,1,2),plot(auto_corr_y)
[pks,locs] = findpeaks(auto_corr_y);
[mm,peak1_ind]=max(pks);
period=locs(peak1_ind+1)-locs(peak1_ind);
pitch_Hz=fs/period

load TruePitch
numSamples = size(audio,1);
testSignals = zeros(numSamples,4);
turbine = audioread('Turbine-16-44p1-mono-22secs.wav');
testSignals(:,1) = mixSNR(audio,turbine,20);
whiteNoiseMaker = dsp.ColoredNoise('Color','white','SamplesPerFrame',size(audio,1));
testSignals(:,3) = mixSNR(audio,whiteNoiseMaker(),20);
noiseConditions = {'Turbine (20 dB)'};
algorithms = {'PEF'};
f0 = zeros(numel(truePitch),numel(algorithms),numel(noiseConditions));
algorithmTimer = zeros(numel(noiseConditions),numel(algorithms));
k = numel(noiseConditions)
    x = testSignals(:,k);
   i = numel(algorithms)
        tic
        f0temp = pitch(x,fs, ...
            'Range',[50 300], ...
            'Method',algorithms{i}, ...
            'MedianFilterLength',3);
        algorithmTimer(k,i) = toc;
        f0(1:max(numel(f0temp),numel(truePitch)),i,k) = f0temp;
        
        idxToCompare = ~isnan(truePitch);
truePitch = truePitch(idxToCompare);
f0 = f0(idxToCompare,:,:);

p = 0.20;
GPE = mean( abs(f0(numel(truePitch),:,:) - truePitch) > truePitch.*p).*100;

ik = numel(noiseConditions)
    fprintf('\nGPE (p = %0.2f), Noise = %s.\n',p,noiseConditions{ik});
   i = size(GPE,2)
        fprintf('- %s : %0.1f %%\n',algorithms{i},GPE(1,i,ik))
    
