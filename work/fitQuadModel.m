function [ modelCoeffs ] = fitQuadModel( X, y )
%FITQUADMODEL Generic function for fitting quadratic models to the data
% See also surf, meshgrid, linspace, ones.
%(a couple of key words)
% All the headers must be in a continuous block of comments

% Therefore this won't be included in the doc file.

%% A good way to make function writing more simple is to 
% break the work up into blocks. These can then be built up as
% local or sub-functions, or else built in an external function.

% Local functions are faster, they're found in the $PATH first

% Cleaning the data
[XClean, yClean] = removeNaNs(X, y);

% Fitting the model
modelCoeffs = fitModel(XClean, yClean);

% Visualising the results **do this at home!**
% visResults(X, y, XClean, yClean, modelCoeffs)

end %fitQuadModel

function[XClean, yClean] = removeNaNs(X, y)

missingVals = any([X,y],2);
XClean = X(~missingVals, :);
yClean = y(~missingVals);

end % removeNaNs

function modelCoeffs = fitModel(XClean, yClean)

nVars = size(XClean, 2); % 1 or 2
switch nVars
    case 1
        A = [ones(size(XClean)), XClean, XClean.^2];
        modelCoeffs = A\yClean;
    case 2
        x1 = XClean(:, 1); x2 = XClean(:, 2);
        A = [ones(size(x1)), x1, x1.^2, ...
            x2, x2.^2, x1.*x2];
    otherwise
    error('fitQuadModel:WrongNumberOfVars', ...
        'X must have one or two columns.')
    % An error should contain a unique identifier 
    % error(function:identifier, 'description of error')
end
end % fitModel

%function visResults(X, y, XClean, yClean, modelCoeffs)

%end % visResults