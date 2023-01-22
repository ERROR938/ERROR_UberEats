local garage = {}

ESX = nil
playerData = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	playerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)

    ESX.PlayerData = playerData

end)

RegisterNetEvent("esx:setJob", function(job)

    ESX.PlayerData.job = job

end)

local function getAllVeh()

    local all_veh = {}

    for _,v in pairs(Config.pos['garage'].vehicles) do 

        all_veh[#all_veh+1] = {

            name = v.label,
            ask = "→",
            askX = true,
            model = v.model

        }

    end

    return all_veh

end

garage.Base = {

    Header = {"commonmenu", "interaction_bgd"},
    Color = {color_Green},
    HeaderColor = {255, 255, 255},
    Title = 'Garage Uber Eats'

}

garage.Data = {currentMenu = "interactions"}

garage.Events = {

    onSelected = function(self, _, btn, PMenu, menuData, currentButton, currentBtn, currentSlt, result, slide)
        
        SpawnVehicle(btn.model)

        ESX.ShowAdvancedNotification("Uber Eats", "Garage", "Bonne chance et travail bien !", "CHAR_HUMANDEFAULT")

        CloseMenu()

    end

}

garage.Menu = {

    ['interactions'] = {

        b = getAllVeh

    }

}

CreateThread(function()

    local pos, dst

    local wait = 1000

    local coord = vector3(Config.pos['garage'].sortir.x, Config.pos['garage'].sortir.y, Config.pos['garage'].sortir.z)

    local garagiste = SpawnNpc()

    while (function()
    
    wait = 1000

    if ESX.PlayerData.job and ESX.PlayerData.job.name ~= "ubere" then return true end

        pos = GetEntityCoords(PlayerPedId())

        dst = #(pos - coord)

        if dst > 2 then return true end

        wait = 0

        ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour acceder au ~b~garage")

        if IsControlJustPressed(0, 51) then 

            CreateMenu(garage)

        end

        return true
    
    end) () do 

        Wait(wait)

    end

end)