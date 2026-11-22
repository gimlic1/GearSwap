function user_job_setup()

    -- Options: Override default values	
	state.OffenseMode:options('Normal','Acc')
    state.HybridMode:options('Tank','DDTank','BreathTank','Dawn','NoShellTank','Normal')
    state.WeaponskillMode:options('Match','Normal', 'Acc')
    state.CastingMode:options('Normal','SIRD')
	state.Passive:options('None','AbsorbMP')
    state.PhysicalDefenseMode:options('PDT','PDT_HP','Tank')
    state.MagicalDefenseMode:options('BDT','MDT_HP','AegisMDT','AegisNoShellMDT','OchainMDT','OchainNoShellMDT','MDT_Reraise')
	state.ResistDefenseMode:options('MEVA','MEVA_HP','Death','Charm')
	state.IdleMode:options('Normal','Tank','KiteTank','PDT','MDT','Refresh','Reraise')
	state.Weapons:options('None','BurtgangAegis','TP','TP2','NaeglingAegis')--,'DeaconAegis','SequenceAegis','SequenceBlurred')
	
    state.ExtraDefenseMode = M{['description']='Extra Defense Mode','None','MP','Twilight'}
	
	gear.fastcast_jse_back = {name="Rudianos's Mantle", augments={'INT+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','"Fast Cast"+10','Phys. dmg. taken-10%',}}
	gear.enmity_jse_back = {name="Rudianos's Mantle",augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','Enmity+10',}}

	-- Additional local binds
	send_command('bind !` gs c SubJobEnmity')
	send_command('bind ^backspace input /ja "Shield Bash" <t>')
	send_command('bind @backspace input /ja "Cover" <stpt>')
	send_command('bind !backspace input /ja "Sentinel" <me>')
	send_command('bind @= input /ja "Chivalry" <me>')
	send_command('bind != input /ja "Palisade" <me>')
	send_command('bind ^delete input /ja "Provoke" <stnpc>')
	send_command('bind !delete input /ma "Cure IV" <stal>')
	send_command('bind @delete input /ma "Flash" <stnpc>')
    send_command('bind !f11 gs c cycle ExtraDefenseMode')
	send_command('bind @` gs c cycle RuneElement')
	send_command('bind ^pause gs c toggle AutoRuneMode')
	send_command('bind @f8 gs c toggle AutoTankMode')
	send_command('bind @f10 gs c toggle TankAutoDefense')
	send_command('bind ^@!` gs c cycle SkillchainMode')
	
    select_default_macro_book()
    update_defense_mode()
	set_lockstyle()
end

function init_gear_sets()
	
	--------------------------------------
	-- Precast sets
	--------------------------------------
	
    sets.Enmity = {main="Burtgang",ammo="Paeapua",
        head="Loess Barbuta +1",neck="Unmoving Collar +1",ear1="Friomisi Earring",ear2="Trux Earring",
        body="Souv. Cuirass +1",hands="Yorium Gauntlets",ring1="Apeile Ring +1",ring2="Apeile Ring",
        back=gear.enmity_jse_back,waist="Creed Baudrier",legs="Souv. Diechlings +1",feet="Eschite Greaves"}
		
    sets.Enmity.SIRD = {main="Burtgang",ammo="Staunch Tathlum +1",
		head="Souveran Schaller +1",neck="Moonlight Necklace",ear1="Friomisi Earring",ear2="Trux Earring",
		body="Souv. Cuirass +1",hands="Yorium Gauntlets",ring1="Defending Ring",ring2="Moonlight Ring",
		back=gear.enmity_jse_back,waist="Audumbla Sash",legs="Founder's Hose",feet="Odyssean Greaves"}
		
    sets.Enmity.DT = {main="Burtgang",ammo="Staunch Tathlum +1",
        head="Souv. Schaller +1",neck="Loricate Torque +1",ear1="Odnowa Earring +1",ear2="Tuisto Earring",
        body="Rev. Surcoat +3",hands="Yorium Gauntlets",ring1="Gelatinous Ring +1",ring2="Moonlight Ring",
        back="Moonbeam Cape",waist="Creed Baudrier",legs="Souv. Diechlings +1",feet="Souveran Schuhs +1"}
		
    -- Precast sets to enhance JAs
    sets.precast.JA['Invincible'] = set_combine(sets.Enmity,{legs="Cab. Breeches +3"})
    sets.precast.JA['Holy Circle'] = set_combine(sets.Enmity,{feet="Rev. Leggings +3"})
    sets.precast.JA['Sentinel'] = set_combine(sets.Enmity,{feet="Cab. Leggings +3"})
    sets.precast.JA['Rampart'] = set_combine(sets.Enmity,{head="Cab. Coronet +3"}) --head="Valor Coronet" (Also Vit?)
    sets.precast.JA['Fealty'] = set_combine(sets.Enmity,{body="Cab. Surcoat +3"})
    sets.precast.JA['Divine Emblem'] = set_combine(sets.Enmity,{feet="Chev. Sabatons +1"})
    sets.precast.JA['Cover'] = set_combine(sets.Enmity, {body="Cab. Surcoat +3"}) --head="Rev. Coronet +1",
	
    sets.precast.JA['Invincible'].DT = set_combine(sets.Enmity.DT,{legs="Cab. Breeches +3"})
    sets.precast.JA['Holy Circle'].DT = set_combine(sets.Enmity.DT,{feet="Rev. Leggings +3"})
    sets.precast.JA['Sentinel'].DT = set_combine(sets.Enmity.DT,{feet="Cab. Leggings +3"})
    sets.precast.JA['Rampart'].DT = set_combine(sets.Enmity.DT,{head="Cab. Coronet +3"}) --head="Valor Coronet" (Also Vit?)
    sets.precast.JA['Fealty'].DT = set_combine(sets.Enmity.DT,{body="Cab. Surcoat +3"})
    sets.precast.JA['Divine Emblem'].DT = set_combine(sets.Enmity.DT,{feet="Chev. Sabatons +1"})
    sets.precast.JA['Cover'].DT = set_combine(sets.Enmity.DT, {body="Cab. Surcoat +3"}) --head="Rev. Coronet +1",
	
    -- add mnd for Chivalry
    sets.precast.JA['Chivalry'] = {
		head="Sulevia's Mask +2",neck="Phalaina Locket",ear1="Nourish. Earring",ear2="Nourish. Earring +1",
		body="Rev. Surcoat +3",hands="Cab. Gauntlets +3",ring1="Stikini Ring +1",ring2="Rufescent Ring",
		back=gear.enmity_jse_back,waist="Luminary Sash",legs="Carmine Cuisses +1",feet="Carmine Greaves +1"}

	sets.precast.JA['Shield Bash'] = set_combine(sets.Enmity, {sub="Aegis",hands="Cab. Gauntlets +3"})		
    sets.precast.JA['Provoke'] = set_combine(sets.Enmity, {})
	sets.precast.JA['Warcry'] = set_combine(sets.Enmity, {})
	sets.precast.JA['Palisade'] = set_combine(sets.Enmity, {})
	sets.precast.JA['Intervene'] = set_combine(sets.Enmity, {})
	sets.precast.JA['Defender'] = set_combine(sets.Enmity, {})
	sets.precast.JA['Berserk'] = set_combine(sets.Enmity, {})
	sets.precast.JA['Aggressor'] = set_combine(sets.Enmity, {})
	
	sets.precast.JA['Shield Bash'].DT = set_combine(sets.Enmity.DT, {sub="Aegis",hands="Cab. Gauntlets +3"})		
    sets.precast.JA['Provoke'].DT = set_combine(sets.Enmity.DT, {})
	sets.precast.JA['Warcry'].DT = set_combine(sets.Enmity.DT, {})
	sets.precast.JA['Palisade'].DT = set_combine(sets.Enmity.DT, {})
	sets.precast.JA['Intervene'].DT = set_combine(sets.Enmity.DT, {})
	sets.precast.JA['Defender'].DT = set_combine(sets.Enmity.DT, {})
	sets.precast.JA['Berserk'].DT = set_combine(sets.Enmity.DT, {})
	sets.precast.JA['Aggressor'].DT = set_combine(sets.Enmity.DT, {})

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
		head="Carmine Mask +1",
		body="Rev. Surcoat +3",ring1="Asklepian Ring",ring2="Valseur's Ring",
		waist="Chaac Belt",legs="Sulev. Cuisses +2"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}
    
    sets.precast.Step = {ammo="Aurgelmir Orb +1",
        head="Founder's Corona",neck="Combatant's Torque",ear1="Mache Earring +1",ear2="Telos Earring",
        body="Tartarus Platemail",hands="Leyline Gloves",ring1="Ramuh Ring +1",ring2="Patricius Ring",
        back="Ground. Mantle +1",waist="Olseni Belt",legs="Carmine Cuisses +1",feet="Founder's Greaves"}
		
	sets.precast.JA['Violent Flourish'] = {ammo="Aurgelmir Orb +1",
        head="Founder's Corona",neck="Erra Pendant",ear1="Gwati Earring",ear2="Digni. Earring",
        body="Found. Breastplate",hands="Leyline Gloves",ring1="Defending Ring",ring2="Stikini Ring +1",
        back="Ground. Mantle +1",waist="Olseni Belt",legs="Carmine Cuisses +1",feet="Founder's Greaves"}
		
	sets.precast.JA['Animated Flourish'] = set_combine(sets.Enmity, {})

    -- Fast cast sets for spells
    
    sets.precast.FC = {main="Sakpata's Sword",ammo="Impatiens",
		head="Sakpata's Helm",neck="Voltsurge Torque",ear1="Etiolation Earring",ear2="Moonshade Earring", -- [2026-11-22 Fix] Was: ear1="Eriolation Earring"
		body="Rev. Surcoat +3",hands="Leyline Gloves",ring1="Lebeche Ring",ring2="Kishar Ring",
		back=gear.fastcast_jse_back,waist="Flume Belt +1",legs="Enif Cosciales",feet="Odyssean Greaves"}
		
    sets.precast.FC.DT = {ammo="Staunch Tathlum +1",
        head="Sakpata's Helm",neck="Loricate Torque +1",ear1="Odnowa Earring +1",ear2="Moonshade Earring",--ear2="Tuisto Earring"
        body="Rev. Surcoat +3",hands="Sakpata's Gauntlets",ring1="Defending Ring",ring2="Lebeche Ring", -- [2026-11-22 Fix] Was: ring1="Defendering Ring"
        back="Moonbeam Cape",waist="Creed Baudrier",legs="Souv. Diechlings +1",feet="Sakpata's Leggings"}
		
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})
	
	sets.precast.FC.Cure = set_combine(sets.precast.FC, {ear1="Nourish. Earring +1",body="Jumalik Mail"})--neck="Diemer Gorget",
  
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {ammo="Paeapua",
		head="Flam. Zucchetto +2",neck="Asperity Necklace",ear1="Cessance Earring",ear2="Brutal Earring",
		body="Rev. Surcoat +3",hands="Sakpata's Gauntlets",ring1="Regal Ring",ring2="Rufescent Ring",
		back="Bleating Mantle",waist="Fotia Belt",legs="Sulev. Cuisses +2",feet="Sulev. Leggings +2"}
		
    sets.precast.WS.DT = {ammo="Staunch Tathlum +1",
        head="Souv. Schaller +1",neck="Loricate Torque +1",ear1="Odnowa Earring +1",ear2="Tuisto Earring",
        body="Rev. Surcoat +3",hands="Sakpata's Gauntlets",ring1="Gelatinous Ring +1",ring2="Moonlight Ring",
        back="Moonbeam Cape",waist="Creed Baudrier",legs="Souv. Diechlings +1",feet="Sakpata's Leggings"}

    sets.precast.WS.Acc = {ammo="Hasty Pinion +1",
        head="Ynglinga Sallet",neck="Combatant's Torque",ear1="Mache Earring +1",ear2="Telos Earring",
        body="Rev. Surcoat +3",hands="Sakpata's Gauntlets",ring1="Ramuh Ring +1",ring2="Ramuh Ring +1",
        back="Ground. Mantle +1",waist="Olseni Belt",legs="Carmine Cuisses +1",feet="Sulev. Leggings +2"}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {neck="Fotia Gorget",ear1="Brutal Earring",ear2="Moonshade Earring"})
    sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS.Acc, {neck="Fotia Gorget",ear1="Mache Earring +1",ear2="Moonshade Earring"})

	sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {neck="Fotia Gorget",ear1="Brutal Earring",ear2="Moonshade Earring"})
    sets.precast.WS['Chant du Cygne'].Acc = set_combine(sets.precast.WS.Acc, {neck="Fotia Gorget",ear1="Mache Earring +1",ear2="Moonshade Earring"})

	sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {neck="Fotia Gorget",ear1="Ishvara Earring",ear2="Moonshade Earring"})
    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS.Acc, {ear1="Mache Earring +1",ear2="Telos Earring"})
	
	sets.precast.WS['Flat Blade'] = {ammo="Aurgelmir Orb +1",
        head="Founder's Corona",neck="Voltsurge Torque",ear1="Gwati Earring",ear2="Digni. Earring",
        body="Flamma Korazin +2",hands="Leyline Gloves",ring1="Defending Ring",ring2="Stikini Ring +1",
        back="Ground. Mantle +1",waist="Olseni Belt",legs="Carmine Cuisses +1",feet="Founder's Greaves"}

	sets.precast.WS['Flat Blade'].Acc = {ammo="Aurgelmir Orb +1",
        head="Flam. Zucchetto +2",neck="Sanctity Necklace",ear1="Gwati Earring",ear2="Digni. Earring",
        body="Flamma Korazin +2",hands="Flam. Manopolas +2",ring1="Ramuh Ring +1",ring2="Ramuh Ring +1",
        back="Ground. Mantle +1",waist="Eschan Stone",legs="Flamma Dirs +2",feet="Flam. Gambieras +2"}

    sets.precast.WS['Sanguine Blade'] = {ammo="Dosis Tathlum",
        head="Jumalik Helm",neck="Sanctity Necklace",ear1="Friomisi Earring",ear2="Crematio Earring",
        body="Jumalik Mail",hands="Founder's Gauntlets",ring1="Metamor. Ring +1",ring2="Archon Ring",
        back="Toro Cape",waist="Fotia Belt",legs="Flamma Dirs +2",feet="Founder's Greaves"}

	sets.precast.WS['Sanguine Blade'].Acc = sets.precast.WS['Sanguine Blade']

    sets.precast.WS['Atonement'] = {ammo="Paeapua",
		head="Loess Barbuta +1",neck="Fotia Gorget",ear1="Moonshade Earring",ear2="Ishvara Earring",
		body=gear.valorous_wsd_body,hands=gear.odyssean_wsd_hands,ring1="Defending Ring",ring2="Moonlight Ring",
		back=gear.enmity_jse_back,waist="Fotia Belt",legs="Flamma Dirs +2",feet="Eschite Greaves"}

    sets.precast.WS['Atonement'].Acc = sets.precast.WS['Atonement']
    sets.precast.WS['Spirits Within'] = sets.precast.WS['Atonement']
    sets.precast.WS['Spirits Within'].Acc = sets.precast.WS['Atonement']

	-- Swap to these on Moonshade using WS if at 3000 TP
	sets.MaxTP = {ear1="Cessance Earring",ear2="Brutal Earring",}
	sets.AccMaxTP = {ear1="Mache Earring +1",ear2="Telos Earring"}


	--------------------------------------
	-- Midcast sets
	--------------------------------------

    sets.midcast.FastRecast = {main="Vampirism",ammo="Paeapua",
        head="Chev. Armet +1",neck="Voltsurge Torque",ear1="Enchntr. Earring +1",ear2="Loquac. Earring",
        body="Rev. Surcoat +3",hands="Leyline Gloves",ring1="Defending Ring",ring2="Kishar Ring",
        waist="Tempus Fugit",legs=gear.odyssean_fc_legs,feet="Odyssean Greaves"}
		
	sets.midcast.FastRecast.DT = {main="Vampirism",ammo="Staunch Tathlum +1",
        head="Souv. Schaller +1",neck="Loricate Torque +1",ear1="Odnowa Earring +1",ear2="Tuisto Earring",
        body="Rev. Surcoat +3",hands="Sakpata's Gauntlets",ring1="Gelatinous Ring +1",ring2="Moonlight Ring",
        back="Moonbeam Cape",waist="Creed Baudrier",legs="Souv. Diechlings +1",feet="Sakpata's Leggings"}

    sets.midcast.Flash = set_combine(sets.Enmity, {})
	sets.midcast.Flash.SIRD = set_combine(sets.Enmity.SIRD, {})
    sets.midcast.Stun = set_combine(sets.Enmity, {})
	sets.midcast.Stun.SIRD = set_combine(sets.Enmity.SIRD, {})
	sets.midcast['Blue Magic'] = set_combine(sets.Enmity.SIRD, {})--I want SIRD on all Blu magic I think?
	sets.midcast['Blue Magic'].SIRD = set_combine(sets.Enmity.SIRD, {})
	sets.midcast.Cocoon = set_combine(sets.Enmity.SIRD, {})

    sets.midcast.Cure = {main="Deacon Sword",sub="Sacro Bulwark",ammo="Staunch Tathlum +1",
		head="Loess Barbuta +1",neck="Sacro Gorget",ear1="Nourish. Earring",ear2="Nourish. Earring +1",
		body="Jumalik Mail",hands="Macabre Gaunt. +1",ring1="Defending Ring",ring2="Moonlight Ring",
		back="Solemnity Cape",waist="Creed Baudrier",legs="Carmine Cuisses +1",feet="Odyssean Greaves"}
		
    sets.midcast.Cure.SIRD = {main="Deacon Sword",sub="Sacro Bulwark",ammo="Staunch Tathlum +1",
		head="Souveran Schaller +1",neck="Moonlight Necklace",ear1="Nourish. Earring",ear2="Nourish. Earring +1",
		body="Jumalik Mail",hands="Macabre Gaunt. +1",ring1="Defending Ring",ring2="Moonlight Ring",
		back="Solemnity Cape",waist="Creed Baudrier",legs="Founder's Hose",feet="Odyssean Greaves"}
		
    sets.midcast.Cure.DT = {main="Deacon Sword",sub="Sacro Bulwark",ammo="Staunch Tathlum +1",
        head="Souv. Schaller +1",neck="Loricate Torque +1",ear1="Odnowa Earring +1",ear2="Tuisto Earring",
        body="Rev. Surcoat +3",hands="Sakpata's Gauntlets",ring1="Gelatinous Ring +1",ring2="Moonlight Ring",
        back="Moonbeam Cape",waist="Creed Baudrier",legs="Souv. Diechlings +1",feet="Sakpata's Leggings"}
		
    sets.midcast.Reprisal = {ammo="Staunch Tathlum +1",
		head="Loess Barbuta +1",neck="Unmoving Collar +1",ear1="Odnowa Earring +1",ear2="Tuisto Earring",
        body="Rev. Surcoat +3",hands="Sakpata's Gauntlets",ring1="Gelatinous Ring +1",ring2="Moonlight Ring",
        back="Moonbeam Cape",waist="Creed Baudrier",legs="Arke Cosc. +1",feet="Souveran Schuhs +1"}

	sets.Self_Healing = {main="Deacon Sword",sub="Sacro Bulwark",ammo="Staunch Tathlum +1",
		head="Souv. Schaller +1",neck="Sacro Gorget",ear1="Nourish. Earring",ear2="Nourish. Earring +1",
		body="Souv. Cuirass +1",hands="Macabre Gaunt. +1",ring1="Gelatinous Ring +1",ring2="Moonlight Ring",
		back="Moonbeam Cape",waist="Creed Baudrier",legs="Souv. Diechlings +1",feet="Souveran Schuhs +1"}
		
	sets.Self_Healing.SIRD = {main="Deacon Sword",sub="Sacro Bulwark",ammo="Staunch Tathlum +1",
		head="Souv. Schaller +1",neck="Moonlight Necklace",ear1="Nourish. Earring",ear2="Nourish. Earring +1",
		body="Souv. Cuirass +1",hands="Macabre Gaunt. +1",ring1="Defending Ring",ring2="Moonlight Ring",
		back="Solemnity Cape",waist="Flume Belt +1",legs="Founder's Hose",feet="Odyssean Greaves"}
		
	sets.Self_Healing.DT = {main="Deacon Sword",sub="Sacro Bulwark",ammo="Staunch Tathlum +1",
        head="Souv. Schaller +1",neck="Loricate Torque +1",ear1="Odnowa Earring +1",ear2="Tuisto Earring",
        body="Rev. Surcoat +3",hands="Sakpata's Gauntlets",ring1="Gelatinous Ring +1",ring2="Moonlight Ring",
        back="Moonbeam Cape",waist="Creed Baudrier",legs="Souv. Diechlings +1",feet="Souveran Schuhs +1"}

	sets.Cure_Received = {head="Souv. Schaller +1",body="Sakpata's Breastplate",hands="Souv. Handsch. +1",feet="Souveran Schuhs +1"}
	sets.Self_Refresh = {waist="Gishdubar Sash"}

    sets.midcast['Enhancing Magic'] = {main="Colada",ammo="Staunch Tathlum +1",
		head="Carmine Mask +1",neck="Incanter's Torque",ear1="Andoaa Earring",ear2="Mimir Earring",
		body="Shab. Cuirass +1",hands="Leyline Gloves",ring1="Defending Ring",ring2="Kishar Ring",
		back="Merciful Cape",waist="Olympus Sash",legs="Carmine Cuisses +1",feet="Odyssean Greaves"}
		
    sets.midcast['Enhancing Magic'].SIRD = {main="Colada",ammo="Staunch Tathlum +1",
		head="Souv. Schaller +1",neck="Moonlight Necklace",ear1="Andoaa Earring",ear2="Tuisto Earring",
		body="Shab. Cuirass +1",hands="Sakpata's Gauntlets",--ring1="Defending Ring",ring2="Moonlight Ring",
		back="Merciful Cape",waist="Olympus Sash",legs="Carmine Cuisses +1",feet="Odyssean Greaves"} -- [2026-11-22 Fix] Was: legs="Rev. Leggings +3" (feet item in legs slot; Carmine Cuisses +1 gives SIRD/Enhancing)

	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {waist="Siegel Sash"})

    sets.midcast.Protect = set_combine(sets.midcast['Enhancing Magic'], {sub="Aegis",ring2="Sheltered Ring"})
    sets.midcast.Shell = set_combine(sets.midcast['Enhancing Magic'], {ring2="Sheltered Ring"})
	
	sets.midcast.Phalanx = set_combine(sets.midcast['Enhancing Magic'], {main="Sakpata's Sword",hands="Yorium Gauntlets",legs="Sakpata's Cuisses",back="Weard Mantle",feet="Souveran Schuhs +1"})
	sets.midcast.Phalanx.SIRD = set_combine(sets.midcast['Enhancing Magic'].SIRD, {main="Sakpata's Sword",hands="Souv. Handsch. +1",back="Weard Mantle",feet="Souveran Schuhs +1"})
	sets.midcast.Phalanx.DT = set_combine(sets.midcast.Phalanx.SIRD, {})	

	--------------------------------------
	-- Idle/resting/defense/etc sets
	--------------------------------------

    sets.resting = {ammo="Homiliary",
		head="Jumalik Helm",neck="Coatl Gorget +1",ear1="Etiolation Earring",ear2="Ethereal Earring",
		body="Jumalik Mail",hands="Souv. Handsch. +1",ring1="Defending Ring",ring2="Dark Ring",
		back="Moonbeam Cape",waist="Fucho-no-obi",legs="Sulev. Cuisses +2",feet="Cab. Leggings +3"}

    -- Idle sets
    sets.idle = {main="Burtgang",sub="Aegis",ammo="Homiliary",--ochain
		head="Loess Barbuta +1",neck="Coatl Gorget +1",ear1="Etiolation Earring",ear2="Ethereal Earring", --head="Jumalik Helm"
		body="Chozoron Coselete",hands="Sakpata's Gauntlets",--ring1="Stikini Ring +1",ring2="Hercules' Ring",
		back="Moonbeam Cape",waist="Flume Belt +1",legs="Carmine Cuisses +1",feet="Sakpata's Leggings"}--feet="Hippo. Socks +1"
		
    sets.idle.PDT = {main="Burtgang",sub="Ochain",ammo="Staunch Tathlum +1",
		head="Loess Barbuta +1",neck="Diemer Gorget",ear1="Creed Earring",ear2="Thureous Earring",
		body="Tartarus Platemail",hands="Sakpata's Gauntlets",ring1="Defending Ring",ring2="Moonlight Ring",
		back="Shadow Mantle",waist="Flume Belt +1",legs="Arke Cosc. +1",feet="Sakpata's Leggings"}
		
    sets.idle.MDT = {main="Burtgang",sub="Ochain",ammo="Staunch Tathlum +1",
		head="Jumalik Helm",neck="Warder's Charm +1",ear1="Etiolation Earring",ear2="Sanare Earring",
		body="Tartarus Platemail",hands="Sakpata's Gauntlets",ring1="Defending Ring",ring2="Shadow Ring",
		back=gear.fastcast_jse_back,waist="Flume Belt +1",legs="Souv. Diechlings +1",feet="Founder's Greaves"}
		
	sets.idle.Refresh = {main="Burtgang",sub="Ochain",ammo="Homiliary",
		head="Jumalik Helm",neck="Coatl Gorget +1",ear1="Etiolation Earring",ear2="Ethereal Earring",
		body="Chozoron Coselete",hands="Sakpata's Gauntlets",ring1="Defending Ring",ring2="Hercules' Ring",
		back="Moonbeam Cape",waist="Flume Belt +1",legs="Souv. Diechlings +1",feet="Cab. Leggings +3"}

	sets.idle.Tank = {main="Burtgang",sub="Ochain",ammo="Staunch Tathlum +1",
		head="Chev. Armet +1",neck="Loricate Torque +1",ear1="Creed Earring",ear2="Thureous Earring",
		body="Tartarus Platemail",hands="Sakpata's Gauntlets",--ring1="Defending Ring",ring2="Shadow Ring",
		back="Shadow Mantle",waist="Flume Belt +1",legs="Chev. Cuisses +1",feet="Sakpata's Leggings"}
		
	sets.idle.KiteTank = {main="Burtgang",sub="Ochain",ammo="Staunch Tathlum +1",
		head="Loess Barbuta +1",neck="Loricate Torque +1",ear1="Etiolation Earring",ear2="Thureous Earring",
		body="Tartarus Platemail",hands="Sakpata's Gauntlets",ring1="Defending Ring",ring2="Shadow Ring",
		back="Shadow Mantle",waist="Flume Belt +1",legs="Carmine Cuisses +1",feet="Hippo. Socks +1"}
		
    sets.idle.Reraise = {main="Burtgang",sub="Ochain",ammo="Staunch Tathlum +1",
		head="Twilight Helm",neck="Loricate Torque +1",ear1="Etiolation Earring",ear2="Thureous Earring",
		body="Twilight Mail",hands="Sakpata's Gauntlets",ring1="Defending Ring",ring2="Dark Ring",
		back="Moonbeam Cape",waist="Flume Belt +1",legs="Carmine Cuisses +1",feet="Cab. Leggings +3"}
		
    sets.idle.Weak = {main="Burtgang",sub="Ochain",ammo="Staunch Tathlum +1",
		head="Twilight Helm",neck="Loricate Torque +1",ear1="Etiolation Earring",ear2="Thureous Earring",
		body="Twilight Mail",hands="Sakpata's Gauntlets",ring1="Defending Ring",ring2="Moonlight Ring",
		back="Moonbeam Cape",waist="Flume Belt +1",legs="Carmine Cuisses +1",feet="Cab. Leggings +3"}
		
	sets.Kiting = {legs="Carmine Cuisses +1",feet="Hippo. Socks +1"}

	sets.latent_refresh = {waist="Fucho-no-obi",neck="Parade Gorget"}
	sets.latent_refresh_grip = {sub="Oneiros Grip"}
	sets.latent_regen = {ring1="Apeile Ring +1",ring2="Apeile Ring"}
	sets.DayIdle = {}
	sets.NightIdle = {}

	--------------------------------------
    -- Defense sets
    --------------------------------------
    
    -- Extra defense sets.  Apply these on top of melee or defense sets.
	sets.Knockback = {}
    sets.MP = {head="Chev. Armet +1",neck="Coatl Gorget +1",ear2="Ethereal Earring",waist="Flume Belt +1",feet="Rev. Leggings +3"}
	sets.passive.AbsorbMP = {head="Chev. Armet +1",neck="Coatl Gorget +1",ear2="Ethereal Earring",waist="Flume Belt +1",feet="Rev. Leggings +3"}
    sets.MP_Knockback = {}
    sets.Twilight = {head="Twilight Helm", body="Twilight Mail"}
	sets.TreasureHunter = set_combine(sets.TreasureHunter, {legs=gear.valorous_treasure_legs})
	
	-- Weapons sets
	sets.weapons.BurtgangAegis = {main="Burtgang",sub="Aegis"}
	sets.weapons.NaeglingAegis = {main="Naegling",sub="Aegis"}
	sets.weapons.TP = {main="Burtgang",sub="Naegling"}
	sets.weapons.TP2 = {main="Burtgang",sub="Joyeuse"}
	sets.weapons.DeaconAegis = {main="Deacon Sword",sub="Aegis"}
	sets.weapons.SequenceBlurred = {main="Sequence",sub="Blurred Shield"}
	sets.weapons.SequenceAegis = {main="Sequence",sub="Aegis"}
	sets.weapons.DualWeapons = {main="Sequence",sub="Demersal Degen +1"}
    
    sets.defense.PDT = {main="Burtgang",sub="Ochain",ammo="Staunch Tathlum +1",
		head="Chev. Armet +1",neck="Diemer Gorget",ear1="Creed Earring",ear2="Thureous Earring",
		body="Tartarus Platemail",hands="Sakpata's Gauntlets",ring1="Defending Ring",ring2="Warden's Ring",
		back="Shadow Mantle",waist="Flume Belt +1",legs="Souv. Diechlings +1",feet="Sakpata's Leggings"}
		
    sets.defense.PDT_HP = {main="Burtgang",sub="Ochain",ammo="Staunch Tathlum +1",
        head="Souv. Schaller +1",neck="Loricate Torque +1",ear1="Odnowa Earring +1",ear2="Tuisto Earring",
        body="Rev. Surcoat +3",hands="Sakpata's Gauntlets",ring1="Gelatinous Ring +1",ring2="Moonlight Ring",
        back="Moonbeam Cape",waist="Creed Baudrier",legs="Arke Cosc. +1",feet="Sakpata's Leggings"}
		
    sets.defense.MDT_HP = {main="Burtgang",sub="Aegis",ammo="Staunch Tathlum +1",
        head="Souv. Schaller +1",neck="Loricate Torque +1",ear1="Odnowa Earring +1",ear2="Tuisto Earring",
        body="Rev. Surcoat +3",hands="Sakpata's Gauntlets",ring1="Gelatinous Ring +1",ring2="Moonlight Ring",
        back="Moonbeam Cape",waist="Creed Baudrier",legs="Arke Cosc. +1",feet="Sakpata's Leggings"}
		
    sets.defense.MEVA_HP = {main="Burtgang",sub="Aegis",ammo="Staunch Tathlum +1",
        head="Nyame Helm",neck="Loricate Torque +1",ear1="Odnowa Earring +1",ear2="Tuisto Earring",
        body="Nyame Mail",hands="Nyame Gauntlets",ring1="Gelatinous Ring +1",ring2="Moonlight Ring",
        back="Moonbeam Cape",waist="Creed Baudrier",legs="Nyame Flanchard",feet="Nyame Sollerets"}
		
    sets.defense.PDT_Reraise = {ammo="Staunch Tathlum +1",
        head="Twilight Helm",neck="Loricate Torque +1",ear1="Etiolation Earring",ear2="Thureous Earring",
        body="Twilight Mail",hands="Macabre Gaunt. +1",ring1="Defending Ring",ring2="Moonlight Ring",
		back="Moonbeam Cape",waist="Flume Belt +1",legs="Arke Cosc. +1",feet="Sakpata's Leggings"}
		
    sets.defense.MDT_Reraise = {main="Burtgang",sub="Aegis",ammo="Staunch Tathlum +1",
        head="Twilight Helm",neck="Loricate Torque +1",ear1="Etiolation Earring",ear2="Sanare Earring",
        body="Twilight Mail",hands="Sakpata's Gauntlets",ring1="Defending Ring",ring2="Moonlight Ring",
		back="Engulfer Cape +1",waist="Flume Belt +1",legs=gear.odyssean_fc_legs,feet="Cab. Leggings +3"}

	sets.defense.BDT = {main="Burtgang",sub="Aegis",ammo="Staunch Tathlum +1",
		head="Loess Barbuta +1",neck="Warder's Charm +1",ear1="Odnowa Earring +1",ear2="Sanare Earring",
		body="Tartarus Platemail",hands="Sakpata's Gauntlets",ring1="Defending Ring",ring2="Shadow Ring",
		back="Moonbeam Cape",waist="Asklepian Belt",legs="Sulev. Cuisses +2",feet="Amm Greaves"}
		
	sets.defense.Tank = {ammo="Staunch Tathlum +1",
		head="Chev. Armet +1",neck="Loricate Torque +1",ear1="Creed Earring",ear2="Thureous Earring",
		body="Tartarus Platemail",hands="Sakpata's Gauntlets",ring1="Defending Ring",ring2="Shadow Ring",
		back="Shadow Mantle",waist="Flume Belt +1",legs="Chev. Cuisses +1",feet="Sakpata's Leggings"} -- [2026-11-22 Fix] Was: ffeet="Sakpata's Leggings"
		
	sets.defense.MEVA = {main="Malignance Sword",sub="Aegis",ammo="Staunch Tathlum +1",
        head="Nyame Helm",neck="Warder's Charm +1",ear1="Etiolation Earring",ear2="Sanare Earring",
		body="Nyame Mail",hands="Nyame Gauntlets",ring1="Vengeful Ring",ring2="Purity Ring",
        back=gear.fastcast_jse_back,waist="Asklepian Belt",legs="Nyame Flanchard",feet="Nyame Sollerets"}
		
	sets.defense.Death = {ammo="Staunch Tathlum +1",
        head="Founder's Corona",neck="Loricate Torque +1",ear1="Etiolation Earring",ear2="Sanare Earring",
		body="Tartarus Platemail",hands="Leyline Gloves",ring1="Warden's Ring",ring2="Shadow Ring",
        back=gear.fastcast_jse_back,waist="Asklepian Belt",legs=gear.odyssean_fc_legs,feet="Odyssean Greaves"}
		
	sets.defense.Charm = {ammo="Staunch Tathlum +1",
        head="Founder's Corona",neck="Unmoving Collar +1",ear1="Etiolation Earring",ear2="Sanare Earring",
		body="Tartarus Platemail",hands="Leyline Gloves",ring1="Vengeful Ring",ring2="Purity Ring",
        back="Solemnity Cape",waist="Asklepian Belt",legs="Souv. Diechlings +1",feet="Odyssean Greaves"}
		
		-- To cap MDT with Shell IV (52/256), need 76/256 in gear.
    -- Shellra V can provide 75/256, which would need another 53/256 in gear.
    sets.defense.OchainMDT = {sub="Aegis",ammo="Staunch Tathlum +1",
		head="Founder's Corona",neck="Warder's Charm +1",ear1="Odnowa Earring +1",ear2="Sanare Earring",
		body="Tartarus Platemail",hands="Sakpata's Gauntlets",ring1="Defending Ring",ring2="Shadow Ring",
		back="Engulfer Cape +1",waist="Creed Baudrier",legs="Chev. Cuisses +1",feet="Chev. Sabatons +1"}
		
    sets.defense.OchainNoShellMDT = {sub="Aegis",ammo="Staunch Tathlum +1",
		head="Founder's Corona",neck="Warder's Charm +1",ear1="Odnowa Earring +1",ear2="Sanare Earring",
		body="Tartarus Platemail",hands="Sakpata's Gauntlets",ring1="Defending Ring",ring2="Shadow Ring",
		back="Engulfer Cape +1",waist="Flax Sash",legs="Sulev. Cuisses +2",feet="Chev. Sabatons +1"}
		
    sets.defense.AegisMDT = {sub="Aegis",ammo="Staunch Tathlum +1",
		head="Founder's Corona",neck="Warder's Charm +1",ear1="Odnowa Earring +1",ear2="Sanare Earring",
		body="Tartarus Platemail",hands="Leyline Gloves",ring1="Defending Ring",ring2="Shadow Ring",
		back=gear.fastcast_jse_back,waist="Asklepian Belt",legs=gear.odyssean_fc_legs,feet="Odyssean Greaves"}
		
    sets.defense.AegisNoShellMDT = {sub="Aegis",ammo="Staunch Tathlum +1",
		head="Founder's Corona",neck="Warder's Charm +1",ear1="Odnowa Earring +1",ear2="Sanare Earring",
		body="Tartarus Platemail",hands="Sakpata's Gauntlets",ring1="Defending Ring",ring2="Shadow Ring",
		back=gear.fastcast_jse_back,waist="Asklepian Belt",legs="Sulev. Cuisses +2",feet="Amm Greaves"}		

	--------------------------------------
	-- Engaged sets
	--------------------------------------
    
	sets.engaged = {main="Burtgang",sub="Ochain",ammo="Aurgelmir Orb +1",
		head="Sakpata's Helm",neck="Asperity Necklace",ear1="Cessance Earring",ear2="Brutal Earring",
		body="Sakpata's Plate",hands="Sakpata's Gauntlets",ring1="Flamma Ring",ring2="Petrov Ring",
		back="Bleating Mantle",waist="Windbuffet Belt +1",legs="Sakpata's Cuisses",feet="Sakpata's Leggings"}

    sets.engaged.Acc = {main="Burtgang",sub="Ochain",ammo="Hasty Pinion +1",
        head="Flam. Zucchetto +2",neck="Combatant's Torque",ear1="Mache Earring +1",ear2="Telos Earring",
        body=gear.valorous_wsd_body,hands="Sakpata's Gauntlets",ring1="Ramuh Ring +1",ring2="Ramuh Ring +1",
        back="Ground. Mantle +1",waist="Tempus Fugit",legs="Carmine Cuisses +1",feet="Sakpata's Leggings"}

    sets.engaged.DW = {ammo="Paeapua",
		head="Flam. Zucchetto +2",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
		body=gear.valorous_wsd_body,hands="Sakpata's Gauntlets",ring1="Flamma Ring",ring2="Petrov Ring",
		back="Bleating Mantle",waist="Windbuffet Belt +1",legs="Sulev. Cuisses +2",feet="Founder's Greaves"}

    sets.engaged.DW.Acc = {ammo="Aurgelmir Orb +1",
		head="Flam. Zucchetto +2",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
		body=gear.valorous_wsd_body,hands="Sakpata's Gauntlets",ring1="Flamma Ring",ring2="Ramuh Ring +1",
		back="Letalis Mantle",waist="Olseni Belt",legs="Sulev. Cuisses +2",feet="Founder's Greaves"}

	sets.engaged.Tank = {main="Burtgang",sub="Ochain",ammo="Staunch Tathlum +1",
		head="Chev. Armet +1",neck="Loricate Torque +1",ear1="Creed Earring",ear2="Thureous Earring",
		body="Tartarus Platemail",hands="Sakpata's Gauntlets",ring1="Defending Ring",ring2="Shadow Ring",
		back="Shadow Mantle",waist="Flume Belt +1",legs="Chev. Cuisses +1",feet="Sakpata's Leggings"}
		
	sets.engaged.Dawn = {main="Burtgang",sub="Ochain",ammo="Staunch Tathlum +1",
		head="Jumalik Helm",neck="Loricate Torque +1",ear1="Telos Earring",ear2="Ethereal Earring",
		body="Jumalik Mail",hands="Sakpata's Gauntlets",ring1="Defending Ring",ring2="Shadow Ring",
		back="Moonbeam Cape",waist="Tempus Fugit",legs="Arke Cosc. +1",feet="Rev. Leggings +3"}
		
	sets.engaged.BreathTank = {main="Burtgang",sub="Ochain",ammo="Staunch Tathlum +1",
		head="Loess Barbuta +1",neck="Loricate Torque +1",ear1="Thureous Earring",ear2="Etiolation Earring",
		body="Tartarus Platemail",hands="Sakpata's Gauntlets",ring1="Defending Ring",ring2="Shadow Ring",
		back="Engulfer Cape +1",waist="Creed Baudrier",legs="Sulev. Cuisses +2",feet="Amm Greaves"}
		
	sets.engaged.DDTank = {ammo="Hasty Pinion +1",
		head="Sulevia's Mask +2",neck="Loricate Torque +1",ear1="Brutal Earring",ear2="Cessance Earring",
		body="Tartarus Platemail",hands="Sakpata's Gauntlets",ring1="Defending Ring",ring2="Patricius Ring",
		back="Weard Mantle",waist="Tempus Fugit",legs="Sulev. Cuisses +2",feet="Sakpata's Leggings"}
		
	sets.engaged.Acc.DDTank = {ammo="Hasty Pinion +1",
		head="Sulevia's Mask +2",neck="Loricate Torque +1",ear1="Mache Earring +1",ear2="Telos Earring",
		body="Tartarus Platemail",hands="Sakpata's Gauntlets",ring1="Defending Ring",ring2="Patricius Ring",
		back="Weard Mantle",waist="Tempus Fugit",legs="Sulev. Cuisses +2",feet="Sulev. Leggings +2"}
		
	sets.engaged.NoShellTank = {main="Burtgang",sub="Ochain",ammo="Staunch Tathlum +1",
        head="Jumalik Helm",neck="Loricate Torque +1",ear1="Thureous Earring",ear2="Etiolation Earring",
        body="Rev. Surcoat +3",hands="Sakpata's Gauntlets",ring1="Defending Ring",ring2="Moonlight Ring",
        back="Moonbeam Cape",waist="Flume Belt +1",legs=gear.odyssean_fc_legs,feet="Cab. Leggings +3"}
		
	-- [2026-11-22 Note] sets.Reraise and sets.engaged.Acc.Tank are not defined yet; guarded with fallbacks so set_combine does not receive nil
    sets.engaged.Reraise = set_combine(sets.engaged.Tank, sets.Reraise or {}) -- [2026-11-22 Fix] Was: set_combine(sets.engaged.Tank, sets.Reraise)
    sets.engaged.Acc.Reraise = set_combine(sets.engaged.Acc.Tank or sets.engaged.Tank, sets.Reraise or {}) -- [2026-11-22 Fix] Was: set_combine(sets.engaged.Acc.Tank, sets.Reraise)
		
	--------------------------------------
	-- Custom buff sets
	--------------------------------------
	sets.buff.Doom = {neck="Nicander's Necklace",waist="Gishdubar Sash",ring1="Eshmun's Ring",ring2="Eshmun's Ring"} --Shabti Cuisses +1? ~5M and don't consistently sell. Not sure if I'd want to lock an ilvl115 piece while doom is up.
	sets.buff.Sleep = {neck="Vim Torque +1"}
    sets.buff.Cover = {body="Cab. Surcoat +3"}
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'NIN' then
        set_macro_page(2, 5)
    elseif player.sub_job == 'RUN' then
        set_macro_page(9, 5)
    elseif player.sub_job == 'RDM' then
        set_macro_page(6, 5)
    elseif player.sub_job == 'BLU' then
        set_macro_page(8, 5)
    elseif player.sub_job == 'DNC' then
        set_macro_page(4, 5)
    else
        set_macro_page(1, 5) --War/Etc
    end
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset 1')--regular 1
end


function BurtgangTP()
	
	-- [2026-11-22 Fix] Was: local player1 = windower.ffxi.get_player() (unused) and windower.ffxi.get_mob_by_target() without 't', plus engaged/distance checks (< 6 yalms for WS, < 20 yalms for Flash)
	local mob = windower.ffxi.get_mob_by_target('t')
	local abil_recasts = windower.ffxi.get_ability_recasts()
	local spell_recasts = windower.ffxi.get_spell_recasts()
	
	if mob == nil or player.status ~= 'Engaged' then
		return false

	
	elseif mob.hpp <= 20 and player.tp >= 1000 and mob.distance < 36 then -- [2026-11-22 Fix] Added mob.distance < 36 (6 yalms)
		
		windower.chat.input('/ws "Atonement" <t>')
		tickdelay = os.clock() + 2.8
		return true
	
	elseif spell_recasts[112] < spell_latency and mob.distance < 400 then -- [2026-11-22 Fix] Added mob.distance < 400 (20 yalms)
		windower.chat.input('/ma "Flash" <t>')
		tickdelay = os.clock() + 1.1
		return true
	
	--elseif spell_recasts[476] < spell_latency then
	--	windower.chat.input('/ma "Crusade" <me>')
	--	tickdelay = os.clock() + 1.1
	--	return true
	
	else
		
		return false
			
	end
end


buff_spell_lists = {
	Auto = {	
		{Name='Crusade',Buff='Enmity Boost',SpellID=476,When='Always'},
		{Name='Reprisal',Buff='Reprisal',SpellID=97,When='Always'},
		{Name='Phalanx',Buff='Phalanx',SpellID=106,When='Always'},
		--{Name='Enlight II',Buff='Enlight',SpellID=855,When='Always'},
		{Name='Cocoon',Buff='Defense Boost',SpellID=547,When='Always'},
	},
	
	Default = {
		{Name='Crusade',Buff='Enmity Boost',SpellID=476,Reapply=false},
		{Name='Reprisal',Buff='Reprisal',SpellID=97,Reapply=false},
		{Name='Haste',Buff='Haste',SpellID=57,Reapply=false},
		{Name='Refresh',Buff='Refresh',SpellID=109,Reapply=false},
		{Name='Aquaveil',Buff='Aquaveil',SpellID=55,Reapply=false},
		{Name='Stoneskin',Buff='Stoneskin',SpellID=54,Reapply=false},
		{Name='Blink',Buff='Blink',SpellID=53,Reapply=false},
		{Name='Regen',Buff='Regen',SpellID=108,Reapply=false},
		{Name='Phalanx',Buff='Phalanx',SpellID=106,Reapply=false},
	},
}