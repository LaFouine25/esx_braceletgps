-- Initialisation Config.
Config		= {};

-- Autorisation pour l'affichage des blips
Config.metiers	= {'police', 'sheriff'};
Config.items	= {'braceletgps'};
Config.affall	= false;	-- On affiche aussi les autres métiers autorisé en couleur AUTRE
Config.hidall	= true;		-- Utilse si Config.affall == false Le blip est soit affiché en rouge, soit pas affiché

-- Configuration des messages d'activation
Config.notpict	= "CHAR_CALL911";
Config.nottitre= "MyCity GPS.";
Config.notsujet= "LSPD Technique.";
Config.notmess1= "Activation de la localisation des Bracelets GPS.";
Config.notmess2= "Désactivation de la localisation des Bracelets GSP.";
