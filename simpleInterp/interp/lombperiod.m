function Pn = lombperiod(h,t,f)

% P = lomb_period(H,T,F) FFT estimation for non-uniformly sampled series.
%
% 	H: time series
%	T: corresponding time of sampling
%	F: frequency axes requested

% Initials
h = h(:);
hm = mean(h);
h = h - hm;
t = t(:);

% Calculate PSD
Pn = zeros(length(f),1);
k = find(f>0,1);
if f(1)==0;
    Pn(1)=hm^2;
end
warning off
for i=k:length(f)
    % Working freq
    w=2*pi*f(i);
    % LS delay
    auxtau = sum(sin(2*w*t))/sum(cos(2*w*t));
    tau=(1/(2*w))*atan(auxtau);
    % Lomb Normalized Periodogram
    Pn(i) = (sum(h.*cos(w*(t-tau)))).^2 / sum((cos(w*(t-tau))).^2) + ...
            (sum(h.*sin(w*(t-tau)))).^2 / sum((sin(w*(t-tau))).^2);
end
warning on