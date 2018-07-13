--------------------------------
--- RP Revive, Made by FAXES ---
--------------------------------

local reviveWait = 90 -- Change the amount of time to wait before allowing revive (in seconds) (This feature is not in use yet!)

-- Turn off automatic respawn here instead of updating FiveM file.
AddEventHandler('onClientMapStart', function()
	Citizen.Trace("RPRevive: Disabling le autospawn.")
	exports.spawnmanager:spawnPlayer() -- Ensure player spawns into server.
	Citizen.Wait(2500)
	exports.spawnmanager:setAutoSpawn(false)
	Citizen.Trace("RPRevive: Autospawn is disabled.")
end)

function respawnPed(ped, coords)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.heading, true, false) 

	SetPlayerInvincible(ped, false) 

	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z, coords.heading)
	ClearPedBloodDamage(ped)
end

local allowRespawn = false

Citizen.CreateThread(function()
	local respawnCount = 0
	local spawnPoints = {}
	local playerIndex = NetworkGetPlayerIndex(-1) or 0
	math.randomseed(playerIndex)

	function createSpawnPoint(x1,x2,y1,y2,z,heading)
		local xValue = math.random(x1,x2) + 0.0001
		local yValue = math.random(y1,y2) + 0.0001

		local newObject = {
			x = xValue,
			y = yValue,
			z = z + 0.0001,
			heading = heading + 0.0001
		}
		table.insert(spawnPoints,newObject)
	end

	createSpawnPoint(-448, -448, -340, -329, 35.5, 0) -- Mount Zonah
	createSpawnPoint(372, 375, -596, -594, 30.0, 0)   -- Pillbox Hill
	createSpawnPoint(335, 340, -1400, -1390, 34.0, 0) -- Central Los Santos
	createSpawnPoint(1850, 1854, 3700, 3704, 35.0, 0) -- Sandy Shores
	createSpawnPoint(-247, -245, 6328, 6332, 33.5, 0) -- Paleto
	--createSpawnPoint(1152, 1156, -1525, -1521, 34.9, 0) -- St. Fiacre


    while true do
    Citizen.Wait(0)
		ped = GetPlayerPed(-1)
		if IsEntityDead(ped) then
			-- ShowInfoRevive('~r~You Are Dead ~w~Please wait ~y~'.. tostring(reviveWait) ..' Seconds ~w~ before choosing an action')

            SetPlayerInvincible(ped, true)
            SetEntityHealth(ped, 1)

			ShowInfoRevive('~y~ You Are Dead. ~w~Use ~p~E ~y~ to Revive or ~p~R ~y~to Respawn')

			if ( IsControlJustReleased( 0, 38 ) or IsDisabledControlJustReleased( 0, 38 ) ) and GetLastInputMethod( 0 ) then 
					revivePed(ped)
					
            elseif ( IsControlJustReleased( 0, 45 ) or IsDisabledControlJustReleased( 0, 45 ) ) and GetLastInputMethod( 0 ) then
                local coords = spawnPoints[math.random(1,#spawnPoints)]

				respawnPed(ped, coords)

				allowRespawn = false
				respawnCount = respawnCount + 1
				math.randomseed( playerIndex * respawnCount )
            end
        end
    end
end)

function revivePed(ped)
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