
local _, ns = ...

ns.Config = {
    media = {
        statusbar = 'Interface\\AddOns\\oUF_tree\\media\\HalO.tga',                 -- Health- and Powerbar texture
    },

    font = {
        fontSmall = 'Interface\\AddOns\\oUF_tree\\fonts\\pixelfont.ttf',                    -- Name font
        fontSmallSize = 1,

        fontBig = 'Interface\\AddOns\\oUF_tree\\fonts\\pixelfont.ttf',                      -- Health, dead/ghost/offline etc. font
        fontBigSize = 8,
    },

    units = {
        ['raid'] = {
            showSolo = false,
            showParty = true,

            nameLength = 5,

            width = 60,
            height = 32,
            scale = 1, 

            layout = {
                frameSpacing = 2,
                numGroups = 6,

                initialAnchor = 'BOTTOMRIGHT',                                                  -- 'TOPLEFT' 'BOTTOMLEFT' 'TOPRIGHT' 'BOTTOMRIGHT'
                orientation = 'VERTICAL',                                                 -- 'VERTICAL' 'HORIZONTAL'
            },

            smoothUpdates = false,                                                           -- Enable smooth updates for all bars
            showThreatText = true,                                                         -- Show a red 'AGGRO' text on the raidframes in addition to the glow
            showRolePrefix = true,                                                         -- A simple role abbrev..tanks = '>'..healer = '+'..dds = '-'
            showNotHereTimer = true,                                                        -- A afk and offline timer
            showMainTankIcon = true,                                                        -- A little shield on the top of a raidframe if the unit is marked as maintank
            showResurrectText = true,                                                       -- Not working atm. just a placeholder
            showMouseoverHighlight = true,

            showTargetBorder = true,                                                        -- Ahows a little border on the raid/party frame if this unit is your target
            targetBorderColor = {1, 1, 1},

            iconSize = 22,                                                                  -- The size of the debufficon
            indicatorSize = 7,

            horizontalHealthBars = true,
            deficitThreshold = 0.1,

            manabar = {
                show = false,
                horizontalOrientation = false,
            },
        },
    },
}
