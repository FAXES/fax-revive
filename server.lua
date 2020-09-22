--------------------------------
--- RP Revive, Made by FAXES ---
--------------------------------

--- Config ---

local bypassRoles = { -- Discord Role ID(s) that can bypass the revive wait time. Leave this as it is if you don't want this function.
    "DISCORD_ROLE_ID",
}


--- Code ---

RegisterServerEvent("RPRevive:CheckPermission")
AddEventHandler("RPRevive:CheckPermission", function()
    local src = source
    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            identifierDiscord = v
        end
    end

    if identifierDiscord then
        exports['discordroles']:isRolePresent(src, bypassRoles, function(hasRole, roles)
            if not roles then
                TriggerClientEvent("RPRevive:CheckPermission:Return", src, false)
            end
            if hasRole then
                TriggerClientEvent("RPRevive:CheckPermission:Return", src, true)
            else
                TriggerClientEvent("RPRevive:CheckPermission:Return", src, false)
            end
        end)
    else
        TriggerClientEvent("RPRevive:CheckPermission:Return", src, false)
    end
end)