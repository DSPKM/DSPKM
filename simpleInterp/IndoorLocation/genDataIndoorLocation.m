function data = genDataIndoorLocation(conf)

MACs = {'0020a659bae6','0020a65a3de9','0020a65a21ff'};
Naps = length(MACs);
thresh = -89; falseThr=-150;
load(conf.data.path,'train','test')
% Train
[data.Xtrain,data.Ytrain]=getRSSandLocations(train,MACs,thresh,falseThr);
%data.Ytrain = data.Ytrain(:,1) + 1i * data.Ytrain(:,2);
% Test
[~,~,values]=getRSSandLocations(test,MACs,thresh,falseThr);
Nm = 60; % seconds
iv = values;
RSStest = zeros((size(iv,1)-1)/Nm, Naps);
for n = 1:(size(iv,1)-1)/Nm,
    RSStest(n,:) = median(iv((n-1)*Nm+1:n*Nm ,:));
end
data.Xtest = RSStest;
data.Ytest = zeros(size(RSStest,1),2);
% [~, data.Ytest] = sortByRSS(RSStest,zeros(size(RSStest,1),2));
% % data.Ytest = data.Ytest(:,1) + 1i * data.Ytest(:,2);
