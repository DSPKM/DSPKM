function [X,Y,instantValues] = getRSSandLocations(data,MACs,thresh,falseThr)
j=0;
for i = 1:length(data)
    aux = data{i};
    if ~isfield(aux,'measurements'); continue; end
    j=j+1;
    Y(j,:)=[str2num(aux.location.X), str2num(aux.location.Y)];
    auxRSS_Mean   = zeros(1,length(MACs));
    for indAccessPoint = 1:length(aux.measurements)
        myIndex = findMAC(MACs, aux.measurements{indAccessPoint}.MAC);
        if ~myIndex; continue; end
        values = aux.measurements{indAccessPoint}.InstValues;
        if isempty(values); values=0; end
        values(values==falseThr) = thresh;
        auxRSS_Mean(myIndex) = mean(values);
        if j==1; instantValues(:,myIndex) = values; end
    end
    RSS(j,:) = auxRSS_Mean;
end
RSS(RSS==0 | RSS<thresh) = thresh;
include = find(~isnan(sum(RSS,2)));
[X, Y] = sortByRSS(RSS(include,:),Y(include,:));
