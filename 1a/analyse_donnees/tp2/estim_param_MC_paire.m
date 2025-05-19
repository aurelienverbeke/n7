% fonction estim_param_MC_paire (pour exercice_2.m)

function parametres = estim_param_MC_paire(d,x,y_inf,y_sup)

p=size(x, 1);

a = zeros(2*p, 2*d-1);

for k=1:d-1
    vect = vecteur_bernstein(x, d, k);
    a(1:p, k) = vect;
    a(p+1:2*p, k+d-1) = vect;
end
a(:,end) = repmat(vecteur_bernstein(x, d, d), 2, 1);

b = zeros(2*p, 1);
b(1:p) = y_inf - y_inf(1)*vecteur_bernstein(x, d, 0);
b(p+1:end) = y_sup - y_sup(1)*vecteur_bernstein(x, d, 0);

parametres = a\b;

end
