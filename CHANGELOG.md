# Change log

## v0.1.3

### Content
* Add new skills
* Reworked how guilds work (procedurally generated guilds)

### Interface
* Add EXP bars for player level, abilities and guilds
* Add text label colors for skills, abilities, guild level and resistances that show the progress
* Add text label color for locations that shows the danger

### Bug fixes
* fixed a problem with incorrect BB code on the journal page

## v0.1.2

### Interface
* added known recipes and guild information
* filter options for crafting
* tooltips are now shown after a delay of 0.5s

### Balancing
* increased player character's base accuracy by 10 to avoid high miss rates for new characters
* retreat after 1000 battle turns

## v0.1.1c

### Interface
* fixed title window hiding stats
* fixed some spelling
* made single dot graphs visible

### Bug fixes
* fixed problem that set the main menu to light mode on first login
* fixed graph starting time (only works for version v0.1.1c an onwards, will not affect earlier saves)
* fixed popup window going out of frame

### Bug progress
* the weird lines in the ui appear as a result of scaling

## v0.1.1
### Content
* a few more prefixes and suffixes for legendary equipment
* new name generator for legendary equipment

### Internal changes
* moved several definitions into json files to prepare modding support
* Linux: target wayland as display driver with x11 as fallback
* updated to Godot 4.4

## v0.1.0
### Content
* new item description generator
* reworked generation of legendary equipment

### Interface
* completely new UI
* UI scaling
* themes (light/dark)
* charts/statistics

### Balancing
* increased experience points needed for level up
* slightly reduced experience gain scaling

### Internal changes
* separated the UI code from the game logic code (interaction via signals)
* updated to Godot 4.3
* the web build is now single-threaded and no longer cross-origin isolated
* refactoring

## v0.0.7
### Content
* increased the level range of all regions

### Interface
* the tooltip popup now has a maximum size and has a scroll bar if content does not fit inside

## v0.0.6
### Interface
* improved tooltips for items, skills, region
* improved autosave
* character settings are no longer automatically updated once changed by user at least once

### Balancing
* chanced damage/resistance bonus quality scaling for enchanting
* changed accuracy/evasion buff to scale only on base attribute values
* soul stones can have additional stats

### Bug fixes
* update character list on import

## v0.0.5
### Content
* more complex enchanting system
* most equipment can be enchanted multiple times
* higher chance to find enchanted items
* items can increase stats
* new ability used for acquiring enchantment materials
* added cooking recipe for mayonnaise

### Interface
* ability to change the sleeping time
* minor GUI improvements

### Balancing
* better scaling for summoning skills

### Bug fixes
* restore summoned creatures on loading a game

## v0.0.4
### Content
* some new skill modules
* new high level regions
* new enemies

### Interface
* character import/export function for the web version
* added tooltips for tasks and abilities

### Balancing
* more skill level ups
* stronger enemy scaling
* enemy skills get level ups

### Internal changes
* Moved to Godot version 4.2.1

## v0.0.3
### Interface
* some combinations of multi magic element skills have special names

### Bug fixes
* more auto saves
* fixed a missing translation string

## v0.0.2
### Content
* add blessings received by praying to a god during resting

### Balancing
* slightly reduced maximum number of shopping attempts
* modified some skill modules

### Interface
* add ability to select which skill modules are allowed when creating new skills
* make summary persistent
* more tool tips
* minor changes

### Bug fixes
* tried to fix a bug that I can't reproduce

## v0.0.1
### Content
* a few more skill modules

### Interface
* customizable time table for the player character's tasks
* customizable weapon and equipment type filters
* added a summary of important events

### Bug fixes
* normalized the player character's serotonin level to prevent oversleeping issues
