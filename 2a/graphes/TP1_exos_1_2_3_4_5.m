clear all;
close all;

%%%%% SET ENV %%%%%

addpath('matlab_bgl');      %load graph libraries
addpath('matlab_tpgraphe'); %load tp ressources

load TPgraphe.mat;          %load data

%%%%%% DISPLAY INPUT DATA ON TERMINAL %%%%%

cities %names of cities
D      %distance matrix bw cities
pos    %x-y pos of the cities

%%%%%%EXO 1 (modeliser et afficher le graphe) %%%%%

A = D<=500; %adj matrix
viz_adj(D,A,pos,cities);
for n=[2 3 10 12]
    viz_adj(D,graphPower(A, n),pos,cities);
end

%%%%%% EXO 2 %%%%%

%Q1 - existence d'un chemin de longueur 3
% graphPower(A, 3) - graphPower(A, 2)

%Q2 - nb de chemins de 3 sauts
nb_3 = sum(A^3, "all")

%Q3 - nb de chemins <=3
nb_inf_3 = sum(A + A^2 + A^3, "all")

%%%%%%%% EXO 3 %%%%%

%Que toutes les paires soient reliées

c=[18 13 9]; %la chaine 18 13 9 est t dans le graphe?
possedechaine(A,c)
c=[18 6 3]; %la chaine 18 6 3 est t dans le graphe?
possedechaine(A,c)
c=[26 5 17]; %la chaine 26 5 17 est t dans le graphe?
possedechaine(A,c)

%%%%%%%% EXO 4%%%%%
isEulerien(A)

%%%%%%%% EXO 5%%%%%
porteeEulerien(D)
