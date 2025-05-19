% fonction estim_param_MC (pour exercice_1.m)

function parametres = estim_param_MC(d,x,y)

p=size(x, 1);

a = zeros(p, d);

for k=1:d
    a(:,k) = vecteur_bernstein(x, d, k);
end

b = y - y(1)*vecteur_bernstein(x, d, 0);

parametres = a\b;
    
end
