-- Setup vars that are user-dependent.  Can override this in a sidecar file.
function user_job_setup()
    state.OffenseMode:options('Normal','Acc')
    state.CastingMode:options('Normal','Resistant')
    state.IdleMode:options('Normal','PDT','MDT')
	state.PhysicalDefenseMode:options('PDT')
	state.MagicalDefenseMode:options('MDT')
	state.ResistDefenseMode:options('MEVA')
	state.Weapons:options('None','DualWeapons','MeleeWeapons')
	
	state.AutoHealMode = M(false, 'Auto Heal Mode')
	
	autows = 'Mystic Boon'

	gear.obi_cure_waist = "Austerity Belt +1"
	gear.obi_cure_back = "Alaunus's Cape"

	gear.obi_nuke_waist = "Sekhmet Corset"
	gear.obi_high_nuke_waist = "Yamabuki-no-Obi"
	gear.obi_nuke_back = "Toro Cape"
	
	

		-- Additional local binds 
	send_command('bind ^` input /ma "Arise" <t>')
	send_command('bind !` input /ja "Penury" <me>')
	send_command('bind @` gs c cycle MagicBurstMode')
	send_command('bind ^@!` gs c toggle AutoCaress')
	send_command('bind ^backspace input /ja "Sacrosanctity" <me>')
	send_command('bind @backspace input /ma "Aurora Storm" <me>')
	send_command('bind !pause gs c toggle AutoSubMode') --Automatically uses sublimation.
	send_command('bind !backspace input /ja "Accession" <me>')
	send_command('bind != input /ja "Sublimation" <me>')
	send_command('bind ^delete input /ja "Dark Arts" <me>')
	send_command('bind !delete input /ja "Addendum: Black" <me>')
	send_command('bind @delete input /ja "Manifestation" <me>')
	send_command('bind ^\\\\ input /ma "Protectra V" <me>')
	send_command('bind @\\\\ input /ma "Shellra V" <me>')
	send_command('bind !\\\\ input /ma "Reraise IV" <me>')
	send_command('bind @f1 gs c toggle AutoHealMode')
	send_command('bind ^pause gs c toggle AutoShadowMode') --Turns Auto Shadows on and off.
	send_command('bind @f2 gs c toggle AutoShadowMode')
	
	set_lockstyle()
    select_default_macro_book()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

	-- Weapons sets
	sets.weapons.MeleeWeapons = {main="Yagrush",sub="Ammurapi Shield"}
	sets.weapons.DualWeapons = {main="Yagrush",sub="Bolelabunga"}
	
    sets.buff.Sublimation = {waist="Embla Sash"}
    sets.buff.DTSublimation = {waist="Embla Sash"}
	
    -- Precast Sets

    -- Fast cast sets for spells
    sets.precast.FC = {main=gear.grioavolr_fc_staff,sub="Clerisy Strap +1",ammo="Impatiens",
		head="Welkin Crown",neck="Clr. Torque +2",ear1="Etiolation Earring",ear2="Moonshade Earring",
		body="Inyanga Jubbah +2",hands="Fanatic Gloves",ring1="Kishar Ring",ring2="Lebeche Ring",
		back="Alaunus's Cape",waist="Witful Belt",legs="Lengo Pants",feet="Regal Pumps +1"}

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})
	
    sets.precast.FC.Stoneskin = set_combine(sets.precast.FC['Enhancing Magic'], {legs="Doyen Pants"})

    sets.precast.FC['Healing Magic'] = set_combine(sets.precast.FC, {legs="Ebers Pantaloons +1"})

    sets.precast.FC.StatusRemoval = sets.precast.FC['Healing Magic']
	
    sets.precast.FC.Cure = set_combine(sets.precast.FC['Healing Magic'], {feet="Hygieia Clogs +1"})

    sets.precast.FC.Curaga = sets.precast.FC.Cure

	sets.precast.FC.CureSolace = sets.precast.FC.Cure

	sets.precast.FC.Impact =  set_combine(sets.precast.FC, {head=empty,body="Twilight Cloak"})
	
	sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak",sub="Genbu's Shield"})

    -- Precast sets to enhance JAs
    sets.precast.JA.Benediction = {body="Piety Bliaut +3"} -- [2026-11-22 Fix] Was: "Piety Briault +3"

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
		head="Nahtirah Hat",ear1="Roundel Earring",
		body="Piety Bliaut +3",hands="Telchine Gloves", -- [2026-11-22 Fix] Was: "Piety Briault +3"
		waist="Chaac Belt",back="Aurist's Cape +1"}

    -- Weaponskill sets

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {ammo="Hasty Pinion +1",
		head="Befouled Crown",neck="Fotia Gorget",ear1="Ishvara Earring",ear2="Brutal Earring",
		body="Kaykaus Bliaut",hands="Telchine Gloves",ring1="Rufescent Ring",ring2="Stikini Ring +1",
		back="Buquwik Cape",waist="Fotia Belt",legs="Assid. Pants +1",feet="Gende. Galosh. +1"}
		
    sets.precast.WS.Dagan = {ammo="Hasty Pinion +1",
		head="Befouled Crown",neck="Asperity Necklace",ear1="Etiolation Earring",ear2="Moonshade Earring",
		body="Kaykaus Bliaut",hands="Telchine Gloves",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
		back="Buquwik Cape",waist="Fotia Belt",legs="Assid. Pants +1",feet="Gende. Galosh. +1"}
		
	sets.MaxTP = {ear1="Cessance Earring",ear2="Brutal Earring"}
	sets.MaxTP.Dagan = {ear1="Etiolation Earring",ear2="Evans Earring"}

    --sets.precast.WS['Flash Nova'] = {}

    --sets.precast.WS['Mystic Boon'] = {}

    -- Midcast Sets

    sets.Kiting = {feet="Herald's Gaiters"}
    sets.latent_refresh = {waist="Fucho-no-obi"}
	sets.latent_refresh_grip = {sub="Oneiros Grip"}
	sets.TPEat = {neck="Chrys. Torque"}
	sets.DayIdle = {}
	sets.NightIdle = {back="Umbra Cape"}
	sets.TreasureHunter = set_combine(sets.TreasureHunter, {feet=gear.chironic_treasure_feet})
	
	--Situational sets: Gear that is equipped on certain targets
	sets.Self_Healing = {neck="Phalaina Locket",ring1="Vocane Ring",ring2="Asklepian Ring",waist="Gishdubar Sash",back="Moonbeam Cape"}
	sets.Cure_Received = {neck="Phalaina Locket",ring1="Vocane Ring",ring2="Asklepian Ring",waist="Gishdubar Sash",back="Moonbeam Cape"}
	sets.Self_Refresh = {back="Grapevine Cape",waist="Gishdubar Sash",feet="Inspirited Boots"}

	-- Conserve Mp set for spells that don't need anything else, for set_combine.
	
	sets.ConserveMP = {main=gear.grioavolr_fc_staff,sub="Umbra Strap",ammo="Hasty Pinion +1",
		head="Vanya Hood",neck="Incanter's Torque",ear1="Gifted Earring",ear2="Gwati Earring",
		body="Vedic Coat",hands="Fanatic Gloves",ring1="Kishar Ring",ring2="Prolix Ring",
		back="Solemnity Cape",waist="Austerity Belt +1",legs="Vanya Slops",feet="Medium's Sabots"}
		
	sets.midcast.Teleport = sets.ConserveMP
	
	-- Gear for Magic Burst mode.
    sets.MagicBurst = {main=gear.grioavolr_nuke_staff,sub="Enki Strap",neck="Mizu. Kubikazari",ring1="Mujin Band",ring2="Locus Ring"}
	
    sets.midcast.FastRecast = {main=gear.grioavolr_fc_staff,sub="Clerisy Strap +1",ammo="Hasty Pinion +1",
		head="Nahtirah Hat",neck="Voltsurge Torque",ear1="Enchntr. Earring +1",ear2="Malignance Earring",
		body="Inyanga Jubbah +2",hands="Gende. Gages +1",ring1="Kishar Ring",ring2="Prolix Ring",
		back="Swith Cape +1",waist="Witful Belt",legs="Lengo Pants",feet="Regal Pumps +1"}
		
    -- Cure sets

	sets.midcast['Full Cure'] = sets.midcast.FastRecast
	
	sets.midcast.Cure = {main="Queller Rod",sub="Sors Shield",ammo="Pemphredo Tathlum",
		head="Gende. Caubeen +1",neck="Incanter's Torque",ear1="Nourish. Earring +1",ear2="Glorious Earring",
		body="Theo. Bliaut +2",hands="Theophany Mitts +2",ring1="Janniston Ring",ring2="Menelaus's Ring", -- [2026-11-22 Fix] Was: "Theo. Briault +2"
		back="Alaunus's Cape",waist="Luminary Sash",legs="Ebers Pantaloons +1",feet="Kaykaus Boots"}
		
	sets.midcast.CureSolace = {main="Queller Rod",sub="Sors Shield",ammo="Pemphredo Tathlum",
		head="Gende. Caubeen +1",neck="Incanter's Torque",ear1="Nourish. Earring +1",ear2="Glorious Earring",
		body="Ebers Bliaut +1",hands="Theophany Mitts +2",ring1="Janniston Ring",ring2="Menelaus's Ring", -- [2026-11-22 Fix] Was: "Ebers Bliaud +1"
		back="Alaunus's Cape",waist="Luminary Sash",legs="Ebers Pantaloons +1",feet="Kaykaus Boots"}

	sets.midcast.LightWeatherCure = {main="Chatoyant Staff",sub="Curatio Grip",ammo="Esper Stone +1",
		head="Gende. Caubeen +1",neck="Incanter's Torque",ear1="Nourish. Earring +1",ear2="Glorious Earring",
		body="Kaykaus Bliaut",hands="Theophany Mitts +2",ring1="Janniston Ring",ring2="Lebeche Ring",
		back="Twilight Cape",waist="Hachirin-no-Obi",legs="Ebers Pantaloons +1",feet="Kaykaus Boots"}

	sets.midcast.LightWeatherCureSolace = {main="Chatoyant Staff",sub="Curatio Grip",ammo="Esper Stone +1",
		head="Gende. Caubeen +1",neck="Incanter's Torque",ear1="Nourish. Earring +1",ear2="Glorious Earring",
		body="Ebers Bliaut +1",hands="Theophany Mitts +2",ring1="Janniston Ring",ring2="Lebeche Ring", -- [2026-11-22 Fix] Was: "Ebers Bliaud +1"
		back="Alaunus's Cape",waist="Hachirin-no-Obi",legs="Ebers Pantaloons +1",feet="Kaykaus Boots"}
		
	sets.midcast.LightDayCureSolace = {main="Queller Rod",sub="Sors Shield",ammo="Pemphredo Tathlum",
		head="Gende. Caubeen +1",neck="Incanter's Torque",ear1="Nourish. Earring +1",ear2="Glorious Earring",
		body="Ebers Bliaut +1",hands="Theophany Mitts +2",ring1="Janniston Ring",ring2="Menelaus's Ring", -- [2026-11-22 Fix] Was: "Ebers Bliaud +1"
		back="Alaunus's Cape",waist="Hachirin-no-Obi",legs="Ebers Pantaloons +1",feet="Kaykaus Boots"}

	sets.midcast.LightDayCure = {main="Queller Rod",sub="Sors Shield",ammo="Pemphredo Tathlum",
		head="Gende. Caubeen +1",neck="Incanter's Torque",ear1="Nourish. Earring +1",ear2="Glorious Earring",
		body="Theo. Bliaut +2",hands="Theophany Mitts +2",ring1="Janniston Ring",ring2="Menelaus's Ring", -- [2026-11-22 Fix] Was: "Theo. Briault +2"
		back="Twilight Cape",waist="Hachirin-no-Obi",legs="Ebers Pantaloons +1",feet="Kaykaus Boots"}

	sets.midcast.Curaga = {main="Queller Rod",sub="Sors Shield",ammo="Pemphredo Tathlum",
		head="Gende. Caubeen +1",neck="Incanter's Torque",ear1="Nourish. Earring +1",ear2="Glorious Earring",
		body="Theo. Bliaut +2",hands="Theophany Mitts +2",ring1="Janniston Ring",ring2="Menelaus's Ring", -- [2026-11-22 Fix] Was: "Theo. Briault +2"
		back="Alaunus's Cape",waist="Luminary Sash",legs="Ebers Pantaloons +1",feet="Kaykaus Boots"}
		
	sets.midcast.LightWeatherCuraga = {main="Chatoyant Staff",sub="Curatio Grip",ammo="Esper Stone +1",
		head="Gende. Caubeen +1",neck="Incanter's Torque",ear1="Nourish. Earring +1",ear2="Glorious Earring",
		body="Kaykaus Bliaut",hands="Theophany Mitts +2",ring1="Janniston Ring",ring2="Lebeche Ring",
		back="Twilight Cape",waist="Hachirin-no-Obi",legs="Ebers Pantaloons +1",feet="Kaykaus Boots"}
		
	sets.midcast.LightDayCuraga = {main="Queller Rod",sub="Sors Shield",ammo="Pemphredo Tathlum",
		head="Gende. Caubeen +1",neck="Incanter's Torque",ear1="Nourish. Earring +1",ear2="Glorious Earring",
		body="Theo. Bliaut +2",hands="Theophany Mitts +2",ring1="Janniston Ring",ring2="Menelaus's Ring", -- [2026-11-22 Fix] Was: "Theo. Briault +2"
		back="Twilight Cape",waist="Hachirin-no-Obi",legs="Ebers Pantaloons +1",feet="Kaykaus Boots"}

	sets.midcast.Cure.DT = {main="Queller Rod",sub="Genbu's Shield",ammo="Staunch Tathlum +1",
		head="Gende. Caubeen +1",neck="Loricate Torque +1",ear1="Nourish. Earring +1",ear2="Glorious Earring",
		body="Ayanmo Corazza +2",hands="Gende. Gages +1",ring1="Defending Ring",ring2="Dark Ring",
		back="Alaunus's Cape",waist="Luminary Sash",legs="Ebers Pantaloons +1",feet="Gende. Galosh. +1"}
		
	--Melee Curesets are used whenever your Weapons state is set to anything but None.
	sets.midcast.MeleeCure = {ammo="Pemphredo Tathlum",
		head="Gende. Caubeen +1",neck="Incanter's Torque",ear1="Nourish. Earring +1",ear2="Glorious Earring",
		body="Theo. Bliaut +2",hands="Kaykaus Cuffs",ring1="Janniston Ring",ring2="Lebeche Ring", -- [2026-11-22 Fix] Was: "Theo. Briault +2"
		back="Alaunus's Cape",waist="Luminary Sash",legs="Ebers Pantaloons +1",feet="Kaykaus Boots"}
		
	sets.midcast.MeleeCureSolace = set_combine(sets.midcast.MeleeCure, {body="Ebers Bliaut +1"}) -- [2026-11-22 Fix] Was: "Ebers Bliaud +1"
	sets.midcast.MeleeLightWeatherCure = set_combine(sets.midcast.MeleeCure, {waist="Hachirin-no-Obi"})
	sets.midcast.MeleeLightWeatherCureSolace = set_combine(sets.midcast.MeleeCure, {body="Ebers Bliaut +1",waist="Hachirin-no-Obi"}) -- [2026-11-22 Fix] Was: "Ebers Bliaud +1"
	sets.midcast.MeleeLightDayCureSolace = set_combine(sets.midcast.MeleeCure, {body="Ebers Bliaut +1",waist="Hachirin-no-Obi"}) -- [2026-11-22 Fix] Was: "Ebers Bliaud +1"
	sets.midcast.MeleeLightDayCure = set_combine(sets.midcast.MeleeCure, {waist="Hachirin-no-Obi"})
	sets.midcast.MeleeCuraga = set_combine(sets.midcast.MeleeCure, {})
	sets.midcast.MeleeLightWeatherCuraga = set_combine(sets.midcast.MeleeCure, {waist="Hachirin-no-Obi"})
	sets.midcast.MeleeLightDayCuraga = set_combine(sets.midcast.MeleeCure, {waist="Hachirin-no-Obi"})

	sets.midcast.CureSolace.DT = set_combine(sets.midcast.Cure.DT, {body="Ebers Bliaut +1"}) -- [2026-11-22 Fix] Was: "Ebers Bliaud +1"
	sets.midcast.LightWeatherCure.DT = set_combine(sets.midcast.Cure.DT, {waist="Hachirin-no-Obi"})
	sets.midcast.LightWeatherCureSolace.DT = set_combine(sets.midcast.Cure.DT, {body="Ebers Bliaut +1",waist="Hachirin-no-Obi"}) -- [2026-11-22 Fix] Was: "Ebers Bliaud +1"
	sets.midcast.LightDayCureSolace.DT = set_combine(sets.midcast.Cure.DT, {body="Ebers Bliaut +1",waist="Hachirin-no-Obi"}) -- [2026-11-22 Fix] Was: "Ebers Bliaud +1"
	sets.midcast.LightDayCure.DT = set_combine(sets.midcast.Cure.DT, {waist="Hachirin-no-Obi"})
	sets.midcast.Curaga.DT = set_combine(sets.midcast.Cure.DT, {})
	sets.midcast.LightWeatherCuraga.DT = set_combine(sets.midcast.Cure.DT, {waist="Hachirin-no-Obi"})
	sets.midcast.LightDayCuraga.DT = set_combine(sets.midcast.Cure.DT, {waist="Hachirin-no-Obi"})
	sets.midcast.MeleeCure.DT = set_combine(sets.midcast.Cure.DT, {})
	
	sets.midcast.MeleeCureSolace.DT = set_combine(sets.midcast.Cure.DT, {body="Ebers Bliaut +1"}) -- [2026-11-22 Fix] Was: "Ebers Bliaud +1"
	sets.midcast.MeleeLightWeatherCure.DT = set_combine(sets.midcast.Cure.DT, {waist="Hachirin-no-Obi"})
	sets.midcast.MeleeLightWeatherCureSolace.DT = set_combine(sets.midcast.Cure.DT, {body="Ebers Bliaut +1",waist="Hachirin-no-Obi"}) -- [2026-11-22 Fix] Was: "Ebers Bliaud +1"
	sets.midcast.MeleeLightDayCureSolace.DT = set_combine(sets.midcast.Cure.DT, {body="Ebers Bliaut +1",waist="Hachirin-no-Obi"}) -- [2026-11-22 Fix] Was: "Ebers Bliaud +1"
	sets.midcast.MeleeLightDayCure.DT = set_combine(sets.midcast.Cure.DT, {waist="Hachirin-no-Obi"})
	sets.midcast.MeleeCuraga.DT = set_combine(sets.midcast.Cure.DT, {})
	sets.midcast.MeleeLightWeatherCuraga.DT = set_combine(sets.midcast.Cure.DT, {waist="Hachirin-no-Obi"})
	sets.midcast.MeleeLightDayCuraga.DT = set_combine(sets.midcast.Cure.DT, {waist="Hachirin-no-Obi"})

	sets.midcast.Cursna = {main="Yagrush",sub="Ammurapi Shield",ammo="Hasty Pinion +1",
		head="Ebers Cap +1",neck="Debilis Medallion",ear1="Meili Earring",ear2="Malignance Earring",
		body="Ebers Bliaut +1",hands="Fanatic Gloves",ring1="Haoma's Ring",ring2="Menelaus's Ring", -- [2026-11-22 Fix] Was: "Ebers Bliaud +1"
		back="Alaunus's Cape",waist="Witful Belt",legs="Theophany Pantaloons +2",feet="Vanya Clogs"}

	sets.midcast.StatusRemoval = {main="Yagrush",sub="Ammurapi Shield",ammo="Hasty Pinion +1",
		head="Ebers Cap +1",neck="Voltsurge Torque",ear1="Enchntr. Earring +1",ear2="Malignance Earring",
		body="Inyanga Jubbah +2",hands="Fanatic Gloves",ring1="Kishar Ring",ring2="Prolix Ring",
		back="Swith Cape +1",waist="Witful Belt",legs="Ebers Pantaloons +1",feet="Regal Pumps +1"}
		
	sets.midcast.Erase = set_combine(sets.midcast.StatusRemoval, {neck="Cleric's Torque"})

    -- 110 total Enhancing Magic Skill; caps even without Light Arts
	sets.midcast['Enhancing Magic'] = {main=gear.gada_enhancing_club,sub="Ammurapi Shield",ammo="Hasty Pinion +1",
		head="Telchine Cap",neck="Incanter's Torque",ear1="Andoaa Earring",ear2="Gifted Earring",
		body="Telchine Chas.",hands="Telchine Gloves",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
		back="Perimede Cape",waist="Embla Sash",legs="Telchine Braconi",feet="Theo. Duckbills +2"}

	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {neck="Nodens Gorget",ear2="Earthcry Earring",waist="Siegel Sash",legs="Shedir Seraweels"})

	sets.midcast.Auspice = set_combine(sets.midcast['Enhancing Magic'], {feet="Ebers Duckbills +1"})

	sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {main="Vadose Rod",sub="Ammurapi Shield",hands="Regal Cuffs",waist="Emphatikos Rope",legs="Shedir Seraweels"})

	sets.midcast.Regen = set_combine(sets.midcast['Enhancing Magic'], {hands="Ebers Mitts +1",legs="Theophany Pantaloons +2",body="Piety Bliaut +3"}) -- [2026-11-22 Fix] Was: "Piety Briault+3"
	
	sets.midcast.Protect = set_combine(sets.midcast['Enhancing Magic'], {ring2="Sheltered Ring",feet="Piety Duckbills +1",ear1="Gifted Earring",waist="Sekhmet Corset"})
	sets.midcast.Protectra = set_combine(sets.midcast['Enhancing Magic'], {ring2="Sheltered Ring",feet="Piety Duckbills +1",ear1="Gifted Earring",waist="Sekhmet Corset"})
	sets.midcast.Shell = set_combine(sets.midcast['Enhancing Magic'], {ring2="Sheltered Ring",legs="Piety Pantaln. +1",ear1="Gifted Earring",waist="Sekhmet Corset"})
	sets.midcast.Shellra = set_combine(sets.midcast['Enhancing Magic'], {ring2="Sheltered Ring",legs="Piety Pantaln. +1",ear1="Gifted Earring",waist="Sekhmet Corset"})
	
	sets.midcast.BarElement = {main="Beneficus",sub="Ammurapi Shield",ammo="Hasty Pinion +1",
		head="Ebers Cap +1",neck="Incanter's Torque",ear1="Andoaa Earring",ear2="Gifted Earring",
		body="Ebers Bliaut +1",hands="Ebers Mitts +1",ring1="Stikini Ring +1",ring2="Stikini Ring +1", -- [2026-11-22 Fix] Was: "Ebers Bliaud +1"
		back="Alaunus's Cape",waist="Olympus Sash",legs="Piety Pantaln. +1",feet="Ebers Duckbills +1"}

	sets.midcast.Impact = {main="Daybreak",sub="Ammurapi Shield",ammo="Pemphredo Tathlum",
		head=empty,neck="Erra Pendant",ear1="Nourish. Earring +1",ear2="Digni. Earring",
		body="Twilight Cloak",hands=gear.chironic_enfeeble_hands,ring1="Metamor. Ring +1",ring2="Stikini Ring +1",
		back="Toro Cape",waist="Acuity Belt +1",legs="Chironic Hose",feet=gear.chironic_nuke_feet}
		
	sets.midcast['Elemental Magic'] = {main="Daybreak",sub="Ammurapi Shield",ammo="Dosis Tathlum",
		head="C. Palug Crown",neck="Baetyl Pendant",ear1="Nourish. Earring +1",ear2="Friomisi Earring",
		body="Witching Robe",hands=gear.chironic_enfeeble_hands,ring1="Shiva Ring +1",ring2="Freke Ring",
		back="Toro Cape",waist=gear.ElementalObi,legs="Chironic Hose",feet=gear.chironic_nuke_feet}

	sets.midcast['Elemental Magic'].Resistant = {main="Daybreak",sub="Ammurapi Shield",ammo="Dosis Tathlum",
		head="C. Palug Crown",neck="Sanctity Necklace",ear1="Nourish. Earring +1",ear2="Crematio Earring",
		body="Witching Robe",hands=gear.chironic_enfeeble_hands,ring1="Metamor. Ring +1",ring2="Freke Ring",
		back="Toro Cape",waist="Yamabuki-no-Obi",legs="Chironic Hose",feet=gear.chironic_nuke_feet}

	sets.midcast['Divine Magic'] = {main="Daybreak",sub="Ammurapi Shield",ammo="Pemphredo Tathlum",
		head="C. Palug Crown",neck="Incanter's Torque",ear1="Nourish. Earring +1",ear2="Digni. Earring",
		body="Inyanga Jubbah +2",hands="Fanatic Gloves",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
		back="Aurist's Cape +1",waist="Luminary Sash",legs="Chironic Hose",feet=gear.chironic_nuke_feet}
		
	sets.midcast.Holy = {main="Daybreak",sub="Ammurapi Shield",ammo="Pemphredo Tathlum",
		head="C. Palug Crown",neck="Baetyl Pendant",ear1="Nourish. Earring +1",ear2="Friomisi Earring",
		body="Witching Robe",hands=gear.chironic_enfeeble_hands,ring1="Metamor. Ring +1",ring2="Freke Ring",
		back="Toro Cape",waist=gear.ElementalObi,legs="Gyve Trousers",feet=gear.chironic_nuke_feet}

	sets.midcast['Dark Magic'] = {main="Daybreak",sub="Ammurapi Shield",ammo="Pemphredo Tathlum",
		head="Befouled Crown",neck="Erra Pendant",ear1="Nourish. Earring +1",ear2="Digni. Earring",
		body="Inyanga Jubbah +2",hands=gear.chironic_enfeeble_hands,ring1="Stikini Ring +1",ring2="Stikini Ring +1",
		back="Aurist's Cape +1",waist="Acuity Belt +1",legs="Chironic Hose",feet=gear.chironic_nuke_feet}

    sets.midcast.Drain = {main="Rubicundity",sub="Ammurapi Shield",ammo="Pemphredo Tathlum",
        head="Pixie Hairpin +1",neck="Erra Pendant",ear1="Nourish. Earring +1",ear2="Digni. Earring",
        body="Inyanga Jubbah +2",hands=gear.chironic_enfeeble_hands,ring1="Evanescence Ring",ring2="Archon Ring",
        back="Aurist's Cape +1",waist="Fucho-no-obi",legs="Chironic Hose",feet=gear.chironic_nuke_feet}

    sets.midcast.Drain.Resistant = {main="Rubicundity",sub="Ammurapi Shield",ammo="Pemphredo Tathlum",
        head="Befouled Crown",neck="Erra Pendant",ear1="Nourish. Earring +1",ear2="Digni. Earring",
        body="Chironic Doublet",hands=gear.chironic_enfeeble_hands,ring1="Stikini Ring +1",ring2="Stikini Ring +1",
        back="Aurist's Cape +1",waist="Fucho-no-obi",legs="Chironic Hose",feet=gear.chironic_nuke_feet}

    sets.midcast.Aspir = sets.midcast.Drain
	sets.midcast.Aspir.Resistant = sets.midcast.Drain.Resistant

	sets.midcast.Stun = {main=gear.grioavolr_fc_staff,sub="Clerisy Strap +1",ammo="Hasty Pinion +1",
		head="Nahtirah Hat",neck="Voltsurge Torque",ear1="Enchntr. Earring +1",ear2="Malignance Earring",
		body="Inyanga Jubbah +2",hands="Fanatic Gloves",ring1="Kishar Ring",ring2="Stikini Ring +1",
		back="Aurist's Cape +1",waist="Witful Belt",legs="Lengo Pants",feet="Regal Pumps +1"}

	sets.midcast.Stun.Resistant = {main="Daybreak",sub="Ammurapi Shield",ammo="Pemphredo Tathlum",
		head="Nahtirah Hat",neck="Erra Pendant",ear1="Nourish. Earring +1",ear2="Digni. Earring",
		body="Inyanga Jubbah +2",hands="Fanatic Gloves",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
		back="Aurist's Cape +1",waist="Acuity Belt +1",legs="Chironic Hose",feet=gear.chironic_nuke_feet}
		
	sets.midcast.Dispel = {main="Daybreak",sub="Ammurapi Shield",ammo="Pemphredo Tathlum",
		head="Nahtirah Hat",neck="Erra Pendant",ear1="Nourish. Earring +1",ear2="Digni. Earring",
		body="Inyanga Jubbah +2",hands="Fanatic Gloves",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
		back="Aurist's Cape +1",waist="Acuity Belt +1",legs="Chironic Hose",feet=gear.chironic_nuke_feet}
		
	sets.midcast.Dispelga = set_combine(sets.midcast.Dispel, {main="Daybreak",sub="Ammurapi Shield"})

	sets.midcast['Enfeebling Magic'] = {main="Daybreak",sub="Ammurapi Shield",ammo="Pemphredo Tathlum",
		head="Befouled Crown",neck="Erra Pendant",ear1="Nourish. Earring +1",ear2="Digni. Earring",
		body="Theo. Bliaut +2",hands="Theophany Mitts +2",ring1="Kishar Ring",ring2="Stikini Ring +1", -- [2026-11-22 Fix] Was: "Theophany Briault +2"
		back="Aurist's Cape +1",waist="Luminary Sash",legs="Chironic Hose",feet="Theo. Duckbills +2"}

	sets.midcast['Enfeebling Magic'].Resistant = {main="Daybreak",sub="Ammurapi Shield",ammo="Pemphredo Tathlum",
		head="Befouled Crown",neck="Erra Pendant",ear1="Nourish. Earring +1",ear2="Digni. Earring",
		body="Theo. Bliaut +2",hands="Theophany Mitts +2",ring1="Metamor. Ring +1",ring2="Stikini Ring +1", -- [2026-11-22 Fix] Was: "Theophany Briault +2"
		back="Aurist's Cape +1",waist="Luminary Sash",legs="Chironic Hose",feet="Theo. Duckbills +2"}
		
	sets.midcast.Dia = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
	sets.midcast.Diaga = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
	sets.midcast['Dia II'] = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
	sets.midcast.Bio = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
	sets.midcast['Bio II'] = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)

    sets.midcast.ElementalEnfeeble = set_combine(sets.midcast['Enfeebling Magic'], {})
    sets.midcast.ElementalEnfeeble.Resistant = set_combine(sets.midcast['Enfeebling Magic'].Resistant, {})

	sets.midcast.IntEnfeebles = set_combine(sets.midcast['Enfeebling Magic'], {waist="Acuity Belt +1"})
	sets.midcast.IntEnfeebles.Resistant = set_combine(sets.midcast['Enfeebling Magic'].Resistant, {waist="Acuity Belt +1"})

	sets.midcast.MndEnfeebles = set_combine(sets.midcast['Enfeebling Magic'], {back="Alaunus's Cape"})
	sets.midcast.MndEnfeebles.Resistant = set_combine(sets.midcast['Enfeebling Magic'].Resistant, {back="Alaunus's Cape"})

    -- Sets to return to when not performing an action.

    -- Resting sets
	sets.resting = {main="Chatoyant Staff",sub="Oneiros Grip",ammo="Homiliary",
		head="Befouled Crown",neck="Clr. Torque +2",ear1="Antivenom Earring",ear2="Ethereal Earring",
		body="Piety Bliaut +3",hands=gear.chironic_refresh_hands,ring1="Bifrost Ring",ring2="Serket Ring", -- [2026-11-22 Fix] Was: "Piety Briault +3"
		back="Vita Cape",waist="Cleric's Belt",legs="Assid. Pants +1",feet=gear.chironic_refresh_feet}

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
	sets.idle = {main="Bolelabunga",sub="Genbu's Shield",ammo="Homiliary",
		head="Befouled Crown",neck="Clr. Torque +2",ear1="Etiolation Earring",ear2="Ethereal Earring",
		body="Piety Bliaut +3",hands=gear.chironic_refresh_hands,ring1="Bifrost Ring",ring2="Serket Ring", -- [2026-11-22 Fix] Was: "Piety Briault +3"
		back="Moonbeam Cape",waist="Flax Sash",legs="Assid. Pants +1",feet=gear.chironic_refresh_feet}

	sets.idle.PDT = {main="Mafic Cudgel",sub="Genbu's Shield",ammo="Staunch Tathlum +1",
		head="Gende. Caubeen +1",neck="Loricate Torque +1",ear1="Etiolation Earring",ear2="Ethereal Earring",
		body="Piety Bliaut +3",hands="Gende. Gages +1",ring1="Defending Ring",ring2="Dark Ring", -- [2026-11-22 Fix] Was: "Piety Briault +3"
		back="Moonbeam Cape",waist="Flax Sash",legs="Assid. Pants +1",feet=gear.chironic_refresh_feet}
		
	sets.idle.MDT = {main="Daybreak",sub="Genbu's Shield",ammo="Staunch Tathlum +1",
		head="Gende. Caubeen +1",neck="Loricate Torque +1",ear1="Etiolation Earring",ear2="Ethereal Earring",
		body="Inyanga Jubbah +2",hands="Gende. Gages +1",ring1="Defending Ring",ring2="Dark Ring",
		back="Moonbeam Cape",waist="Flax Sash",legs="Assid. Pants +1",feet=gear.chironic_refresh_feet}
		
	sets.idle.Weak = {main="Bolelabunga",sub="Genbu's Shield",ammo="Homiliary",
		head="Befouled Crown",neck="Loricate Torque +1",ear1="Etiolation Earring",ear2="Ethereal Earring",
		body="Witching Robe",hands=gear.chironic_refresh_hands,ring1="Defending Ring",ring2="Dark Ring",
		back="Moonbeam Cape",waist="Witful Belt",legs="Assid. Pants +1",feet=gear.chironic_refresh_feet}

    -- Defense sets

	sets.defense.PDT = {main="Mafic Cudgel",sub="Genbu's Shield",ammo="Staunch Tathlum +1",
		head="Gende. Caubeen +1",neck="Loricate Torque +1",ear1="Etiolation Earring",ear2="Ethereal Earring",
		body="Piety Bliaut +3",hands="Gende. Gages +1",ring1="Defending Ring",ring2="Vocane Ring", -- [2026-11-22 Fix] Was: "Piety Briault +3"
		back="Moonbeam Cape",waist="Flax Sash",legs="Assid. Pants +1",feet=gear.chironic_refresh_feet}

	sets.defense.MDT = {main="Bolelabunga",sub="Genbu's Shield",ammo="Staunch Tathlum +1",
		head="Gende. Caubeen +1",neck="Loricate Torque +1",ear1="Etiolation Earring",ear2="Sanare Earring",
		body="Inyanga Jubbah +2",hands=gear.chironic_refresh_hands,ring1="Defending Ring",ring2="Vocane Ring",
		back="Moonbeam Cape",waist="Flax Sash",legs="Theophany Pantaloons +2",feet="Gende. Galosh. +1"}

    sets.defense.MEVA = {ammo="Staunch Tathlum +1",
        head="Telchine Cap",neck="Warder's Charm +1",ear1="Etiolation Earring",ear2="Sanare Earring",
		body="Inyanga Jubbah +2",hands="Telchine Gloves",ring1="Vengeful Ring",ring2="Purity Ring", -- [2026-11-22 Fix] Was: Ring2="Purity Ring"
        back="Aurist's Cape +1",waist="Luminary Sash",legs="Telchine Braconi",feet="Telchine Pigaches"}
		
		-- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Basic set for if no TP weapon is defined.
    sets.engaged = {ammo="Staunch Tathlum +1",
        head="Aya. Zucchetto +2",neck="Asperity Necklace",ear1="Mache Earring",ear2="Brutal Earring",
		body="Ayanmo Corazza +2",hands="Aya. Manopolas +2",ring1="Petrov Ring",ring2="Ilabrat Ring", -- [2026-11-22 Fix] Was: Ring2="Ilabrat Ring"
        back="Kayapa Cape",waist="Windbuffet Belt +1",legs="Aya. Cosciales +2",feet="Battlecast Gaiters"}

    sets.engaged.Acc = {ammo="Hasty Pinion +1",
        head="Aya. Zucchetto +2",neck="Combatant's Torque",ear1="Telos Earring",ear2="Brutal Earring",
		body="Ayanmo Corazza +2",hands="Aya. Manopolas +2",ring1="Petrov Ring",ring2="Ilabrat Ring", -- [2026-11-22 Fix] Was: Ring2="Ilabrat Ring"
        back="Kayapa Cape",waist="Olseni Belt",legs="Aya. Cosciales +2",feet="Aya. Gambieras +2"}

	sets.engaged.DW = {ammo="Staunch Tathlum +1",
        head="Aya. Zucchetto +2",neck="Asperity Necklace",ear1="Telos Earring",ear2="Suppanomimi",
		body="Ayanmo Corazza +2",hands="Aya. Manopolas +2",ring1="Petrov Ring",ring2="Ilabrat Ring", -- [2026-11-22 Fix] Was: Ring2="Ilabrat Ring"
        back="Kayapa Cape",waist="Shetal Stone",legs="Aya. Cosciales +2",feet="Battlecast Gaiters"}

    sets.engaged.DW.Acc = {ammo="Hasty Pinion +1",
        head="Aya. Zucchetto +2",neck="Combatant's Torque",ear1="Telos Earring",ear2="Suppanomimi",
		body="Ayanmo Corazza +2",hands="Aya. Manopolas +2",ring1="Petrov Ring",ring2="Ilabrat Ring", -- [2026-11-22 Fix] Was: Ring2="Ilabrat Ring"
        back="Kayapa Cape",waist="Shetal Stone",legs="Aya. Cosciales +2",feet="Aya. Gambieras +2"}

		-- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Divine Caress'] = {hands="Ebers Mitts +1",back="Mending Cape"}

	sets.HPDown = {head="Pixie Hairpin +1",ear1="Mendicant's Earring",ear2="Evans Earring",
		body="Zendik Robe",hands="Hieros Mittens",ring1="Mephitas's Ring +1",ring2="Mephitas's Ring",
		back="Swith Cape +1",waist="Flax Sash",legs="Shedir Seraweels",feet=""}

	sets.HPCure = {main="Queller Rod",sub="Ammurapi Shield",ammo="Pemphredo Tathlum",
		head="Blistering Sallet +1",neck="Nodens Gorget",ear1="Etiolation Earring",ear2="Ethereal Earring",
		body="Kaykaus Bliaut",hands="Kaykaus Cuffs",ring1="Kunaji Ring",ring2="Meridian Ring",
		back="Alaunus's Cape",waist="Eschan Stone",legs="Ebers Pantaloons +1",feet="Kaykaus Boots"}

	sets.buff.Doom = set_combine(sets.buff.Doom, {})

end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	set_macro_page(10, 4)
end


function set_lockstyle()
    send_command('wait 2; input /lockstyleset 6')--regular 6
end


function check_heal()
	--use_equipment_items()
    
	local abil_recasts = windower.ffxi.get_ability_recasts()
	local spell_recasts = windower.ffxi.get_spell_recasts()
	
	-- doom and charm check
	for i=1,party.count do -- [2026-11-22 Fix] Was: `for i=1,1 do`
		if state.AutoHealMode.value and party[i] and party[i].mob and party[i].mob.distance < 400 and party[i].hpp > 0 and player.mp > 50 and player.hp > 0 then -- [2026-11-22 Fix] Was: party[i].mob.distance < 20 (unsquared) and unguarded party[i]/mob
			local has_caress_debuff = party[i].buffactive and (party[i].buffactive.doom or party[i].buffactive.Curse or party[i].buffactive.petrification or party[i].buffactive.paralysis or party[i].buffactive.disease or party[i].buffactive.plagued or party[i].buffactive.silence or (party[i].buffactive.blindness and party[i].name ~= 'Clintbeastwood') or party[i].buffactive.poison)
			if abil_recasts[32] < latency and not buffactive['Divine Caress'] and has_caress_debuff then -- [2026-11-22 Fix] Was: unconditional `abil_recasts[32] < latency` firing Divine Caress every 60s
				windower.chat.input('/ja "Divine Caress" <me>')
				tickdelay = os.clock() + 1.1
				return true
			elseif spell_recasts[20] < spell_latency and party[i].buffactive and party[i].buffactive.doom then
				windower.chat.input('/ma "Cursna" "'..party[i].name..'"')
				tickdelay = os.clock() + 2
				return true
			elseif spell_recasts[98] < spell_latency and party[i].buffactive and party[i].buffactive.charm and not party[i].buffactive.sleep then
				windower.chat.input('/ma "Repose" "'..party[i].name..'"')
				tickdelay = os.clock() + 2
				return true
			end
			
				
        end
    end
	
	-- cure
				
				
	-- rest of debuffs
	
	for i=1,party.count do -- [2026-11-22 Fix] Was: `for i=1,1 do`
		if state.AutoHealMode.value and party[i] and party[i].mob and party[i].mob.distance < 400 and party[i].hpp > 0 and player.mp > 50 and player.hp > 0 then -- [2026-11-22 Fix] Was: party[i].mob.distance < 20 (unsquared) and unguarded party[i]/mob
			
			if spell_recasts[7] < spell_latency and party[i].buffactive and party[i].buffactive.sleep and not party[i].buffactive.charm then
				windower.chat.input('/ma "Curaga" "'..party[i].name..'"')
				tickdelay = os.clock() + 2
				return true
			elseif spell_recasts[20] < spell_latency and party[i].buffactive and party[i].buffactive.Curse then
				windower.chat.input('/ma "Cursna" "'..party[i].name..'"')
				tickdelay = os.clock() + 2
				return true
			elseif spell_recasts[18] < spell_latency and party[i].buffactive and party[i].buffactive.petrification then
				windower.chat.input('/ma "Stona" "'..party[i].name..'"')
				tickdelay = os.clock() + 2
				return true
			elseif spell_recasts[15] < spell_latency and party[i].buffactive and party[i].buffactive.paralysis then
				windower.chat.input('/ma "Paralyna" "'..party[i].name..'"')
				tickdelay = os.clock() + 2
				return true	
			elseif spell_recasts[19] < spell_latency and party[i].buffactive and (party[i].buffactive.disease or party[i].buffactive.plagued) then
				windower.chat.input('/ma "Viruna" "'..party[i].name..'"')
				tickdelay = os.clock() + 2
				return true
			elseif spell_recasts[17] < spell_latency and party[i].buffactive and party[i].buffactive.silence then
				windower.chat.input('/ma "Silena" "'..party[i].name..'"')
				tickdelay = os.clock() + 2
				return true
			elseif spell_recasts[16] < spell_latency and party[i].buffactive and party[i].buffactive.blindness and party[i].name ~= 'Clintbeastwood' then -- [2026-11-22 Fix] Was: `not party[i].name == 'Clintbeastwood'`
				windower.chat.input('/ma "Blindna" "'..party[i].name..'"')
				tickdelay = os.clock() + 2
				return true	
			elseif spell_recasts[14] < spell_latency and party[i].buffactive and party[i].buffactive.poison then -- [2026-11-22 Fix] Was: `party[i].buffactive.poision`
				windower.chat.input('/ma "Poisona" "'..party[i].name..'"')
				tickdelay = os.clock() + 2
				return true
			elseif spell_recasts[143] < spell_latency and party[i].buffactive and (party[i].buffactive.bind or party[i].buffactive.weight or party[i].buffactive.slow or party[i].buffactive.addle or party[i].buffactive.bio) then
				windower.chat.input('/ma "Erase" "'..party[i].name..'"')
				tickdelay = os.clock() + 2
				return true
				
			end
		end
	end
	for i=1,party.count do  
		if state.AutoHealMode.value and party[i] and party[i].mob and party[i].mob.distance < 400 and player.hp > 0 then -- [2026-11-22 Fix] Was: party[i].mob.distance < 20 (unsquared) and unguarded party[i]/mob
			if spell_recasts[494] < spell_latency and party[i].hp==0 and player.mp>300 then
				windower.chat.input('/ma "Arise" "'..party[i].name..'"')
				tickdelay = os.clock() + 10
				return true
			elseif abil_recasts[28] < latency and party[i].mob.distance < 64 and party[i].name ~= player.name and party[i].max_mp and party[i].mp and party[i].max_mp ~= party[i].mp then -- [2026-11-22 Fix] Was: `< 8 and not party[i].name == player.name and not party[i].max_mp == party[i].mp`
				if party[i].max_mp - party[i].mp > 500 then
					windower.chat.input('/ja "Devotion" "'..party[i].name..'"')
					tickdelay = os.clock() + 1.1
					return true
				end
			end	
        end
    end

if state.AutoHealMode.value and spell_recasts[54] < spell_latency and not buffactive.Stoneskin and player.sub_job == 'SCH' then
	if abil_recasts[228] < latency and not buffactive['Light Arts'] then
		windower.chat.input('/ja "Light Arts" <me>')
		tickdelay = os.clock() + 1.1
		return true
	end
	if abil_recasts[233] < latency and not buffactive['Accession'] then
		windower.chat.input('/ja "Accession" <me>')
		tickdelay = os.clock() + 1.1
		return true
	end	
	windower.chat.input('/ma "Stoneskin" <me>') -- [2026-11-22 Fix] Was: "Stone Skin"
	tickdelay = os.clock() + 5
	return true
end
	
return false
end











