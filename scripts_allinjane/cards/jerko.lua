--[[
Jerko
 - +0.25 damage and take fake damage, retriggers 0-10 times at random
]]

local sfx = AllInJane.SFX

local DAMAGE_UP = 0.25
local MAX_TRIGGERS = 10
local TRIGGER_DELAY = 30

---@param player EntityPlayer
local function jerkoEffect(player)
    local data = AllInJane:getData(player)
    data.JERKO_DAMAGE = (data.JERKO_DAMAGE or 0)+DAMAGE_UP
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)

    player:TakeDamage(1, DamageFlag.DAMAGE_FAKE, EntityRef(player), 0)
end

---@param id Card
---@param player EntityPlayer
---@param flags UseFlag
local function useCard(_, id, player, flags)
    jerkoEffect(player)

    local numRetriggers = player:GetCardRNG(id):RandomInt(0, MAX_TRIGGERS)
    if(numRetriggers>0) then
       Isaac.CreateTimer(
            function()
                if(player and player:Exists()) then
                     jerkoEffect(player)
                     sfx:Play(AllInJane.SFX_MULT)
                     player:AnimateCard(id, "UseItem")
                end
            end,
            TRIGGER_DELAY,
            numRetriggers
       )
    end

    sfx:Play(AllInJane.SFX_MULT)
    AllInJane:playAnnouncerVoice(AllInJane.SFX_JIMBO, flags)
end
AllInJane:AddCallback(ModCallbacks.MC_USE_CARD, useCard, AllInJane.CARD_JERKO)

---@param pl EntityPlayer
---@param val number
local function evalStat(_, pl, stat, val)
    local data = AllInJane:getData(pl)
    if(not data.JERKO_DAMAGE) then return end

    return val+data.JERKO_DAMAGE
end
AllInJane:AddCallback(ModCallbacks.MC_EVALUATE_STAT, evalStat, EvaluateStatStage.FLAT_DAMAGE)

---@param pl EntityPlayer
local function removeJerkoStats(_, pl)
    local data = AllInJane:getData(pl)
    if(data.JERKO_DAMAGE) then
        data.JERKO_DAMAGE = nil
        pl:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
end
AllInJane:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_ROOM_TEMP_EFFECTS, removeJerkoStats)
