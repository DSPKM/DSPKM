function [sortedRSS, sortedY] = sortByRSS(RSS,Y)

Naps = size(RSS,2);
[aux, ~] = sortrows([RSS Y]);
sortedRSS = aux(:,1:Naps);
sortedY = aux(:,Naps+1:end);
