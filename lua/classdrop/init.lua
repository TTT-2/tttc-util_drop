-- server
include("classdrop/server/functions.lua")

DROPCLASSENTS = {}
    
hook.Add("TTTCDropClass", "TTTCClassDropAddon", function(ply)
    DropCustomClass(ply)
end)

hook.Add("TTTCUpdateClass", "TTTCClassDropAddonPost", function(ply, old, new)
    if not ply:HasWeapon("weapon_ttt_classdrop") and new then
        ply:Give("weapon_ttt_classdrop")
    end
end)

hook.Add("TTTCPlayerRespawnedWithClass", "TTTCGiveClassDropperOnSpawn", function(ply)
    if not ply:HasWeapon("weapon_ttt_classdrop") then
        ply:Give("weapon_ttt_classdrop")
    end
end)

hook.Add("TTTPrepareRound", "TTTCDropClassPrepare", function()
    for _, e in ipairs(DROPCLASSENTS) do
        SafeRemoveEntity(e)
    end
    
    DROPCLASSENTS = {}
end)

hook.Add("TTTEndRound", "TTTCDropClassPrepare", function()
    for _, v in pairs(player.GetAll()) do
        if v:HasWeapon("weapon_ttt_classdrop") then 
            v:StripWeapon("weapon_ttt_classdrop")
        end
    end

    for _, e in ipairs(DROPCLASSENTS) do
        SafeRemoveEntity(e)
    end
    
    DROPCLASSENTS = {}
end)

hook.Add("PlayerCanPickupWeapon", "TTTCPickupClassDropper", function(ply, wep)
    if ply:HasCustomClass() then
        local wepClass = wep:GetClass()
    
        if wepClass == "weapon_ttt_classdrop" and not ply:HasWeapon(wepClass) then
            return true
        end
    end
end)
