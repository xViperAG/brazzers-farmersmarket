return {
    Debug = false,
    DefaultImage = 'https://i.imgur.com/G8LcacY.png',
    ClearPeds = true,

    -- Stash Location
    StashWeight = 500000,
    StashSlots = 30,

    -- Pickup Location
    PickupWeight = 200000,
    PickupSlots = 25,

    WipeStashOnLeave = true, -- WIPES THE CONTENTS INSIDE THE STASHES OF YOUR BOOTH WHEN YOU LEAVE [RECOMMENDED: TRUE] [REQUIRES OXMYSQL]
    AllowMultipleClaims = true, -- THIS ALLOWS MULTIPLE BOOTHS TO BE CLAIMED FROM THE SAME PERSON [RECOMMENDED: FALSE]

    -- PolyZone Config
    PierPoly = vector3(-1690.36, -1065.11, 13.12), -- JUST DON'T TOUCH
    PierRadius = 150.00, -- JUST DON'T TOUCH

    Market = {
        [1] = {
            booth = {
                coords = vector3(-1665.14, -1022.04, 13.02),
                heading = 230,
            },
            register = {
                coords = vector3(-1661.52, -1024.1, 12.55),
                heading = 320,
            },
            type = 'pier',
            owner = {},
            groupMembers = {},
            password = nil,
            -- DUI SETTINGS --
            boothDUI = {
                ytd = 'fm_tent_scr_textures',
                ytdname = 'fm_tent_screen_01',
                width = 1024,
                height = 1024,
                url = 'https://i.imgur.com/G8LcacY.png',
                dui = nil,
            },
        },
        [2] = {
            booth = {
                coords = vector3(-1668.95, -1026.54, 13.02),
                heading = 230,
            },
            register = {
                coords = vector3(-1664.82, -1027.94, 12.67),
                heading = 320,
            },
            type = 'pier',
            owner = nil,
            groupMembers = {},
            password = nil,
            -- DUI SETTINGS --
            boothDUI = {
                ytd = 'fm_tent_scr_textures',
                ytdname = 'fm_tent_screen_02',
                width = 1024,
                height = 1024,
                url = 'https://i.imgur.com/G8LcacY.png',
                dui = nil,
            },
        },
        [3] = {
            booth = {
                coords = vector3(-1672.68, -1030.8, 13.02),
                heading = 230,
            },
            register = {
                coords = vector3(-1668.92, -1032.16, 12.75),
                heading = 320,
            },
            type = 'pier',
            owner = nil,
            groupMembers = {},
            password = nil,
            -- DUI SETTINGS --
            boothDUI = {
                ytd = 'fm_tent_scr_textures',
                ytdname = 'fm_tent_screen_03',
                width = 1024,
                height = 1024,
                url = 'https://i.imgur.com/G8LcacY.png',
                dui = nil,
            },
        },
        [4] = {
            booth = {
                coords = vector3(-1681.17, -1045.21, 13.13),
                heading = 140,
            },
            register = {
                coords = vector3(-1677.52, -1042.26, 12.89),
                heading = 232.01,
            },
            type = 'pier',
            owner = nil,
            groupMembers = {},
            password = nil,
            -- DUI SETTINGS --
            boothDUI = {
                ytd = 'fm_tent_scr_textures',
                ytdname = 'fm_tent_screen_04',
                width = 1024,
                height = 1024,
                url = 'https://i.imgur.com/G8LcacY.png',
                dui = nil,
            },
        },
        [5] = {
            booth = {
                coords = vector3(-1685.37, -1046.22, 13.02),
                heading = 230,
            },
            register = {
                coords = vector3(-1681.46, -1048.49, 12.74),
                heading = 320,
            },
            type = 'pier',
            owner = nil,
            groupMembers = {},
            password = nil,
            -- DUI SETTINGS --
            boothDUI = {
                ytd = 'fm_tent_scr_textures',
                ytdname = 'fm_tent_screen_05',
                width = 1024,
                height = 1024,
                url = 'https://i.imgur.com/G8LcacY.png',
                dui = nil,
            },
        },
        [6] = {
            booth = {
                coords = vector3(-1692.91, -1055.19, 13.02),
                heading = 230,
            },
            register = {
                coords = vector3(-1689.07, -1057.23, 12.92),
                heading = 320,
            },
            type = 'pier',
            owner = nil,
            groupMembers = {},
            password = nil,
            -- DUI SETTINGS --
            boothDUI = {
                ytd = 'fm_tent_scr_textures',
                ytdname = 'fm_tent_screen_06',
                width = 1024,
                height = 1024,
                url = 'https://i.imgur.com/G8LcacY.png',
                dui = nil,
            },
        },
        [7] = {
            booth = {
                coords = vector3(-1696.79, -1059.88, 13.02),
                heading = 230,
            },
            register = {
                coords = vector3(-1692.53, -1061.44, 12.85),
                heading = 320,
            },
            type = 'pier',
            owner = nil,
            groupMembers = {},
            password = nil,
            -- DUI SETTINGS --
            boothDUI = {
                ytd = 'fm_tent_scr_textures',
                ytdname = 'fm_tent_screen_07',
                width = 1024,
                height = 1024,
                url = 'https://i.imgur.com/G8LcacY.png',
                dui = nil,
            },
        },
        [8] = {
            booth = {
                coords = vector3(-1696.83, -1064.03, 13.11),
                heading = 320,
            },
            register = {
                coords = vector3(-1698.47, -1068.68, 13.15),
                heading = 51,
            },
            type = 'pier',
            owner = nil,
            groupMembers = {},
            password = nil,
            -- DUI SETTINGS --
            boothDUI = {
                ytd = 'fm_tent_scr_textures',
                ytdname = 'fm_tent_screen_08',
                width = 1024,
                height = 1024,
                url = 'https://i.imgur.com/G8LcacY.png',
                dui = nil,
            },
        },
        [9] = {
            booth = {
                coords = vector3(-1709.35, -1078.42, 13.08),
                heading = 140,
            },
            register = {
                coords = vector3(-1705.6, -1076.3, 13.01),
                heading = 140,
            },
            type = 'pier',
            owner = nil,
            groupMembers = {},
            password = nil,
            -- DUI SETTINGS --
            boothDUI = {
                ytd = 'fm_tent_scr_textures',
                ytdname = 'fm_tent_screen_09',
                width = 1024,
                height = 1024,
                url = 'https://i.imgur.com/G8LcacY.png',
                dui = nil,
            },
        },
        [10] = {
            booth = {
                coords = vector3(-1713.42, -1079.57, 13.02),
                heading = 230,
            },
            register = {
                coords = vector3(-1708.97, -1081.46, 12.96),
                heading = 320,
            },
            type = 'pier',
            owner = nil,
            groupMembers = {},
            password = nil,
            -- DUI SETTINGS --
            boothDUI = {
                ytd = 'fm_tent_scr_textures',
                ytdname = 'fm_tent_screen_10',
                width = 1024,
                height = 1024,
                url = 'https://i.imgur.com/G8LcacY.png',
                dui = nil,
            },
        },
        [11] = {
            booth = {
                coords = vector3(-1720.61, -1088.27, 13.02),
                heading = 230,
            },
            register = {
                coords = vector3(-1716.31, -1089.71, 12.83),
                heading = 320,
            },
            type = 'pier',
            owner = nil,
            groupMembers = {},
            password = nil,
            -- DUI SETTINGS --
            boothDUI = {
                ytd = 'fm_tent_scr_textures',
                ytdname = 'fm_tent_screen_11',
                width = 1024,
                height = 1024,
                url = 'https://i.imgur.com/G8LcacY.png',
                dui = nil,
            },
        },
        [12] = {
            booth = {
                coords = vector3(-1724.29, -1092.86, 13.02),
                heading = 230,
            },
            register = {
                coords = vector3(-1721.7, -1096.66, 12.83),
                heading = 320,
            },
            type = 'pier',
            owner = nil,
            groupMembers = {},
            password = nil,
            -- DUI SETTINGS --
            boothDUI = {
                ytd = 'fm_tent_scr_textures',
                ytdname = 'fm_tent_screen_12',
                width = 1024,
                height = 1024,
                url = 'https://i.imgur.com/G8LcacY.png',
                dui = nil,
            },
        },
        [13] = {
            booth = {
                coords = vector3(-1728.03, -1097.36, 13.02),
                heading = 230,
            },
            register = {
                coords = vector3(-1723.92, -1099.29, 12.77),
                heading = 320,
            },
            type = 'pier',
            owner = nil,
            groupMembers = {},
            password = nil,
            -- DUI SETTINGS --
            boothDUI = {
                ytd = 'fm_tent_scr_textures',
                ytdname = 'fm_tent_screen_13',
                width = 1024,
                height = 1024,
                url = 'https://i.imgur.com/G8LcacY.png',
                dui = nil,
            },
        },
    },
}