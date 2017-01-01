
function  [f,mu,sig] = scale(x)

[samples,features] = size(x);

for j=1:features
   mu(j,1)=min(x(:,j));
   sig(j,1)=max(x(:,j))-min(x(:,j));
   f(:,j)=(x(:,j)-mu(j,1))/sig(j,1);
end
 
 