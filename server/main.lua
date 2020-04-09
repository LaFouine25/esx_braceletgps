--================================
-- Développé par Fouinette
-- Pour le projet MyCitY RP
--================================
ESX		= nil;
Porteur	= {};

-- Initialisation du FrameWork
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
	while true do
		local xPlayers	= ESX.GetPlayers();
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
		Citizen.Wait(30000);
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
	
end)