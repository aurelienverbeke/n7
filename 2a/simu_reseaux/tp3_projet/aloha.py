# Tracé du débit en fonction de la charge pour Pure Aloha et Slotted Aloha

from matplotlib import pyplot as plt
import math


# Définition des fonctions de débit pour Pure Aloha et Slotted Aloha
def throughput_pure_aloha(G):
    return G * math.exp(-2 * G)


def throughput_slotted_aloha(G):
    return G * math.exp(-G)


# Génération des valeurs de charge (G) et de débit (S)
G_values = [i * 0.1 for i in range(0, 50)]  # Charge de 0 à 5
throughput_pure = [throughput_pure_aloha(G) for G in G_values]
throughput_slotted = [throughput_slotted_aloha(G) for G in G_values]

# Tracé des courbes
plt.figure(figsize=(10, 6))
plt.plot(G_values, throughput_pure, label="Pure Aloha", color="blue")
plt.plot(G_values, throughput_slotted, label="Slotted Aloha", color="orange")
plt.title("Débit en fonction de la charge pour Pure Aloha et Slotted Aloha")
plt.xlabel("Charge (G)")
plt.ylabel("Débit (S)")
plt.legend()
plt.grid()
plt.xlim(0, 5)
plt.ylim(0, 0.5)
plt.show()
