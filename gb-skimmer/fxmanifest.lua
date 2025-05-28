fx_version 'cerulean'
game 'gta5'

description 'ATM Skimmer Script'
author 'GrossBean'
version '1.0.0'

shared_script 'config.lua'

client_script 'client/main.lua'
server_script 'server/main.lua'

dependencies {
    'qb-core',
    'qb-target',
    'qb-menu',
    'qb-inventory',
    'qb-policejob'
}
