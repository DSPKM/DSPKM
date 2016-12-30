function [varargout] = interpSignal(conf,varargin)
cf = conf.data;
varargout = cell(nargout,1);
for m = 1:nargout,
    t = varargin{m};
    y = zeros(size(t));
    x = ((t-cf.mu)./cf.sigma);
    switch cf.FNAME
        case 'MSSF'
            y = cos(2*pi*cf.f.*t) .* (1/(cf.sigma*sqrt(2*pi))).*exp((-1/2).*(x.^2));
        case 'DMGF'
            sigma=3; f1=.75; f2=0.25;
            y = (cos(2*pi*f1.*t) + cos(2*pi*f2.*t)) .* (1/(sigma*sqrt(2*pi))).*exp((-1/2).*((x*cf.sigma/sigma).^2));
        case 'gauss'
            y = (1/(cf.sigma*sqrt(2*pi))).*exp((-1/2).*(x.^2));
        case 'sinc2'
            y = sinc(t/(cf.T0*2)).^2;
        case 'doblesinc2'
            t0 = 6*cf.T0;
            w = 2/(3*cf.T0);
            tc = t - (t(1)+t(end))/2;
            y = sinc(tc/t0).^2 + cf.k*(sinc(tc/t0).^2) .* sin(w*tc);
        case '50sincs'
            A = rand(50,1);
            mu = (rand(50,1)+cf.DESP).*cf.L*cf.T;
            for n = 1:50,
                sinc_aux = A(n) .* sinc((t-mu(n))/cf.T0);
                y = y + sinc_aux;
            end
    end
    varargout{m} = y;
end