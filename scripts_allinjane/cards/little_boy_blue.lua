local sfx = AllInJane.SFX

---@param id Card
---@param player EntityPlayer
---@param flags UseFlag
local function useCard(_, id, player, flags)
    local pool = AllInJane.GAME:GetItemPool()
    local conf = Isaac.GetItemConfig()

    local rng = player:GetCardRNG(id)

    for _, ent in ipairs(Isaac.FindByType(5,100)) do
        local item = ent:ToPickup()
        if(item and item.SubType~=0) then
            local newId = item.SubType

            local diddyFailsafe = 250
            repeat
                local itempool = AllInJane.GAME:GetRoom():GetItemPool(rng:Next())
                itempool = (itempool==ItemPoolType.POOL_NULL and ItemPoolType.POOL_TREASURE or itempool)

                newId = pool:GetCollectible(itempool, false, nil, CollectibleType.COLLECTIBLE_SAD_ONION, GetCollectibleFlag.BAN_ACTIVES)

                diddyFailsafe = diddyFailsafe-1
            until((newId~=0 and conf:GetCollectible(newId):HasTags(ItemConfig.TAG_TEARS_UP)) or diddyFailsafe<=0)

            pool:RemoveCollectible(newId)

            item:Morph(5,100,newId,true)
            local poof = Isaac.Spawn(1000,15,2,item.Position,Vector.Zero,item)
        end
    end

    player:UseActiveItem(CollectibleType.COLLECTIBLE_ISAACS_TEARS, UseFlag.USE_NOANIM, -1)

    sfx:Play(AllInJane.SFX_FOIL)
    AllInJane:playAnnouncerVoice(AllInJane.SFX_JIMBO, flags)
end
AllInJane:AddCallback(ModCallbacks.MC_USE_CARD, useCard, AllInJane.CARD_LITTLE_BOY_BLUE)