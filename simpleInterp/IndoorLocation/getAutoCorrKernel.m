function H = getAutoCorrKernel(Xtrain,Xtest,acorr,acx,acy,acz)

[str1,str2]=size(Xtrain);
stst1=size(Xtest,1);

deltaR = zeros(stst1,str1,str2);
for nx=1:stst1
    deltaR(nx,:,:) = bsxfun(@minus,Xtest(nx,:),Xtrain);
end
deltaRv = reshape(deltaR,[stst1*str1,str2]);
dRv = num2cell(deltaRv,1);
NN=1e6; % Maximum size for batch execution
NTEST=size(deltaRv,1);
if NTEST<NN; % Batch execution
    if str2==2
        Hv=interp2(acx',acy',acorr',dRv{:},'*linear');
    elseif str2==3
        acx=permute(acx,[2 1 3]); acy=permute(acy,[2 1 3]);
        acz=permute(acz,[2 1 3]); acorr=permute(acorr,[2 1 3]);
        Hv=interp3(acx,acy,acz,acorr,dRv{:},'*linear');
    end
else % Obtaining kernel matrix by chunks
    Hv=zeros(NTEST,1);
    L=ceil(NTEST/NN);
    for k=1:L
        range=(k-1)*NN+1:min(k*NN,NTEST);
        dRv = num2cell(deltaRv(range,:),1);
        if str2==2
            Hv(range)=interp2(acx',acy',acorr',dRv{:},'*linear');
        else
            acx=permute(acx,[2 1 3]); acy=permute(acy,[2 1 3]);
            acz=permute(acz,[2 1 3]); acorr=permute(acorr,[2 1 3]);
            Hv(range)=interp3(acx,acy,acz,acorr,dRv{:},'*linear');
        end
    end
end
H = reshape(Hv,stst1,str1);
