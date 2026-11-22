-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_job_setup()
	-- Options: Override default values
    state.OffenseMode:options('Normal','SomeAcc','Acc','FullAcc','Fodder')
    state.WeaponskillMode:options('Match','Normal','SomeAcc','Acc','FullAcc','Fodder')
    state.HybridMode:options('Normal')
    state.PhysicalDefenseMode:options('PDT', 'PDTReraise')
    state.MagicalDefenseMode:options('MDT', 'MDTReraise')
	state.ResistDefenseMode:options('MEVA')
	state.IdleMode:options('Normal', 'PDT','Refresh','Reraise')
    state.ExtraMeleeMode = M{['description']='Extra Melee Mode','None'}
	state.Weapons:options('Gungnir','club')
	state.Passive = M{['description'] = 'Passive Mode','None','MP','Twilight'}

	autows = 'Geirskogul'
	autofood = 'Red Curry Bun'
	--autofood = 'Sublime Sushi'

	set_lockstyle()
    select_default_macro_book()
	
	-- Additional local binds
	send_command('bind ^` input /ja "Hasso" <me>')
	send_command('bind !` input /ja "Seigan" <me>')
	send_command('bind ^f11 gs c cycle MagicalDefenseMode')
	send_command('bind @f7 gs c toggle AutoJumpMode')
	send_command('bind @` gs c cycle SkillchainMode')
	send_command('bind ^\\\\ input /ma "Protectra V" <me>')
	send_command('bind @\\\\ input /ma "Shellra V" <me>')
	send_command('bind !\\\\ input /ma "Reraise IV" <me>')
	send_command('bind !@^` gs c cycle Stance')
	send_command('bind @f1 gs c toggle AutoBreathMode')
		
end

-- Define sets and vars used by this job file.
function init_gear_sets()
	--------------------------------------
	-- Start defining the sets
	--------------------------------------
	
	-- Precast Sets
	-- Precast sets to enhance JAs
	sets.precast.JA.Angon = {ammo="Angon",hands="Ptero. Fin. G. +3"} --hands="Ptero. Fin. G. +3"
	sets.precast.JA.Jump = {ammo="Ginsen",
		head="Flam. Zucchetto +2",neck="Ganesha's Mala",ear1="Brutal Earring",ear2="Sherida Earring",
		body="Pteroslaver Mail +3",hands=gear.valorous_acc_hands,ring1="Petrov Ring",ring2="Niqmaddu Ring",
		back="Brigantia's Mantle",waist="Windbuffet Belt +1",legs="Vishap Brais +3",feet="Vishap Greaves +3"}
	sets.precast.JA['Ancient Circle'] = {legs="Vishap Brais +3"} --legs="Vishap Brais +3"
	sets.precast.JA['High Jump'] = {ammo="Ginsen",
		head="Flam. Zucchetto +2",neck="Ganesha's Mala",ear1="Brutal Earring",ear2="Sherida Earring",
		body="Pteroslaver Mail +3",hands=gear.valorous_acc_hands,ring1="Petrov Ring",ring2="Niqmaddu Ring",
		back="Brigantia's Mantle",waist="Windbuffet Belt +1",legs="Vishap Brais +3",feet="Vishap Greaves +3"}
	sets.precast.JA['Soul Jump'] = {ammo="Ginsen",
		head="Flam. Zucchetto +2",neck="Ganesha's Mala",ear1="Brutal Earring",ear2="Sherida Earring",
		body="Pteroslaver Mail +3",hands=gear.valorous_acc_hands,ring1="Petrov Ring",ring2="Niqmaddu Ring",
		back="Brigantia's Mantle",waist="Windbuffet Belt +1",legs="Vishap Brais +3",feet="Vishap Greaves +3"}
	sets.precast.JA['Spirit Jump'] = {ammo="Ginsen",
		head="Flam. Zucchetto +2",neck="Ganesha's Mala",ear1="Brutal Earring",ear2="Sherida Earring",
		body="Pteroslaver Mail +3",hands=gear.valorous_acc_hands,ring1="Petrov Ring",ring2="Niqmaddu Ring",
		back="Brigantia's Mantle",waist="Windbuffet Belt +1",legs="Vishap Brais +3",feet="Vishap Greaves +3"}
	sets.precast.JA['Super Jump'] = {}
	sets.precast.JA['Spirit Link'] = {head="Vishap Armet +2",feet="Pteroslaver Greaves +3"} --head="Vishap Armet +2",hands="Lnc. Vmbrc. +2"
	sets.precast.JA['Call Wyvern'] = {body="Pteroslaver Mail +3",neck="Dragoon's Collar +2"} --body=""Pteroslaver Mail +3""
	sets.precast.JA['Deep Breathing'] = {head="Ptero. Armet +3"} --head="Ptero. Armet +3"
	sets.precast.JA['Spirit Surge'] = {body="Pteroslaver Mail +3"} --body=""Pteroslaver Mail +3""
	sets.precast.JA['Steady Wing'] = {}
	
	-- Breath sets
	sets.precast.JA['Restoring Breath'] = {head="Ptero. Armet +3",back="Brigantia's Mantle"}
	sets.precast.JA['Smiting Breath'] = {head="Ptero. Armet +3",back="Brigantia's Mantle"}
	sets.HealingBreath = {head="Ptero. Armet +3",back="Brigantia's Mantle"}
	sets.SmitingBreath = {head="Ptero. Armet +3",back="Brigantia's Mantle",legs="Pteroslaver Brais +1"}

	-- Fast cast sets for spells
	
	sets.precast.FC = {ammo="Impatiens",
		head="Carmine Mask +1",neck="Voltsurge Torque",ear1="Etiolation Earring",ear2="Moonshade Earring",
		body="Taeon Tabard",hands="Leyline Gloves",ring1="Lebeche Ring",ring2="Prolix Ring",
		back="Moonbeam Cape",waist="Flume Belt +1",legs="Founder's Hose",feet="Carmine Greaves +1"} -- [2026-11-22 Fix] Was: legs="Founder's Greaves" (feet item in legs slot)
	
	-- Waltz set (chr and vit)
	sets.precast.Waltz = {}
		
	-- Don't need any special gear for Healing Waltz.
	sets.precast.Waltz['Healing Waltz'] = {}

	sets.midcast.Cure = {}
	
	sets.Self_Healing = {neck="Phalaina Locket",hands="Buremte Gloves",ring1="Vocane Ring",waist="Gishdubar Sash",ring2="Kunaji Ring"} -- [2026-11-22 Fix] Was: duplicate ring2= (ring2="Kunaji Ring",...,ring2="Vocane Ring")
	sets.Cure_Received = {neck="Phalaina Locket",hands="Buremte Gloves",ring1="Vocane Ring",waist="Gishdubar Sash",ring2="Kunaji Ring"} -- [2026-11-22 Fix] Was: duplicate ring2= (ring2="Kunaji Ring",...,ring2="Vocane Ring")
	sets.Self_Refresh = {waist="Gishdubar Sash"}
	
	-- Midcast Sets
	sets.midcast.FastRecast = {ammo="Staunch Tathlum +1",
		head="Carmine Mask +1",neck="Voltsurge Torque",ear1="Enchntr. Earring +1",ear2="Loquac. Earring",
		body="Taeon Tabard",hands="Leyline Gloves",ring1="Lebeche Ring",ring2="Prolix Ring",
		back="Moonbeam Cape",waist="Tempus Fugit",legs="Founder's Hose",feet="Carmine Greaves +1"} -- [2026-11-22 Fix] Was: legs="Founder's Greaves" (feet item in legs slot)
		
	-- Put HP+ gear and the AF head to make healing breath trigger more easily with this set.
	sets.midcast.HB_Trigger = set_combine(sets.midcast.FastRecast, {head="Vishap Armet +2", back="Moonbeam Cape"})
	
	-- Weaponskill sets

	-- Default set for any weaponskill that isn't any more specifically defined
	
	sets.precast.WS = {ammo="Knobkierrie",
		head="Flam. Zucchetto +2",neck="Fotia Gorget",ear1="Brutal Earring",ear2="Sherida Earring", -- [2026-11-22 Fix] Was: "Brutal Earing"
		body=gear.valorous_wsd_body,hands="Sulev. Gauntlets +2",ring1="Regal Ring",ring2="Niqmaddu Ring",
		back="Brigantia's Mantle",waist="Fotia Belt",legs="Vishap Brais +3",feet="Flam. Gambieras +2"}
		
	sets.precast.WS.SomeAcc = set_combine(sets.precast.WS, {})
	sets.precast.WS.Acc = set_combine(sets.precast.WS, {neck="Shulmanu Collar"})
	sets.precast.WS.FullAcc = set_combine(sets.precast.WS, {back="Vespid Mantle",ring2="Rufescent Ring",neck="Fotia Gorget"})
	sets.precast.WS.Fodder = set_combine(sets.precast.WS, {})
	
	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS['Stardiver'] = set_combine(sets.precast.WS, {neck="Fotia Gorget",waist="Fotia Belt"})
	sets.precast.WS['Stardiver'].SomeAcc = set_combine(sets.precast.WS.Acc, {neck="Fotia Gorget",waist="Fotia Belt"})
	sets.precast.WS['Stardiver'].Acc = set_combine(sets.precast.WS.Acc, {neck="Fotia Gorget",waist="Fotia Belt"})
	sets.precast.WS['Stardiver'].Fodder = set_combine(sets.precast.WS.Fodder, {neck="Fotia Gorget",waist="Fotia Belt"})

	sets.precast.WS['Drakesbane'] = set_combine(sets.precast.WS, {})
	sets.precast.WS['Drakesbane'].SomeAcc = set_combine(sets.precast.WS.Acc, {})
	sets.precast.WS['Drakesbane'].Acc = set_combine(sets.precast.WS.Acc, {})
	sets.precast.WS['Drakesbane'].Fodder = set_combine(sets.precast.WS.Fodder, {})

	sets.precast.WS['Geirskogul'] = set_combine(sets.precast.WS, {ring2="Rufescent Ring",hands="Pteroslaver Finger Gauntlets +3",ear2="Ishvara Earring",feet="Sulev. Leggings +2"})
	sets.precast.WS['Geirskogul'].SomeAcc = set_combine(sets.precast.WS.Acc, {ring2="Rufescent Ring",hands="Pteroslaver Finger Gauntlets +3",ear2="Ishvara Earring",feet="Sulev. Leggings +2"})
	sets.precast.WS['Geirskogul'].Acc = set_combine(sets.precast.WS.Acc, {ring2="Rufescent Ring",hands="Pteroslaver Finger Gauntlets +3",ear2="Ishvara Earring",feet="Sulev. Leggings +2"})
	sets.precast.WS['Geirskogul'].Fodder = set_combine(sets.precast.WS.Fodder, {ring2="Rufescent Ring",hands="Pteroslaver Finger Gauntlets +3",ear2="Ishvara Earring",feet="Sulev. Leggings +2"})


	
	-- Sets to return to when not performing an action.
	
	-- Resting sets
	sets.resting = {}

	-- Idle sets
	sets.idle = {ammo="Focal Orb",
		head="Pteroslaver Armet +3",neck="Dragoon's Collar +2",ear1="Brutal Earring",ear2="Ethereal Earring",
		body="Pteroslaver Mail +3",hands="Pteroslaver Finger Gauntlets +3",ring1="Vocane Ring",ring2="Rajas Ring",
		back="Brigantia's Mantle",waist="Flume belt +1",legs="Crimson Cuisses",feet="Pteroslaver Greaves +3"}
		
	sets.idle.Refresh = {ammo="Knobkierrie",
		head="Pteroslaver Armet +3",neck="Dragoon's Collar +2",ear1="Brutal Earring",ear2="Ethereal Earring",
		body="Pteroslaver Mail +3",hands="Pteroslaver Finger Gauntlets +3",ring1="Vocane Ring",ring2="Rajas Ring",
		back="Brigantia's Mantle",waist="Flume belt +1",legs="Crimson Cuisses",feet="Pteroslaver Greaves +3"}

	sets.idle.Weak = set_combine(sets.idle, {head="Twilight Helm",body="Twilight Mail"})
		
	sets.idle.Reraise = set_combine(sets.idle, {head="Twilight Helm",body="Twilight Mail"})
	
	-- Defense sets
	sets.defense.PDT = {ammo="Staunch Tathlum +1",
		head="Loess Barbuta +1",neck="Loricate Torque +1",ear1="Genmei Earring",ear2="Ethereal Earring",
		body="Hjarrandi Breastplate",hands="Sulev. Gauntlets +2",ring1="Vocane Ring",ring2="Defending Ring",
		back="Moonbeam Cape",waist="Flume Belt +1",legs="Arke Cosc. +1",feet="Amm Greaves"}
		
	sets.defense.PDTReraise = set_combine(sets.defense.PDT, {head="Twilight Helm",body="Twilight Mail"})

	sets.defense.MDT = {ammo="Staunch Tathlum +1",
		head="Loess Barbuta +1",neck="Warder's Charm +1",ear1="Etiolation Earring",ear2="Ethereal Earring",
		body="Hjarrandi Breastplate",hands="Sulev. Gauntlets +2",ring1="Vocane Ring",ring2="Defending Ring",
		back="Moonbeam Cape",waist="Windbuffet Belt +1",legs="Arke Cosc. +1",feet="Amm Greaves"}
		
	sets.defense.MDTReraise = set_combine(sets.defense.MDT, {head="Twilight Helm",body="Twilight Mail"})
		
	sets.defense.MEVA = {ammo="Staunch Tathlum +1",
		head="Loess Barbuta +1",neck="Warder's Charm +1",ear1="Genmei Earring",ear2="Ethereal Earring",
		body="Tartarus Platemail",hands="Sulev. Gauntlets +2",ring1="Moonbeam Ring",ring2="Moonlight Ring",
		back="Moonbeam Cape",waist="Flume Belt +1",legs="Arke Cosc. +1",feet="Amm Greaves"}

	sets.Kiting = {legs="Carmine Cuisses +1"}
	sets.Reraise = {head="Twilight Helm",body="Twilight Mail"}
	sets.buff.Doom = set_combine(sets.buff.Doom, {})
	sets.buff.Sleep = {head="Frenzy Sallet"}
	
    -- Extra defense sets.  Apply these on top of melee or defense sets.
    sets.passive.MP = {ear2="Ethereal Earring",waist="Flume Belt +1"}
    sets.passive.Twilight = {head="Twilight Helm", body="Twilight Mail"}
	sets.TreasureHunter = set_combine(sets.TreasureHunter, {})
	
	-- Weapons sets
	-- sets.weapons.Trishula = {main="Trishula",sub="Utu Grip"}
	sets.weapons.Gungnir = {main="Gungnir",sub="Utu Grip"}
	sets.weapons.club = {main="Dream Bell"}

	-- Swap to these on Moonshade using WS if at 3000 TP
	sets.MaxTP = {ear1="Lugra Earring +1",ear2="Sherida Earring",}
	sets.AccMaxTP = {ear1="Mache Earring +1",ear2="Telos Earring"}
	sets.AccDayMaxTPWSEars = {ear1="Mache Earring +1",ear2="Telos Earring"}
	sets.DayMaxTPWSEars = {ear1="Brutal Earring",ear2="Sherida Earring",}
	sets.AccDayWSEars = {ear1="Mache Earring +1",ear2="Telos Earring"}
	sets.DayWSEars = {ear1="Moonshade Earring",ear2="Sherida Earring",}
	
	-- Engaged sets

	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion
	
	-- Normal melee group


	if player.sub_job == 'WHM' or player.sub_job == 'RDM' or player.sub_job == 'BLU' then
		gear.DRGEar2={name="Ethereal Earring"}
	else
		gear.DRGEar2={name="Mache Earring +1"}
	end


	sets.engaged = {ammo="Focal Orb",
		head="Pteroslaver Armet +3",neck="Dragoon's Collar +2",ear1="Brutal Earring",ear2=gear.DRGEar2,
		body="Pteroslaver Mail +3",hands="Sulevia's Gauntlets +2",ring1="Vocane Ring",ring2="Rajas Ring",
		back="Brigantia's Mantle",waist="Windbuffet Belt +1",legs="Sulev. Cuisses +2",feet="Flam. Gambieras +2"}
    sets.engaged.SomeAcc = {ammo="Knobkierrie",
		head="Flam. Zucchetto +2",neck="Shulmanu Collar",ear1="Brutal Earring",ear2=gear.DRGEar2,
		body=gear.valorous_wsd_body,hands=gear.valorous_acc_hands,ring1="Regal Ring",ring2="Niqmaddu Ring",
		back="Brigantia's Mantle",waist="Ioskeha Belt",legs="Sulev. Cuisses +2",feet="Flam. Gambieras +2"}
	sets.engaged.Acc = {ammo="Ginsen",
		head="Flam. Zucchetto +2",neck="Shulmanu Collar",ear1="Digni. Earring",ear2=gear.DRGEar2,
		body=gear.valorous_wsd_body,hands=gear.valorous_acc_hands,ring1="Ramuh Ring +1",ring2="Niqmaddu Ring",
		back="Brigantia's Mantle",waist="Ioskeha Belt",legs="Sulev. Cuisses +2",feet="Flam. Gambieras +2"}
    sets.engaged.FullAcc = {ammo="Ginsen",
		head="Flam. Zucchetto +2",neck="Shulmanu Collar",ear1="Mache Earring +1",ear2=gear.DRGEar2,
		body=gear.valorous_wsd_body,hands=gear.valorous_acc_hands,ring1="Ramuh Ring +1",ring2="Ramuh Ring +1",
		back="Brigantia's Mantle",waist="Ioskeha Belt",legs="Sulev. Cuisses +2",feet="Flam. Gambieras +2"}
    sets.engaged.Fodder = {ammo="Ginsen",
		head="Flam. Zucchetto +2",neck="Ganesha's Mala",ear1="Brutal Earring",ear2="Sherida Earring",
		body=gear.valorous_wsd_body,hands=gear.valorous_acc_hands,ring1="Petrov Ring",ring2="Niqmaddu Ring",
		back="Brigantia's Mantle",waist="Ioskeha Belt",legs="Sulev. Cuisses +2",feet="Flam. Gambieras +2"}

    sets.engaged.AM = {}
    sets.engaged.AM.SomeAcc = {}
	sets.engaged.AM.Acc = {}
    sets.engaged.AM.FullAcc = {}
    sets.engaged.AM.Fodder = {}
	
    sets.engaged.PDT = {}
    sets.engaged.SomeAcc.PDT = {}
	sets.engaged.Acc.PDT = {}
    sets.engaged.FullAcc.PDT = {}
    sets.engaged.Fodder.PDT = {}
	
    sets.engaged.AM.PDT = {}
    sets.engaged.AM.SomeAcc.PDT = {}
	sets.engaged.AM.Acc.PDT = {}
    sets.engaged.AM.FullAcc.PDT = {}
    sets.engaged.AM.Fodder.PDT = {}
		
	--[[ Melee sets for in Adoulin, which has an extra 2% Haste from Ionis.
	
    sets.engaged.Adoulin = {}
    sets.engaged.Adoulin.SomeAcc = {}
	sets.engaged.Adoulin.Acc = {}
    sets.engaged.Adoulin.FullAcc = {}
    sets.engaged.Adoulin.Fodder = {}

    sets.engaged.Adoulin.AM = {}
    sets.engaged.Adoulin.AM.SomeAcc = {}
	sets.engaged.Adoulin.AM.Acc = {}
    sets.engaged.Adoulin.AM.FullAcc = {}
    sets.engaged.Adoulin.AM.Fodder = {}
	
    sets.engaged.Adoulin.PDT = {}
    sets.engaged.Adoulin.SomeAcc.PDT = {}
	sets.engaged.Adoulin.Acc.PDT = {}
    sets.engaged.Adoulin.FullAcc.PDT = {}
    sets.engaged.Adoulin.Fodder.PDT = {}
	
    sets.engaged.Adoulin.AM.PDT = {}
    sets.engaged.Adoulin.AM.SomeAcc.PDT = {}
	sets.engaged.Adoulin.AM.Acc.PDT = {}
    sets.engaged.Adoulin.AM.FullAcc.PDT = {}
    sets.engaged.Adoulin.AM.Fodder.PDT = {}
	]]



end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
        set_macro_page(9, 1)
    elseif player.sub_job == 'SAM' then
        set_macro_page(9, 1)
    elseif player.sub_job == 'BLU' then
        set_macro_page(9, 1)
    else
        set_macro_page(9, 1)
    end

end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset 3')--regular 3
end


state.AutoBreathMode = M(true, 'Auto Breath Mode')



function check_breath()
	use_equipment_items()
    
	-- [2026-11-22 Fix] Was: returned false on first nil mob / 0 hpp / idle check instead of continuing loop, used unsquared distances (14, 6.25), unquoted buffactive[amnesia], and lacked post-loop return false
	for i=1,party.count do
		if state.AutoBreathMode.value and player.status == 'Engaged' and pet.isvalid and party[i] and party[i].mob and party[i].hpp > 0 and party[i].mob.distance < 196 and (party[i].hpp < Breath_HPP - 15 or pet.hpp < 50) then -- [2026-11-22 Fix] Was: party[i].mob.distance < 14 (unsquared) and missing party[i]/mob/hpp > 0 guards
			local abil_recasts = windower.ffxi.get_ability_recasts()
			local spell_recasts = windower.ffxi.get_spell_recasts()
			
			if abil_recasts[164] < latency and party[i].hpp < 30 and pet.distance < 36 and not buffactive['Amnesia'] then -- [2026-11-22 Fix] Was: pet.distance < 6.25 and not buffactive[amnesia]
				windower.chat.input('/ja "Deep Breathing" <me>')
				tickdelay = os.clock() + 1.1
				return true
			elseif abil_recasts[149] < latency and pet.distance < 36 and not buffactive['Amnesia'] then -- [2026-11-22 Fix] Was: pet.distance < 6.25 and not buffactive[amnesia]
				windower.chat.input('/ja "Spirit Bond" <me>')
				tickdelay = os.clock() + 1.1
				return true
			elseif abil_recasts[239] < latency and not buffactive['Amnesia'] then -- [2026-11-22 Fix] Was: not buffactive[amnesia]
				windower.chat.input('/ja "Restoring Breath" <me>')
				tickdelay = os.clock() + 5.1
				return true
			elseif spell_recasts[23] < spell_latency and (player.sub_job == 'WHM' or player.sub_job == 'RDM') then
				windower.chat.input('/ma "Dia" <t>')
				tickdelay = os.clock() + 1.1
				return true
			end
        end
    end
	return false
end






--use highpotion tanks up

res = require('resources')
extdata = require('extdata')
 
-- Item must be equipped for it to return any meaningful value.
function is_enchant_ready(--[[name of item]]item_name) -- [2026-11-22 Fix] Was: parameter `item` (shadowed by `local item_id, item = ...`)
    local item_id, item = res.items:find(function(v) if v.name == item_name then return true end end) -- [2026-11-22 Fix] Was: v.name == item
    local inventory = windower.ffxi.get_items()
    local usable_bags = T{'inventory','wardrobe','wardrobe2','wardrobe3','wardrobe4','wardrobe5','wardrobe6','wardrobe7','wardrobe8'} -- [2026-11-22 Fix] Was: missing wardrobe5..8
    local itemdata = {}
     
    for i,v in pairs(inventory) do
        if usable_bags:contains(i) then
            for key,val in pairs(v) do
                if type(val) == 'table' and val.id == item_id then
                    itemdata = extdata.decode(val)
                end
            end
        end
    end
     
    if itemdata and itemdata.charges_remaining then
        if itemdata.activation_time - itemdata.next_use_time > item.cast_delay then
            return true
        end
    end
    return false
end
 
function has_charges(--[[name of item]]item_name) -- [2026-11-22 Fix] Was: parameter `item` (shadowed by `local item_id, item = ...`)
    local item_id, item = res.items:find(function(v) if v.name == item_name then return true end end) -- [2026-11-22 Fix] Was: v.name == item
    local inventory = windower.ffxi.get_items()
    local bags = T{'inventory','safe','safe2','storage','satchel','locker','sack','case','wardrobe','wardrobe2','wardrobe3','wardrobe4','wardrobe5','wardrobe6','wardrobe7','wardrobe8'} -- [2026-11-22 Fix] Was: missing wardrobe5..8
    local itemdata = {}
     
    for i,v in pairs(inventory) do
        if bags:contains(i) then
            for key,val in pairs(v) do
                if type(val) == 'table' and val.id == item_id then
                    itemdata = extdata.decode(val)
                end
            end
        end
    end
     
    if itemdata and itemdata.charges_remaining then
        if itemdata.charges_remaining > 0 then
            return true
        end
    end
    return false
end


function use_equipment_items()
	local lockables = {"Moogle's Largesse","Moggiebag","Hi-Potion Tank","Ether Tank"}
	
	for _,useItemName in pairs(lockables) do
		--windowner.chat.input('"'..useItemName..'"')
		if data.areas.cities:contains(world.area) and has_charges(useItemName) then
		
			windower.chat.input('/console gs c useitem back "'..useItemName..'"') -- [2026-11-22 Fix] Was: hardcoded "Hi-Potion Tank"
			
		end
	end
end