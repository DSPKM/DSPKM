function solution_summary = results_summary(solution,conf)

algs = fields(solution);
addstr = ''; extra1 = '%.2f'; extra2 = extra1;
cname1 = conf.(conf.varname_loop1); cname2 = conf.(conf.varname_loop2);
if iscell(cname1); cname1 = cname1{1}; extra1 = '%s'; end
if iscell(cname2); cname2 = cname2{1}; extra2 = '%s'; end
cnf1 = sprintf(['%s = ',extra1],conf.varname_loop1,cname1);
cnf2 = sprintf(['%s = ',extra2],conf.varname_loop2,cname2);
cv1 = conf.varname_loop1; cv2 = conf.varname_loop2;
if ~strcmp(cv1,'idle1') && ~strcmp(cv2,'idle2');
    addstr = sprintf('(%s, %s)',cnf1,cnf2);
elseif ~strcmp(cv1,'idle1')
    addstr = sprintf('(%s)',cnf1);
elseif ~strcmp(cv2,'idle2')
    addstr = sprintf('(%s)',cnf2);
end
fprintf('\n-------------------------------------------------------------\n');
fprintf(' Performance summary %s\n',addstr);
fprintf('-------------------------------------------------------------\n');
for ie = 1:length(conf.evalfuncs)
    evalname = func2str(conf.evalfuncs{ie});
    fprintf('%s\n',evalname)
    for ia = 1:length(algs)
        err = cat(1,solution.(algs{ia}).(evalname));
        solution_summary.(algs{ia}).([evalname,'_mean']) = mean(err);
        solution_summary.(algs{ia}).([evalname,'_std']) = std(err);
        solution_summary.(algs{ia}).([evalname,'_vector']) = err;
        fprintf('  \t- %s \t %s: Mean = %.2e  Std = %.2e \n',...
            algs{ia}, evalname,...
            solution_summary.(algs{ia}).([evalname,'_mean']),...
            solution_summary.(algs{ia}).([evalname,'_std']));
    end
end
fprintf('-------------------------------------------------------------\n');