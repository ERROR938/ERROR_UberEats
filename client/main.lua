local commande = {}

local eUberEats = {}

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

eUberEats.Base = {

    Header = {"commonmenu", "interaction_bgd"},
    Color = {color_Green},
    HeaderColor = {255, 255, 255},
    Title = 'Uber Eats'

}

eUberEats.Data = {
    currentMenu = "interactions"
}

eUberEats.Events = {

    onSelected = function(self, _, btn, PMenu, menuData, currentButton, currentBtn, currentSlt, result, slide)

        if _.currentMenu == "informations" then

            if btn.name == "~b~Voir la position" then

                SetNewWaypoint(btn.position.x, btn.position.y)

            end

            if btn.name == "~g~Prendre la course" then

                TriggerServerEvent("error:editCurse", btn.id)

            end

            if btn.name == "~r~Supprimer la course" then 

                TriggerServerEvent("error:deleteCourse", btn.id)

                self:OpenMenu("interactions")

            end

        end

        if _.currentMenu == "liste des ~b~courses" then

            if not string.find(btn.name, "Aucune") then

                if not eUberEats.Menu["informations"].b[1] then

                    table.insert(eUberEats.Menu["informations"].b, {
                        name = "~b~Numéro de la personne : ~s~" .. btn.num,
                        ask = "→",
                        askX = true
                    })
                    table.insert(eUberEats.Menu["informations"].b, {
                        name = "~b~Details ~s~: " .. btn.cmd,
                        ask = "→",
                        askX = true
                    })
                    table.insert(eUberEats.Menu["informations"].b, {
                        name = "~b~Voir la position",
                        ask = "→",
                        askX = true,
                        position = btn.pos
                    })
                    table.insert(eUberEats.Menu["informations"].b, {
                        name = "~g~Prendre la course",
                        ask = "→",
                        askX = true,
                        id = btn.id
                    })
                    table.insert(eUberEats.Menu["informations"].b, {
                        name = "~r~Supprimer la course",
                        ask = "→",
                        askX = true
                    })

                end

                self:OpenMenu("informations")

            end

        end

        if btn.name == "Annonce ~g~Ouverture" then

            TriggerServerEvent("error:annonces", "~g~Ouvert")

        elseif btn.name == "Annonce ~r~Fermeture" then

            TriggerServerEvent("error:annonces", "~r~Fermer")

        end

        if btn.name == "Faire une ~b~facture" then

            local player, distance = ESX.Game.GetClosestPlayer()

            if distance ~= -1 and distance <= 3.0 then

                local nb = KeyboardInput("Montant", "", 9)

                if nb == "" then
                    return
                end

                TriggerServerEvent("esx_billing:sendBill", GetPlayerServerId(player), "society_ubere",
                    ESX.PlayerData.job.label, tonumber(nb))

            else

                ESX.ShowNotification('~r~Personne autour')

            end

        end

    end

}

eUberEats.Menu = {

    ['interactions'] = {

        b = {{
            name = "Annonces",
            ask = "→",
            askX = true
        }, {
            name = "Faire une ~b~facture",
            ask = "→",
            askX = true
        }, {
            name = "Liste des ~b~courses",
            ask = "→",
            askX = true
        }}

    },

    ['annonces'] = {

        b = {{
            name = "Annonce ~g~Ouverture",
            ask = "→",
            askX = true
        }, {
            name = "Annonce ~r~Fermeture",
            ask = "→",
            askX = true
        }}

    },

    ['liste des ~b~courses'] = {

        b = getAllCourses

    },

    ['informations'] = {

        b = {}

    }

}

keyRegister("ubere", "Meu Travail Uber Eats", "F6", function()

    if ESX.PlayerData.job and ESX.PlayerData.job.name == "ubere" then 

        CreateMenu(eUberEats)

    end

end)

RegisterCommand("ubereats", function()

    ESX.TriggerServerCallback("error:getClientCourse", function(cb)

        if cb then 

            local cmd = KeyboardInput("La commande", "", 500)

            local num = KeyboardInput("Votre numéro de téléphone", "", 10)
        
            local pos = GetEntityCoords(PlayerPedId())
        
            TriggerServerEvent("error:CreateCourse", GetPlayerServerId(PlayerId()) , cmd, num, pos)

            return
        end

        ESX.ShowNotification("~r~Vous avez dèja une course en cours")
        
    end, GetPlayerServerId(PlayerId()))

end, false)