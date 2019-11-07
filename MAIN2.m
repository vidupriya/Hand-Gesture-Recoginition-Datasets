function varargout = MAIN2(varargin)
% MAIN2 MATLAB code for MAIN2.fig
%      MAIN2, by itself, creates a new MAIN2 or raises the existing
%      singleton*.
%
%      H = MAIN2 returns the handle to a new MAIN2 or the handle to
%      the existing singleton*.
%
%      MAIN2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN2.M with the given input arguments.
%
%      MAIN2('Property','Value',...) creates a new MAIN2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MAIN2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MAIN2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MAIN2

% Last Modified by GUIDE v2.5 21-Jul-2019 01:49:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MAIN2_OpeningFcn, ...
                   'gui_OutputFcn',  @MAIN2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before MAIN2 is made visible.
function MAIN2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MAIN2 (see VARARGIN)

% Choose default command line output for MAIN2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MAIN2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MAIN2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  %% CEP
 global audio fs  
[f0,loc] = pitch(audio,fs, ...
    'Method','CEP', ...
    'Range',[50 800], ...
    'WindowLength',round(fs*0.08), ...
    'OverlapLength',round(fs*0.05));

t = loc/fs;
axes(handles.axes1);
plot(t,f0)
ylabel('Pitch (Hz)')
xlabel('Time (s)')
[pks,locs] = findpeaks(f0);
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
set(handles.edit1,'String',GPE);
set(handles.edit2,'String',pitch_Hz);
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MAIN3



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
