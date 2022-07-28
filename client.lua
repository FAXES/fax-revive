--------------------------------
--- RP Revive, Made by FAXES ---
--------------------------------

--- Config ---

local reviveTimer = 10 -- Change the amount of time to wait before allowing revive (in seconds)
local respawnTimer = 5 -- Change the amount of time to wait before allowing revive (in seconds)
local reviveColor = "~y~" -- Color used for revive button
local respawnColor = "~r~" -- Color used for respawn button
local chatColor = "~b~" -- The chat color overall
-- Add/remove spawn points at line 77

--- Code ---
timerCount1 = reviveTimer
timerCount2 = respawnTimer
isDead = false
cHavePerms = false

AddEventHandler('playerSpawned', function()
    local src = source
    TriggerServerEvent("RPRevive:CheckPermission", src)
end)

RegisterNetEvent("RPRevive:CheckPermission:Return")
AddEventHandler("RPRevive:CheckPermission:Return", function(havePerms)
	cHavePerms = havePerms
end)

-- Turn off automatic respawn here instead of updating FiveM file.
AddEventHandler('onClientMapStart', function()
	Citizen.Trace("RPRevive: Disabling the autospawn.")
	exports.spawnmanager:spawnPlayer() -- Ensure player spawns into server.
	Citizen.Wait(2500)
	exports.spawnmanager:setAutoSpawn(false)
	Citizen.Trace("RPRevive: Autospawn is disabled.")
end)

function respawnPed(ped, coords)
	isDead = false
	timerCount1 = reviveTimer
	timerCount2 = respawnTimer
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.heading, true, false) 
	SetPlayerInvincible(ped, false) 
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z, coords.heading)
	ClearPedBloodDamage(ped)
end

function revivePed(ped)
	isDead = false
	timerCount1 = reviveTimer
	timerCount2 = respawnTimer
	local playerPos = GetEntityCoords(ped, true)
	NetworkResurrectLocalPlayer(playerPos, true, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)
end

function ShowInfoRevive(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentSubstringPlayerName(text)
	DrawNotification(true, true)
end

Citizen.CreateThread(function()
	local spawnPoints = {}

	function createSpawnPoint(x, y, z, heading)
		local newObject = {
			x = x,
			y = y,
			z = z,
			heading = heading
		}

		table.insert(spawnPoints, newObject)
	end

	createSpawnPoint(1828.44, 3692.32, 34.22, 37.12) -- Back of Sandy Shores Hospital

	ShowInfoRevive(chatColor .. 'You are dead. Use ' .. reviveColor .. 'E ' .. chatColor ..'to revive or ' .. respawnColor .. 'R ' .. chatColor .. 'to respawn.')
    while true do
    	Citizen.Wait(0)
		ped = GetPlayerPed(-1)
        if IsEntityDead(ped) then
			isDead = true
            SetPlayerInvincible(ped, true)
            SetEntityHealth(ped, 1)
            if IsControlJustReleased(0, 38) and GetLastInputMethod(0) then
                if timerCount1 == 0 or cHavePerms then
                    revivePed(ped)
				else
					TriggerEvent('chat:addMessage', {args = {'^1^*Wait ' .. timerCount1 .. ' more seconds before reviving'}})
                end	
            elseif IsControlJustReleased(0, 45) and GetLastInputMethod(0) then
                if timerCount2 == 0 or cHavePerms then
					local coords = spawnPoints[math.random(1,#spawnPoints)]
					respawnPed(ped, coords)
				else
					TriggerEvent('chat:addMessage', {args = {'^1^*Wait ' .. timerCount2 .. ' more seconds before respawning'}})
				end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if isDead then
			if timerCount1 ~= 0 then
				timerCount1 = timerCount1 - 1
			end

			if timerCount2 ~= 0 then
				timerCount2 = timerCount2 - 1
			end
        end
        Citizen.Wait(1000)          
    end
end)
