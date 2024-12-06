fx_version 'cerulean'
game 'gta5'

name "Brazzers Farmers Market"
author "Brazzers Development | MannyOnBrazzers#6826"
version "2.0.0"

lua54 'yes'

ox_lib 'locale'

client_scripts {
    'client/*.lua',
    "bridge/**/**/client.lua",
}

server_scripts {
    'server/*.lua',
    "bridge/**/**/server.lua",
}

shared_scripts {
    '@ox_lib/init.lua',
    '@Renewed-Lib/init.lua'
}

files {
    'locales/*.json',
    'shared/*.lua',
}

escrow_ignore {
    'client/open.lua',
    "bridge/**/**/*.*",
	"bridge/**/*.*",
	'shared/*.lua',
}