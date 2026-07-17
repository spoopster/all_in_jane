if(not EID) then return end

local cardDescs = {
    [AllInJane.CARD_NOBODY] = {
        Name = "Nobody",
        Desc = {
            "{{BlackHeart}} Spawns a Black Heart",
            "After clearing 2 floors, it instead spawns a random item from the current room's item pool",
            "The item's quality is always 3 or higher",
            "!!! Destroys itself when dropped"
        }
    },
    --[[] ]
    [AllInJane.CARD_LITTLE_BOY_BLUE] = {
        Name = "Little Boy Blue",
        Desc = {
            "Rerolls all items in the room into \"Tears Up\" items",
            "{{Collectible323}} Triggers Isaac's Tears"
        }
    },
    [AllInJane.CARD_HAT_TRICK] = {
        Name = "Hat Trick",
        Desc = {
            "For the rest of the floor, every 3rd hit taken deals no damage and counts as self-damage",
        }
    },
    [AllInJane.CARD_COMEDIANS_MANIFESTO] = {
        Name = "Comedian's Manifesto",
        Desc = {
            "{{Card21}} For the rest of the floor, all consumables are turned into XX - Judgement",
        }
    },
    [AllInJane.CARD_LEXICON] = {
        Name = "Lexicon",
        Desc = {
            "\1 Grants +0.01 flat Damage per letter in the names of all held items",
            "Rarer letters grant more damage",
            "{{Timer}} Damage only lasts for the current room"
        }
    },
    [AllInJane.CARD_GNASHER] = {
        Name = "Gnasher",
        Desc = {
            "Spawns 2 copies of a random consumable in the room",
        }
    },
    [AllInJane.CARD_SILVIO] = {
        Name = "Silvio",
        Desc = {
            "Grants a passive item for every charge on your active item",
            "The items granted only last for the current room"
        }
    },
    [AllInJane.CARD_EULENSPIEGEL] = {
        Name = "Eulenspiegel",
        Desc = {
            "{{Collectible127}} Rerolls and restarts the current floor",
        }
    },
    [AllInJane.CARD_COCONUT] = {
        Name = "Coconut",
        Desc = {
            "Grants {{Collectible139}} 1 trinket slot and {{Collectible454}} 1 consumable slot for the current floor",
        }
    },
    --]]
}

local itemDescs = {
    --[[] ]
    [AllInJane.COLLECTIBLE_DOUBLE_SIDED_CARD] = {
        Name = "Double-Sided Card",
        Desc = {
            "{{CardbackFlipFlopRed}} When used at full charge, spawns a random flip-flop card",
            "When used at partial charge, consumes 1 pip and morphs held cards:",
            "{{CardbackFlipFlopRed}} Regular <-> flipped flip-flop cards",
            "{{Card}} Regular <-> reverse tarot cards"
        }
    }
    --]]
}

local iconSprite = Sprite("gfx_allinjane/ui/ui_eid_cards.anm2", true)
EID:addIcon("Card"..tostring(AllInJane.CARD_NOBODY), "Cards", 0, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(AllInJane.CARD_PARTY_TIME), "Cards", 1, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(AllInJane.CARD_INFURIATING_NOTE), "Cards", 2, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(AllInJane.CARD_BEANSTALK), "Cards", 3, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(AllInJane.CARD_JERKO), "Cards", 4, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(AllInJane.CARD_NEGATIVE_NANCY), "Cards", 5, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(AllInJane.CARD_TALHAK), "Cards", 6, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(AllInJane.CARD_YU_SZE), "Cards", 7, 16, 16, 0, 0, iconSprite)

EID:addIcon("CardbackAllInJane", "Cardbacks", 0, 16, 16, 0, 0, iconSprite)

---@param stringTable string[]
local function turnStringTableToDesc(stringTable)
    local str = ""
    for i, tableStr in ipairs(stringTable) do
        if(i>1) then str = str.."#" end
        str = str..tableStr
    end
    return str
end

for id, table in pairs(cardDescs) do
    EID:addCard(id, turnStringTableToDesc(table.Desc), table.Name, "en_us")
end

for id, table in pairs(itemDescs) do
    EID:addCollectible(id, turnStringTableToDesc(table.Desc), table.Name, "en_us")
end

--[[] ]
local cardVarDataModifiers = {
    [AllInJane.CARD_REPORT] = function(val)
        return "{{ColorSilver}}"..tostring(val).." room"..(val==1 and "" or "s").." cleared{{CR}}"
    end,
    [AllInJane.CARD_SCRATCH] = function(val)
        local str = "{{ColorSilver}}"

        for i=0, 2 do
            local outcome = (val>>(i*AllInJane.OUTCOME_BIT_BLOCK_SIZE)) & (2^AllInJane.OUTCOME_BIT_BLOCK_SIZE-1)
            str = str..(i>0 and ", " or "")..(scratchOutcomes[outcome] or scratchOutcomes[0])
        end

        return str.."{{CR}}"
    end,
}

for id, result in pairs(cardVarDataModifiers) do
    EID:addDescriptionModifier(
        "CardJamFlipCardModifier"..tostring(id),
        function(descObj)
            if(descObj.ObjType==5 and descObj.ObjVariant==300 and descObj.ObjSubType==id) then
                return true
            end
            return false
        end,
        function(descObj, player)
            player = player or Isaac.GetPlayer()

            local val = 0
            if(descObj.Entity) then
                local pickup = descObj.Entity:ToPickup()
                if(pickup) then
                    val = pickup:GetVarData()
                end
            elseif(player) then
                for i=0,3 do
                    if(player:GetCard(i)==descObj.ObjSubType) then
                        val = AllInJane:getCardData(player, i)
                        break
                    end
                end
            end

            local str = result(val)
            descObj.Description = descObj.Description.."#"..str
            return descObj
        end
    )
end
--]]