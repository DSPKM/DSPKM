x  = (-14:14) / 29;
z1 = kron(ones(1,18),x); z1 = z1(1:500);
x  = (-9:9) / 25;
z2 = kron(ones(1,28),x.^3)/0.1; z2 = z2(1:500);
z3 = 5 * sin(2*pi*32*(0:499)/500)/2;
z4 = 0.01 * randn(1,500);
W  = [1 1 0.5 0.2;0.2 1 1 0.5;0.2 1 1.4 0.4; 1 0.3 0.5 0.5];
X  = W' * [z1;z2;z3;z4];
