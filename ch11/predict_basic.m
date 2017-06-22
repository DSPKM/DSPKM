function [kappa,oa,yp] = predict_basic(d)
% Output for messages
global OUT;
if isempty(OUT), OUT=1; end
yt = d.YY;oc = gendatoc(d.XX); rr = oc * d.w; dd = rr;
% Find maximum values (== classes)
idx = ((dd(:,1) - dd(:,2)) > 0);
yp = zeros(size(yt));yp(idx) = d.class;
% If testing rejection
yt(yt ~= d.class) = 0;
% Calculate CM
res = assessment(yt,yp); kappa = res.Kappa; oa = res.OA;