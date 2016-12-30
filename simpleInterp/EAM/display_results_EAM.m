function display_results_EAM(solution,conf)

% Loading data for figure
if ~isfield(conf,'I'); conf.I=1; end
filename=conf.data.path;
if ~strcmp(conf.data.path(end-3:end),'.mat')
    if ~strcmp(conf.data.path(end),'/'); add='/'; else add=''; end
    s = dir([conf.data.path,add,'*.mat']);
    filename=[filename,add,s(conf.I).name];
end
load(filename);            % Load data
load(conf.data.colorpath)  % Load colormap

algs=fields(solution);
for ia=1:length(algs)
    out = find(test_data(:,4) == -10000);
    in = setdiff(1:size(test_data,1),out);
    predict{ia} = -10000*ones(size(test_data,1),1);
    predict{ia}(in) = solution.(algs{ia})(conf.I).Ytestpred;
end
ytest=solution.(algs{1})(conf.I).Ytest;
c_min = min(ytest);
c_max = max(ytest);
options={'k.','MarkerSize',60};

%% Display figure
figure
patch('faces',faces,'vertices',test_data(:,1:3),...
    'FaceVertexCData',test_data(:,4),'FaceColor','interp')
hold on; plot3(train_data(:,1),train_data(:,2),train_data(:,3),options{:})
caxis([c_min c_max])
colormap(flipud(carto));
for ia=1:length(algs)
    patch('faces',faces,'vertices',[test_data(:,1)+(ia*100) test_data(:,2:3)],...
        'FaceVertexCData',predict{ia},'FaceColor','interp'); hold on
    plot3(train_data(:,1)+(ia*100),train_data(:,2),train_data(:,3),options{:})
    caxis([c_min c_max])
    colormap(flipud(carto));
end
c = colorbar('south');
c.Label.String = 'Bipolar Voltage (mV)';
axis off; set(gcf, 'Position', get(0, 'Screensize'));

%% Performance summary
fprintf('\n-------------------------------------------------------------\n');
fprintf(' Performance summary                                         \n');
fprintf('-------------------------------------------------------------\n');
for ie=1:length(conf.evalfuncs)
    evalname = func2str(conf.evalfuncs{ie});
    fprintf('%s\n',evalname)
    for ia=1:length(algs)
        err=cat(1,solution.(algs{ia}).(evalname));
        solution_summary.(algs{ia}).([evalname,'_mean'])=mean(err);
        solution_summary.(algs{ia}).([evalname,'_std'])=std(err);
        solution_summary.(algs{ia}).([evalname,'_vector'])=err;
        fprintf('  \t- %s \t %s: Mean = %.2f  Std = %.2f \n',...
            algs{ia}, evalname,...
            solution_summary.(algs{ia}).([evalname,'_mean']),...
            solution_summary.(algs{ia}).([evalname,'_std']));
    end
end
fprintf('-------------------------------------------------------------\n');

%% Saving results
if conf.save.results
    if ~exist('s','var'); s=dir(filename); s=s(end); end
    for i=1:conf.NREPETS
        for ia=1:length(algs)
            name=s(i).name(1:end-4);
            results.(name).(algs{ia})=...
                solution.(algs{ia})(i);
            for ie=1:length(conf.evalfuncs)
                evalname = func2str(conf.evalfuncs{ie});
                results.(name).([evalname,'_summary']).(algs{ia})=...
                    solution.(algs{ia})(i).(evalname);
            end
        end
        results.solution_summary=solution_summary;
    end
    if ~exist(conf.save.path,'dir'); mkdir(conf.save.path); end
    if ~strcmp(conf.save.path(end),'/'); add='/'; else add=''; end
    disp('Saving results...')
    numNow=strrep(datestr(now,'HH:MM_ddmmyy'),':','h');
    if conf.NREPETS>1; name='results'; end
    save([conf.save.path,add,name,'_',numNow],'results')
    disp('Done.')
end
