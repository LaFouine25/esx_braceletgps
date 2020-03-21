--================================
-- Développé par Fouinette
-- Pour le projet MyCitY RP
--================================
montrerBlips	= false;
autorise		= false;
listebracelets	= {};
PlayerLoaded	= false;
ESX				= nil;

-- Initialisation du FrameWork ESX.
function initESX()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10);
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100);
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
	ESX.PlayerData = xPlayer
	PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
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
			if ESX.PlayerData.job.name == v then
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
					if v.job.name == ESX.PlayerData.job.name then
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
	local monPED	= GetPlayerPed(-1);
	while true do
		Citizen.Wait(10);
		if autorise then
			for _,i in ipairs(GetActivePlayers()) do
				ped	= GetPlayerPed(i);
				if NetworkIsPlayerActive(i) and estEquipe(i) then
					blip	= GetBlipFromEntity(ped);
					if montrerBlips then
						if not DoesBlipExist(blip) then
							blip = AddBlipForEntity(ped);
							SetBlipSprite(blip, 1);
							if estLSPD(i) == 1 then
								SetBlipColour(blip, 3);
							elseif estLSPD(i) == 2 then
								SetBlipColour(blip, 2);
							else
								SetBlipColour(blip, 1);
							end
							Citizen.InvokeNative(0x5FBCA48327B914DF, blip, true);
						end
					else
						RemoveBlip(blip);
					end
				else
					blip = GetBlipFromEntity(ped);
					RemoveBlip(blip);
				end
			end
		else
			Citizen.Wait(500);
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
		ESX.ShowAdvancedNotification(Config.nottitre, Config.notsujet, Config.notmess2, Config.notpict, 1)
	end
end)

-- Commande /bracelets pour des/activer l'affichage des Blips
RegisterCommand("bracelets", function(source, args, raw) --change command here
    TriggerEvent("esx_braceletgps:acitvergps")
end, false) --False, allow everyone to run it
