--================================
-- Développé par Fouinette
-- Pour le projet MyCitY RP
--================================
ESX		= nil;
Porteur	= {};
OldPor	= {};

-- Initialisation du FrameWork
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
	while true do
		local xPlayers	= ESX.GetPlayers();
		OldPor	= Porteur;
		Porteur	= {};

		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i]);

			for k,v in ipairs(Config.items) do
				if xPlayer.getInventoryItem(v).count > 0 then
					table.insert(Porteur, xPlayer);
					break;
				end
			end
		end
				
		if Config.ctrlretrait and Config.addrwebhook ~= "" then
			for i=1, #OldPor, 1 do
				if OldPor[i] == Porteur[i] then
					-- On ne fait rien, c'est le même joueur
				else
					-- On parcours la table Porteur pour voir si OldPor est dedans mais ailleurs.
					local temp = false;
					for _,v in ipairs(Porteur) do
						if v.identifier == OldPor[i].identifier then
							temp = true;
							break;
						end
					end
					if not temp then
						-- Retrait du bracelet.
						AlerteDiscord("Retrait du Bracelet GPS pour " .. OldPor[i].name .. " Coords: " .. OldPor[i].getCoords(false)["x"] .. ", " .. OldPor[i].getCoords(false)["y"]);
					end
				end
			end
		end
		
		Citizen.Wait(30000);
	end
end)

-- Fonction WebHook
function AlerteDiscord(message)
	if Config.ctrlretrait and Config.addrwebhook ~= "" then
		PerformHttpRequest(Config.addrwebhook, function(err, text, headers) end, 'POST', json.encode({username = "Retrait Bracelets GPS", content = message}), { ['Content-Type'] = 'application/json' });
	end
end

-- Mise à jour de la liste lors d'une déco/reco
AddEventHandler("playerDropped",function(reason)
	local source	= source;
	local xPlayer	= ESX.GetPlayerFromId(source);
	for i=1, #Porteur, 1 do
		if Porteur[i].identifier == xPlayer.identifier then
			table.remove(Porteur, i);
			break;
		end
	end
end)

-- Récupération de la liste des joueurs avec Bracelets.
RegisterNetEvent('esx_braceletgps:srv_updateliste')
AddEventHandler('esx_braceletgps:srv_updateliste', function()
	local sPlayer	= ESX.GetPlayerFromId(source);
	TriggerClientEvent('esx_braceletgps:majbracelets', sPlayer.source, Porteur);
end)

ESX.RegisterUsableItem('braceletgps', function(source)
	local xPlayer = ESX.GetPlayerFromId(source);
	local data = {};
	
	data.message = "ALERTE BRACELET GPS";
	-- Envoi du message à tous les metiers autorisés.
	for _,v in ipairs(Config.metiers) do
		data.number = v;
		TriggerClientEvent('esx_addons_gcphone:call', source, data);
	end
	TriggerEvent('Fouinette_srv:logs', 'Envoi alerte Breacelt GPS par '.. tostring(xPlayer.identifier));
	AlerteDiscord("Utilisation du Bracelet GPS par " .. xPlayer.getName());
end)