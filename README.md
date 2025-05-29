**gb-skimmer**

A plug-and-play skimmer system for QBCore. Allows players to purchase a skimmer, plant it at ATMs, and retrieve marked bills after 20 minutes. Police are alerted when the skimmer is pulled.

## Updates

- Added an NUI element to display how long the player has left until they're able to retrieve their skimmer.
- Added a flag in the Config to disable the NPC and their target location incase the player wants to handle skimmer distribution in another way.
- Added a flag to use black_money instead of marked bills incase players use that in their server setup.
- Added/edited the code to support the above two options.

## Requirements
- QBCore
- qb-menu
- qb-target
- qb-inventory
- qb-policejob

## Preview

https://streamable.com/vnp0b9

## Setup

### 1. Add the item to `qb-core/shared/items.lua`

```lua
skimmer = { name = 'skimmer', label = 'Card Skimmer', weight = 200, type = 'item', image = 'skimmer.png', unique = true, useable = false, shouldClose = true, combinable = nil, description = 'A suspicious device that fits in an ATM slot.' },
```

Put the skimmer.png inside of qb-inventory/html/images


Start the server.




In config you can find the NPC Vendor for buying skimmer.

Fully customizable script.

Hope you enjoy it.


-Grossbean
