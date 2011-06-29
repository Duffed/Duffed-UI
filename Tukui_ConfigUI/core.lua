-- This will filter everythin NON user config data out of TukuiDB

local myPlayerRealm = GetCVar("realmName")
local myPlayerName  = UnitName("player")

local ALLOWED_GROUPS = {
	["general"]=1,
	["unitframes"]=1,
	["arena"]=1,
	["actionbar"]=1,
	["nameplate"]=1,
	["bags"]=1,
	["map"]=1,
	["loot"]=1,
	["cooldown"]=1,
	["datatext"]=1,
	["chat"]=1,
	["tooltip"]=1,
	["merchant"]=1,
	["error"]=1,
	["invite"]=1,
	["buffreminder"]=1,
	["pvp"]=1,
	["castbar"]=1,
	["classtimer"]=1,
	["skins"]=1,
	["sCombo"]=1,
	["auras"]=1,
	["swingtimer"]=1,
}

--List of "Table Names" that we do not want to show in the config
local TableFilter = {
	["filter"]=1,
}

local function Local(o)
	local T, C, L = unpack(Tukui)
	
	-- Duffed UI config entrys (english)
	if o == "TukuiConfigUIgeneralblizzardsct" then o = "Skin Blizzard SCT" end
	if o == "TukuiConfigUIgeneralnormalfont" then o = "Use the Normal/Old Font instead of pixelfont." end
	if o == "TukuiConfigUIgeneraloverridehightolow" then o = "Use Low-res Version on High-res (Experimental)" end
	if o == "TukuiConfigUIgeneralbordercolor" then o = "Bordercolor (Tukui Panels)" end
	if o == "TukuiConfigUIgeneralbackdropcolor" then o = "Backdropcolor (Tukui Panels)" end
	if o == "TukuiConfigUIgeneralclasscoloredborder" then o = "Tukui-Panel-Border classcolored" end
	
	if o == "TukuiConfigUIdatatextcolor" then o = "Text Color (datatext, chat etc.)" end
	if o == "TukuiConfigUIdatatextclasscolored" then o = "Classcolored Text" end
	if o == "TukuiConfigUIdatatextzonepanel" then o = "Panel that shows current Zone below Minimap" end
	if o == "TukuiConfigUIdatatextexperience" then o = "Experience Position" end
	if o == "TukuiConfigUIdatatextreputation" then o = "Reputation Position" end
	if o == "TukuiConfigUIdatatextmmenu"  then o = "mMenu Position (mMenu required)" end
	if o == "TukuiConfigUIdatatextfont" then o = "Font (datatext, buffs, chat-tabs, ClassTimer)" end
	if o == "TukuiConfigUIdatatexthonorablekills" then o = "Honorable Kills Position" end
	if o == "TukuiConfigUIdatatexthonor" then o = "Honor Position" end
	
	if o == "TukuiConfigUIunitframeshealthbarcolor"  then o = "Healthbar Color (unicolor)" end
	if o == "TukuiConfigUIunitframesdeficitcolor"  then o = "Deficit Color (unicolor)" end
	if o == "TukuiConfigUIunitframespriestarmor"  then o = "Display current Armor for Priest" end
	if o == "TukuiConfigUIunitframestotandpetlines"  then o = "Display Lines from Pet & ToT" end
	if o == "TukuiConfigUIunitframesframewidth"  then o = "Player & Target width (affect also boss- & arenaframes)" end
	if o == "TukuiConfigUIunitframesfader" then o = "[EXPERIMENTAL] Fade Unitframes out when not in combat (+ some more conditions ofc)" end
	if o == "TukuiConfigUIunitframesfader_alpha" then o = "(Fader) Alpha for frames (if not 0)" end
	if o == "TukuiConfigUIunitframesvengeancebar" then o = "Display Vengeance-Bar instead of Threat-Bar" end
	if o == "TukuiConfigUIunitframeslargefocus" then o = "Use larger Focus Frame" end
	if o == "TukuiConfigUIunitframesgridvertical" then o = "Grid direction vertical instead of horizontal" end
	if o == "TukuiConfigUIunitframesgridpets" then o = "Show pets in Grid Layout (only in group, not raid)" end
	if o == "TukuiConfigUIunitframesfontsize" then o = "Unitframe Fontsize" end
	if o == "TukuiConfigUIunitframesgridsolo" then o = "Show Grid even without a Group (Solo)" end
	if o == "TukuiConfigUIunitframesfocusdebuffs" then o = "Enable Focus Debuffs" end
	if o == "TukuiConfigUIunitframesbuffrows" then o = "Buff-rows above Target" end
	if o == "TukuiConfigUIunitframesdebuffrows" then o = "Debuff-rows above Target" end
	if o == "TukuiConfigUIunitframesportraitstyle" then o = "Portrait Style: ICON or MODEL (Layout 2 only)" end
	if o == "TukuiConfigUIunitframeslayout" then o = "Layout (1 or 2)" end
	if o == "TukuiConfigUIunitframesColorGradient" then o = "Add Color-Gradient to healthbar (from red to healthbarcolor u set in config)" end
	if o == "TukuiConfigUIunitframespowerClasscolored" then o = "Powerbar in class-color instead of power-color" end
	
	if o == "TukuiConfigUIcastbar" then o = "Castbar" end
	if o == "TukuiConfigUIcastbarcolor"  then o = "Castbarcolor for not-player (if not classcolored)" end
	if o == "TukuiConfigUIcastbarclasscolored"  then o = "Castbar classcolored." end
	if o == "TukuiConfigUIcastbartarget-y-offset"  then o = "Target Castbar offset from the BOTTOM" end
	if o == "TukuiConfigUIcastbarfocus-y-offset"  then o = "Focus Castbar offset from the TOP" end
	if o == "TukuiConfigUIcastbarenable" then o = TukuiL.option_unitframes_castbar end
	if o == "TukuiConfigUIcastbarcblatency" then o = TukuiL.option_unitframes_latency end
	if o == "TukuiConfigUIcastbarcbicons" then o = TukuiL.option_unitframes_icon end
	
	if o == "TukuiConfigUIactionbarswapbar1and3"  then o = "Swap Mainbar with 3. (on top)" end
	if o == "TukuiConfigUIactionbarrightbarsmouseover"  then o = "Rightbars on mouseover" end
	if o == "TukuiConfigUIactionbarshapeshiftborder"  then o = "Display Border around Shapeshiftbar" end
	if o == "TukuiConfigUIactionbarshapeshiftmouseover"  then o = "Shapeshiftbar on mouseover" end
	if o == "TukuiConfigUIactionbarmacrotext"  then o = "Display Macrotext" end
	if o == "TukuiConfigUIactionbarpetbaralwaysvisible"  then o = "Always show Petbar even if rightbarsmouseover = true" end
	if o == "TukuiConfigUIactionbarpetbarhorizontal"  then o = "Petbar horizontal on top of Bar2/1" end
	if o == "TukuiConfigUIactionbarhideplusminus" then o = "Hide +/- button at the bottom (between both datatext panels)" end
	
	if o == "TukuiConfigUIpvpdrinkannouncement"  then o = "Announce 'drinking' in  Arena" end
	if o == "TukuiConfigUIpvpccannouncement"  then o = "Announce CC/Buffs/Debuffs" end
	if o == "TukuiConfigUIpvpsayinterrupt"  then o = "Announce when u interrupt someone" end
	if o == "TukuiConfigUIpvpdispelannouncement" then o = "Announce Dispels in a movable Frame (/duffed)" end
	if o == "TukuiConfigUIpvparenaonly" then o = "Aura & Interrupt announcement in arena only." end
	
	if o == "TukuiConfigUIclasstimer" then o = "ClassTimer" end
	if o == "TukuiConfigUIclasstimerplayercolor" then o = "Player-Bar Color" end
	if o == "TukuiConfigUIclasstimertargetbuffcolor" then o = "Target-Buffs Color" end
	if o == "TukuiConfigUIclasstimertargetdebuffcolor" then o = "Target-Debuffs Color" end
	if o == "TukuiConfigUIclasstimertrinketcolor" then o = "Player-Trinket(Procs) Color" end
	if o == "TukuiConfigUIclasstimertargetdebuffs" then o = "Target Debuffs above Target (looks crappy imo :))" end
	
	if o == "TukuiConfigUIchataddonborder" then o = "Create Panel that looks exactly like the left chat (by default) at the BOTTOMRIGHT" end
	if o == "TukuiConfigUIchatleftchatbackground" then o = "Show Background for the left Chat (ChatFrame1)" end
	if o == "TukuiConfigUIchatrightchatbackground" then o = "Show Background for the right Chat (ChatFrame4)" end
	if o == "TukuiConfigUIchatrightchatnumber" then o = "(For Rightchat-Background) Chat Number X" end
	if o == "TukuiConfigUIchatfading" then o = "Enable fading" end
	
	if o == "TukuiConfigUIskins" then o = "Skins" end
	if o == "TukuiConfigUIskinsbackground" then o = "Create Panel that looks exactly like the left chat (by default) at the BOTTOMRIGHT" end
	if o == "TukuiConfigUIskinscombat_toggle" then o = "Toggle Addonbackground, Recount, Omen & Skada in-/outfight (NOTE: Turn off auto-hide functions in these Addons)" end
	if o == "TukuiConfigUIskinsSkada" then o = "Enable Skada Skin" end
	if o == "TukuiConfigUIskinsRecount" then o = "Enable Recount Skin" end
	if o == "TukuiConfigUIskinsOmen" then o = "Enable Omen Skin" end
	if o == "TukuiConfigUIskinsKLE" then o = "Enable KLE Skin" end
	if o == "TukuiConfigUIskinsTinyDPS" then o = "Enable TinyDPS Skin" end
	if o == "TukuiConfigUIskinsQuartz" then o = "Enable Quartz Skin" end
	if o == "TukuiConfigUIskinsblizzardframes" then o = "Skin Blizzard-Frames" end
	
	if o == "TukuiConfigUItooltipshowspellid" then o = "Show SpellID on Tooltip" end
	
	if o == "TukuiConfigUIsCombo" then o = "ComboBar (sCombo)" end
	if o == "TukuiConfigUIsComboenable" then o = "Enable sCombo-Addon for combopoints instead of default cp-display" end
	if o == "TukuiConfigUIsComboenergybar" then o = "Show Energy-Bar below Combopoints" end
	
	if o == "TukuiConfigUImerchantautoguildrepair" then o = "Autorepair from Guild Bank if possible." end
	
	if o == "TukuiConfigUInameplateclassicons" then o = "Display Classicon on nameplates for enemys" end
	
	if o == "TukuiConfigUIswingtimer" then o = "SwingTimer" end
	if o == "TukuiConfigUIswingtimerenable" then o = "Enable SwingTimer" end
	if o == "TukuiConfigUIswingtimerwidth" then o = "Width" end
	if o == "TukuiConfigUIswingtimerheight" then o = "Height" end
	if o == "TukuiConfigUIswingtimercolor" then o = "Bar-Color" end
	
	-- general
	if o == "TukuiConfigUIgeneral" then o = TukuiL.option_general end
	if o == "TukuiConfigUIgeneralautoscale" then o = TukuiL.option_general_uiscale end
	if o == "TukuiConfigUIgeneraloverridelowtohigh" then o = TukuiL.option_general_override end
	if o == "TukuiConfigUIgeneralmultisampleprotect" then o = TukuiL.option_general_multisample end
	if o == "TukuiConfigUIgeneraluiscale" then o = TukuiL.option_general_customuiscale end
	
	-- nameplate
	if o == "TukuiConfigUInameplate" then o = TukuiL.option_nameplates end
	if o == "TukuiConfigUInameplateenable" then o = TukuiL.option_nameplates_enable end
	if o == "TukuiConfigUInameplateshowhealth" then o = TukuiL.option_nameplates_showhealth end
	if o == "TukuiConfigUInameplateenhancethreat" then o = TukuiL.option_nameplates_enhancethreat end
	if o == "TukuiConfigUInameplateoverlap" then o = UNIT_NAMEPLATES_ALLOW_OVERLAP end
	if o == "TukuiConfigUInameplatecombat" then o = TukuiL.option_nameplates_combat end
	if o == "TukuiConfigUInameplategoodcolor" then o = TukuiL.option_nameplates_goodcolor end
	if o == "TukuiConfigUInameplatebadcolor" then o = TukuiL.option_nameplates_badcolor end
	if o == "TukuiConfigUInameplatetransitioncolor" then o = TukuiL.option_nameplates_transitioncolor end
	
	-- merchant
	if o == "TukuiConfigUImerchant" then o = TukuiL.option_merchant end
	if o == "TukuiConfigUImerchantsellgrays" then o = TukuiL.option_merchant_autosell end
	if o == "TukuiConfigUImerchantautorepair" then o = TukuiL.option_merchant_autorepair end
	if o == "TukuiConfigUImerchantsellmisc" then o = TukuiL.option_merchant_sellmisc end
	
	-- bags
	if o == "TukuiConfigUIbags" then o = TukuiL.option_bags end
	if o == "TukuiConfigUIbagsenable" then o = TukuiL.option_bags_enable end
	
	-- datatext
	if o == "TukuiConfigUIdatatext" then o = TukuiL.option_datatext end
	if o == "TukuiConfigUIdatatexttime24" then o = TukuiL.option_datatext_24h end
	if o == "TukuiConfigUIdatatextlocaltime" then o = TukuiL.option_datatext_localtime end
	if o == "TukuiConfigUIdatatextbattleground" then o = TukuiL.option_datatext_bg end
	if o == "TukuiConfigUIdatatexthps_text" then o = TukuiL.option_datatext_hps end
	if o == "TukuiConfigUIdatatextguild" then o = TukuiL.option_datatext_guild end
	if o == "TukuiConfigUIdatatextarp" then o = TukuiL.option_datatext_arp end
	if o == "TukuiConfigUIdatatextsystem" then o = TukuiL.option_datatext_mem end
	if o == "TukuiConfigUIdatatextbags" then o = TukuiL.option_datatext_bags end
	if o == "TukuiConfigUIdatatextfontsize" then o = TukuiL.option_datatext_fontsize end
	if o == "TukuiConfigUIdatatextfps_ms" then o = TukuiL.option_datatext_fps_ms end
	if o == "TukuiConfigUIdatatextarmor" then o = TukuiL.option_datatext_armor end
	if o == "TukuiConfigUIdatatextavd" then o = TukuiL.option_datatext_avd end
	if o == "TukuiConfigUIdatatextpower" then o = TukuiL.option_datatext_power end
	if o == "TukuiConfigUIdatatexthaste" then o = TukuiL.option_datatext_haste end
	if o == "TukuiConfigUIdatatextfriends" then o = TukuiL.option_datatext_friend end
	if o == "TukuiConfigUIdatatextwowtime" then o = TukuiL.option_datatext_time end
	if o == "TukuiConfigUIdatatextgold" then o = TukuiL.option_datatext_gold end
	if o == "TukuiConfigUIdatatextdps_text" then o = TukuiL.option_datatext_dps end
	if o == "TukuiConfigUIdatatextcrit" then o = TukuiL.option_datatext_crit end	
	if o == "TukuiConfigUIdatatextdur" then o = TukuiL.option_datatext_dur end
	if o == "TukuiConfigUIdatatextcurrency" then o = TukuiL.option_datatext_currency end
	if o == "TukuiConfigUIdatatextmicromenu" then o = TukuiL.option_datatext_micromenu end
	if o == "TukuiConfigUIdatatexthit" then o = TukuiL.option_datatext_hit end	
	if o == "TukuiConfigUIdatatextmastery" then o = TukuiL.option_datatext_mastery end	

	-- unit frames
	if o == "TukuiConfigUIunitframes" then o = TukuiL.option_unitframes_unitframes end
	if o == "TukuiConfigUIunitframescombatfeedback" then o = TukuiL.option_unitframes_combatfeedback end
	if o == "TukuiConfigUIunitframesrunebar" then o = TukuiL.option_unitframes_runebar end
	if o == "TukuiConfigUIunitframesauratimer" then o = TukuiL.option_unitframes_auratimer end
	if o == "TukuiConfigUIunitframestotemtimer" then o = TukuiL.option_unitframes_totembar end
	if o == "TukuiConfigUIunitframesshowtotalhpmp" then o = TukuiL.option_unitframes_totalhpmp end
	if o == "TukuiConfigUIunitframesshowplayerinparty" then o = TukuiL.option_unitframes_playerparty end
	if o == "TukuiConfigUIunitframesraidunitdebuffwatch" then o = TukuiL.option_unitframes_aurawatch end
	if o == "TukuiConfigUIunitframesunitcastbar" then o = TukuiL.option_unitframes_castbar end
	if o == "TukuiConfigUIunitframestargetauras" then o = TukuiL.option_unitframes_targetaura end
	if o == "TukuiConfigUIunitframespositionbychar" then o = TukuiL.option_unitframes_saveperchar end
	if o == "TukuiConfigUIunitframesws_show_time" then o = TukuiL.option_unitframes_wstimer end
	if o == "TukuiConfigUIunitframesplayeraggro" then o = TukuiL.option_unitframes_playeraggro end
	if o == "TukuiConfigUIunitframesshowsmooth" then o = TukuiL.option_unitframes_smooth end
	if o == "TukuiConfigUIunitframescharportrait" then o = TukuiL.option_unitframes_portrait end
	if o == "TukuiConfigUIunitframesenable" then o = TukuiL.option_unitframes_enable end
	if o == "TukuiConfigUIunitframesws_show_target" then o = TukuiL.option_unitframes_wstarget end
	if o == "TukuiConfigUIunitframestargetpowerpvponly" then o = TukuiL.option_unitframes_enemypower end
	if o == "TukuiConfigUIunitframesgridonly" then o = TukuiL.option_unitframes_gridonly end
	if o == "TukuiConfigUIunitframeshealcomm" then o = TukuiL.option_unitframes_healcomm end
	if o == "TukuiConfigUIunitframesfocusdebuffs" then o = TukuiL.option_unitframes_focusdebuff end
	if o == "TukuiConfigUIunitframesws_show_player" then o = TukuiL.option_unitframes_wsplayer end
	if o == "TukuiConfigUIunitframesaggro" then o = TukuiL.option_unitframes_raidaggro end
	if o == "TukuiConfigUIunitframesshowboss" then o = TukuiL.option_unitframes_boss end
	if o == "TukuiConfigUIunitframesenemyhcolor" then o = TukuiL.option_unitframes_enemyhostilitycolor end
	if o == "TukuiConfigUIunitframesgridhealthvertical" then o = TukuiL.option_unitframes_hpvertical end
	if o == "TukuiConfigUIunitframesshowsymbols" then o = TukuiL.option_unitframes_symbol end
	if o == "TukuiConfigUIunitframesshowthreat" then o = TukuiL.option_unitframes_threatbar end
	if o == "TukuiConfigUIunitframesshowrange" then o = TukuiL.option_unitframes_enablerange end
	if o == "TukuiConfigUIunitframesshowfocustarget" then o = TukuiL.option_unitframes_focus end
	if o == "TukuiConfigUIunitframescblatency" then o = TukuiL.option_unitframes_latency end
	if o == "TukuiConfigUIunitframescbicons" then o = TukuiL.option_unitframes_icon end
	if o == "TukuiConfigUIunitframesplayerauras" then o = TukuiL.option_unitframes_playeraura end
	if o == "TukuiConfigUIunitframesauratextscale" then o = TukuiL.option_unitframes_aurascale end
	if o == "TukuiConfigUIunitframesgridscale" then o = TukuiL.option_unitframes_gridscale end
	if o == "TukuiConfigUIunitframeshighThreshold" then o = TukuiL.option_unitframes_manahigh end
	if o == "TukuiConfigUIunitframeslowThreshold" then o = TukuiL.option_unitframes_manalow end
	if o == "TukuiConfigUIunitframesraidalphaoor" then o = TukuiL.option_unitframes_range end
	if o == "TukuiConfigUIunitframesmaintank" then o = TukuiL.option_unitframes_maintank end
	if o == "TukuiConfigUIunitframesmainassist" then o = TukuiL.option_unitframes_mainassist end
	if o == "TukuiConfigUIunitframesunicolor" then o = TukuiL.option_unitframes_unicolor end
	if o == "TukuiConfigUIunitframestotdebuffs" then o = TukuiL.option_unitframes_totdebuffs end
	if o == "TukuiConfigUIunitframesclassbar" then o = TukuiL.option_unitframes_classbar end
	if o == "TukuiConfigUIunitframesweakenedsoulbar" then o = TukuiL.option_unitframes_weakenedsoulbar end
	if o == "TukuiConfigUIunitframesonlyselfdebuffs" then o = TukuiL.option_unitframes_onlyselfdebuffs end

	-- loot
	if o == "TukuiConfigUIloot" then o = TukuiL.option_loot end
	if o == "TukuiConfigUIlootlootframe" then o = TukuiL.option_loot_enableloot end
	if o == "TukuiConfigUIlootautogreed" then o = TukuiL.option_loot_autogreed end
	if o == "TukuiConfigUIlootrolllootframe" then o = TukuiL.option_loot_enableroll end
	
	-- map
	if o == "TukuiConfigUImap" then o = TukuiL.option_map end
	if o == "TukuiConfigUImapenable" then o = TukuiL.option_map_enable end
	
	-- invite
	if o == "TukuiConfigUIinvite" then o = TukuiL.option_invite end
	if o == "TukuiConfigUIinviteautoaccept" then o = TukuiL.option_invite_autoinvite end

	-- tooltip
	if o == "TukuiConfigUItooltip" then o = TukuiL.option_tooltip end
	if o == "TukuiConfigUItooltipenable" then o = TukuiL.option_tooltip_enable end
	if o == "TukuiConfigUItooltiphidecombat" then o = TukuiL.option_tooltip_hidecombat end
	if o == "TukuiConfigUItooltiphidebuttons" then o = TukuiL.option_tooltip_hidebutton end
	if o == "TukuiConfigUItooltiphideuf" then o = TukuiL.option_tooltip_hideuf end
	if o == "TukuiConfigUItooltipcursor" then o = TukuiL.option_tooltip_cursor end
	
	-- others
	if o == "TukuiConfigUIothers" then o = TukuiL.option_others end
	if o == "TukuiConfigUIotherspvpautorelease" then o = TukuiL.option_others_bg end
	
	-- reminder
	if o == "TukuiConfigUIbuffreminder" then o = TukuiL.option_reminder end
	if o == "TukuiConfigUIbuffreminderenable" then o = TukuiL.option_reminder_enable end
	if o == "TukuiConfigUIbuffremindersound" then o = TukuiL.option_reminder_sound end
	
	-- error
	if o == "TukuiConfigUIerror" then o = TukuiL.option_error end
	if o == "TukuiConfigUIerrorenable" then o = TukuiL.option_error_hide end
	
	-- action bar
	if o == "TukuiConfigUIactionbar" then o = TukuiL.option_actionbar end
	if o == "TukuiConfigUIactionbarhideshapeshift" then o = TukuiL.option_actionbar_hidess end
	if o == "TukuiConfigUIactionbarshowgrid" then o = TukuiL.option_actionbar_showgrid end
	if o == "TukuiConfigUIactionbarenable" then o = TukuiL.option_actionbar_enable end
	if o == "TukuiConfigUIactionbarrightbarmouseover" then o = TukuiL.option_actionbar_rb end
	if o == "TukuiConfigUIactionbarhotkey" then o = TukuiL.option_actionbar_hk end
	if o == "TukuiConfigUIactionbarshapeshiftmouseover" then o = TukuiL.option_actionbar_ssmo end
	if o == "TukuiConfigUIactionbarbottomrows" then o = TukuiL.option_actionbar_rbn end
	if o == "TukuiConfigUIactionbarrightbars" then o = TukuiL.option_actionbar_rn end
	if o == "TukuiConfigUIactionbarbuttonsize" then o = TukuiL.option_actionbar_buttonsize end
	if o == "TukuiConfigUIactionbarbuttonspacing" then o = TukuiL.option_actionbar_buttonspacing end
	if o == "TukuiConfigUIactionbarpetbuttonsize" then o = TukuiL.option_actionbar_petbuttonsize end
	
	-- quest watch frame
	if o == "TukuiConfigUIwatchframe" then o = TukuiL.option_quest end
	if o == "TukuiConfigUIwatchframemovable" then o = TukuiL.option_quest_movable end
	
	-- arena
	if o == "TukuiConfigUIarena" then o = TukuiL.option_arena end
	if o == "TukuiConfigUIarenaspelltracker" then o = TukuiL.option_arena_st end
	if o == "TukuiConfigUIarenaunitframes" then o = TukuiL.option_arena_uf end
	
	-- pvp
	if o == "TukuiConfigUIpvp" then o = TukuiL.option_pvp end
	if o == "TukuiConfigUIpvpinterrupt" then o = TukuiL.option_pvp_ii end
	
	-- cooldowns
	if o == "TukuiConfigUIcooldown" then o = TukuiL.option_cooldown end
	if o == "TukuiConfigUIcooldownenable" then o = TukuiL.option_cooldown_enable end
	if o == "TukuiConfigUIcooldowntreshold" then o = TukuiL.option_cooldown_th end
	
	-- chat
	if o == "TukuiConfigUIchat" then o = "Chat" end
	if o == "TukuiConfigUIchatenable" then o = TukuiL.option_chat_enable end
	if o == "TukuiConfigUIchatwhispersound" then o = TukuiL.option_chat_whispersound end
	if o == "TukuiConfigUIchatbackground" then o = TukuiL.option_chat_background end
	
	-- aura
	if o == "TukuiConfigUIauras" then o = TukuiL.option_auras end
	if o == "TukuiConfigUIaurasplayer" then o = TukuiL.option_auras_player end

	T.option = o
end

local NewButton = function(text,parent)
	local T, C, L = unpack(Tukui)
	
	local result = CreateFrame("Button", nil, parent)
	local label = result:CreateFontString(nil,"OVERLAY",nil)
	label:SetFont(C.media.font,12)
	label:SetText(text)
	result:SetWidth(label:GetWidth())
	result:SetHeight(label:GetHeight())
	result:SetFontString(label)
	
	result:SetScript("OnEnter", function() label:SetTextColor(unpack(C["datatext"].color)) end)
	result:SetScript("OnLeave", function() label:SetTextColor(1,1,1) end)

	return result
end

StaticPopupDialogs["PERCHAR"] = {
	text = TukuiL.option_perchar,
	OnAccept = function() 
		if TukuiConfigAllCharacters:GetChecked() then 
			TukuiConfigAll[myPlayerRealm][myPlayerName] = true
		else 
			TukuiConfigAll[myPlayerRealm][myPlayerName] = false
		end 	
		ReloadUI() 
	end,
	OnCancel = function() 
		TukuiConfigCover:Hide()
		if TukuiConfigAllCharacters:GetChecked() then 
			TukuiConfigAllCharacters:SetChecked(false)
		else 
			TukuiConfigAllCharacters:SetChecked(true)
		end 		
	end,
	button1 = ACCEPT,
	button2 = CANCEL,
	timeout = 0,
	whileDead = 1,
}

StaticPopupDialogs["RESET_PERCHAR"] = {
	text = TukuiL.option_resetchar,
	OnAccept = function() 
		TukuiConfig = TukuiConfigSettings
		ReloadUI() 
	end,
	OnCancel = function() if TukuiConfigUI and TukuiConfigUI:IsShown() then TukuiConfigCover:Hide() end end,
	button1 = ACCEPT,
	button2 = CANCEL,
	timeout = 0,
	whileDead = 1,
}

StaticPopupDialogs["RESET_ALL"] = {
	text = TukuiL.option_resetall,
	OnAccept = function() 
		TukuiConfigSettings = nil
		TukuiConfig = nil
		ReloadUI() 
	end,
	OnCancel = function() TukuiConfigCover:Hide() end,
	button1 = ACCEPT,
	button2 = CANCEL,
	timeout = 0,
	whileDead = 1,
}

-- We wanna make sure we have all needed tables when we try add values
local function SetValue(group,option,value)		
	--Determine if we should be copying our default settings to our player settings, this only happens if we're not using player settings by default
	local mergesettings
	if TukuiConfig == TukuiConfigSettings then
		mergesettings = true
	else
		mergesettings = false
	end

	if TukuiConfigAll[myPlayerRealm][myPlayerName] == true then
		if not TukuiConfig then TukuiConfig = {} end	
		if not TukuiConfig[group] then TukuiConfig[group] = {} end
		TukuiConfig[group][option] = value
	else
		--Set PerChar settings to the same as our settings if theres no per char settings
		if mergesettings == true then
			if not TukuiConfig then TukuiConfig = {} end	
			if not TukuiConfig[group] then TukuiConfig[group] = {} end
			TukuiConfig[group][option] = value
		end
		
		if not TukuiConfigSettings then TukuiConfigSettings = {} end
		if not TukuiConfigSettings[group] then TukuiConfigSettings[group] = {} end
		TukuiConfigSettings[group][option] = value
	end
end

local VISIBLE_GROUP = nil
local function ShowGroup(group)
	local T, C, L = unpack(Tukui)
	if(VISIBLE_GROUP) then
		_G["TukuiConfigUI"..VISIBLE_GROUP]:Hide()
	end
	if _G["TukuiConfigUI"..group] then
		local o = "TukuiConfigUI"..group
		Local(o)
		_G["TukuiConfigUITitle"]:SetText(T.panelcolor..T.option)
		local height = _G["TukuiConfigUI"..group]:GetHeight()
		_G["TukuiConfigUI"..group]:Show()
		local scrollamntmax = 305
		local scrollamntmin = scrollamntmax - 10
		local max = height > scrollamntmax and height-scrollamntmin or 1
		
		if max == 1 then
			_G["TukuiConfigUIGroupSlider"]:SetValue(1)
			_G["TukuiConfigUIGroupSlider"]:Hide()
		else
			_G["TukuiConfigUIGroupSlider"]:SetMinMaxValues(0, max)
			_G["TukuiConfigUIGroupSlider"]:Show()
			_G["TukuiConfigUIGroupSlider"]:SetValue(1)
		end
		_G["TukuiConfigUIGroup"]:SetScrollChild(_G["TukuiConfigUI"..group])
		
		local x
		if TukuiConfigUIGroupSlider:IsShown() then 
			_G["TukuiConfigUIGroup"]:EnableMouseWheel(true)
			_G["TukuiConfigUIGroup"]:SetScript("OnMouseWheel", function(self, delta)
				if TukuiConfigUIGroupSlider:IsShown() then
					if delta == -1 then
						x = _G["TukuiConfigUIGroupSlider"]:GetValue()
						_G["TukuiConfigUIGroupSlider"]:SetValue(x + 10)
					elseif delta == 1 then
						x = _G["TukuiConfigUIGroupSlider"]:GetValue()			
						_G["TukuiConfigUIGroupSlider"]:SetValue(x - 30)	
					end
				end
			end)
		else
			_G["TukuiConfigUIGroup"]:EnableMouseWheel(false)
		end		
		VISIBLE_GROUP = group
	end
end

function CreateTukuiConfigUI()
	local T, C, L = unpack(Tukui)
	
	if TukuiConfigUI then
		ShowGroup("general")
		TukuiConfigUI:Show()
		return
	end
	
	-- MAIN FRAME
	local TukuiConfigUI = CreateFrame("Frame","TukuiConfigUI",UIParent)
	TukuiConfigUI:SetPoint("CENTER", UIParent, "CENTER", 90, 0)
	TukuiConfigUI:SetWidth(550)
	TukuiConfigUI:SetHeight(300)
	TukuiConfigUI:SetFrameStrata("DIALOG")
	TukuiConfigUI:SetFrameLevel(20)
	
	-- TITLE 2
	local TukuiConfigUITitleBox = CreateFrame("Frame","TukuiConfigUI",TukuiConfigUI)
	TukuiConfigUITitleBox:SetWidth(570)
	TukuiConfigUITitleBox:SetHeight(24)
	TukuiConfigUITitleBox:SetPoint("TOPLEFT", -10, 42)
	TukuiConfigUITitleBox:SetTemplate("Default")
	TukuiConfigUITitleBox:CreateShadow("Default")
	
	local title = TukuiConfigUITitleBox:CreateFontString("TukuiConfigUITitle", "OVERLAY")
	title:SetFont(C.media.font, 12)
	title:SetPoint("LEFT", TukuiConfigUITitleBox, "LEFT", 10, 0)
		
	local TukuiConfigUIBG = CreateFrame("Frame","TukuiConfigUI",TukuiConfigUI)
	TukuiConfigUIBG:SetPoint("TOPLEFT", -10, 10)
	TukuiConfigUIBG:SetPoint("BOTTOMRIGHT", 10, -10)
	TukuiConfigUIBG:SetTemplate("Default")
	TukuiConfigUIBG:CreateShadow("Default")
	
	-- GROUP SELECTION ( LEFT SIDE )
	local groups = CreateFrame("ScrollFrame", "TukuiCatagoryGroup", TukuiConfigUI)
	groups:SetPoint("TOPLEFT",-180,0)
	groups:SetWidth(150)
	groups:SetHeight(300)

	local groupsBG = CreateFrame("Frame","TukuiConfigUI",TukuiConfigUI)
	groupsBG:SetPoint("TOPLEFT", groups, -10, 10)
	groupsBG:SetPoint("BOTTOMRIGHT", groups, 10, -10)
	groupsBG:SetTemplate("Default")
	groupsBG:CreateShadow("Default")
	
	--This is our frame we will use to prevent clicking on the config, before you choose a popup window
	local TukuiConfigCover = CreateFrame("Frame", "TukuiConfigCover", TukuiConfigUI)
	TukuiConfigCover:SetPoint("TOPLEFT", TukuiCatagoryGroup, "TOPLEFT")
	TukuiConfigCover:SetPoint("BOTTOMRIGHT", TukuiConfigUI, "BOTTOMRIGHT")
	TukuiConfigCover:SetFrameLevel(TukuiConfigUI:GetFrameLevel() + 20)
	TukuiConfigCover:EnableMouse(true)
	TukuiConfigCover:SetScript("OnMouseDown", function(self) print(TukuiL.option_makeselection) end)
	TukuiConfigCover:Hide()	
		
	local slider = CreateFrame("Slider", "TukuiConfigUICatagorySlider", groups)
	slider:SetPoint("TOPRIGHT", 0, 0)
	slider:SetWidth(20)
	slider:SetHeight(300)
	slider:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
	slider:SetOrientation("VERTICAL")
	slider:SetValueStep(20)
	slider:SetScript("OnValueChanged", function(self,value) groups:SetVerticalScroll(value) end)
	slider:SetTemplate("Default")
	local r,g,b,a = unpack(C["media"].bordercolor)
	slider:SetBackdropColor(r,g,b,0.2)
	local child = CreateFrame("Frame",nil,groups)
	child:SetPoint("TOPLEFT")
	local offset=5
	for group in pairs(ALLOWED_GROUPS) do
		local o = "TukuiConfigUI"..group
		Local(o)
		local button = NewButton(T.option, child)
		button:SetHeight(16)
		button:SetWidth(125)
		button:SetPoint("TOPLEFT", 5,-(offset))
		button:SetScript("OnClick", function(self) ShowGroup(group) end)
		offset=offset+20
	end
	child:SetWidth(125)
	child:SetHeight(offset)
	slider:SetMinMaxValues(0, (offset == 0 and 1 or offset-12*25))
	slider:SetValue(1)
	groups:SetScrollChild(child)
	
	local x
	_G["TukuiCatagoryGroup"]:EnableMouseWheel(true)
	_G["TukuiCatagoryGroup"]:SetScript("OnMouseWheel", function(self, delta)
		if _G["TukuiConfigUICatagorySlider"]:IsShown() then
			if delta == -1 then
				x = _G["TukuiConfigUICatagorySlider"]:GetValue()
				_G["TukuiConfigUICatagorySlider"]:SetValue(x + 10)
			elseif delta == 1 then
				x = _G["TukuiConfigUICatagorySlider"]:GetValue()			
				_G["TukuiConfigUICatagorySlider"]:SetValue(x - 20)	
			end
		end
	end)
	-- GROUP SCROLLFRAME ( RIGHT SIDE)
	local group = CreateFrame("ScrollFrame", "TukuiConfigUIGroup", TukuiConfigUI)
	group:SetPoint("TOPLEFT",0,5)
	group:SetWidth(550)
	group:SetHeight(300)
	local slider = CreateFrame("Slider", "TukuiConfigUIGroupSlider", group)
	slider:SetPoint("TOPRIGHT",0,0)
	slider:SetWidth(20)
	slider:SetHeight(300)
	slider:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
	slider:SetOrientation("VERTICAL")
	slider:SetValueStep(20)
	slider:SetTemplate("Default")
	local r,g,b,a = unpack(C["media"].bordercolor)
	slider:SetBackdropColor(r,g,b,0.2)
	slider:SetScript("OnValueChanged", function(self,value) group:SetVerticalScroll(value) end)
	
	for group in pairs(ALLOWED_GROUPS) do
		local frame = CreateFrame("Frame","TukuiConfigUI"..group,TukuiConfigUIGroup)
		frame:SetPoint("TOPLEFT")
		frame:SetWidth(325)
	
		local offset=5

		if type(C[group]) ~= "table" then error(group.." GroupName not found in config table.") return end
		for option,value in pairs(C[group]) do

			if type(value) == "boolean" then
				local button = CreateFrame("CheckButton", "TukuiConfigUI"..group..option, frame, "InterfaceOptionsCheckButtonTemplate")
				local o = "TukuiConfigUI"..group..option
				Local(o)
				_G["TukuiConfigUI"..group..option.."Text"]:SetText(T.option)
				_G["TukuiConfigUI"..group..option.."Text"]:SetFont(C.media.font, 12)
				button:SetChecked(value)
				button:SetScript("OnClick", function(self) SetValue(group,option,(self:GetChecked() and true or false)) end)
				button:SetPoint("TOPLEFT", 5, -(offset))
				offset = offset+25
			elseif type(value) == "number" or type(value) == "string" then
				local label = frame:CreateFontString(nil,"OVERLAY",nil)
				label:SetFont(C.media.font,12)
				local o = "TukuiConfigUI"..group..option
				Local(o)
				label:SetText(T.option)
				label:SetWidth(420)
				label:SetHeight(20)
				label:SetJustifyH("LEFT")
				label:SetPoint("TOPLEFT", 5, -(offset))
				
				local editbox = CreateFrame("EditBox", nil, frame)
				editbox:SetAutoFocus(false)
				editbox:SetMultiLine(false)
				editbox:SetWidth(280)
				editbox:SetHeight(20)
				editbox:SetMaxLetters(255)
				editbox:SetTextInsets(3,0,0,0)
				editbox:SetBackdrop({
					bgFile = [=[Interface\Addons\Tukui\media\textures\blank]=], 
					tiled = false,
				})
				editbox:SetBackdropColor(0,0,0,0.5)
				editbox:SetBackdropBorderColor(0,0,0,1)
				editbox:SetFontObject(GameFontHighlight)
				editbox:SetPoint("TOPLEFT", 5, -(offset+20))
				editbox:SetText(value)
				
				editbox:SetTemplate("Default")
				
				local okbutton = CreateFrame("Button", nil, frame)
				okbutton:SetHeight(editbox:GetHeight())
				okbutton:SetWidth(editbox:GetHeight())
				okbutton:SetTemplate("Default")
				okbutton:SetPoint("LEFT", editbox, "RIGHT", 2, 0)
				
				local oktext = okbutton:CreateFontString(nil,"OVERLAY",nil)
				oktext:SetFont(C.media.font,12)
				oktext:SetText("OK")
				oktext:SetPoint("CENTER", T.Scale(1), 0)
				oktext:SetJustifyH("CENTER")
				okbutton:Hide()
 
				if type(value) == "number" then
					editbox:SetScript("OnEscapePressed", function(self) okbutton:Hide() self:ClearFocus() self:SetText(value) end)
					editbox:SetScript("OnChar", function(self) okbutton:Show() end)
					editbox:SetScript("OnEnterPressed", function(self) okbutton:Hide() self:ClearFocus() SetValue(group,option,tonumber(self:GetText())) end)
					okbutton:SetScript("OnMouseDown", function(self) editbox:ClearFocus() self:Hide() SetValue(group,option,tonumber(editbox:GetText())) end)
				else
					editbox:SetScript("OnEscapePressed", function(self) okbutton:Hide() self:ClearFocus() self:SetText(value) end)
					editbox:SetScript("OnChar", function(self) okbutton:Show() end)
					editbox:SetScript("OnEnterPressed", function(self) okbutton:Hide() self:ClearFocus() SetValue(group,option,tostring(self:GetText())) end)
					okbutton:SetScript("OnMouseDown", function(self) editbox:ClearFocus() self:Hide() SetValue(group,option,tostring(editbox:GetText())) end)
				end
				offset = offset+45
			elseif type(value) == "table" and not TableFilter[option] then
				local label = frame:CreateFontString(nil,"OVERLAY",nil)
				label:SetFont(C.media.font,12)
				local o = "TukuiConfigUI"..group..option
				Local(o)
				label:SetText(T.option)
				label:SetWidth(420)
				label:SetHeight(20)
				label:SetJustifyH("LEFT")
				label:SetPoint("TOPLEFT", 5, -(offset))
				
				colorbuttonname = (label:GetText().."ColorPicker")
				local colorbutton = CreateFrame("Button", colorbuttonname, frame)
				colorbutton:SetHeight(20)
				colorbutton:SetWidth(50)
				colorbutton:SetTemplate("Default")
				colorbutton:SetBackdropColor(unpack(value))
				colorbutton:SetPoint("LEFT", label, "RIGHT", 2, 0)
				local colortext = colorbutton:CreateFontString(nil,"OVERLAY",nil)
				colortext:SetFont(C.media.font,12)
				colortext:SetText("Set Color")
				colortext:SetPoint("LEFT", colorbutton, "RIGHT", 3, 0)
				colortext:SetJustifyH("CENTER")
				
				
				local function round(number, decimal)
					return (("%%.%df"):format(decimal)):format(number)
				end	
				
				colorbutton:SetScript("OnMouseDown", function(button) 
					if ColorPickerFrame:IsShown() then return end
					local oldr, oldg, oldb, olda = unpack(value)

					local function ShowColorPicker(r, g, b, a, changedCallback, sameCallback)
						HideUIPanel(ColorPickerFrame)
						ColorPickerFrame.button = button
						ColorPickerFrame:SetColorRGB(r,g,b)
						ColorPickerFrame.hasOpacity = (a ~= nil and a < 1)
						ColorPickerFrame.opacity = a
						ColorPickerFrame.previousValues = {oldr, oldg, oldb, olda}
						ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = changedCallback, changedCallback, sameCallback;
						ShowUIPanel(ColorPickerFrame)
					end
										
					local function ColorCallback(restore)
						-- Something change
						if restore ~= nil or button ~= ColorPickerFrame.button then return end

						local newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB()
						
						value = { newR, newG, newB, newA }
						SetValue(group,option,(value)) 
						button:SetBackdropColor(newR, newG, newB, newA)	
					end
					
					local function SameColorCallback()
						value = { oldr, oldg, oldb, olda }
						SetValue(group,option,(value))
						button:SetBackdropColor(oldr, oldg, oldb, olda)
					end
										
					ShowColorPicker(oldr, oldg, oldb, olda, ColorCallback, SameColorCallback)
				end)
				
				offset = offset+25
			end
		end
				
		frame:SetHeight(offset)
		frame:Hide()
	end

	local reset = NewButton(TukuiL.option_button_reset, TukuiConfigUI)
	reset:SetWidth(100)
	reset:SetHeight(20)
	reset:SetPoint("BOTTOMLEFT",-10, -38)
	reset:SetScript("OnClick", function(self) 
		TukuiConfigCover:Show()
		if TukuiConfigAll[myPlayerRealm][myPlayerName] == true then
			StaticPopup_Show("RESET_PERCHAR")
		else
			StaticPopup_Show("RESET_ALL")
		end
	end)
	reset:SetTemplate("Default")
	reset:CreateShadow("Default")
	
	local close = NewButton(TukuiL.option_button_close, TukuiConfigUI)
	close:SetWidth(100)
	close:SetHeight(20)
	close:SetPoint("BOTTOMRIGHT", 10, -38)
	close:SetScript("OnClick", function(self) TukuiConfigUI:Hide() end)
	close:SetTemplate("Default")
	close:CreateShadow("Default")
	
	local load = NewButton(TukuiL.option_button_load, TukuiConfigUI)
	load:SetHeight(20)
	load:SetPoint("LEFT", reset, "RIGHT", 15, 0)
	load:SetPoint("RIGHT", close, "LEFT", -15, 0)
	load:SetScript("OnClick", function(self) ReloadUI() end)
	load:SetTemplate("Default")
	load:CreateShadow("Default")
	
	if TukuiConfigAll then
		local button = CreateFrame("CheckButton", "TukuiConfigAllCharacters", TukuiConfigUITitleBox, "InterfaceOptionsCheckButtonTemplate")
		
		button:SetScript("OnClick", function(self) StaticPopup_Show("PERCHAR") TukuiConfigCover:Show() end)
		
		button:SetPoint("RIGHT", TukuiConfigUITitleBox, "RIGHT",-3, 0)	
		
		local label = TukuiConfigAllCharacters:CreateFontString(nil,"OVERLAY",nil)
		label:SetFont(C.media.font,12)
		
		label:SetText(TukuiL.option_setsavedsetttings)
		label:SetPoint("RIGHT", button, "LEFT")
		
		if TukuiConfigAll[myPlayerRealm][myPlayerName] == true then
			button:SetChecked(true)
		else
			button:SetChecked(false)
		end
	end	
	
	ShowGroup("general")
end

do
	SLASH_CONFIG1 = '/tc'
	SLASH_CONFIG2 = '/tukui'
	function SlashCmdList.CONFIG(msg, editbox)
		if not TukuiConfigUI or not TukuiConfigUI:IsShown() then
			CreateTukuiConfigUI()
		else
			TukuiConfigUI:Hide()
		end
	end
	
	SLASH_RESETCONFIG1 = '/resetconfig'
	function SlashCmdList.RESETCONFIG()
		if TukuiConfigUI and TukuiConfigUI:IsShown() then TukuiConfigCover:Show() end
		
		if TukuiConfigAll[myPlayerRealm][myPlayerName] == true then
			StaticPopup_Show("RESET_PERCHAR")
		else
			StaticPopup_Show("RESET_ALL")
		end	
	end
end