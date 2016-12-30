function param_selec = sequentialSearch(XTrain,YTrain,conf,XValid,YValid)

% Cell array of free parameters
value_range = conf.machine.value_range;
nparams = length(value_range);
params = cell(nparams,1);
lp = zeros(nparams,1);
for ip = 1:nparams
    params{ip} = value_range{ip}(1);
    lp(ip) = length(value_range{ip});
end
% Return if only one parameter
if sum(lp) == nparams; param_selec = params; return; end

for ciclo = 1:conf.cv.NCICLOS
    for ip = 1:length(value_range)
        values = value_range{ip};
        err = inf*ones(1,length(values));
        for iv = 1:length(values)
            % Train
            prediction = conf.machine.function_name(XTrain,YTrain,XValid,params{:});
            % Validation error
            err(iv) = conf.cv.evalfunc(prediction,YValid);
        end
        [bestValue,indMin] = min(err);
        params{ip} = bestValue;
        
        if conf.DRAWMODE == 2
            subplot(2,ceil(nparams/2),ip)
            semilogx(values, err, values, err(indMin), 'ro')
            xlabel([num2str(ip),' param.']), ylabel(func2str(conf.cv.evalfunc))
            xlim([values(1) values(end)]); drawnow
        end
    end
end
param_selec = params;