% Builds a GMM cluster kernel given input train data
% Inputs: Xtrain: Train samples.[samplesxfeatures]
%	  N:          Number of realizations
%	  Kvector:    Number of clustering (Array)
% Output: Kbag:    Probailistic Cluster Kernel
%	 C_tot:       Gaussian mixture parameter estimates
%	 IDX_tot:     Clusters from Gaussian mixture distribution

% Copyright (c) 2013  Emma Izquierdo-Verdiguier, Robert Jenssen, Luis Gómez-Chova, and Gustavo Camps-Valls
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If you use the software, please consider citing this related paper:
%  cite: @article{IzquierdoVerdiguier20151299,
%  title = "Spectral clustering with the probabilistic cluster kernel ",
%  journal = "Neurocomputing ",
%  volume = "149, Part C",
%  number = "0",
%  pages = "1299 - 1304",
%  year = "2015",
%  note = "",
%  issn = "0925-2312",
%  doi = "http://dx.doi.org/10.1016/j.neucom.2014.08.068",
%  url = "http://www.sciencedirect.com/science/article/pii/S0925231214011291",
%  author = "Emma Izquierdo-Verdiguier and Robert Jenssen and Luis Gómez-Chova and Gustavo Camps-Valls",
%  keywords = "Kernel methods",
%  keywords = "Generative kernels",
%  keywords = "Manifold learning",
%  keywords = "Spectral clustering "
%  }
% emma.izquierdo@uv.es, http://isp.uv.es
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Kbag,C_tot,IDX_tot,Z]=ProbClusterKernel(Xtrain,N,Kvector)

X=Xtrain;

Kbag = zeros(size(X,1));

IDX_tot = cell(length(Kvector),N);
C_tot = cell(length(Kvector),N);
nk=0;

for k = Kvector
    nk = nk+1;
    for n=1:N
        disp(['Building the cluster/generative kernel for (k,n)=' num2str(k) ',' num2str(n)])
        try
            options = statset('Display','off');
            obj = gmdistribution.fit(X,k,'Options',options,'SharedCov',true);
            Pgmm = posterior(obj,X);
            IDX = cluster(obj,X);
            PP = Pgmm*Pgmm';
            % Bag kernel from GMM clustering
            for i=1:(size(X,1))
                for j=1:(size(X,1))
                    Kbag(i,j) = Kbag(i,j) + PP(i,j);
                end;
            end;
            IDX_tot{nk,n} = IDX;
            C_tot{nk,n} = obj;
            clear IDX
            clear C
        catch
            disp('GMM failed due to low samples/dim ratio')
        end
    end
    
end

Kbag = Kbag(1:size(X,1),1:size(X,1));
Z = max(max(Kbag));
Kbag = Kbag/Z;