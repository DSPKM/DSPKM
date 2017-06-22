function w = train_basic(d)
% Basic funcion to train a one-class classifier, used by xs
targets  = (d.YY == d.class);
outliers = (d.YY ~= d.class);
% Output for messages
global OUT;
if isempty(OUT), OUT=1; end
x1 = gendatoc(d.XX(targets,:), d.XX(outliers,:));
% Train
switch d.classifier
    case 'incsvdd'
        % Kernel 'r' = radial basis
        w = incsvdd(x1,d.frac, d.ktype, d.par);
    otherwise
        error('Unknown classifier')
end