-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_job_setup()
	-- Options: Override default values
    state.OffenseMode:options('Normal','SomeAcc','Acc','FullAcc','Fodder','Hybrid')
    state.WeaponskillMode:options('Match','Normal','SomeAcc','Acc','FullAcc','Fodder')
    state.HybridMode:options('Normal')
    state.PhysicalDefenseMode:options('PDT', 'PDTReraise')
    state.MagicalDefenseMode:options('MDT', 'MDTReraise')
	state.ResistDefenseMode:options('MEVA')
	state.IdleMode:options('Normal', 'PDT','Refresh','Reraise')
    state.ExtraMeleeMode = M{['description']='Extra Melee Mode','None'}
	state.Weapons:options('Trishula','Gungnir','Naegling','Staff')
	state.Passive = M{['description'] = 'Passive Mode','None','MP','Twilight'}

	--autows = 'Geirskogul'
	autows = 'Stardiver'
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
		head="Flam. Zucchetto +2",neck="Ganesha's Mala",ear1="Telos Earring",ear2="Sherida Earring",
		body="Pteroslaver Mail +3",hands="Vis. Fng. Gaunt. +3",ring1="Petrov Ring",ring2="Niqmaddu Ring",
		back="Brigantia's Mantle",waist="Windbuffet Belt +1",legs="Vishap Brais +3",feet="Vishap Greaves +3"}
	sets.precast.JA['Ancient Circle'] = {legs="Vishap Brais +3"} --legs="Vishap Brais +3"
	sets.precast.JA['High Jump'] = {ammo="Ginsen",
		head="Flam. Zucchetto +2",neck="Ganesha's Mala",ear1="Telos Earring",ear2="Sherida Earring",
		body="Pteroslaver Mail +3",hands="Vis. Fng. Gaunt. +3",ring1="Petrov Ring",ring2="Niqmaddu Ring",
		back="Brigantia's Mantle",waist="Windbuffet Belt +1",legs="Vishap Brais +3",feet="Vishap Greaves +3"}
	sets.precast.JA['Soul Jump'] = {ammo="Ginsen",
		head="Flam. Zucchetto +2",neck="Ganesha's Mala",ear1="Telos Earring",ear2="Sherida Earring",
		body="Pteroslaver Mail +3",hands="Vis. Fng. Gaunt. +3",ring1="Petrov Ring",ring2="Niqmaddu Ring",
		back="Brigantia's Mantle",waist="Windbuffet Belt +1",legs="Vishap Brais +3",feet="Vishap Greaves +3"}
	sets.precast.JA['Spirit Jump'] = {ammo="Ginsen",
		head="Flam. Zucchetto +2",neck="Ganesha's Mala",ear1="Telos Earring",ear2="Sherida Earring",
		body="Pteroslaver Mail +3",hands="Vis. Fng. Gaunt. +3",ring1="Petrov Ring",ring2="Niqmaddu Ring",
		back="Brigantia's Mantle",waist="Windbuffet Belt +1",legs="Vishap Brais +3",feet="Vishap Greaves +3"}
	sets.precast.JA['Super Jump'] = {}
	sets.precast.JA['Spirit Link'] = {head="Vishap Armet +3",ear1="Pratik Earring",feet="Pteroslaver Greaves +3"} --head="Vishap Armet +3",hands="Lnc. Vmbrc. +2",earing = "Pratik Earring"
	sets.precast.JA['Call Wyvern'] = {body="Pteroslaver Mail +3",neck="Dragoon's Collar +2"} --body=""Pteroslaver Mail +3""
	sets.precast.JA['Deep Breathing'] = {head="Ptero. Armet +3"} --head="Ptero. Armet +3"
	sets.precast.JA['Steady Wing'] = {ear1="Lancer's Earring",legs ="Vishap Brais +3",feet="Ptero. Greaves +3"}
	sets.precast.JA['Spirit Surge'] = set_combine(sets.precast.JA['Steady Wing'],{body="Pteroslaver Mail +3"})--body=""Pteroslaver Mail +3""
	--+
	-- Breath sets
	sets.HealingBreath = {head="Ptero. Armet +3",neck="Dragoon's Collar +2",back="Brigantia's Mantle",legs="Vishap Brais +3",feet="Ptero. Greaves +3"}
	sets.SmitingBreath = {head="Ptero. Armet +3",neck="Adad Amulet",ear1="Enmerkar Earring",back="Brigantia's Mantle",waist="Incarnation Sash",legs="Pteroslaver Brais +3"}--Voluspa Tathlum,Kyrene's Earring,C. Palug Ring,Updraft Mantle, Acro + breath gear
	sets.precast.JA['Restoring Breath'] = set_combine(sets.HealingBreath, {})
	sets.precast.JA['Smiting Breath'] = set_combine(sets.SmitingBreath, {})

	-- Fast cast sets for spells
	
	sets.precast.FC = {ammo="Impatiens",
		head="Carmine Mask +1",neck="Voltsurge Torque",ear1="Etiolation Earring",ear2="Moonshade Earring",
		body=gear.valorous_fc_body,hands=gear.valorous_fc_hands,ring1="Lebeche Ring",ring2="Prolix Ring",
		back="Moonbeam Cape",waist="Flume Belt +1",legs="Enif Cosciales",feet="Carmine Greaves +1"}
		
		
	sets.precast.FC.Cure = set_combine(sets.precast.FC, {body="Jumalik Mail"})--neck="Diemer Gorget",
	
	
	-- Ranged snapshot gear -- really just used to pull without having to run to mob
    sets.precast.RA = {ammo="Tathlum"}
	
	-- Waltz set (chr and vit)
	sets.precast.Waltz = {}
		
	-- Don't need any special gear for Healing Waltz.
	sets.precast.Waltz['Healing Waltz'] = {}

	sets.midcast.Cure = {}
	
	sets.Self_Healing = {neck="Phalaina Locket",hands="Buremte Gloves",ring2="Kunaji Ring",waist="Gishdubar Sash",ring1="Vocane Ring",legs="Flamma Dirs +2"}
	sets.Cure_Received = set_combine(sets.Self_Healing, {})
	sets.Self_Refresh = {waist="Gishdubar Sash"}
	
	-- Midcast Sets
	sets.midcast.FastRecast = {ammo="Staunch Tathlum +1",
		head="Vishap Armet +3",neck="Voltsurge Torque",ear1="Enchntr. Earring +1",ear2="Loquac. Earring",
		body="Taeon Tabard",hands="Leyline Gloves",ring1="Lebeche Ring",ring2="Prolix Ring",
		back="Moonbeam Cape",waist="Tempus Fugit",legs="Founder's Hose",feet="Carmine Greaves +1"}
		
	-- Put HP+ gear and the AF head to make healing breath trigger more easily with this set.
	sets.midcast.HB_Trigger = set_combine(sets.midcast.FastRecast, {head="Vishap Armet +3", back="Moonbeam Cape"})
	
	-- Weaponskill sets

	-- Default set for any weaponskill that isn't any more specifically defined
	
	sets.precast.WS = {ammo="Knobkierrie",
		head="Ptero. Armet +3",neck="Dgn. Collar +2",ear1="Thud Earring",ear2="Sherida Earring",
		body="Gleti's Cuirass",hands="Sulev. Gauntlets +2",ring1="Regal Ring",ring2="Niqmaddu Ring",
		back="Brigantia's Mantle",waist="Fotia Belt",legs="Sulev. Cuisses +2",feet="Sulev. Leggings +2"}
		
	sets.precast.WS.SomeAcc = set_combine(sets.precast.WS, {ammo="Knobkierrie",feet="Ptero. Greaves +3"})
	sets.precast.WS.Acc = set_combine(sets.precast.WS, {ammo="Knobkierrie",feet="Vishap Greaves +3"})
	sets.precast.WS.FullAcc = set_combine(sets.precast.WS, {ammo="Knobkierrie",back="Vespid Mantle",legs="Vishap Brais +3",feet="Vishap Greaves +3",ring2="Rufescent Ring",neck="Fotia Gorget"})
	
	sets.precast.WS.Fodder = {ammo="Knobkierrie",
		head="Flam. Zucchetto +2",neck="Dgn. Collar +2",ear1="Thud Earring",ear2="Sherida Earring",
		body="Gleti's Cuirass",hands="Gleti's Gauntlets",ring1="Regal Ring",ring2="Niqmaddu Ring",
		back="Brigantia's Mantle",waist="Fotia Belt",legs="Gleti's Breeches",feet="Sulev. Leggings +2"}
	
	
	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS['Stardiver'] = set_combine(sets.precast.WS, {neck="Fotia Gorget",waist="Fotia Belt"})
	sets.precast.WS['Stardiver'].SomeAcc = set_combine(sets.precast.WS.SomeAcc, {neck="Fotia Gorget",waist="Fotia Belt"})
	sets.precast.WS['Stardiver'].Acc = set_combine(sets.precast.WS.Acc, {neck="Fotia Gorget",waist="Fotia Belt"})
	sets.precast.WS['Stardiver'].FullAcc = set_combine(sets.precast.WS.FullAcc, {neck="Fotia Gorget",waist="Fotia Belt"})
	sets.precast.WS['Stardiver'].Fodder = set_combine(sets.precast.WS.Fodder, {waist="Fotia Belt"})

	sets.precast.WS["Camlann's Torment"] = set_combine(sets.precast.WS, {ear2="Ishvara Earring",head="Nyame Helm",body="Nyame Mail",hands="Ptero. Fin. G. +3",legs="Vishap Brais +3"})
	sets.precast.WS["Camlann's Torment"].SomeAcc = set_combine(sets.precast.WS.SomeAcc, {ear2="Ishvara Earring",head="Nyame Helm",body="Nyame Mail",hands="Ptero. Fin. G. +3",legs="Vishap Brais +3"})
	sets.precast.WS["Camlann's Torment"].Acc = set_combine(sets.precast.WS.Acc, {ear2="Ishvara Earring",head="Nyame Helm",body="Nyame Mail",hands="Ptero. Fin. G. +3",legs="Vishap Brais +3"})
	sets.precast.WS["Camlann's Torment"].FullAcc = set_combine(sets.precast.WS.FullAcc, {ear2="Ishvara Earring",head="Nyame Helm",body="Nyame Mail",hands="Ptero. Fin. G. +3",legs="Vishap Brais +3"})
	sets.precast.WS["Camlann's Torment"].Fodder = set_combine(sets.precast.WS.Fodder, {ear2="Ishvara Earring",head="Gleti's Mask",hands="Ptero. Fin. G. +3"})
	
	sets.precast.WS['Sonic Thrust'] = set_combine(sets.precast.WS, {head="Nyame Helm",body="Nyame Mail",hands="Ptero. Fin. G. +3",legs="Nyame Flanchard",feet="Nyame Sollerets"})
	sets.precast.WS['Sonic Thrust'].SomeAcc = set_combine(sets.precast.WS.SomeAcc, {head="Nyame Helm",body="Nyame Mail",hands="Ptero. Fin. G. +3",legs="Nyame Flanchard"})
	sets.precast.WS['Sonic Thrust'].Acc = set_combine(sets.precast.WS.Acc, {head="Nyame Helm",body="Nyame Mail",hands="Ptero. Fin. G. +3",legs="Nyame Flanchard"})
	sets.precast.WS['Sonic Thrust'].FullAcc = set_combine(sets.precast.WS.FullAcc, {head="Nyame Helm",body="Nyame Mail",hands="Ptero. Fin. G. +3"})
	sets.precast.WS['Sonic Thrust'].Fodder = set_combine(sets.precast.WS.Fodder, {head="Gleti's Mask",hands="Ptero. Fin. G. +3",feet="Nyame Sollerets"})
		
	sets.precast.WS['Impulse Drive'] = set_combine(sets.precast.WS, {head="Ptero. Armet +3",hands="Ptero. Fin. G. +3"})--Sailfi Belt +1
	sets.precast.WS['Impulse Drive'].SomeAcc = set_combine(sets.precast.WS.SomeAcc, {head="Ptero. Armet +3",hands="Ptero. Fin. G. +3"})
	sets.precast.WS['Impulse Drive'].Acc = set_combine(sets.precast.WS.Acc, {head="Ptero. Armet +3",hands="Ptero. Fin. G. +3"})
	sets.precast.WS['Impulse Drive'].FullAcc = set_combine(sets.precast.WS.FullAcc, {head="Ptero. Armet +3",hands="Ptero. Fin. G. +3"})
	sets.precast.WS['Impulse Drive'].Fodder = set_combine(sets.precast.WS.Fodder, {head="Gleti's Mask",feet="Gleti's Boots"})
	
	sets.precast.WS['Drakesbane'] = set_combine(sets.precast.WS, {head="Gleti's Mask",body="Hjarrandi Breast.",hands="Gleti's Gauntlets",ear2="Sherida Earring",feet="Gleti's Boots"})--Sailfi Belt +1
	sets.precast.WS['Drakesbane'].SomeAcc = set_combine(sets.precast.WS.SomeAcc, {head="Gleti's Mask",body="Hjarrandi Breast.",hands="Gleti's Gauntlets",ear2="Sherida Earring"})
	sets.precast.WS['Drakesbane'].Acc = set_combine(sets.precast.WS.Acc, {head="Gleti's Mask",body="Hjarrandi Breast.",hands="Gleti's Gauntlets",ear2="Sherida Earring"})
	sets.precast.WS['Drakesbane'].FullAcc = set_combine(sets.precast.WS.FullAcc, {head="Gleti's Mask",body="Hjarrandi Breast.",hands="Gleti's Gauntlets",ear2="Sherida Earring"})
	sets.precast.WS['Drakesbane'].Fodder = set_combine(sets.precast.WS.Fodder, {head="Gleti's Mask",ear2="Sherida Earring",feet="Gleti's Boots"})

	sets.precast.WS['Geirskogul'] = set_combine(sets.precast.WS, {neck="Fotia Gorget",hands="Pteroslaver Finger Gauntlets +3",ear2="Ishvara Earring",legs="Vishap Brais +3"})
	sets.precast.WS['Geirskogul'].SomeAcc = set_combine(sets.precast.WS.SomeAcc, {neck="Fotia Gorget",hands="Pteroslaver Finger Gauntlets +3",ear2="Ishvara Earring",legs="Vishap Brais +3"})
	sets.precast.WS['Geirskogul'].Acc = set_combine(sets.precast.WS.Acc, {neck="Fotia Gorget",hands="Pteroslaver Finger Gauntlets +3",ear2="Ishvara Earring",legs="Vishap Brais +3"})
	sets.precast.WS['Geirskogul'].FullAcc = set_combine(sets.precast.WS.FullAcc, {neck="Fotia Gorget",hands="Pteroslaver Finger Gauntlets +3",ear2="Ishvara Earring",legs="Vishap Brais +3"})
	sets.precast.WS['Geirskogul'].Fodder = set_combine(sets.precast.WS.Fodder, {head="Gleti's Mask",hands="Pteroslaver Finger Gauntlets +3",ear2="Ishvara Earring",legs="Vishap Brais +3",feet="Gleti's Boots"})
	
	sets.precast.WS['Leg Sweep'] = {ammo="Knobkierrie",
		head="Flam. Zucchetto +2",neck="Fotia Belt",ear1="Thud Earring",ear2="Sherida Earring",
		body="Flamma Korazin +2",hands="Flam. Manopolas +2",ring1="Flamma Ring",ring2="Niqmaddu Ring",
		back="Brigantia's Mantle",waist="Fotia Belt",legs="Flamma Dirs +2",feet="Flam. Gambieras +2"}
		
	sets.precast.WS['Leg Sweep'].SomeAcc = set_combine(sets.precast.WS['Leg Sweep'], {})
	sets.precast.WS['Leg Sweep'].Acc = set_combine(sets.precast.WS['Leg Sweep'], {})
	sets.precast.WS['Leg Sweep'].FullAcc = set_combine(sets.precast.WS['Leg Sweep'], {})
	sets.precast.WS['Leg Sweep'].Fodder = set_combine(sets.precast.WS['Leg Sweep'], {})


	
	-- Sets to return to when not performing an action.
	
	-- Resting sets
	sets.resting = {}

	-- Idle sets
	sets.idle = {ammo="Staunch Tathlum +1",
		head="Loess Barbuta +1",neck="Dragoon's Collar +2",ear1="Brutal Earring",ear2="Ethereal Earring",
		body="Chozoron Coselete",hands=gear.valorous_refresh_hands,ring1="Vocane Ring",ring2="Defending Ring",
		back="Brigantia's Mantle",waist="Flume belt +1",legs="Carmine Cuisses +1",feet="Pteroslaver Greaves +3"}
		
	sets.idle.Refresh = {ammo="Staunch Tathlum +1",
		head="Loess Barbuta +1",neck="Dragoon's Collar +2",ear1="Brutal Earring",ear2="Ethereal Earring",
		body="Chozoron Coselete",hands=gear.valorous_refresh_hands,ring1="Vocane Ring",ring2="Defending Ring",
		back="Brigantia's Mantle",waist="Flume belt +1",legs="Carmine Cuisses +1",feet="Pteroslaver Greaves +3"}

	sets.idle.Weak = set_combine(sets.idle, {head="Twilight Helm",body="Twilight Mail"})
		
	sets.idle.Reraise = set_combine(sets.idle, {head="Twilight Helm",body="Twilight Mail"})
	
	-- Defense sets
	sets.defense.PDT = {ammo="Staunch Tathlum +1",
		head="Loess Barbuta +1",neck="Dragoon's Collar +2",ear1="Genmei Earring",ear2="Ethereal Earring",
		body="Hjarrandi Breastplate",hands="Sulev. Gauntlets +2",ring1="Vocane Ring",ring2="Defending Ring",
		back="Moonbeam Cape",waist="Flume Belt +1",legs="Arke Cosc. +1",feet="Amm Greaves"}
		
	sets.defense.PDTReraise = set_combine(sets.defense.PDT, {head="Twilight Helm",body="Twilight Mail"})

	sets.defense.MDT = {ammo="Staunch Tathlum +1",
		head="Loess Barbuta +1",neck="Warder's Charm +1",ear1="Etiolation Earring",ear2="Ethereal Earring",
		body="Hjarrandi Breastplate",hands="Sulev. Gauntlets +2",ring1="Vocane Ring",ring2="Defending Ring",
		back="Moonbeam Cape",waist="Windbuffet Belt +1",legs="Arke Cosc. +1",feet="Amm Greaves"}
		
	sets.defense.MDTReraise = set_combine(sets.defense.MDT, {head="Twilight Helm",body="Twilight Mail"})
		
	sets.defense.MEVA = {ammo="Staunch Tathlum +1",
		head="Nyame Helm",neck="Warder's Charm +1",ear1="Genmei Earring",ear2="Ethereal Earring",
		body="Nyame Mail",hands="Nyame Gauntlets",ring1="Moonbeam Ring",ring2="Moonlight Ring",
		back="Moonbeam Cape",waist="Flume Belt +1",legs="Nyame Flanchard",feet="Nyame Sollerets"}

	sets.Kiting = {legs="Carmine Cuisses +1"}
	sets.Reraise = {head="Twilight Helm",body="Twilight Mail"}
	sets.buff.Doom = set_combine(sets.buff.Doom, {})
	sets.buff.Sleep = {neck="Vim Torque +1"}
	

    -- Extra defense sets.  Apply these on top of melee or defense sets.
    sets.passive.MP = {ear2="Ethereal Earring",waist="Flume Belt +1"}
    sets.passive.Twilight = {head="Twilight Helm", body="Twilight Mail"}
	sets.TreasureHunter = set_combine(sets.TreasureHunter, {legs=gear.valorous_treasure_legs})
	
	-- Weapons sets
	sets.weapons.Trishula = {main="Trishula",sub="Utu Grip"}
	sets.weapons.Gungnir = {main="Gungnir",sub="Utu Grip"}
	sets.weapons.club = {main="Dream Bell"}
	sets.weapons.Naegling = {main="Naegling"}
	sets.weapons.Staff = {main="Exalted Staff",sub="Utu Grip"}

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
		gear.DRGEar2={name="Sherida Earring"}
	end


	--sets.precast.WS.SomeAcc = set_combine(sets.precast.WS, {ammo="Knobkierrie",feet="Ptero. Greaves +3"})
	--sets.precast.WS.Acc = set_combine(sets.precast.WS, {ammo="Knobkierrie",feet="Vishap Greaves +3"})
	--sets.precast.WS.FullAcc = set_combine(sets.precast.WS, {ammo="Knobkierrie",back="Vespid Mantle",legs="Vishap Brais +3",feet="Vishap Greaves +3",ring2="Rufescent Ring",neck="Fotia Gorget"})

	sets.engaged = {ammo="Ginsen",
		head="Flam. Zucchetto +2",neck="Vim Torque +1",ear1="Telos Earring",ear2=gear.DRGEar2,
		body="Hjarrandi Breast.",hands="Nyame Gauntlets",ring1="Petrov Ring",ring2="Niqmaddu Ring",
		back="Brigantia's Mantle",waist="Windbuffet Belt +1",legs="Ptero. Brais +3",feet="Flam. Gambieras +2"}
    
	sets.engaged.SomeAcc = set_combine(sets.engaged, {neck="Shulmanu Collar",feet="Ptero. Greaves +3"})
	
	sets.engaged.Acc = set_combine(sets.engaged, {neck="Shulmanu Collar",feet="Vishap Greaves +3"})
    
	sets.engaged.FullAcc = set_combine(sets.engaged, {legs="Vishap Brais +3",feet="Vishap Greaves +3",neck="Shulmanu Collar"})
    
	sets.engaged.Fodder = {ammo="Ginsen",
		head="Flam. Zucchetto +2",neck="Vim Torque +1",ear1="Brutal Earring",ear2="Sherida Earring",
		body="Gleti's Cuirass",hands="Nyame Gauntlets",ring1="Petrov Ring",ring2="Niqmaddu Ring",
		back="Brigantia's Mantle",waist="Ioskeha Belt",legs="Nyame Flanchard",feet="Flam. Gambieras +2"}
	
	sets.engaged.Hybrid = set_combine(sets.engaged, {Head="Loess Barbuta +1",neck ="Dragoon's Collar +2",
		body="Hjarrandi Breastplate",ring1="Vocane Ring",ring2="Defending Ring"})
	
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
    send_command('wait 2; input /lockstyleset 3')--regular 3 stanta 7, swimsuit 8, halloween 10
	send_command('lua load SKillchains')
end


state.AutoBreathMode = M(true, 'Auto Breath Mode')



function check_breath()
	    
	for i=1,party.count do
		
		if party[i].mob == nil and player.status == 'Engaged' then
			return false
		end
		
		if state.AutoBreathMode.value and player.status == 'Engaged' and pet.isvalid and (party[i].hpp < Breath_HPP - 15 or pet.hpp < 50) and party[i].mob.distance < 14  then
			
			local abil_recasts = windower.ffxi.get_ability_recasts()
			local spell_recasts = windower.ffxi.get_spell_recasts()
			
			--if party[i].buffactive.KO == nil then
				--return false
			if party[i].hpp == 0 then
				return false
			else
				if abil_recasts[164] < latency and party[i].hpp < 30 and pet.distance < 6.25 and not buffactive[amnesia] then
					windower.chat.input('/ja "Deep Breathing" <me>')
					tickdelay = os.clock() + 1.1
					return true
				elseif abil_recasts[149] < latency and pet.distance < 6.25 and not buffactive[amnesia] then
					windower.chat.input('/ja "Spirit Bond" <me>')
					tickdelay = os.clock() + 1.1
					return true
				elseif abil_recasts[239] < latency and not buffactive[amnesia] then
					windower.chat.input('/ja "Restoring Breath" <me>')
					tickdelay = os.clock() + 5.1
					return true
				elseif spell_recasts[23] < spell_latency and (player.sub_job == 'WHM' or player.sub_job == 'RDM') and party[i].hpp < Breath_HPP - 15 then
					windower.chat.input('/ma "Dia" <t>')
					tickdelay = os.clock() + 1.1
					return true
				elseif spell_recasts[159] < spell_latency and (player.sub_job == 'BLM' or player.sub_job == 'RDM') and party[i].hpp < Breath_HPP - 15 then
					windower.chat.input('/ma "Stone" <t>')
					tickdelay = os.clock() + 1.1
					return true
				elseif abil_recasts[70] < latency and pet.distance < 6.25 and not buffactive[amnesia] then
					windower.chat.input('/ja "Steady Wing" <me>')
					tickdelay = os.clock() + 1.1
					return true
				else
					return false
				end
			end
        end
    end
end

