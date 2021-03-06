%% Header
% Plan for today, do the algorithm design
% chapter.

% Load in the data, the reference folder 
% must be in the path
load S02_MedData

%% Begin data
% Basic data exploration

% Generate a new figure for each graphic
% This ensure you don't overwrite existing
% graphics on another users code
figure

% Load the required data into variables
x = MedData.Age;
y = MedData.BPDiff; % Pulse pressure

% Plot a scatter plot into the figure
scatter(x,y,'kx')

% Add epilog data (labels, titles)
xlabel('Pulse pressure (mmHg)')
ylabel('Age (years)')
title('Pulse pressure vs age')

%% Fixing data in the series

% The mean function should return the
% mean of the value
mean(x)

% With this dataset, there are NaN (not a number)
% values and so they must be dealt with first
% These can be dealt with using the 
% isnan function
missingVals = isnan(x)|isnan(y);

% This creates a logical index and so we can
% filter to remove 'not missing' values
xClean=x(~missingVals);
yClean=y(~missingVals);

%% Making the model

% We want to make a trend-line to add to the data.

% Formulate model and write it in Matlab
% This can be written as
% pulsePressure = [1,Age,Age^2]*[C0; C1; C2]

b = yClean;
A = [ones(size(xClean)), xClean, xClean.^2];
% another alternative to make a matrix of 1s 
% is to use xClean^0

% To solve Ax = b, x = A\b
modelCoeffs = A\b; % solve the system

% Then to generate the fitted curve (model)
pulseModel = A * modelCoeffs;

hold on
% This needs to be added to the plot
plot(xClean, pulseModel, 'r*')

% Along with a legend
legend('Raw Data', 'Fitted Model')

%% Move to two dimensions
height = MedData.Height; % x1
waist = MedData.Waist; % x2
weight = MedData.Weight; % y

% Problem, can we estimate weight from height and waist?
% To solve this we need to use a quadratic model.

% Step 1, plot the raw data (SCATTER3)
figure
scatter3(height,waist,weight)

% Step 2, clean the data (isnan)
missingVals = isnan(height)|isnan(waist)|isnan(weight);
% This creates a logical index and so we can
% filter to remove 'not missing' values
heightClean=height(~missingVals);
weightClean=weight(~missingVals);
waistClean=waist(~missingVals);

% This can also be done by:
badcols = any(isnan([height, waist, weight]));
% The any command runs by column rather than rows,
% so we need to transpose with ' or call the 2nd dimension.
%badrows = any(isnan([height, waist, weight]),2);
%badrows = any(isnan([height, waist, weight])');

% Step 3, formulate and solve the model

% weight = C0 + C1height + C2height^2 + c3 waist + c4 waist ^2 + C5
% waist*height

b = weightClean;
A = [heightClean.^0, heightClean, heightClean.^2, ...
    waistClean, waistClean.^2, waistClean.*heightClean];

% To solve Ax = b, x = A\b
bmiModelCoeffs = A\b; % solve the system

% Then to generate the fitted curve (model)
bmiModel = A * bmiModelCoeffs;

% Step 4: Visualisation
% Create an input function using handlers
modelFun = @(c,x1,x2) c(1) + c(2)*x1 + c(3)*x1.^2 ...
    + c(4)*x2 + c(5)*x2.^2 + c(6)*x1.*x2;
% Substep 1: make vector data for x1 and x2
x1Vec = linspace(min(heightClean),max(heightClean), 150);
x2Vec = linspace(min(waistClean),max(waistClean), 150);
% Substep 2: make this into a grid
[X1, X2] = meshgrid(x1Vec,x2Vec);
% Please note that anything with a capital contains
% a matrix. This is a useful notation for programming.

%Substep 3: evaluate the model on the grid
modelOnGrid = modelFun(bmiModelCoeffs, X1, X2);

hold on
surf(X1, X2, modelOnGrid, 'EdgeAlpha', 0)
% EdgeAlpha refers to transparency (0 is transparent)

legend('Raw data','Model Data')

%% Test the function we've written
% 1D set
x = MedData.Age;
y = MedData.BPDiff;
modelCoeffs = fitQuadModel(x,y)

% Test for 2D example
height = MedData.Height; %x1
waist = MedData.Waist; %x2
weight = MedData.Weight; %y
modelCoeffs = fitquadModel(height,waist,weight)
