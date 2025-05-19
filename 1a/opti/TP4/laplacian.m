function L = laplacian(nu,dx1,dx2,N1,N2)
%
%  Cette fonction construit la matrice de l'opérateur Laplacien 2D anisotrope
%
%  Inputs
%  ------
%
%  nu : nu=[nu1;nu2], coefficients de diffusivité dans les dierctions x1 et x2. 
%
%  dx1 : pas d'espace dans la direction x1.
%
%  dx2 : pas d'espace dans la direction x2.
%
%  N1 : nombre de points de grille dans la direction x1.
%
%  N2 : nombre de points de grilles dans la direction x2.
%
%  Outputs:
%  -------
%
%  L      : Matrice de l'opérateur Laplacien (dimension N1N2 x N1N2)
%
% 

% Initialisation
b1 = nu(1)/(dx1^2);
b2 = nu(2)/(dx2^2);
a = 2*(b1+b2);

B1 = -b1*ones(N1*N2, 1);
B2 = -b2*ones(N1*N2-1, 1);
B2(N2:N2:N1*N2-1) = 0;
A = a*ones(N1*N2, 1);

%L = spdiags([B1, [B2 ; 0], A, [0 ; B2], B1], [-N2, -1, 0, 1, N2], N1*N2, N1*N2);

L = nu(1)* + nu(2)*;

end    
