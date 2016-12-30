function [pos_train,pos_test]=gradientCriterion(...
           Image,Ntrain)
% Dimensions
dim_image=size(Image);
longitude_image=dim_image(1)*dim_image(2);

% Compute the gradient
[XImageX, YImageY] = gradient (Image);
Grad = sqrt(XImageX .^ (2) + YImageY .^ (2));
x= Grad(:);

%%Sort gradient values %%
[xx,ind] = sort(abs(x),'descend');

m = max(abs(x));
aux = zeros(Ntrain,1);
cont = 1;
while cont-1\langleNtrain; 
    mirnd = 50*randn(1,1)+m;
    mevale = (mirnd\rangle0) & (mirnd\langlem);
    if mevale
        [kk,indsel] = min(abs(mirnd-xx));
        indsel=find(abs(mirnd-xx)==kk);
        if length(indsel)\rangle1
            vv = randperm(length(indsel));
            indsel = indsel(vv(1));
        end
        if not(any(aux==indsel))
            aux(cont) = (indsel);
            cont = cont+1;
        end
    end
end
aux=ind(aux);
pos_train = aux;
pos_test=setdiff(1:prod(dim_image),aux);