% Finds the closer clusters for generating test kernels

function [ID_UL PP]= closerClusterGMM(Xtest,obj,tipo)

% Xtest: test data
% C_tot: GMM object containing centers and mixing components of the Gaussians
% tipo: hard or soft

if strcmpi(tipo,'kmeans')
    d = L2_distance(Xtest',obj');
    [val,ID_UL] = min(d,[],2);
    PP = ones(size(Xtest,1),1);
elseif strcmpi(tipo,'soft')
    options = statset('Display','final');
    Pgmm = posterior(obj,Xtest);
    ID_UL = cluster(obj,Xtest);
    PP = max(Pgmm,[],2);
elseif strcmpi(tipo,'resoft')||strcmpi(tipo,'GMM')
    options = statset('Display','final');
    Pgmm = posterior(obj,Xtest);
    ID_UL = cluster(obj,Xtest);
    PP = Pgmm;
elseif strcmpi(tipo,'completo')
    % options = statset('Display','final');
    Pgmm = gmmpost(obj,Xtest);
    [p_k,ID_UL] = max(Pgmm,[],2);
    PP = Pgmm;
end