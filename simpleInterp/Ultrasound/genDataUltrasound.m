function data = genDataUltrasound(conf)

% Each column is a scan (time signal) from a location
load CompPlate4
% Normalization
Bscan4 = Bscan4/max(abs(Bscan4(:)));
% Return structured data
data.h = Bscan4(225:end-60,5);
data.z = Bscan4(:,conf.I);
data.u = 1;
data.x = data.z;
