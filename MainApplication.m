function varargout = MainApplication(varargin)
% MAINAPPLICATION MATLAB code for MainApplication.fig
%      MAINAPPLICATION, by itself, creates a new MAINAPPLICATION or raises the existing
%      singleton*.
%
%      H = MAINAPPLICATION returns the handle to a new MAINAPPLICATION or the handle to
%      the existing singleton*.
%
%      MAINAPPLICATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINAPPLICATION.M with the given input arguments.
%
%      MAINAPPLICATION('Property','Value',...) creates a new MAINAPPLICATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainApplication_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainApplication_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainApplication

% Last Modified by GUIDE v2.5 14-Jan-2017 01:49:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MainApplication_OpeningFcn, ...
    'gui_OutputFcn',  @MainApplication_OutputFcn, ...
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

% --- Executes just before MainApplication is made visible.
function MainApplication_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainApplication (see VARARGIN)

% Choose default command line output for MainApplication
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MainApplication wait for user response (see UIRESUME)
% uiwait(handles.figure1);
setappdata(0,'methode',1);
setappdata(0,'isDenoise',0);
setappdata(0,'isNoiseCreated',0);
set(handles.bilateralFilterButtonGroup ,'visible','off');
set(handles.meanFilterButtonGroup ,'visible','off');
set(handles.gaussianFilterButtonGroup ,'visible','off');

% --- Outputs from this function are returned to the command line.
function varargout = MainApplication_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

function openButton_Callback(hObject, eventdata, handles)
% hObject    handle to openButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileName,~] = imgetfile;

image = double(imread(fileName));

setappdata(0,'image',image);
setappdata(0,'isDenoise',0);
setappdata(0,'isNoiseCreated',0);

axes(handles.imageAxes);
imshow(fileName);title('Original Image');

function saveButton_Callback(hObject, eventdata, handles)
if getappdata(0,'isDenoise') == 1
    denoiseImage = getappdata(0,'denoiseImage');
    
    [filename, ext, user_canceled] = imputfile;
    denoiseImage = mat2gray(denoiseImage);
    imwrite(denoiseImage,filename);
end


function denoiseFunctionMenu_Callback(hObject, eventdata, handles)
% Determine the selected data set.
str = get(hObject, 'String');
val = get(hObject,'Value');
setappdata(0,'isDenoise',0);
switch str{val};
    case 'NLMeans'
        setappdata(0,'methode',1);
        set(handles.bilateralFilterButtonGroup ,'visible','off');
        set(handles.meanFilterButtonGroup ,'visible','off');
        set(handles.gaussianFilterButtonGroup ,'visible','off');
    case 'Bilateral'
        setappdata(0,'methode',2);
        set(handles.bilateralFilterButtonGroup ,'visible','on');
        set(handles.meanFilterButtonGroup ,'visible','off');
        set(handles.gaussianFilterButtonGroup ,'visible','off');
    case 'Median'
        setappdata(0,'methode',3);
        set(handles.meanFilterButtonGroup ,'title','Median Filter');
        set(handles.meanFilterButtonGroup ,'visible','on');
        set(handles.bilateralFilterButtonGroup ,'visible','off');
        set(handles.gaussianFilterButtonGroup ,'visible','off');
    case 'Averaging'
        setappdata(0,'methode',4);
        set(handles.meanFilterButtonGroup ,'title','Averaging Filter');
        set(handles.meanFilterButtonGroup ,'visible','on');
        set(handles.bilateralFilterButtonGroup ,'visible','off');
        set(handles.gaussianFilterButtonGroup ,'visible','off');
    case 'Gaussian'
        setappdata(0,'methode',5);
        set(handles.meanFilterButtonGroup ,'visible','off');
        set(handles.bilateralFilterButtonGroup ,'visible','off');
        set(handles.gaussianFilterButtonGroup ,'visible','on');
    case 'Weiner'
        setappdata(0,'methode',6);
        set(handles.meanFilterButtonGroup ,'title','Averaging Filter');
        set(handles.meanFilterButtonGroup ,'visible','on');
        set(handles.bilateralFilterButtonGroup ,'visible','off');
        set(handles.gaussianFilterButtonGroup ,'visible','off');
        
        
end


function denoiseButton_Callback(hObject, eventdata, handles)

if getappdata(0,'isNoiseCreated') == 0
    noiseImage = getappdata(0,'image');
    axes(handles.noiseImageAxes);
    noiseImageShow = mat2gray(noiseImage);
    imshow(noiseImageShow);title('Noise Image');
else
    noiseImage = getappdata(0,'noiseImage');
end

switch getappdata(0,'methode');
    case 1
        if getappdata(0,'isDenoise') == 0
        noiseEstimationButton_Callback(hObject, eventdata, handles);
        end
        denoiseImage = getappdata(0,'denoiseImage');
    case 2
        h=waitbar(0,'Please wait..');
        
        bilateralFilterSize = getappdata(0,'bilateralFilterSize');
        bilateralFilterSpatialDeviation = getappdata(0,'bilateralFilterSpatialDeviation');
        bilateralFilterIntensityDeviation = getappdata(0,'bilateralFilterIntensityDeviation');
        
        denoiseImage = bilateralFilter(noiseImage,bilateralFilterSize,bilateralFilterSpatialDeviation,bilateralFilterIntensityDeviation);
        setappdata(0,'isDenoise',1);
        close(h);
    case 3
        h=waitbar(0,'Please wait..');
        meanFilterSize = getappdata(0,'filterSize');
        if size(noiseImage,3) == 1
            denoiseImage = medianFilter(noiseImage,meanFilterSize);
        else
            denoiseImage = medfilt3(noiseImage,[meanFilterSize meanFilterSize meanFilterSize]);
        end
        setappdata(0,'isDenoise',1);
        close(h);
    case 4
        h=waitbar(0,'Please wait..');
        
        averagingFilterSize = getappdata(0,'filterSize');
        if size(noiseImage,3) == 1
            denoiseImage = filter2(fspecial('average',averagingFilterSize),noiseImage);
        else
            denoiseImage = noiseImage;
        end
        setappdata(0,'isDenoise',1);
        close(h);
    case 5
        h=waitbar(0,'Please wait..');
        
        gaussianFilterSigma = getappdata(0,'gaussianFilterSigma');
        denoiseImage = imgaussfilt(noiseImage,gaussianFilterSigma);
        
        setappdata(0,'isDenoise',1);
        close(h);
    case 6
        h=waitbar(0,'Please wait..');
        
        wienerFilterSize = getappdata(0,'filterSize');
        if size(noiseImage,3) == 1
            denoiseImage = wiener2(noiseImage,[wienerFilterSize wienerFilterSize]);
        else
            denoiseImage = noiseImage;
        end
        setappdata(0,'isDenoise',1);
        close(h);

end

setappdata(0,'denoiseImage',denoiseImage);
denoiseImage = mat2gray(denoiseImage);
axes(handles.denoiseImageAxes);
imshow(denoiseImage);title('Denoised Image');

disp('Done DeNoise Estimation');


function createNoiseButton_Callback(hObject, eventdata, handles)

image = getappdata(0,'image');

[M, N, T] = size(image);

a = getappdata(0,'aCoefficient');
b = getappdata(0,'bCoefficient');
c = getappdata(0,'cCoefficient');

noiseLevelFunction = @(x) a * x.^2 + b * x + c;
noiseImage = image + sqrt(noiseLevelFunction(image)) .* randn(M, N, T);

axes(handles.noiseImageAxes);
noiseImageShow = mat2gray(noiseImage);
imshow(noiseImageShow);title('Noise Image');

setappdata(0,'noiseImage',noiseImage);
setappdata(0,'isNoiseCreated',1);
setappdata(0,'isDenoise',0);


function aCoefficientEditText_Callback(hObject, eventdata, handles)
setappdata(0,'aCoefficient', str2double(get(hObject,'String')) );

function bCoefficientEditText_Callback(hObject, eventdata, handles)
setappdata(0,'bCoefficient', str2double(get(hObject,'String')) );

function cCoefficientEditText_Callback(hObject, eventdata, handles)
setappdata(0,'cCoefficient', str2double(get(hObject,'String')) );


function noiseEstimationButton_Callback(hObject, eventdata, handles)
h=waitbar(0,'Please wait..');

if getappdata(0,'isNoiseCreated') == 0
    noiseImage = getappdata(0,'image');
    axes(handles.noiseImageAxes);
    noiseImageShow = mat2gray(noiseImage);
    imshow(noiseImageShow);title('Noise Image');
else
    noiseImage = getappdata(0,'noiseImage');
end

[denoiseImage,coefficient] = DenoiseBasedNoiseLevelEstimation(noiseImage);

setappdata(0,'denoiseImage',denoiseImage);

coefficientText = sprintf('NLF(x) = %f x^2 + %f x + %f',coefficient(3),coefficient(2),coefficient(1) );
set(handles.noiseEstimationText, 'String', coefficientText);

setappdata(0,'isDenoise',1);

disp('Done Noise Estimation');
close(h);

function bilateralFilterSizeEditText_Callback(hObject, eventdata, handles)
setappdata(0,'bilateralFilterSize', str2double(get(hObject,'String')) );

function bilateralFilterSpatialDeviationEditText_Callback(hObject, eventdata, handles)
setappdata(0,'bilateralFilterSpatialDeviation', str2double(get(hObject,'String')) );

function bilateralFilterIntensityDeviationEditText_Callback(hObject, eventdata, handles)
setappdata(0,'bilateralFilterIntensityDeviation', str2double(get(hObject,'String')) );

function filterSizeEditText_Callback(hObject, eventdata, handles)
setappdata(0,'filterSize', str2double(get(hObject,'String')) );

function gaussianFilterSigma_Callback(hObject, eventdata, handles)
setappdata(0,'gaussianFilterSigma', str2double(get(hObject,'String')) );

function denoiseFunctionMenu_CreateFcn(hObject, eventdata, handles)
function aCoefficientEditText_CreateFcn(hObject, eventdata, handles)
function bCoefficientEditText_CreateFcn(hObject, eventdata, handles)
function cCoefficientEditText_CreateFcn(hObject, eventdata, handles)
function bilateralFilterSizeEditText_CreateFcn(hObject, eventdata, handles)
function bilateralFilterSpatialDeviationEditText_CreateFcn(hObject, eventdata, handles)
function bilateralFilterIntensityDeviationEditText_CreateFcn(hObject, eventdata, handles)
function filterSizeEditText_CreateFcn(hObject, eventdata, handles)
function gaussianFilterSigma_CreateFcn(hObject, eventdata, handles)

