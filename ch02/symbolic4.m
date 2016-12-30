x = 1/t; x2 = subs(x,t,t-2); x3 = subs(x,t,-t);
figure(1), subplot(2,1,1); 
ezplot(x); subplot(2,1,2); ezplot(x2);
figure(2), subplot(2,1,1); 
ezplot(x); subplot(2,1,2); ezplot(x3);
