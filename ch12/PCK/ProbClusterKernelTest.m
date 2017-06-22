% Builds test probabilistic cluster kernel
% Input:  Xtrain:  Train samples.[samplesxfeatures]
%	 Xtest:   Test samples.[samplesxfeatures]
%	 C_tot:   Gaussian mixture parameter estimates
%	 IDX_tot: Clusters from Gaussian mixture distribution
%	 Z:       Normalization factor
%	 N:       Number of realizations
%	 Kvector: Number of clustering (Array)
% Output: KbagUL: Test Probabilistic Cluster Kernel.

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

function KbagUL = ProbClusterKernelTest(Xtrain,Xtest,C_tot,IDX_tot,Z,N,Kvector)

tipo='resoft';
% K: number of clusters
KbagUL = zeros(size(Xtrain,1),size(Xtest,1));

nk=0;
for k=Kvector
    nk=nk+1;
    for n=1:N
        if ~isempty(C_tot{nk,n})
            Pgmm = posterior(C_tot{nk,n},Xtrain);
            [ID_UL PP]= closerClusterGMM(Xtest,C_tot{nk,n},tipo);
            idx_tot=IDX_tot{nk,n};
            idx_tot=idx_tot(1:size(Xtrain,1),:);
            for p=1:length(ID_UL)
                for q=1:length(idx_tot)
                    KbagUL(q,p) = KbagUL(q,p) + PP(p,:)*Pgmm(q,:)';
                end
            end
        end
    end
end

%-------------------------------------------------------------------------
% Test kernel
%-------------------------------------------------------------------------
KbagUL = KbagUL/max(max(KbagUL));