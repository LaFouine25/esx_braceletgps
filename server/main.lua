--================================
-- Développé par Fouinette
-- Pour le projet Reborn RP
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
					estLSPD = false;
					if xPlayer.job.name == "police" then
						estLSPD = true;
					end
					table.insert(Porteur, {xPlayer.getCoords(false), estLSPD});
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
	local _source	= source;
	local xPlayer	= ESX.GetPlayerFromId(_source);
	if xPlayer ~= nil then
		for i=1, #Porteur, 1 do
			if Porteur[i].identifier == xPlayer.identifier then
				table.remove(Porteur, i);
				break;
			end
		end
	end
end)

-- Récupération de la liste des joueurs avec Bracelets.
RegisterNetEvent('esx_braceletgps:srv_updateliste')
AddEventHandler('esx_braceletgps:srv_updateliste', function()
	local sPlayer	= ESX.GetPlayerFromId(source);
	TriggerClientEvent('esx_braceletgps:majbracelets', sPlayer.source, Porteur);
end)

-- Retrait du bracelet de la cible.
RegisterNetEvent('esx_braceletgps:coupebracelet')
AddEventHandler('esx_braceletgps:coupebracelet', function(target)
	local tPlayer	= ESX.GetPlayerFromId(target);
	local xPlayer	= ESX.GetPlayerFromId(source);
	tPlayer.removeInventoryItem('braceletgps', 1);
	xPlayer.showNotification('Retrait avec succès du Bracelet GPS');
end)

ESX.RegisterUsableItem('braceletgps', function(source)
	local xPlayer	= ESX.GetPlayerFromId(source);
	local data		= {};
	
	if xPlayer ~= nil then
		data.message = "ALERTE BRACELET GPS";
		-- Envoi du message à tous les metiers autorisés.
		for _,v in ipairs(Config.metiers) do
			data.number = v;
			TriggerClientEvent('esx_addons_gcphone:call', xPlayer.source, data);
		end
		TriggerEvent('Fouinette_srv:logs', 'Envoi alerte Breacelet GPS par '.. tostring(xPlayer.identifier));
		AlerteDiscord("Utilisation du Bracelet GPS par " .. xPlayer.getName());
	end
end)

ESX.RegisterUsableItem('braceletgpsdiscret', function(source)
	local xPlayer	= ESX.GetPlayerFromId(source);
	local data		= {};
	
	if xPlayer ~= nil then
		xPlayer.removeInventoryItem('braceletgpsdiscret', 1)

		TriggerClientEvent('cd_playerhud:status:add', source, 'hunger', 1)
		TriggerClientEvent('cd_playerhud:status:remove', source, 'thirst', 5)
		TriggerClientEvent('esx_basicneeds:onEat', source)
		TriggerClientEvent('esx:showNotification', source, '~r~Aaahhh~s~ Je crois que je viens d\'en avaler une de travers !!!')
	end
end)

ESX.RegisterUsableItem('coupebracelet', function(source)
	local xPlayer	= ESX.GetPlayerFromId(source);
	local data		= {};
	
	if xPlayer ~= nil then
		data.message = "RETRAIT DU BRACELET GPS";
		TriggerClientEvent('esx_braceletgps:utilisecoupe', xPlayer.source);
	end
end)