# esx_braceletgps
 Projet de bracelet judiciaire pour serveur FiveM RP sous ESX 1.0 - Projet lancé pour le serveur RebornRP.

# Installation
Pour installer esx_braceletgps il suffit de copier le répertoire esx_braceletgps dans le répertoire "resources\[esx]" de votre serveur FiveM

# Utilisation
Lorsque vous êtes en jeu, pour afficher les "signaux GPS" des bracelets (blips), il vous suffit de taper la commande /bracelets
C'est cette même commande qui sera utilisé pour désactiver.

Vous pouvez aussi utiliser un :
			TriggerEvent('esx_braceletgps:acitvergps')
			TriggerClientEvent('esx_braceletgps:acitvergps')

# Configuration
Toute la configuration de fait, et ce fera dans le fichier config.lua. Vous pouvez définir une liste de métier ayant accès à l'affichage des signaux GPS, mais aussi, une liste d'objets répondant au "signaux GPS".
