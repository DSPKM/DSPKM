syms k a_k a_kbis serie t
T = 2;
serie = 0;
for k = 1:50
    a_k = 1/T*(int(...,0,1) + int(...,1,2));
    a_kbis = ... ;
    serie = serie + a_k * exp(j*2*pi/T*k*t) + ...
                    a_kbis * exp(-j*2*pi/T*k*t);
    serie = simple(serie); % Note the effect of simplifying 
    
    if rem(k,5) == 0;
        ezplot(serie,[-4 4]); legend(num2str(k)); pause
    end
end
