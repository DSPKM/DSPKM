% Jitter generation
w = ceil(N*rand(30,1));
w = unique(w); % indexes for jitter
jit = rand(size(w)) - .5;
jit = (sign(jit)*10)+jit;
% Mixing
yy(w) = jit;
% Now we repeat the same procedure to model the system ...
p = 2; q = 3;
m = arx([yy(:),x(:)],[p,q,0]);
[a_est,b_est] = polydata(m);
% Compare results using fvtool
fvtool(b,a,b_est,a_est);
