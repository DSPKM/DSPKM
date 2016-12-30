function data=genDataOFDM(conf)

cf=conf.data;

% Training sequence (preamble)
% (orthogonality is imposed with frequency-domain symbols)
preamble=zeros(cf.Npil,cf.Lp);
for kl=1:cf.Lp
    preamble(:,kl)=exp(1i*2*pi*rand(cf.Npil,1)); % Phase reference random (PN-seq)
end

% TRANSMITTER
s_bits=round(rand(1,cf.Nb_frm));  % generate random 0/1's
s_trx=modcohe(s_bits,cf.N,cf.PC,cf.M,preamble,cf.Nsymb_frm);%modulation

% CHANNEL
[~,~,paths]=chan_SUI3(conf.NREPETS,conf.I); % generate channel taps for SUI/3 model (independent channels)
xch=conv(s_trx,paths(:,conf.I)); % convolution with the channel
r_rx_chan=xch(1:length(s_trx));  % fix same length
if cf.sirFlag      % 'normal','only_preamble','only_data'
    r_rx=channelAWGN_IMPULSIVE(r_rx_chan,...
        cf.SNR,conf.SIR,cf.p,'only_preamble',cf.Npil);  % IMPULSIVE + AWGN noise
else
    r_rx=channelAWGN_IMPULSIVE(r_rx_chan,conf.SNR(rr),conf.SIR,cf.p);  % IMPULSIVE + AWGN noise
end
% Preamble reception
Lpil=cf.Npil+cf.PC;
for l=1:cf.Lp % take Lp preamble OFDM-symbols and eliminate PC
    preamble_rx(:,l) = r_rx((cf.inicSync+cf.PC:cf.inicSync+cf.PC+cf.Npil-1)+((l-1)*Lpil)).';
end
% For Equalization: ZF
inic_dat=cf.inicSync+(Lpil*cf.Lp); %init of data samples at the frame
for l=1:cf.Nsymb_frm,
    s_datos_fd(:,l) = fft(r_rx((inic_dat+cf.PC:inic_dat+cf.PC+cf.N-1)+((l-1)*cf.L)).');
end

data.Xtrain=preamble; data.Ytrain=preamble_rx;
data.Xtest=s_datos_fd; data.Ytest.input=s_bits; data.Ytest.path=paths(:,conf.I);
