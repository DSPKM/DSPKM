function SeriesFourier2(x)

aux = sign(real(abs(x)>40));
indices_ciclos = find(diff(aux) == 1);
ciclo = median(diff(indices_ciclos));
inicio = indices_ciclos(1);
fin = indices_ciclos(length(indices_ciclos));

x = x(inicio:fin);
fs = 500; ts = 1/fs;
t = ts*(0:length(x)-1);

subplot(111),plot(t,x);
xlabel('secs'); ylabel('mV');
title('Period T');
drawnow; pause

orden = 100;
coef_x = zeros(2,orden+1);
coef_x(1,1) = mean(x);

T = length(x);
eje = 0:T-1;

for i = 1:orden
    aux_cos = cos(2*pi*i/ciclo*eje);
    aux_sin = sin(2*pi*i/ciclo*eje);
    ax = 2/T*sum(x.*aux_cos);coef_x(1,i+1) = ax;
    bx = 2/T*sum(x.*aux_sin);coef_x(2,i+1) = bx;
    
    recon_x = zeros(1,T);
    recon_x = recon_x+coef_x(1,1);
    for k = 1:i;
        recon_x  =  recon_x+...
            coef_x(1,k+1)*cos(2*pi*k/ciclo*[0:T-1]) + ...
            coef_x(2,k+1)*sin(2*pi*k/ciclo*[0:T-1]);
    end
    
    if rem(i,5) == 0
        amplichunga = sqrt(coef_x(1,i)^2+coef_x(2,i)^2);
        trozo = 200:700;
        subplot(211);
        plot(t(trozo),x(trozo),'b',t(trozo),recon_x(trozo),'r');
        title(['Order: ', num2str(i)]); xlabel('s');
        axis tight; ejes  =  axis;
        subplot(212); plot(t(trozo),amplichunga*aux_cos(trozo),'g');
        axis(ejes);
        axis tight; xlabel('s')
        
        pause
    end
end