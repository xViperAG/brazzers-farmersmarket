fx_version 'cerulean'
game 'gta5'

name "Brazzers Farmers Market"
author "Brazzers Development | MannyOnBrazzers#6826"
version "1.0"

lua54 'yes'

client_scripts {
    'client/*.lua',
    '@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
    '@PolyZone/CircleZone.lua',
	'@PolyZone/ComboZone.lua',
}

server_scripts {
    'server/*.lua',
    '@oxmysql/lib/MySQL.lua',
}

shared_scripts {
	'@qb-core/shared/locale.lua',
    -- '@ox_lib/init.lua', -- IF YOU USING OX UNCOMMENT THIS
	'locales/*.lua',
	'shared/*.lua',
}

escrow_ignore {
    'client/open.lua',
    'server/open.lua',
    'locales/*.lua',
	'shared/*.lua',
}