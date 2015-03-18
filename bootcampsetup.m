function bootcampsetup()
% Set up the MATLAB path for the course.


% We want all folders under "BootcampFiles" to be on the path for the course.
cd('..')
addpath(genpath('BootcampFiles'))

% We don't want the test data folder on the path yet.
warning('off', 'MATLAB:rmpath:DirNotFound')
rmpath('Test_Data')
warning('on', 'MATLAB:rmpath:DirNotFound')

% Change back to the right directory.
cd('BootcampFiles')


end % setupCoursePaths