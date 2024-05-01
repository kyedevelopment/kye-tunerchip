
local DriftMode,DriftModex,CarMode,RainbowHeadlights,Mode,Neona,Neonb,Neonc,Neond,myVehicle,RainbowNeon = false,false,nil,false, {},true,true,true,true,nil,false
local colorp = {
    [1] = "rgb(255, 255, 255)", -- beyaz
    [2] = "rgb(255, 0, 0)", -- kırmızı
    [3] = "rgb(0, 255, 0)", -- yeşil
    [4] = "rgb(0, 0, 255)", -- mavi
    [5] = "rgb(255, 255, 0)", -- sarı
    [6] = "rgb(255, 0, 255)", -- mor
    [7] = "rgb(0, 255, 255)", -- turkuaz
    [8] = "rgb(128, 128, 128)", -- gri
    [9] = "rgb(255, 165, 0)", -- turuncu
    [10] = "rgb(255, 192, 203)", -- pembe
    [11] = "rgb(255, 99, 71)", -- mercan
    [12] = "rgb(255, 228, 181)", -- sarımsı beyaz
    [13] = "rgb(70, 130, 180)" -- çelik mavisi
  }

RegisterNetEvent("kye:openChip")
AddEventHandler("kye:openChip", function ()
    if IsPedSittingInAnyVehicle(PlayerPedId()) then
        OpenMenu()    
    else
        notify(Config.Lang.NoVehicle)
    end
end)

function OpenMenu()
    if Config.Sound then 
    PlaySoundFrontend(-1, 'CHECKPOINT_NORMAL', 'HUD_MINI_GAME_SOUNDSET', false)
    end
    SetNuiFocus(1, 1)
    SendNUIMessage({
        action = "openChip"
    })
end

RegisterNUICallback("close", function ()
    if Config.Sound then 
    PlaySoundFrontend(-1, 'CHECKPOINT_NORMAL', 'HUD_MINI_GAME_SOUNDSET', false)
    end
    SetNuiFocus(0, 0)
end)

RegisterNUICallback("Mode", function (data)
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    CarMode = data.i
    notify(Config.Lang.ChangeMode .."".. CarMode)
    if Config.Sound then 
    PlaySoundFrontend(-1, 'CHECKPOINT_NORMAL', 'HUD_MINI_GAME_SOUNDSET', false)
    end
    if CarMode == "Comfort" then 
        data = {
            boost = 1,
            drivetrain = 3,
            breaking = 4 ,
            gearchange = 4 , 
            acceleration = 4
        }
        setVehData(vehicle, data)
    elseif CarMode == "Drift" then 
        data = {
            boost = 1 ,
            drivetrain = 1,
            breaking = 3 ,
            gearchange = 1 , 
            acceleration = 1
        }
        myVehicle = vehicle
        setVehData(vehicle, data)
    elseif CarMode == "Sport" then 
        data = {
            boost = 5 ,
            drivetrain = 5,
            breaking = 5 ,
            gearchange = 5 , 
            acceleration = 5
        }
        setVehData(vehicle, data)
    end
end)

RegisterNUICallback("Sound", function ()
    if Config.Sound then 
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end
end)


Citizen.CreateThread( function()
	while true do
        local vehicle = GetVehiclePedIsIn(PlayerPedId())
        local carSpeed = GetEntitySpeed(vehicle)
        if IsPedSittingInAnyVehicle(PlayerPedId()) and CarMode == "Drift" and GetVehiclePedIsUsing(PlayerPedId()) == myVehicle then
            if IsControlPressed(1, 21) then
                if DriftMode then
                    DriftMode = false
                    maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
                    SetEntityMaxSpeed(vehicle, maxSpeed)
                    SetVehicleReduceGrip(vehicle, false)
                    notify(Config.Lang.DriftOff)
                Citizen.Wait(500)
                else 
                    DriftMode = true
                    if carSpeed > 5 and carSpeed < 75 then
                        SetEntityMaxSpeed(vehicle, carSpeed) 
                        SetVehicleReduceGrip(vehicle, true)
                        notify(Config.Lang.DriftOn)
                        Citizen.Wait(500)
                    else 
                        notify(Config.Lang.NoDrift)
                        Citizen.Wait(500)
                    end
                end
            end
        else
            Citizen.Wait(1500)
        end
        Citizen.Wait(25)
    end
end)

function setVehData(veh,data)
    local multp = Config.MultP
    if tonumber(data.drivetrain) == 2 then dTrain = 0.5 elseif tonumber(data.drivetrain) == 3 then dTrain = 1.0 end
    if not DoesEntityExist(veh) or not data then return nil end
    SetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDriveForce", data.boost * multp)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveInertia", data.acceleration * multp)
    SetVehicleEnginePowerMultiplier(veh, data.gearchange * multp)
    LastEngineMultiplier = data.gearchange * multp
    SetVehicleHandlingFloat(veh, "CHandlingData", "fBrakeBiasFront", data.breaking * multp)
end

function resetVeh(veh,t)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDriveForce", 1.0)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveInertia", 1.0)
    SetVehicleEnginePowerMultiplier(veh, 1.0)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveBiasFront", 0.5)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fBrakeBiasFront", 1.0)
    if t then
        DriftMode,DriftModex,CarMode,RainbowHeadlights,Mode,Neona,Neonb,Neonc,Neond,myVehicle,RainbowNeon = false,false,nil,false, {},true,true,true,true,nil,false
    end
end

RegisterNUICallback("ChangeColor", function (data)
    typec = data.type 
    colorc = data.color 
    local veh = GetVehiclePedIsUsing(PlayerPedId())
    if Config.Sound then 
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
        end
    if typec == "HeadLights" then 
        notify(Config.Lang.ColorChange .."".. colorc)
            if colorc == "Yellow" then 
                RainbowHeadlights = false
                ToggleVehicleMod(veh, 22, true)
                SetVehicleHeadlightsColour(veh, 5)
            elseif colorc == "Green" then 
                RainbowHeadlights = false
                ToggleVehicleMod(veh, 22, true)
                SetVehicleHeadlightsColour(veh, 4)
            elseif colorc == "LightBlue" then
                RainbowHeadlights = false
                ToggleVehicleMod(veh, 22, true)
                SetVehicleHeadlightsColour(veh, 2)
            elseif colorc == "Blue" then
                RainbowHeadlights = false
                ToggleVehicleMod(veh, 22, true)
                SetVehicleHeadlightsColour(veh, 1)
            elseif colorc == "Purple" then
                RainbowHeadlights = false 
                ToggleVehicleMod(veh, 22, true)
                SetVehicleHeadlightsColour(veh, 12)
            elseif colorc == "Pink" then 
                RainbowHeadlights = false
                ToggleVehicleMod(veh, 22, true)
                SetVehicleHeadlightsColour(veh, 10 )
            elseif colorc == "Default" then 
                RainbowHeadlights = false
                SetVehicleHeadlightsColour(veh, -1)
            elseif colorc == "Rainbow" then
                myVehicle = veh
                if RainbowHeadlights then 
                    RainbowHeadlights = false
                else 
                    RainbowHeadlights = true
                end
        end
    elseif typec == "Neon" then 
        if colorc == "Yellow" then 
            SetVehicleNeonLightsColour(veh,250,200,250,0)
        elseif colorc == "Green" then 
            SetVehicleNeonLightsColour(veh,250,200,250,0)
        elseif colorc == "LightBlue" then
            SetVehicleNeonLightsColour(veh,250,200,250,0)
        elseif colorc == "Blue" then
            SetVehicleNeonLightsColour(veh,250,200,250,0)
        elseif colorc == "Purple" then 
            SetVehicleNeonLightsColour(veh,250,200,250,0)
        elseif colorc == "Pink" then 
            SetVehicleNeonLightsColour(veh,250,200,250,0)
        elseif colorc == "Rgb" then 
            SetVehicleNeonLightsColour(veh,data.r,data.g,data.b,0)
        elseif colorc == "Rainbow" then
            myVehicle = veh
            if RainbowHeadlights then 
                RainbowHeadlights = false
            else 
                RainbowHeadlights = true
            end
        end
    end
end)


Citizen.CreateThread(function()
    local colorNumber = 1
    while true do
        Citizen.Wait(200)
        
        if GetPedInVehicleSeat(myVehicle, -1) == PlayerPedId() and IsPedInAnyVehicle(PlayerPedId(), false)  and RainbowNeon then

                colorNumber = colorNumber + 1
                if colorNumber == 13 then
                    colorNumber = 1
                end
                SetVehicleNeonLightsColour(myVehicle , rgbToColor(colorp[colorNumber]).r,rgbToColor(colorp[colorNumber]).g,rgbToColor(colorp[colorNumber]).b)
            else 
                Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    local colorNumber = -1
    while true do
        Citizen.Wait(200)
    
        if GetPedInVehicleSeat(myVehicle, -1) == PlayerPedId() and IsPedInAnyVehicle(PlayerPedId(), false)  and RainbowHeadlights then
                ToggleVehicleMod(myVehicle, 22, true)
                colorNumber = colorNumber + 1
                if colorNumber == 13 then
                    colorNumber = -1
                end
                SetVehicleHeadlightsColour(myVehicle , colorNumber)
            else 
                Citizen.Wait(500)
        end
    end
end)


RegisterNUICallback("ChangeNeon", function (data)
    local vehicle = GetVehiclePedIsUsing( PlayerPedId() )
    selectneon = data.neon
    notify(Config.Lang.NeonOnOfF)
    if Config.Sound then 
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
        end
    if selectneon == "neon1" then 
        if Neona then 
            Neona = false 
            SetVehicleNeonLightEnabled(vehicle,0, true)
        else 
            Neona = true 
            SetVehicleNeonLightEnabled(vehicle, 0, false)
        end
    elseif selectneon == "neon2" then
        if Neonb then 
            Neonb = false 
            SetVehicleNeonLightEnabled(vehicle, 1, true)
        else 
            Neonb = true 
            SetVehicleNeonLightEnabled(vehicle, 1, false)
        end
    elseif selectneon == "neon3" then 
        if Neonc then 
            Neonc = false 
            SetVehicleNeonLightEnabled(vehicle, 2, true)
        else 
            Neonc = true 
            SetVehicleNeonLightEnabled(vehicle, 2, false)
        end
    elseif selectneon == "neon4" then
        if Neond then 
            Neond = false 
            SetVehicleNeonLightEnabled(vehicle, 3, true)
        else 
            Neond = true 
            SetVehicleNeonLightEnabled(vehicle, 3, false)
        end
    elseif selectneon == "Rainbow" then 
        local vehicle = GetVehiclePedIsUsing( PlayerPedId() )   
        myVehicle = vehicle
        if RainbowNeon then 
            RainbowNeon = false
        else 
            RainbowNeon = true
        end
    end
end)


RegisterNUICallback("ChangeLightColor", function (data)
    color = rgbToColor(data.color)
    local vehicle = GetVehiclePedIsUsing( PlayerPedId() )
    SetVehicleNeonLightsColour(vehicle, color.r ,color.g, color.b)
    notify(Config.Lang.ColorComplect)
    if Config.Sound then 
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
        end
end)

RegisterNUICallback("ChangeLightColorrgb", function (data)
    r = tonumber(data.r)
    g = tonumber(data.g)
    b = tonumber(data.b)
    local vehicle = GetVehiclePedIsUsing( PlayerPedId() )                                                                                                                                                                                                                       
    SetVehicleNeonLightsColour(vehicle, r ,g, b)
    notify(Config.Lang.ColorComplect)
end)

RegisterNUICallback("DetailChange", function (data)
    i = data.i 
    local vehicle = GetVehiclePedIsUsing( PlayerPedId() )   
    if Config.Sound then 
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
        end
    if i == "boost-l" then
        data = {
            boost = 1
        }
        setVehDatax(vehicle,data,"boost")
    elseif i == "boost-m" then
        data = {
            boost = 2
        }
        setVehDatax(vehicle,data,"boost")
    elseif i == "boost-h" then 
        data = {
            boost = 3
        }
        setVehDatax(vehicle,data,"boost")
    elseif i == "boost-v" then
        data = {
            boost = 4
        }
        setVehDatax(vehicle,data,"boost")
    elseif i == "boost-e" then  
        data = {
            boost = 5
        }
        setVehDatax(vehicle,data,"boost")
    elseif i == "acceleration-l" then
        data = {
            acceleration = 1
        }
        setVehDatax(vehicle,data,"acceleration")
    elseif i == "acceleration-m" then
        data = {
            acceleration = 2
        }
        setVehDatax(vehicle,data,"acceleration")
    elseif i == "acceleration-h" then
        data = {
            acceleration = 3
        }
        setVehDatax(vehicle,data,"acceleration") 
    elseif i == "acceleration-v" then
        data = {
            acceleration = 4
        }
        setVehDatax(vehicle,data,"acceleration")
    elseif i == "acceleration-e" then
        data = {
            acceleration = 5
        }
        setVehDatax(vehicle,data,"acceleration")  
    elseif i == "gear-l" then
        data = {
            gear = 1
        }
        setVehDatax(vehicle,data,"gear")
    elseif i == "gear-m" then
        data = {
            gear = 2
        }
        setVehDatax(vehicle,data,"gear")
    elseif i == "gear-h" then
        data = {
            gear = 3
        }
        setVehDatax(vehicle,data,"gear") 
    elseif i == "gear-v" then
        data = {
            gear = 4
        }
        setVehDatax(vehicle,data,"gear")
    elseif i == "gear-e" then
        data = {
            gear = 5
        }
        setVehDatax(vehicle,data,"gear")  
    elseif i == "breaking-l" then
        data = {
            breaking = 1
        }
        setVehDatax(vehicle,data,"breaking")
    elseif i == "breaking-m" then
        data = {
            breaking = 2
        }
        setVehDatax(vehicle,data,"breaking")
    elseif i == "breaking-h" then
        data = {
            breaking = 3
        }
        setVehDatax(vehicle,data,"breaking") 
    elseif i == "breaking-v" then
        data = {
            breaking = 4
        }
        setVehDatax(vehicle,data,"breaking")
    elseif i == "breaking-e" then 
        data = {
            breaking = 5
        }
        setVehDatax(vehicle,data,"breaking") 
    elseif i == "drivetrain-l" then
        data = {
            drivetrain = 1
        }
        setVehDatax(vehicle,data,"drivetrain")
    elseif i == "drivetrain-m" then
        data = {
            drivetrain = 2
        }
        setVehDatax(vehicle,data,"drivetrain")
    elseif i == "drivetrain-h" then
        data = {
            drivetrain = 3
        }
        setVehDatax(vehicle,data,"drivetrain") 
    elseif i == "drivetrain-v" then
        data = {
            drivetrain = 4
        }
        setVehDatax(vehicle,data,"drivetrain")
    elseif i == "drivetrain-e" then
        data = {
            drivetrain = 5
        }
        setVehDatax(vehicle,data,"drivetrain")  
    end 
end)

function setVehDatax(veh,data,d)
    local multp = Config.MultP
    if tonumber(data.drivetrain) == 2 then dTrain = 0.5 elseif tonumber(data.drivetrain) == 3 then dTrain = 1.0 end
    if not DoesEntityExist(veh) or not data then return nil end
    if d == "boost" then 
        SetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDriveForce", data.boost * multp)
    elseif d == acceleration then 
        SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveInertia", data.acceleration * multp)
    elseif d == "gearchange" then 
        SetVehicleEnginePowerMultiplier(veh, data.gearchange * multp)
        SetVehicleEnginePowerMultiplier(veh, data.gearchange * multp)
        LastEngineMultiplier = data.gearchange * multp
    elseif d == "breaking" then 
        SetVehicleHandlingFloat(veh, "CHandlingData", "fBrakeBiasFront", data.breaking * multp)
    end
end

RegisterNUICallback("Restart", function ()
    local vehicle = GetVehiclePedIsUsing( PlayerPedId() )   
    resetVeh(vehicle,true)
    notify(Config.Lang.Reset)
end)

function rgbToColor(rgb)
    local r, g, b = rgb:match("(%d+), (%d+), (%d+)")
    return {r = tonumber(r) , g = tonumber(g) , b = tonumber(b) }
  end