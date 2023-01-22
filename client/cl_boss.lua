local boss = {}

ESX = nil
playerData = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
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

local function getSocietyMoneyAction()

    local society_money = ""

    ESX.TriggerServerCallback("esx_society:getSocietyMoney", function(money)

        society_money = money

    end, "ubere")

    while society_money == "" do
        Wait(0)
    end

    return {{
        name = "Argent Societé : " .. society_money .. "$",
        ask = "→",
        askX = true
    }, {
        name = "Retirer ~b~argent",
        ask = "→",
        askX = true
    }, {
        name = "Deposer ~b~argent",
        ask = "→",
        askX = true
    }}

end

local function getSocietyEmployes()

    local employe = {}

    ESX.TriggerServerCallback("esx_society:getEmployees", function(employee)

        for _, v in pairs(employee) do

            employe[#employe + 1] = {

                name = v.name,
                ask = v.job.grade_label,
                askX = true

            }

        end

    end, "ubere")

    while #employe == 0 do
        Wait(0)
    end

    return employe

end

boss.Base = {

    Header = {"commonmenu", "interaction_bgd"},
    Color = {color_Green},
    HeaderColor = {255, 255, 255},
    Title = 'Patron Uber Eats'

}

boss.Data = {
    currentMenu = "interactions"
}

boss.Events = {

    onSelected = function(self, _, btn, PMenu, menuData, currentButton, currentBtn, currentSlt, result, slide)

        if string.find(btn.name, "Retirer") then

            local amount = KeyboardInput("Montant du retrait", "", 9)

            if amount == "" then
                return
            end

            TriggerServerEvent("esx_society:withdrawMoney", "ubere", tonumber(amount))

            Back()

        end

        if string.find(btn.name, "Deposer") then

            local amount = KeyboardInput("Montant du depot", "", 9)

            if amount == "" then
                return
            end

            TriggerServerEvent("esx_society:depositMoney", "ubere", tonumber(amount))

            Back()

        end

        if string.find(btn.name, "Promouvoir") then

            local player, distance = ESX.Game.GetClosestPlayer()

            if distance ~= -1 and distance <= 3.0 then

                TriggerServerEvent("error:promote", GetPlayerServerId(player))

            else

                ESX.ShowNotification("~r~Personne autour")

            end

        end

        if string.find(btn.name, "Recruter") then

            local player, distance = ESX.Game.GetClosestPlayer()

            if distance ~= -1 and distance <= 3.0 then

                TriggerServerEvent("error:recruit", GetPlayerServerId(player))

            else

                ESX.ShowNotification("~r~Personne autour")

            end

        end

        if string.find(btn.name, "Rétrograder") then

            local player, distance = ESX.Game.GetClosestPlayer()

            if distance ~= -1 and distance <= 3.0 then

                TriggerServerEvent("error:downgrade", GetPlayerServerId(player))

            else

                ESX.ShowNotification("~r~Personne autour")

            end

        end

        if string.find(btn.name, "virer") then

            local player, distance = ESX.Game.GetClosestPlayer()

            if distance ~= -1 and distance <= 3.0 then

                TriggerServerEvent("error:fire", GetPlayerServerId(player))

            else

                ESX.ShowNotification("~r~Personne autour")

            end

        end

    end

}

boss.Menu = {

    ['interactions'] = {

        b = {{
            name = "Gestion ~b~argent",
            ask = "→",
            askX = true
        }, {

            name = "Liste des ~b~employés",
            ask = "→",
            askX = true

        }, {

            name = "Action citoyen ~b~proche",
            ask = "→",
            askX = true

        }}

    },

    ['gestion ~b~argent'] = {

        b = getSocietyMoneyAction

    },

    ["liste des ~b~employés"] = {

        b = getSocietyEmployes

    },

    ['action citoyen ~b~proche'] = {

        b = {{
            name = "~g~Promouvoir",
            ask = "→",
            askX = true
        }, {
            name = "~b~Recruter",
            ask = "→",
            askX = true
        }, {
            name = "~r~Rétrograder",
            ask = "→",
            askX = true
        }, {
            name = "~r~Virer",
            ask = "→",
            askX = true
        }}

    }

}

CreateThread(function()

    local pos, dst

    local wait = 1000

    local coord = vector3(Config.pos['boss'].x, Config.pos['boss'].y, Config.pos['boss'].z)

    while (function()

        wait = 1000

        if ESX.PlayerData.job and ESX.PlayerData.job.name == "ubere" and ESX.PlayerData.job.grade_name == "boss" then

            pos = GetEntityCoords(PlayerPedId())

            dst = #(pos - coord)

            if dst > 2 then
                return true
            end

            wait = 0

            ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour acceder au ~b~boss")

            if IsControlJustPressed(0, 51) then

                CreateMenu(boss)

            end

        end

        return true

    end)() do

        Wait(wait)

    end

end)
