function h = getri(Q)
num = [1 -.6];
den = poly([.8*exp(1j*5*pi/12) .8*exp(-1j*5*pi/12)]);
h = impz(num,den,Q);