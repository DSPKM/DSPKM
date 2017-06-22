% Binarize of a vector
%
% Inputs:
%       - Y  : Vector, M(samples) x 1
%
% Outputs:
%       - Yb : Matrix, M(samples) x C(Number of values as in Y without repetitions)
%

function Yb = binarize(Y)

unics = unique(Y);
Yb = zeros(length(Y),length(unics));
for i = 1:length(unics)
    Yb(Y == unics(i), i) = 1;
end
