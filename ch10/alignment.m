function A = alignment(Ker,Y)

A = trace(Ker'*Y) / sqrt(trace(Ker'*Ker) * trace(Y'*Y));