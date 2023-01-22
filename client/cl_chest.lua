local chest = {}

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

local function getAllChest()

    local all_items = {}

    ESX.TriggerServerCallback("error:getSocietyChest", function(inv)

        if inv[1] then

            all_items = {

                {name = "Ajouter un ~b~item", ask = "→", askX = true},
                {name = "\t\t\t   -------------------", ask = "→", askX = true},
        
            }

            for _,v in pairs(inv) do

                if v.count >= 1 then

                    all_items[#all_items+1] = {

                        name = "[+~r~"..v.count.."~s~] "..v.label,
                        ask = "→",
                        askX = true,
                        item = v.name,
                        nb = v.count

                    }

                end

            end

        else

            all_items = {

                {name = "Ajouter un ~b~item", ask = "→", askX = true},
                {name = "\t\t\t   -------------------", ask = "→", askX = true},
        
            }

        end
        
    end, ESX.PlayerData.job.name)

    while #all_items == 0 do Wait(0) end

    return all_items

end

local function getPlayerInventory()
    
    local all_data = {}

    ESX.PlayerData = ESX.GetPlayerData()

    for i = 1, #ESX.PlayerData.inventory do

        if ESX.PlayerData.inventory[i].count >= 1 then

            all_data[#all_data+1] = {

                name = ESX.PlayerData.inventory[i].label.." (x"..ESX.PlayerData.inventory[i].count..")",
                ask = "→",
                askX = true,
                item = ESX.PlayerData.inventory[i].name,
                nb = ESX.PlayerData.inventory[i].count

            }

        end

    end
    
    return all_data

end

chest.Base = {

    Header = {"commonmenu", "interaction_bgd"},
    Color = {color_Green},
    HeaderColor = {255, 255, 255},
    Title = 'Coffre Uber Eats'

}

chest.Data = {currentMenu = "interactions"}

chest.Events = {

    onSelected = function(self, _, btn, PMenu, menuData, currentButton, currentBtn, currentSlt, result, slide)
        
        if btn.name == "Ajouter un ~b~item" then 

            self:OpenMenu("deposit")

        end

        if _.currentMenu == "deposit" then

            if string.find(btn.name, "x") then

                local amount = KeyboardInput("Combien ?", "", 10)

                if amount == "" then return end

                if tonumber(amount) > btn.nb then 

                    ESX.ShowNotification("Vous n'avez pas assez de cette item")

                else

                    TriggerServerEvent("error:depositItem", btn.item, tonumber(amount))

                    Back()

                end

            end

        end

        if _.currentMenu == "interactions" then

            if PMenu > 2 then

                print(btn.nb)

                local amount = KeyboardInput("Combien ?", "", 10)

                if amount == "" then return end

                if tonumber(amount) > btn.nb then 

                    ESX.ShowNotification("L'entreprise n'a pas assez de cette item")

                else

                    TriggerServerEvent("error:withdrawItem", btn.item, tonumber(amount))

                    CloseMenu()

                end

            end

        end

    end

}

chest.Menu = {

    ['interactions'] = {

        b = getAllChest

    },

    ['deposit'] = {

        b = getPlayerInventory

    }

}

CreateThread(function()

    local pos, dst

    local wait = 1000

    local coord = vector3(Config.pos['coffre'].x, Config.pos['coffre'].y, Config.pos['coffre'].z)

    while (function()
    
        wait = 1000

        if ESX.PlayerData.job and ESX.PlayerData.job.name ~= "ubere" then return true end

        pos = GetEntityCoords(PlayerPedId())

        dst = #(pos - coord)

        if dst > 2 then return true end

        wait = 0

        ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour acceder au ~b~coffre")

        if IsControlJustPressed(0, 51) then 

            CreateMenu(chest)

        end

        return true
    
    end) () do 

        Wait(wait)

    end

end)