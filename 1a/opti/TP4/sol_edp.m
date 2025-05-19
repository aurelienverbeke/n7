clear all; close all;

L1 = 1;
L2 = 1;
nu = [1 1];
N1 = 50;
N2 = 50;
dx1 = L1/N1;
dx2 = L2/N2;
nbfig = 1;

A = laplacian(nu, dx1, dx2, N1, N2);
C = forcing(nu, dx1, dx2, N1, N2);

uh = A\C;

nbfig_out = plot_uh(uh, dx1, dx2, N1, N2, nbfig);