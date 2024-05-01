fx_version 'cerulean'
lua54 'yes'
game 'gta5'
description 'Kye Tunerchip'

ui_page 'html/ui.html'

client_scripts {
	'shared/config.lua',
	'client.lua',
	'shared/client.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'shared/config.lua',
	'server.lua',
	'shared/server.lua',
}

files {
	'html/ui.html',
	'html/*.css',
	'html/fonts/*.woff',
	'html/*.js',
	'html/img/*.png',
	'html/img/*.jpg',
	'html/img/*.gif',
}

escrow_ignore {
	'shared/*.lua'
}