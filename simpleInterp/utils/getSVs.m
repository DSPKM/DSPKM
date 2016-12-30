function SVs = getSVs(y,model)

SVs = zeros(size(y));
if ~isempty(model)
    SVs(model.idx) = model.sv_coef;
end

