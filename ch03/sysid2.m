% Assume we know the order of the system to be identified
p = 2; q = 3; m = arx([yy(:),x(:)],[p,q,0]); [a_est,b_est] = polydata(m);
% Instead of comparing the obtained coefficients, we will compare the response of the estimated system in terms of the impulse and frequency responses
fvtool(b,a,b_est,a_est);
