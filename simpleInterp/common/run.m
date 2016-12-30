% Configuration file is loaded to execute a particular example
config_file

% Double loop is allowed in order to evaluate different conditions
n1 = length(conf.vector_loop1);
n2 = length(conf.vector_loop2);
solution = cell(n1,n2); summary = solution;
for i = 1:n1
    eval(['conf.',conf.varname_loop1,'=conf.vector_loop1(i);']);
    for j = 1:n2
        eval(['conf.',conf.varname_loop2,'=conf.vector_loop2(j);']);
        solution{i,j} = main(conf); % Common main structure is called
        summary{i,j} = conf.displayfunc(solution{i,j},conf); % Particular visualization
    end
end