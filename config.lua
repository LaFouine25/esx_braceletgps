-- Initialisation Config.
Config		= {};

-- Autorisation pour l'affichage des blips
Config.metiers	= {'police'};
Config.items	= {'braceletgps'};
Config.affall	= true;		-- On affiche aussi les autres métiers autorisé en couleur AUTRE
Config.hidall	= false;	-- Utilse si Config.affall == false Le blip est soit affiché en rouge, soit pas affiché

-- Configuration pour le retrait des bracelets
Config.ctrlretrait	= true;
-- Config.addrwebhook	= "https://discordapp.com/api/webhooks/738780865009549425/7sMgf5_A5y3Ij5eW1LwFzfBV6PJvKPY6BIXWSaaqJC-x2at6VQqFvO_tZ4FUpiy3ogB_";
Config.addrwebhook	= "";

-- Configuration des messages d'activation
Config.notpict	= "CHAR_CALL911";
Config.nottitre	= "Tracker GPS.";
Config.notsujet	= "LSPD Technique.";
Config.notmess1	= "Activation de la localisation des Bracelets GPS.";
Config.notmess2	= "Désactivation de la localisation des Bracelets GSP.";
