TukuiCF["general"] = {
	["autoscale"] = true,                  	-- mainly enabled for users that don't want to mess with the config file
	["uiscale"] = 0.71,                    	-- set your value (between 0.64 and 1) of your uiscale if autoscale is off
	["overridelowtohigh"] = true,          	-- EXPERIMENTAL ONLY! override lower version to higher version on a lower reso.
	["multisampleprotect"] = false,         	-- i don't recommend this because of shitty border but, voila!
}

TukuiCF["duffed"] = {
	["everythingclasscolored"] = false, 		-- Castbar, Datatext & Filger classcolored
	["filgerbarcolor"] = {
		["classcolor"] = false,				-- Filger bars classcolored
		["color"] = {.8, .1, .1, .9}, 		-- use this if classcolor = false
	},
	["blizzardsct"] = false,				-- Also change Blizzard Scrolling combat text font?
}

TukuiCF["unitframes"] = {
	-- Duffed ui specific
	["totandpetlines"] = true, 				-- enable those panels sticked on ToT and Pet
	["partydebuffsright"] = true, 			-- Party debuffs on right side? false = left	
	["portraits"] = { 
		["enable"] = true, 					-- enable portraits (player & target)
		["totandpet"] = true, 				-- enable target of target and pet portrait
	},
	-- if unicolor = true
	["healthbarcolor"] = {.1, .1, .1, 1},	-- Healthbar Color
	["deficitcolor"] = {.7, .1, .1, 1},		-- Healthbar deficit Color

	-- general options
	["enable"] = true,                     	-- do i really need to explain this?
	["enemyhcolor"] = false,               	-- enemy target (players) color by hostility, very useful for healer.
	["unitcastbar"] = true,                	-- enable tukui castbar
	["cblatency"] = false,                 	-- enable castbar latency
	["cbicons"] = true,                    	-- enable icons on castbar
	["auratimer"] = true,                  	-- enable timers on buffs/debuffs
	["auratextscale"] = 11,                	-- the font size of buffs/debuffs timers on unitframes
	["playerauras"] = false,               	-- enable auras
	["targetauras"] = true,                	-- enable auras on target unit frame
	["highThreshold"] = 80,                	-- hunter high threshold
	["lowThreshold"] = 20,                 	-- global low threshold, for low mana warning.
	["targetpowerpvponly"] = true,         	-- enable power text on pvp target only
	["totdebuffs"] = true,                 	-- enable tot debuffs (high reso only)
	["focusdebuffs"] = true,               	-- enable focus debuffs 
	["showfocustarget"] = true,            	-- show focus target
	["showtotalhpmp"] = false,             	-- change the display of info text on player and target with XXXX/Total.
	["showsmooth"] = true,                 	-- enable smooth bar
	["showthreat"] = true,                	-- enable the threat bar anchored to info left panel.
	["charportrait"] = false,              	-- do i really need to explain this?
	["maintank"] = true,  					-- enable maintank
	["mainassist"] = true,					-- enable mainassist
	["unicolor"] = true,                  	-- enable unicolor theme
	["combatfeedback"] = true,             	-- enable combattext on player and target.
	["playeraggro"] = true,                	-- color player border to red if you have aggro on current target.
	["positionbychar"] = true,             	-- save X, Y position with /uf (movable frame) per character instead of per account.
	["healcomm"] = true,                  	-- enable healprediction support.

	-- raid layout
	["showrange"] = true,                  	-- show range opacity on raidframes
	["raidalphaoor"] = 0.6,                	-- alpha of unitframes when unit is out of range
	["gridonly"] = true,                  	-- enable grid only mode for all healer mode raid layout.
	["showsymbols"] = true,	               	-- show symbol.
	["aggro"] = true,                      	-- show aggro on all raids layouts
	["raidunitdebuffwatch"] = true,        	-- track important spell to watch in pve for grid mode.
	["gridhealthvertical"] = true,         -- enable vertical grow on health bar for grid mode.
	["showplayerinparty"] = true,         	-- show my player frame in party
	["gridscale"] = 1,                     	-- set the healing grid scaling
	
	-- boss frames
	["showboss"] = true,                   	-- enable boss unit frames for PVELOL encounters.

	-- priest only plugin
	["ws_show_time"] = false,              	-- show time on weakened soul bar
	["ws_show_player"] = true,             	-- show weakened soul bar on player unit
	["ws_show_target"] = true,             	-- show weakened soul bar on target unit
	
	-- death knight only plugin
	["runebar"] = true,                    	-- enable tukui runebar plugin
	
	-- shaman only plugin
	["totemtimer"] = true,                 	-- enable tukui totem timer plugin
}

TukuiCF["castbar"] = {						
	["classcolor"] = false,					-- classcolored
	["color"] = {
		player = { .7, .1, .1, .9 }, 		-- color if unit is a player (or (only thekCastbar) player castbar color)
		notplayer = { 1, 1, 1, 1 },			-- color if unit is not a player
		target = { 0.1, 0.6, 0.1, 1 },		-- (only thekCastbar) target castbar color
		focus = { 1, 1, 1, 1 }, 			-- (only thekCastbar) focus castbar color
		notinterruptable = {1, 0, 0, 0.7},	-- Castbarcolor if cast is not interruptable
	},		
}

TukuiCF["arena"] = {
	["unitframes"] = true,                 	-- enable tukz arena unitframes (requirement : tukui unitframes enabled)
}

TukuiCF["pvp"] = {
	["interrupt"] = true,					-- enable interrupt icons (interruptbar alternative)
	["drinkannouncement"] = true,			-- drink announcement for arena
	["ccannouncement"] = true,				-- Announce CC/Buffs/Debuffs (config in AddOns/Stuff/Config.lua)
}

TukuiCF["actionbar"] = {
	-- Duffed ui specific
	["swapbar1and3"] = false,				-- Swap Bar 1 and 3 so ur Mainbar will be on top
	["bar3mouseover"] = false, 				-- third bar at the bottom mouseover? (not possible if swapbar1and3 = true ..yet)
	["petbaralwaysvisible"] = true, 		-- Vertical Pet bar visible even if rightbarsmouseover = true
	["petbarhorizontal"] = { 				
		["enable"] = false, 				-- Pet bar horizontal at the bottom (on top of bar3 or if bottomrows = 1, on bar3 position)
		["mouseover"] = false, 				-- Horizontal Petbar mouseover
	},
	["macrotext"] = false,					-- Show/Hide Macro Text on Buttons

	["enable"] = true,                     	-- enable tukz action bars
	["hotkey"] = false,                     -- enable hotkey display because it was a lot requested
	["rightbarmouseover"] = true,          	-- enable right bars on mouse over
	["shapeshiftmouseover"] = true,       	-- enable shapeshift or totembar on mouseover
	["hideshapeshift"] = false,            	-- hide shapeshift or totembar because it was a lot requested.
	["bottomrows"] = 2,                    	-- numbers of row you want to show at the bottom (select between 1 and 2 only)
	["rightbars"] = 2,                     	-- numbers of right bar you want
	["showgrid"] = true,                   	-- show grid on empty button
}

TukuiCF["nameplate"] = {
	["enable"] = true,                     	-- enable nice skinned nameplates that fit into tukui
}

TukuiCF["bags"] = {
	["enable"] = true,                     	-- enable an all in one bag mod that fit tukui perfectly
	["soulbag"] = true,                    	-- show warlock soulbag slot on bag.
}

TukuiCF["map"] = {
	["enable"] = true,                     	-- reskin the map to fit tukui
}

TukuiCF["loot"] = {
	["lootframe"] = true,                  	-- reskin the loot frame to fit tukui
	["rolllootframe"] = true,              	-- reskin the roll frame to fit tukui
	["autogreed"] = false,                  	-- auto-dez or auto-greed item at max level.
}

TukuiCF["cooldown"] = {
	["enable"] = true,                     	-- do i really need to explain this?
	["treshold"] = 8,                      	-- show decimal under X seconds and text turn red
}

TukuiCF["datatext"] = {
	-- Duffed ui specific
	["panelcolor"] = {
		["classcolor"] = false,				-- Panel color classcolored?
		["color"] = "|cffce3a19",			-- use this color if classcolor = false. (default |cffce3a19)
	},										-- Visit: farb-tabelle.de/de/farbtabelle.htm for a color table (it goes like this: |cff<HEXCODE> .. e.g. |cff000000 for black color.
	["zonepanel"] = false,					-- show a third panel below the minimap with zone & coordination info instead of the animation
	
	["fps_ms"] = 2,                        	-- show fps and ms on panels
	["mem"] = 0,                           	-- show total memory on panels
	["bags"] = 0,                          	-- show space used in bags on panels
	["gold"] = 6,                          	-- show your current gold on panels
	["wowtime"] = 8,                       	-- show time on panels
	["guild"] = 1,                         	-- show number on guildmate connected on panels
	["dur"] = 4,                           	-- show your equipment durability on panels.
	["friends"] = 3,                       	-- show number of friends connected.
	["dps_text"] = 0,                      	-- show a dps meter on panels
	["hps_text"] = 0,                      	-- show a heal meter on panels
	["power"] = 7,                         	-- show your attackpower/spellpower/healpower/rangedattackpower whatever stat is higher gets displayed
	["arp"] = 0,                           	-- show your armor penetration rating on panels.
	["haste"] = 0,                         	-- show your haste rating on panels.
	["crit"] = 0,                          	-- show your crit rating on panels.
	["avd"] = 0,                           	-- show your current avoidance against the level of the mob your targeting
	["armor"] = 0,                         	-- show your armor value against the level mob you are currently targeting
	["currency"] = 0,						-- show your tracked currency on panels
	["mmenu"] = 0,							-- Use a datatext instead of the button for mMenu (mMenu AddOn required)
	
	["reputation"] = 5, 					-- show tracked reputation.
	["experience"] = 0, 					-- show experience.
	
	["honor"] = 0, 							-- show ur current honor on panels
	["honorablekills"] = 0,					-- show ur Honorable Kills on panels

	["battleground"] = true,               	-- enable 3 stats in battleground only that replace stat1,stat2,stat3.
	["time24"] = true,                     	-- set time to 24h format.
	["localtime"] = false,                 	-- set time to local time instead of server time.
	["fontsize"] = 12,                     	-- font size for panels.
}

TukuiCF["chat"] = {
	-- Duffed ui specific
	["background"] = false, 				-- turn on/off the black background (mouseover)
	["leftchatborder"] = false, 				-- left chat border
	["rightchatborder"] = false, 			-- right chat border
	
	["enable"] = true,                     	-- blah
	["whispersound"] = true,               	-- play a sound when receiving whisper
}

TukuiCF["tooltip"] = {
	-- Duffed ui specific
	["belowrightbars"] = false,				-- Tooltip Position BELOW rightbars instead of above

	["enable"] = true,                     	-- true to enable this mod, false to disable
	["hidecombat"] = false,                	-- hide bottom-right tooltip when in combat
	["hidebuttons"] = false,               	-- always hide action bar buttons tooltip.
	["hideuf"] = false,                    	-- hide tooltip on unitframes
	["cursor"] = false,                    	-- tooltip via cursor only
}

TukuiCF["merchant"] = {
	["sellgrays"] = true,                  	-- automaticly sell grays?
	["autorepair"] = true,                 	-- automaticly repair?
}

TukuiCF["error"] = {
	["enable"] = true,                     	-- true to enable this mod, false to disable
	filter = {                             	-- what messages to not hide
		["Inventory is full."] = true,     	-- inventory is full will not be hidden by default
	},
}

TukuiCF["invite"] = { 
	["autoaccept"] = true,                 	-- auto-accept invite from guildmate and friends.
}

TukuiCF["watchframe"] = { 
	["movable"] = true,                    	-- disable this if you run "Who Framed Watcher Wabbit" from seerah.
}

TukuiCF["buffreminder"] = {
	["enable"] = true,                     	-- this is now the new innerfire warning script for all armor/aspect class.
	["sound"] = false,                      -- enable warning sound notification for reminder.
}

TukuiCF["others"] = {
	["pvpautorelease"] = false,             -- enable auto-release in bg or wintergrasp. (not working for shaman, sorry)
}

----------------------------------------------------------------------------
-- Per Class Config (overwrite general)
-- Class need to be UPPERCASE
----------------------------------------------------------------------------
if TukuiDB.myclass == "PRIEST" then
	-- do some config!
end
----------------------------------------------------------------------------
-- Per Character Name Config (overwrite general and class)
-- Name need to be case sensitive
----------------------------------------------------------------------------

-- Settings for a Char you are leveling (lvl 2-84) (shown keybindings & Xp instead of rep)
if UnitLevel("player") < 85 then -- 
	TukuiCF["actionbar"].hotkey = true
	TukuiCF["datatext"].experience = 5
	TukuiCF["datatext"].reputation = 0
	if TukuiDB.myname == "Ticky" then TukuiCF.actionbar.bar3mouseover = true end
end

-- Settings for a Lvl 1 Character(Banktwink e.g.)
if UnitLevel("player") == 1 then
	TukuiCF["actionbar"].rightbars = 0
	TukuiCF["actionbar"].bottomrows = 1
	TukuiCF["actionbar"].hotkey = false
end

if TukuiDB.myname == "Sacerdus" or TukuiDB.myname == "Snurq" then 
	TukuiCF["actionbar"].shapeshiftmouseover = false
	TukuiCF["datatext"].reputation = 0
	TukuiCF["datatext"].experience = 0
	TukuiCF["datatext"].mmenu = 5
end