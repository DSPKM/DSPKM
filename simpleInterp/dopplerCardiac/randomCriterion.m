function [pos_train, pos_test] = randomCriterion(image,Ntrain)

% Dimensions
dim_image=size(imagen);
longitude_image=dim_image(1)*dim_image(2);

%% Coordinates for training and test
% Random selection
positions = randperm(longitude_image);
pos_train = posiciones(1:Ntrain);
pos_test = positions(Ntrain+1:end);