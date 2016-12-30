% Chi-Square kernel
d = size(X1,2); n1 = size(X1,1); n2 = size(X2,1);
K = 0;
for i = 1:d
    num = 2 * X1(:,i) * X2(:,i)';
    den = X1(:,i) * ones(1,n2) + ones(n1,1) * X2(:,i)';
    K = K + num./den;
end
