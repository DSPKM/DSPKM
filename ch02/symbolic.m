syms t
x = sin(2*pi*t);
y = exp(-t/10);
z = x*y;
whos

figure(1), clc,
subplot(3,1,1); ezplot(x,[-10 10]);
subplot(3,1,2); ezplot(y,[-10 10]);
subplot(3,1,3); ezplot(z,[-10 10]);

dx = diff(x);
ezplot(x,[-1 1]);  hold on
ezplot(dx,[-1 1]); hold off
grid on
d2x = diff(x,2)
d3x = diff(x,3)