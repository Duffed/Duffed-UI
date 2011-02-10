local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

C["general"] = {
	["autoscale"] = true,                               -- mainly enabled for users that don't want to mess with the config file
	["uiscale"] = 0.71,                                 -- set your value (between 0.64 and 1) of your uiscale if autoscale is off
	["overridelowtohigh"] = true,                      	-- EXPERIMENTAL ONLY! override lower version to higher version on a lower reso.
	["multisampleprotect"] = true,                      -- i don't recommend this because of shitty border but, voila!
	["blizzardsct"] = true,								-- Skin also Blizzard SCT Font(put it in generel now)
	["normalfont"] = false,								-- Use the normal/old font + fontsize instead of pixelfont :>
}

C["unitframes"] = {
	["healthbarcolor"] = {.3, .3, .3, 1},				-- Healthbar color (if unicolor = true)
	["deficitcolor"] = {0, 0, 0, 1},					-- Healthbar deficit color (if unicolor = true)
	["totandpetlines"] = true,							-- Show the small Lines on pet & Target of Target
	["priestarmor"] = false,							-- Display which Armor is currently up on ur priest
	["framewidth"] = 220,								-- Width of Player & Target Frame (affect also arena- & bossframes)

	-- general options
	["enable"] = true,                                  -- do i really need to explain this?
	["enemyhcolor"] = false,                            -- enemy target (players) color by hostility, very useful for healer.
	["unitcastbar"] = true,                             -- enable tukui castbar
	["cblatency"] = false,                              -- enable castbar latency
	["cbicons"] = true,                                 -- enable icons on castbar
	["auratimer"] = true,                               -- enable timers on buffs/debuffs
	["auratextscale"] = 11,                             -- the font size of buffs/debuffs timers on unitframes
	["playerauras"] = false,                            -- enable auras
	["targetauras"] = true,                             -- enable auras on target unit frame
	["lowThreshold"] = 20,                              -- global low threshold, for low mana warning.
	["targetpowerpvponly"] = true,                      -- enable power text on pvp target only
	["totdebuffs"] = false,                             -- enable tot debuffs (high reso only)
	["showtotalhpmp"] = false,                          -- change the display of info text on player and target with XXXX/Total.
	["showsmooth"] = true,                              -- enable smooth bar
	["charportrait"] = true,                           	-- do i really need to explain this?
	["maintank"] = false,                               -- enable maintank
	["mainassist"] = false,                             -- enable mainassist
	["unicolor"] = true,                               	-- enable unicolor theme
	["combatfeedback"] = true,                          -- enable combattext on player and target.
	["playeraggro"] = true,                             -- color player border to red if you have aggro on current target.
	["healcomm"] = true,                               	-- enable healprediction support.
	["onlyselfdebuffs"] = false,                        -- display only our own debuffs applied on target

	-- raid layout (if one of them is enabled)
	["showrange"] = true,                               -- show range opacity on raidframes
	["raidalphaoor"] = 0.5,                             -- alpha of unitframes when unit is out of range
	["gridonly"] = true,                               	-- enable grid only mode for all healer mode raid layout.
	["showsymbols"] = true,	                            -- show symbol.
	["aggro"] = true,                                   -- show aggro on all raids layouts
	["raidunitdebuffwatch"] = true,                     -- track important spell to watch in pve for grid mode.
	["gridhealthvertical"] = true,                      -- enable vertical grow on health bar for grid mode.
	["showplayerinparty"] = true,                      	-- show my player frame in party
	["gridscale"] = 1,                                  -- set the healing grid scaling
	
	-- boss frames
	["showboss"] = true,                                -- enable boss unit frames for PVELOL encounters.

	-- priest only plugin
	["weakenedsoulbar"] = true,                         -- show weakened soul bar
	
	-- class bar
	["classbar"] = true,                                -- enable tukui classbar over player unit
}

C["actionbar"] = {
	["swapbar1and3"] = false,							-- Swap Bar 1 and 3 (Mainbar with the third at the Top)
	["rightbarsmouseover"] = true, 						-- Right Bars on mouseover
	["shapeshiftborder"] = true,						-- Create a Border around the shapeshift buttons
	["shapeshiftmouseover"] = false,					-- Shapeshiftbar on mouseover
	["petbaralwaysvisible"] = true,						-- Always show petbar even if rightbarsmouseover = true
	["macrotext"] = false,								-- display macro text on buttons

	["enable"] = true,                                  -- enable tukui action bars
	["hotkey"] = false,                                 -- enable hotkey display because it was a lot requested
	["hideshapeshift"] = false,                         -- hide shapeshift or totembar because it was a lot requested.
	["showgrid"] = true,                                -- show grid on empty button
	["buttonsize"] = 27,                                -- normal buttons size
	["petbuttonsize"] = 29,                             -- pet & stance buttons size
	["buttonspacing"] = 4,                              -- buttons spacing
}

C["castbar"] = {
	["color"] = { 0.9, 0.9, 0.9, 0.9 },					-- Castbar color for everything except player (player uses datatext.color value)
	["target-y-offset"] = 380,							-- Target Castbar offset from the BOTTOM
	["focus-y-offset"] = -320,							-- Focus Castbar offset from the TOP
}

C["arena"] = {
	["unitframes"] = true,                              -- enable tukz arena unitframes (requirement : tukui unitframes enabled)
}

C["pvp"] = {
	["drinkannouncement"] = true,						-- drink announcement for arena
	["ccannouncement"] = true,							-- Announce CC/Buffs/Debuffs (config in AddOns/Stuff/Config.lua)
	["sayinterrupt"] = true,							-- Announce when u interrupt someone
}

C["classtimer"] = {
	["playercolor"] = {.2, .2, .2, 1 },
	["targetbuffcolor"] = { 70/255, 150/255, 70/255, 1 },
	["targetdebuffcolor"] = { 150/255, 30/255, 30/255, 1 },
	["trinketcolor"] = {75/255, 75/255, 75/255, 1 },
}

C["bags"] = {
	["enable"] = true,                                  -- enable an all in one bag mod that fit tukui perfectly
}

C["map"] = {
	["enable"] = true,                                  -- reskin the map to fit tukui
}

C["loot"] = {
	["lootframe"] = true,                               -- reskin the loot frame to fit tukui
	["rolllootframe"] = true,                           -- reskin the roll frame to fit tukui
	["autogreed"] = true,                               -- auto-dez or auto-greed item at max level, auto-greed Frozen orb
}

C["cooldown"] = {
	["enable"] = true,                                  -- do i really need to explain this?
	["treshold"] = 8,                                   -- show decimal under X seconds and text turn red
}

C["datatext"] = {
	["color"] = { 75/255, 175/255, 76/255 },			-- datatext color { r/255, g/255, b/255 }
	["classcolored"] = false,							-- classcolored datatext
	["zonepanel"] = false,								-- Show Panel with ur current Zone instead of mouseover on minimap
	["mMenu"] = 0,										-- shows mMenu datatext (required: mMenu AddOn)
	["experience"] = 0,
	["reputation"] = 5,
	
	["fps_ms"] = 2,                                     -- show fps and ms on panels
	["system"] = 0,                                     -- show total memory and others systems infos on panels
	["bags"] = 0,                                       -- show space used in bags on panels
	["gold"] = 6,                                       -- show your current gold on panels
	["wowtime"] = 8,                                    -- show time on panels
	["guild"] = 1,                                      -- show number on guildmate connected on panels
	["dur"] = 4,                                        -- show your equipment durability on panels.
	["friends"] = 3,                                    -- show number of friends connected.
	["dps_text"] = 0,                                   -- show a dps meter on panels
	["hps_text"] = 0,                                   -- show a heal meter on panels
	["power"] = 7,                                      -- show your attackpower/spellpower/healpower/rangedattackpower whatever stat is higher gets displayed
	["haste"] = 0,                                      -- show your haste rating on panels.
	["crit"] = 0,                                       -- show your crit rating on panels.
	["avd"] = 0,                                        -- show your current avoidance against the level of the mob your targeting
	["armor"] = 0,                                      -- show your armor value against the level mob you are currently targeting
	["currency"] = 0,                                   -- show your tracked currency on panels.
	["hit"] = 0,										-- show your current hit rating on panels.
	["mastery"] = 0,									-- show your current mastery rating on panels.
	["micromenu"] = 0,									-- Micromenu on panels (toggle the same menu as on minimap).

	["battleground"] = true,                            -- enable 3 stats in battleground only that replace stat1,stat2,stat3.
	["time24"] = true,                                  -- set time to 24h format.
	["localtime"] = false,                              -- set time to local time instead of server time.
	["font"] = [[Interface\AddOns\Tukui\medias\fonts\combat_font.ttf]],
	["fontsize"] = 8,                                  -- font size for panels.
}

C["chat"] = {
	["enable"] = true,                                  -- blah
	["whispersound"] = true,                            -- play a sound when receiving whisper
	["background"] = true,
}

C["nameplate"] = {
	["enable"] = true,                                  -- enable nice skinned nameplates that fit into tukui
	["showhealth"] = false,				                -- show health text on nameplate
	["enhancethreat"] = false,			                -- threat features based on if your a tank or not
	["overlap"] = false,				                -- allow nameplates to overlap
	["combat"] = false,					                -- only show enemy nameplates in-combat.
	["goodcolor"] = {75/255,  175/255, 76/255},	        -- good threat color (tank shows this with threat, everyone else without)
	["badcolor"] = {0.78, 0.25, 0.25},			        -- bad threat color (opposite of above)
	["transitioncolor"] = {218/255, 197/255, 92/255},	-- threat color when gaining threat
}

C["tooltip"] = {
	["enable"] = true,                                  -- true to enable this mod, false to disable
	["hidecombat"] = false,                             -- hide bottom-right tooltip when in combat
	["hidebuttons"] = false,                            -- always hide action bar buttons tooltip.
	["hideuf"] = false,                                 -- hide tooltip on unitframes
	["cursor"] = false,                                 -- tooltip via cursor only
}

C["merchant"] = {
	["sellgrays"] = true,                               -- automaticly sell grays?
	["autorepair"] = true,                              -- automaticly repair?
	["sellmisc"] = true,                                -- sell defined items automatically
}

C["error"] = {
	["enable"] = true,                                  -- true to enable this mod, false to disable
	filter = {                                          -- what messages to not hide
		[INVENTORY_FULL] = true,                        -- inventory is full will not be hidden by default
	},
}

C["invite"] = { 
	["autoaccept"] = true,                              -- auto-accept invite from guildmate and friends.
}

C["buffreminder"] = {
	["enable"] = true,                                  -- this is now the new innerfire warning script for all armor/aspect class.
	["sound"] = false,                                   -- enable warning sound notification for reminder.
}
