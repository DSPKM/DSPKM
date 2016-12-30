function [V Z iter L] = bss2(X,epsilon)
[Dim Ndata] = size(X);
V = randn(Dim);
L = [];
for j = 1:Dim
    current = V(:,j);
    last = zeros(Dim,1);
    iter_max = 40;
    iter(j) = 0;
    while ~(abs(current-last)<epsilon)
        last = V(:,j);
        V(:,j) = 1 / Ndata * X * tanh(V(:,j)'*X)' - 1 / Ndata * ...
            sum((1-tanh(V(:,j)'*X).^2)) * V(:,j);
        V(:,1:j) = gramsmith(V(:,1:j));
        current = V(:,j);
        P = -log(cosh(V'*X));
        L = [L 1/Ndata*sum(P(:))];
        iter(j) = iter(j)+1;
        if iter(j) > iter_max
            break
        end
    end
end
Z = V' * X;
function V = gramsmith(V)
for i = 1:size(V,2)
    V(:,i) = V(:,i) - V(:,1:i-1) * V(:,1:i-1)' * V(:,i);
    V(:,i) = V(:,i) / norm(V(:,i));
end
