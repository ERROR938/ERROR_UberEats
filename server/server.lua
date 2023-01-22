ESX = nil
TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)
TriggerEvent('esx_society:registerSociety', 'ubere', 'Uber Eats', 'society_ubere', 'society_ubere', 'society_ubere', {
    type = 'public'
})

RegisterNetEvent("error:annonces", function(type)

    local xPlayers = ESX.GetPlayers()

    if type == "~g~Ouvert" or type == "~r~Fermer" then

        for i = 1, #xPlayers do

            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

            TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], "Uber Eats", "Annonces",
                "La soceté ~b~Uber Eats~s~ est désormais " .. type, "CHAR_LIFEINVADER")

        end

    end

end)

ESX.RegisterServerCallback("error:getAllCourses", function(source, cb)

    MySQL.Async.fetchAll("SELECT * FROM courses", {}, function(result)

        cb(result)

    end)

end)

RegisterNetEvent("error:CreateCourse", function(id, cmd, num, pos)

    local xTarget = ESX.GetPlayerFromId(id)

    print(id, cmd, num, pos)

    MySQL.Async.execute("INSERT INTO courses (client, playerid, label, num, position) VALUES (@a, @b, @c, @d, @e)", {

        ['@a'] = xTarget.license,
        ['@b'] = id,
        ['@c'] = cmd,
        ['@d'] = num,
        ['@e'] = json.encode(pos)

    })

end)

RegisterNetEvent("error:editCurse", function(client)

    local xTarget = ESX.GetPlayerFromId(client)
    local livreur = ESX.GetPlayerFromId(source)

    xTarget.showNotification("Un livreur à prit votre commande ~b~Uber Eats")

    MySQL.Async.execute("UPDATE courses SET take = @a WHERE playerid = @b", {

        ['@a'] = GetPlayerName(livreur.source),
        ['@b'] = client

    })

    livreur.showNotification("~g~Vous venez de prendre la course")

end)

ESX.RegisterServerCallback("error:getClientCourse", function(source, cb, id)

    MySQL.Async.fetchAll("SELECT * FROM courses WHERE playerid = @a", {
        ['@a'] = id
    }, function(result)

        if result[1] then

            cb(false)

        else

            cb(true)

        end

    end)

end)

RegisterNetEvent("error:deleteCourse", function(id)

    MySQL.Async.execute("DELETE FROM courses WHERE playerid = @a", {

        ['@a'] = id

    })

end)

ESX.RegisterServerCallback("error:getSocietyChest", function(source, cb, society)

    TriggerEvent("esx_addoninventory:getSharedInventory", "society_" .. society, function(inv)

        cb(inv.items)

    end)

end)

RegisterNetEvent("error:depositItem", function(name, cb)

    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerEvent("esx_addoninventory:getSharedInventory", "society_ubere", function(inv)

        xPlayer.removeInventoryItem(name, cb)

        inv.addItem(name, cb)

    end)

end)

RegisterNetEvent("error:withdrawItem", function(name, cb)

    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerEvent("esx_addoninventory:getSharedInventory", "society_ubere", function(inv)

        xPlayer.addInventoryItem(name, cb)

        inv.removeItem(name, cb)

    end)

end)

RegisterNetEvent("error:promote", function(id)

    local target = ESX.GetPlayerFromId(id)

    if target.job.grade <= 3 then

        target.setJob("ubere", target.job.grade + 1)

        xPlayer.showNotification("Vous avez été promu en " .. target.job.grade_label)

    end

end)

RegisterNetEvent("error:recruit", function(id)

    local target = ESX.GetPlayerFromId(id)

    target.setJob("ubere", 0)

    xPlayer.showNotification("Vous avez été recruté dans l'entreprise :  " .. target.job.label)

end)

RegisterNetEvent("error:downgrade", function(id)

    local target = ESX.GetPlayerFromId(id)

    target.setJob("ubere", target.job.grade - 1)

    xPlayer.showNotification("Vous avez rétrograde en :  " .. target.job.grade_label)

end)

RegisterNetEvent("error:fire", function(id)

    local target = ESX.GetPlayerFromId(id)

    target.setJob("unemployed", 0)

    xPlayer.showNotification("Vous avez viré")

end)