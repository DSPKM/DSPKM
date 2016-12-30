% One example
f = t * atan(t);
F = int(f,t);
pretty(F)

% Another example
g = exp(-3*t);
G = int(g,t,0,Inf);
pretty(F)
