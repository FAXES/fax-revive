--------------------------------
--- RP Revive, Made by FAXES ---
--------------------------------

--- Config ---

local bypassRoles = { -- Discord Role ID(s) that can bypass the revive/respawn wait time. Leave this as it is if you don't want this function.
    --"987194867597852724"
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
        local count = 0
        local roleIDs = exports.Badger_Discord_API:GetDiscordRoles(src)
        if not (roleIDs == false) then
            for i = 1, #roleIDs do
                if exports.Badger_Discord_API:CheckEqual(bypassRoles[i][1], roleIDs[j]) and i ~= 1 then
                    TriggerClientEvent("RPRevive:CheckPermission:Return", src, true)
                    count = count + 1
                    break
                end
            end

            if count == 0 then
                TriggerClientEvent("RPRevive:CheckPermission:Return", src, false)
            end
        else
            TriggerClientEvent("RPRevive:CheckPermission:Return", src, false)
        end
    end
end)