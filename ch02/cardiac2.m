egm = EGM(2,340:380);
fs = 1e3; ts = 1/fs;
t = (0:5000-1) * ts;
for ciclo = [80 160 500 1000 2000 5000];
    x = zeros(1,5000);
    x(1:ciclo:end) = 1;
    v = filter(egm,1,x);
    subplot(211), plot(t,v),xlabel('time (s)'), axis tight
    subplot(212), [P,f] = pwelch(v,[],length(v)/2,[],fs);
    plot(f,P), axis tight, xlabel('frequency (Hz)'), pause
end