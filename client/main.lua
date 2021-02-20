--================================
-- Développé par Fouinette
-- Pour le projet Reborn RP
--================================
montrerBlips	= false;
autorise		= false;
listebracelets	= {};
listeBlips		= {};
PlayerLoaded	= false;
ESX				= nil;

-- Initialisation du FrameWork ESX.
function initESX()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0);
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(0);
	end

	PlayerLoaded	= true;
	ESX.PlayerData	= ESX.GetPlayerData();
end

Citizen.CreateThread(function()
	initESX();
end)

-- Dans le cas d'un changement de boulot
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	while ESX == nil do
		Citizen.Wait(0)
	end
	
	ESX.PlayerData = xPlayer
	PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job)
	ESX.PlayerData.job2 = job
end)

-- Trigger mise à jour liste des joueurs avec bracelets
RegisterNetEvent('esx_braceletgps:majbracelets')
AddEventHandler('esx_braceletgps:majbracelets', function(bracelets)
	listebracelets = bracelets;
end)

-- Boucles de mise à jour
Citizen.CreateThread(function()
	while true do
		if ESX == nil or ESX.PlayerData.job == nil then
			initESX()
		end
		local temp = false;
		for k,v in ipairs(Config.metiers) do
			if (ESX.PlayerData.job.name == v and ESX.PlayerData.job.grade ~= 99) or (ESX.PlayerData.job2.name == v and ESX.PlayerData.job2.grade ~= 99) then
				temp = true;
			end
		end
		if temp then
			autorise = true;
			TriggerServerEvent('esx_braceletgps:srv_updateliste');
		else
			autorise = false;
		end
		Citizen.Wait(120000);
	end
end)

-- Fonction de controle si joueurs est équipé
function estEquipe(id)
	local retour = false;
	
	for k,v in pairs(listebracelets) do
		if GetPlayerServerId(id) == v.source then
			retour = true;
			break;
		end
	end

	return retour;
end

-- Fonction de controle si joueur est LSPD
function estLSPD(id)
	local retour = false;
	for k,v in pairs(listebracelets) do
		if GetPlayerServerId(id) == v.source then
			for w, x in pairs(Config.metiers) do
				if v.job.name == x then
					if v.job.name == ESX.PlayerData.job.name or v.job.name == ESX.PlayerData.job2.name then
						retour = 1;
					else
						retour = 2;
					end
					break;
					break;
				end
			end
		end
	end
	
	return retour;
end

-- Boucle principale d'affichage des blips des bracelets.
Citizen.CreateThread(function()
	-- Boucle Principale.
	while true do
		Citizen.Wait(30000);
		-- Dans tous les cas, on supprime les Blips existants
		for _,blip in pairs(listeBlips) do
			RemoveBlip(blip);
		end
		listeBlips = {};
		
		if autorise then
			for _, coords in pairs(listebracelets) do
				-- On parcour uniquement la liste des joueurs AYANT un bracelet.
				if montrerBlips then
					-- Le joueur souhaite afficher les blips
					-- On fait donc les calculs.
					blip = AddBlipForCoord(coords[1].x, coords[1].y, coords[1].z);
					SetBlipSprite(blip, 1);
					if coords[2] then
						SetBlipColour(blip, 3);
					else
						SetBlipColour(blip, 1); -- Rouge
					end
					Citizen.InvokeNative(0x5FBCA48327B914DF, blip, true);
					table.insert(listeBlips, blip);
				end
			end
		end
	end
end)

-- Différents trigger
RegisterNetEvent('esx_braceletgps:acitvergps');
AddEventHandler('esx_braceletgps:acitvergps', function()
	montrerBlips = not montrerBlips;
	if montrerBlips then
		ESX.ShowAdvancedNotification(Config.nottitre, Config.notsujet, Config.notmess1, Config.notpict, 1);
	else
		ESX.ShowAdvancedNotification(Config.nottitre, Config.notsujet, Config.notmess2, Config.notpict, 1);
	end
end)

RegisterNetEvent('esx_braceletgps:utilisecoupe');
AddEventHandler('esx_braceletgps:utilisecoupe', function()
	local target, distance	= ESX.Game.GetClosestPlayer();
	local xPlayer = GetPlayerServerId(target);
	if target ~= -1 and distance < 3.0 then
		-- On peut couper le bracelet
		TriggerServerEvent('esx_braceletgps:coupebracelet', GetPlayerServerId(target));
		
		for _,v in ipairs(Config.metiers) do
			data.number = v;
			TriggerClientEvent('esx_addons_gcphone:call', xPlayer.source, data);
		end
		xPlayer.removeInventoryItem('braceletgps', 1);
		TriggerEvent('Fouinette_srv:logs', 'Tentative de RETRAIT Bracelet GPS par '.. tostring(xPlayer.identifier));
		AlerteDiscord("Tentative de RETRAIT d'un Bracelet GPS par " .. xPlayer.getName());
	else
		ESX.ShowNotificcation("Il n'y a personne à portée de l'appareil.");
	end
end)

-- Commande /bracelets pour des/activer l'affichage des Blips
RegisterCommand("bracelets", function(source, args, raw) --change command here
    TriggerEvent("esx_braceletgps:acitvergps")
end, false) --False, allow everyone to run it
