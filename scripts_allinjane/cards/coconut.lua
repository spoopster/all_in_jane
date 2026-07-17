local sfx = AllInJane.SFX

---@param id Card
---@param player EntityPlayer
---@param flags UseFlag
local function useCard(_, id, player, flags)
    player:SetInnateCollectibleGroup("AllInJaneCoconutItems", {
        [CollectibleType.COLLECTIBLE_MOMS_PURSE] = 1,
        [CollectibleType.COLLECTIBLE_POLYDACTYLY] = 1,
    })

    sfx:Play(AllInJane.SFX_BALANCE)
    AllInJane:playAnnouncerVoice(AllInJane.SFX_JIMBO, flags)
end
AllInJane:AddCallback(ModCallbacks.MC_USE_CARD, useCard, AllInJane.CARD_COCONUT)

---@param pl EntityPlayer
local function removeHatTrick(_, pl)
    if(pl.FrameCount==0) then return end

    pl:SetInnateCollectibleGroup("AllInJaneCoconutItems", {})
end
AllInJane:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_LEVEL, removeHatTrick)