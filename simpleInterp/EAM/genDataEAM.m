function data = genDataEAM(conf)

filename=conf.data.path;
if ~strcmp(conf.data.path(end-3:end),'.mat')
    if ~strcmp(conf.data.path(end),'/'); add='/'; else add=''; end
    s = dir([conf.data.path,add,'*.mat']);
    filename=[filename,add,s(conf.I).name];
end
load(filename,'train_data','test_data');

% Train
data.Xtrain = train_data(:,1:3); % V = [X, Y, Z] % 3D coord.
data.Ytrain = train_data(:,4);   % train values
% Test
% Vertices with the value -10000 are non-active vertices and
% deleted in the EAM. They are excluded in the interpolation
out = find(test_data(:,4) == -10000);
in = setdiff(1:size(test_data,1),out);
sub_test_data = test_data(in,:);
data.Xtest  = sub_test_data(:,1:3);  % U = [X, Y, Z] % 3D coord.
data.Ytest  = sub_test_data(:,4);    % test values
