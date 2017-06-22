function [ct,cv] = getsets(YY, classes, percent, vfold, randstate)
if nargin < 5
    randstate = 0;
end
s = rand('state');
rand('state',randstate);
ct = []; cv = [];
for ii=1:length(classes)
    idt = find(YY == classes(ii));
    if vfold
        ct = union(ct,idt);
        cv = ct;
    else
        lt  = fix(length(idt)*percent);
        idt = idt(randperm(length(idt)));
        idv = idt([lt+1:end]); % remove head
        idt = setdiff(idt,idv);ct  = union(ct,idt);cv  = union(cv,idv);
    end
endrand('state',s);
end