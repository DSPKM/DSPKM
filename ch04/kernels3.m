% Test is matris is P.D. using chol
[R,p] = chol(Kt);
if p > 0,
    error('Matrix is not P.D.')
end
