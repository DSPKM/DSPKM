% Eigenvectors of Kt
e = eig(Kt);
if any(e < 0),
    error('Matrix is not P.D.')
end
