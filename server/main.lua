--================================
-- Développé par Fouinette
-- Pour le projet MyCitY RP
--================================
ESX	= nil;

-- Initialisation du FrameWork
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Récupération de la liste des joueurs avec Bracelets.
RegisterNetEvent('esx_braceletgps:srv_updateliste')
AddEventHandler('esx_braceletgps:srv_updateliste', function()
	local sPlayer	= ESX.GetPlayerFromId(source);
	local xPlayers = ESX.GetPlayers();
	local retour	= {};

	for i=1, #xPlayers, 1 do
	    local xPlayer = ESX.GetPlayerFromId(xPlayers[i]);

	    for k,v in ipairs(Config.items) do
		    if xPlayer.getInventoryItem(v).count > 0 then
			    table.insert(retour, xPlayer);
			    break;
		    end
	    end
	end

	TriggerClientEvent('esx_braceletgps:majbracelets', sPlayer.source, retour);
end)
