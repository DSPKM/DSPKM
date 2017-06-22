function demo_svdd

% dependencies: assessment.m
% Note: needs to download and install dd_tools and pr_tools from
%  http://prlab.tudelft.nl/david-tax/dd_tools.html and http://www.prtools.org 

%% add paths to prtools and ddtols (suposed to be in the actual directory)
addpath(genpath('.'))
addpath ../Installed/dd_tools/
addpath ../Installed/prtools/
 

%% Initialscd
seed = 1; rand('state',seed); randn('state',seed);
N = 500; dif = 1;
XX =[randn(1,N)-dif randn(1,N)+dif; 2*randn(1,N)-dif 2*randn(1,N)+dif]';
YY =[2*ones(1,N) ones(1,N)]';
percent=0.3;vfold=4; par=[1 sqrt(10) 5 10 25 50 100]; frac=[1e-2 .1:.1:.5];

%$ Sets of classes to train
trainclasses=1; w = cell(1,length(trainclasses));

%% Construct validation and test sets
allclasses = unique(YY);
[train_set,test_set] = getsets(YY, allclasses, percent, 0);

%% General training data
data.classifier = 'incsvdd'; classifier = 'incsvdd'; data.ktype = 'r';

% Reserve memory
kappa = zeros(vfold,1); oa = zeros(vfold,1);

%% For every class to be trained
for cl = 1:length(trainclasses)
    % Reserve memory
    errors{cl} = zeros(length(par),length(frac),2);
    data.class = trainclasses(cl);
    % For every par value
    for pit = 1:length(par)
        fprintf('Par %f ...\n', par(pit))
        % For every fraction rejection value
        for fracit = 1:length(frac)
            % Train classifier
            fprintf('  frac %f ... ', frac(fracit))
            data.par  = par(pit);data.frac = frac(fracit);
            % Perform cross validation
            state = rand('state');rand('state',0);
            idx = randperm(length(train_set));
            rand('state',state);groups = ceil(vfold*idx/length(train_set));
            for vf = 1:vfold,
                in  = find(groups ~= vf);out = find(groups == vf);
                % Train
                data.XX = XX(train_set(in),:);data.YY = YY(train_set(in),:);
                data.w  = train_basic(data);
                % Validation
                data.XX = XX(train_set(out),:);data.YY = YY(train_set(out));
                [kappa(vf) oa(vf)] = predict_basic(data);
            end
            errors{cl}(pit,fracit,:) = [mean(kappa), mean(oa)];
            fprintf('  Mean K: %f \t OA: %f\n', errors{cl}(pit,fracit,:))
        end
    end
    % Show optimum values for Kappa
    [val,ifrac] = max(max([errors{:}(:,:,1)]));
    [val,ipar]  = max(max([errors{:}(:,:,1)]'));
    % Now train and test with best parameters
    data.XX   = XX(train_set,:); data.YY   = YY(train_set);
    data.par  = par(ipar);data.frac = frac(ifrac);
    data.w    = train_basic(data);data.XX  = XX(test_set,:);
    data.YY   = YY(test_set);
    [data.kappa(cl) data.oa(cl) data.yp(cl,:)] = predict_basic(data);
    fprintf('Results %s(%02d) Par: %f, f.r.: %f, K: %f, OA: %f\n', ...
        classifier, trainclasses(cl),par(ipar), frac(ifrac), data.kappa, data.oa)
end

%% Plot the distributions
plot(XX(1:N,1),XX(1:N,2),'r.'),hold on,plot(XX(N+1:end,1),XX(N+1:end,2),'kx')
plotc(data.w,'b.',4),set(gca,'LineWidth',1)
end

%% ###############    Auxiliary functions     #######################
function [ct,cv] = getsets(YY, classes, percent, vfold, randstate)
if nargin < 5;randstate = 0;end
s = rand('state');rand('state',randstate);ct = []; cv = [];
for ii=1:length(classes)
    idt = find(YY == classes(ii));
    if vfold
        ct = union(ct,idt);cv = ct;
    else
        lt  = fix(length(idt)*percent); idt = idt(randperm(length(idt)));
        idv = idt([lt+1:end]); % remove head
        idt = setdiff(idt,idv);ct  = union(ct,idt);cv  = union(cv,idv);
    end
end
rand('state',s);
end

%% Callback functions

function [w,res] = train_basic(d)
% Basic funcion to train a one-class classifier, used by xs
targets  = find(d.YY == d.class);outliers = find(d.YY ~= d.class);
x1 = gendatoc(d.XX(targets,:),d.XX(outliers,:));
w = incsvdd(x1,d.frac,d.ktype,d.par);
end

function [kappa,oa,yp] = predict_basic(d)
yt = d.YY;oc = gendatoc(d.XX);rr = oc * d.w;dd = +rr;
idx = find((dd(:,1) - dd(:,2)) > 0);yp = zeros(size(yt));yp(idx) = d.class;
yt(yt ~= d.class) = 0;
res = assessment(yt,yp,'class');kappa = res.Kappa;oa = res.OA;
end
