% Filter
filtcoef = ones(size(vertex));
filtcoef(4,:)=2;

% Reconstructed mesh
x_hat_n = H*(filtcoef.*a);