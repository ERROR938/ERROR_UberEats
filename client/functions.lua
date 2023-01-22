function keyRegister(openname, name, key, action)
    RegisterKeyMapping(openname, name, 'keyboard', key)
    RegisterCommand(openname, function()
        if (action ~= nil) then
            action();
        end
    end, false)
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)

    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        if result == "" then
            return
        end
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end

end

function getAllCourses()

    local all_courses = {}

    ESX.TriggerServerCallback("error:getAllCourses", function(cb)

        if cb[1] then

            for _, v in pairs(cb) do

                if v.take == "non" or v.take == GetPlayerName(source) then

                    all_courses[#all_courses + 1] = {

                        name = v.label,
                        ask = "→",
                        askX = true,
                        cmd = v.label,
                        pos = json.decode(v.position),
                        num = v.num,
                        take = v.take,
                        id = v.playerid,
                        playerid = v.playerid

                    }

                end

            end

        else

            all_courses[#all_courses+1] = {

                name = "Aucune Course",
                ask = "→",
                askX = true

            }

        end

    end)

    while #all_courses == 0 do Wait(0) end

    return all_courses

end

function SpawnVehicle(name)

    local pos = Config.pos['garage'].spawnPoint

    local hash = GetHashKey(name)

    RequestModel(hash)

    while not HasModelLoaded(hash) do Wait(0) end

    local veh = CreateVehicle(hash, pos.x, pos.y, pos.z, pos.h, true, false)

    SetVehicleNumberPlateText(veh, "UBEREATS")

end

function SpawnNpc()

    local hash = GetHashKey(Config.pnj)

    RequestModel(hash)

    while not HasModelLoaded(hash) do Wait(0) end

    local ped = CreatePed(6, hash, Config.pos['garage'].sortir.x, Config.pos['garage'].sortir.y, Config.pos['garage'].sortir.z-1, Config.pos['garage'].sortir.h, true, false)

    SetBlockingOfNonTemporaryEvents(ped, true)

    SetEntityInvincible(ped, true)

    FreezeEntityPosition(ped, true)

    return ped

end