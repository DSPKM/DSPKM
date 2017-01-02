function [X,Y] = moons(n)

rng(2);
space = 1.2; noise = 0.1;

r = randn(n,1) * noise + 1; theta = randn(n,1) * pi;
r1 = 1.1 * r; r2 = r;
X1 = ([r1 .* cos(theta) abs(r2 .* sin(theta))]);
Y1 = ones(n,1); % labels

r = randn(n,1) * noise + 1; theta = randn(n,1) * pi + 2*pi;
r1 = 1.1 * r; r2 = r;
X2 = ([r1 .* cos(theta) + space*rand -abs(r2 .* sin(theta)) + 0.2 ]);
Y2 = -ones(n,1); % labels

X = [X1;X2]; Y = [Y1;Y2]; v = randperm(2*n); X = X(v,:); Y = Y(v);
