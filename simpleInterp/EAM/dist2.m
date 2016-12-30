function distance = dist2(x1,x2)

n1 = size(x1,1);
n2 = size(x2,1);
distance = (ones(n2,1) * sum((x1.^2)', 1))' + ...
  ones(n1,1) * sum((x2.^2)',1) - ...
  2.*(x1*(x2'));
distance(distance<0) = 0;
