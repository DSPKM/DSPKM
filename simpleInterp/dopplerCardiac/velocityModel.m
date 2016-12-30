function velocityModel
% Simulated velocity model of diastole, with three waves (E1, E2, A).

syms f v s t ro Sigma

% Parameters
s1=8; 	s2=4;			%  limits of the spatial integration
Sigma = [1 -0.5; -0.5 1];
at= 0.05;	as= 1.5;

v0 = 100*exp(-(1/2) *[s,t] * inv(Sigma)*[s;t]);  	% E (symbolic)
v1 = subs(v0,{s,t},{(s-6)/as, ((t+0.25)/at)});  	% Substitution for  E1 
v2 = 0.5 * subs(v0,{s,t},{(s-7)/as,(t+0.08)/at}); 	% Substitution for E2 
Sigma2 = [.8 -.05; -.05 .1];
v4 = 100*exp(-(1/2) *[s,t] * inv(Sigma2)*[s;t]);   	% A (symbolic)
v3 = .75*subs(v4,{s,t},{(s-6)/as, ((t+0.3)/at)});  	% Substitution for A

% To avoid values higher than 100 cm/s
v1 = .9*v1; v2 = .9*v2; v3 = .65*v3;
v = v1+v2+v3;