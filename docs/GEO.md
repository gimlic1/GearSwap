# FFXI GearSwap — GEO (Geomancer)

> [!NOTE]
> **Quick Reference**
> - **Logic File:** `C:\Windower\addons\GearSwap\data\GEO.lua` *(unmodified Selindrile core, includes live Luopan/Indi distance HUD)*
> - **Character Gear Files & Customization Status:**
>   - `Voicelessbicep\Voicelessbicep_Geo_Gear.lua` — **Flagship Idris GEO** (`Idris` + `Dunna`, full `Bagua +3`, `Geo. Tunic/Mitaines/Sandals +3`, `Nyame` DT/idle, custom `Nantosuelta's Cape` augments, lockstyle `1`)
>   - `Gimlic\Gimlic_Geo_Gear.lua` — **Heavily customized** (`Dowser's Wand` / `Filiae Bell` / `Solstice` / `Daybreak`, full `Bagua +3`, `Geo. Pants/Sandals +3`, `Nyame` DT, lockstyle `11`)
>   - `Balullu\Balullu_Geo_Gear.lua` & `Friendlessvirus\Friendlessvirus_Geo_Gear.lua` — **Identical baseline templates** (older Selindrile clones, no custom overrides)
> - **Default Weapons:** `None` (unlocked for Geomancy/Nuke swaps) | `Voicelessbicep`: `None`, `Idris`, `Nehushtan` | `Gimlic`: `None`, `Nehushtan`, `DualWeapons`
> - **Default Auto-Geomancy:** `autoindi = 'Haste'`, `autogeo = 'Frailty'`, `autoentrust = 'Fury'`, `autoentrustee = '<p1>'`, `indi_duration = 290`
> - **Default AutoWS / Food:** `autows = 'Realmrazer'` (`autowstp = 1000`) | `autofood = 'Miso Ramen'`
> - **Default Macro Book / Lockstyle:** Book `10`, Page `4` (both) | `Gimlic`: `/lockstyleset 11`, `Voicelessbicep`: `/lockstyleset 1` *(both run `lua unload SKillchains`)*
> - **Key Automation Flags:** `AutoGeoAbilities = true` (auto `Blaze of Glory` + `Ecliptic Attrition`), `AutoEntrust = false` (manual Indi targeting), `CombatEntrustOnly = true`, `ShowDistance = true`

Comprehensive code, command, and character gear reference for Kevin's Selindrile Geomancer setup, anchored by `Voicelessbicep` (`Idris` main GEO) and `Gimlic` (secondary GEO).

---

## Job-Specific Modes & Keybinds

### Job States & Modes (`GEO.lua` + Gear Overrides)

| State / Mode | Options / Default | Defined / Overridden In | Purpose |
| :--- | :--- | :--- | :--- |
| `state.OffenseMode` | `'Normal'` | `*_Geo_Gear.lua` | Melee accuracy tier |
| `state.CastingMode` | `'Normal'`, `'Resistant'`, `'Fodder'`, `'Proc'` | `*_Geo_Gear.lua` | Controls Elemental/Enfeebling/Stun sets (`Proc` strips weapons for low-dmg procs; `Fodder` enables `Zodiac Ring`) |
| `state.IdleMode` | `'Normal'`, `'PDT'` | `*_Geo_Gear.lua` | Idle profile; automatically switches to `.Pet` when Luopan is out and appends `.Indi` when an Indi-spell is active |
| `state.PhysicalDefenseMode` | `'PDT'`, `'NukeLock'`, `'GeoLock'`, `'PetPDT'` | `*_Geo_Gear.lua` | `F10` lock — notably lets you lock **Pet PDT**, **Nuke gear**, or **Geomancy gear** |
| `state.MagicalDefenseMode` | `'MDT'`, `'NukeLock'` | `*_Geo_Gear.lua` | `F11` lock |
| `state.ResistDefenseMode` | `'MEVA'` | `*_Geo_Gear.lua` | `F12` magic evasion lock |
| `state.Weapons` | `Gimlic`: `'None'`, `'Nehushtan'`, `'DualWeapons'` / `Voicelessbicep`: `'None'`, `'Idris'`, `'Nehushtan'` | `*_Geo_Gear.lua` | Locks main/sub weapons when meleeing |
| `state.RecoverMode` | `'35%'`, `'60%'`, `'Always'`, `'Never'` | `GEO.lua` | Equips `sets.RecoverMP` (`Seidr Cotehardie`) on Elemental Magic midcast when MP% drops below threshold |
| `state.ElementalMode` | Standard 8 elements (`Sel-Include`) | `Sel-Include` + `GEO.lua` | Element used by `//gs c elemental ...` |
| `state.ShowDistance` | `true` (bool) | `GEO.lua` | Toggles the on-screen **Luopan & Indi aura target distance HUD** (prerender overlay) |
| `state.AutoEntrust` | `false` (bool) | `GEO.lua` | When `true`, manually casting an `Indi-` spell on a party member automatically fires `Entrust` first |
| `state.CombatEntrustOnly` | `true` (bool) | `GEO.lua` | Restricts `AutoBuffMode` automatic `Entrust` casts to when `player.in_combat` is true |
| `state.AutoGeoAbilities` | `true` (bool) | `GEO.lua` | Lets `check_geo()` auto-fire `Blaze of Glory` before `Geo-` and `Ecliptic Attrition` once per Luopan |

### Job-Specific Keybinds (`Gimlic_Geo_Gear.lua` & `Voicelessbicep_Geo_Gear.lua`)

*(Modifier key legend: `^` = `Ctrl`, `!` = `Alt`, `@` = `Win`)*

| Keybind | Command | Action |
| :--- | :--- | :--- |
| `Ctrl+~` (`^` + `` ` ``) | `gs c cycle ElementalMode` | Cycle active nuke/storm element |
| `Alt+~` (`!` + `` ` ``) | `input /ja "Full Circle" <me>` | Dismiss active Luopan (`Azimuth Hood +1` / `Bagua Mitaines +3`) |
| `Win+~` (`@` + `` ` ``) | `gs c cycle MagicBurstMode` | Cycle `MagicBurstMode` (`Off`, `Single`, `Lock`) |
| `Win+F8` | `gs c toggle AutoNukeMode` | Toggle automatic nuking (`//gs c autonuke <Spell>`) |
| `Win+F10` | `gs c cycle RecoverMode` | Cycle MP-recovery body (`Seidr Cotehardie`) threshold (`35%`/`60%`/`Always`/`Never`) |
| `Ctrl+Backspace` | `input /ja "Entrust" <me>` | Ready `Entrust` for next `Indi-` spell |
| `Alt+Backspace` | `input /ja "Life Cycle" <me>` | Heal Luopan (`Geo. Tunic` + `Nantosuelta's Cape`) |
| `Win+Backspace` | `input /ma "Sleep II" <t>` | Cast `Sleep II` (starts 90s timer) |
| `Ctrl+Delete` | `input /ma "Aspir III" <t>` | Cast `Aspir III` (`Rubicundity` + Drain/Aspir set) |
| `Win+Delete` | `input /ma "Sleep" <t>` | Cast `Sleep` (starts 60s timer) |

---

## Job-Specific Commands (`//gs c ...`)

All custom handlers live in `GEO.lua` (`job_self_command`, lines 392–414, and `handle_elemental`, lines 418–539).

| Command | Arguments | Behavior | Macro Example |
| :--- | :--- | :--- | :--- |
| `//gs c autoindi <Name>` | Suffix without `Indi-` (e.g., `Haste`, `Fury`, `Acumen`, `None`) | Sets `autoindi` used by `AutoBuffMode` (`check_geo()`). Capitalizes first letter automatically. | `/con gs c autoindi Fury` |
| `//gs c autogeo <Name>` | Suffix without `Geo-` (e.g., `Frailty`, `Malaise`, `Vex`, `None`) | Sets `autogeo` Luopan spell cast automatically when `AutoBuffMode` is active. | `/con gs c autogeo Malaise` |
| `//gs c autoentrust <Name>` | Suffix without `Indi-` (or `None`) | Sets the `Indi-` spell automatically Entrusted on cooldown during `AutoBuffMode`. | `/con gs c autoentrust Precision` |
| `//gs c autoentrustee <Target>` *(or any arg containing `trustee`)* | Player name or `<p1>`–`<p5>` | Sets `autoentrustee` target for auto-Entrust. | `/con gs c autoentrustee Gimlic` |
| `//gs c elemental nuke [target]` | Optional mob ID/name | Casts highest ready single-target nuke of `ElementalMode`: Tier V (if `>=100` JP spent) → IV → III → II → I (or `Banish II` → `Banish` for `Light`). | `/con gs c elemental nuke <t>` |
| `//gs c elemental smallnuke [target]` | Optional target | Cascades Tier II → Tier I of current element. | `/con gs c elemental smallnuke <t>` |
| `//gs c elemental tier1..tier6 [target]` | `tier1`–`tier6` | Casts exact single-target tier of current element. | `/con gs c elemental tier5 <t>` |
| `//gs c elemental ara [target]` *(or `ara1`/`ara2`/`ara3`)* | `ara` cascades III → II → I | Casts `-ra` AoE spell of current element (`Stone`/`Water`/`Aero`/`Fire`/`Blizz`/`Thundara`). | `/con gs c elemental ara <t>` |
| `//gs c elemental aga` / `helix` / `enfeeble` / `ninjutsu` / `bardsong` | Optional target | Casts `-ga`, Helix, Elemental Enfeeble, `: Ni` ninjutsu, or Threnody of current element. | `/con gs c elemental aga <t>` |
| `//gs c elemental weather` / `spikes` / `enspell` | None | Weather casts `Phalanx` if `/RDM`, else Storm (or `Klimaform` if Storm is already up on self). | `/con gs c elemental weather` |
| `//gs c buffup [Default]` | `Default` (default) | Walks `buff_spell_lists.Default`: `Haste`, `Refresh`, `Aquaveil`, `Stoneskin`, `Blink`, `Regen`, `Phalanx`. | `/con gs c buffup` |
| `//gs c toggle ShowDistance` | None | Shows/hides the on-screen Luopan & Indi range overlay. | `/con gs c toggle ShowDistance` |
| `//gs c toggle AutoGeoAbilities` | None | Toggles automatic `Blaze of Glory` and `Ecliptic Attrition` in `AutoBuffMode`. | `/con gs c toggle AutoGeoAbilities` |
| `//gs c toggle AutoEntrust` / `CombatEntrustOnly` | None | Toggles manual target auto-Entrust or combat-only auto-Entrust gating. | `/con gs c toggle AutoEntrust` |

---

## How the Job Logic Works (`GEO.lua`)

### Geomancy Targeting, Recasting & Casting Pipeline

1. **`job_filter_precast()` (lines 96–104) — Automatic `Full Circle` Before Re-casting `Geo-`:**
   - Whenever you cast *any* `Geo-` spell while a Luopan is already out (`pet.isvalid`), cancels the spell, fires `/ja "Full Circle" <me>`, and reschedules `/ma "<Geo-Spell>" <target>` `1.3s` later.
2. **`job_pretarget()` (lines 106–141) — Smart `Indi-` / `Geo-` / `Entrust` Targeting:**
   - **`Indi-` spells:**
     - If `Entrust` buff is active and target is `SELF`, cancels with a warning (`You can't entrust yourself`).
     - If `Entrust` is not active and you target a party member/NPC while `state.AutoEntrust` is `true`, automatically injects `/ja "Entrust" <me>; wait 1.1; input /ma "<Indi>" <target>`.
     - Otherwise, if raw target was `<t>`, rewrites target to `<me>`.
   - **`Geo-` spells:** Cancels enemy-targeted debuff `Geo-` spells aimed at party members; rewrites party-buff `Geo-` spells to `<me>` if not aimed at a valid party member or `<stpt>`/`<stal>`/`<st>`.
3. **`job_precast()` (lines 145–168):**
   - Sets Obi fallback capes/waists (`gear.obi_cure_*`, `gear.obi_low_nuke_*` for Tier I/II/-ga/Helix, `gear.obi_high_nuke_*` for Tier III+).
   - **Bolster Protection:** Cancels `Blaze of Glory` and `Ecliptic Attrition` while `Bolster` is active so you don't waste cooldowns (Bolster already caps bubble potency).
4. **`job_get_spell_map()` (lines 298–331):**
   - Routes `Indi-*` → `sets.midcast.Geomancy.Indi`; splits Elemental Magic into `LowTierNuke` vs `HighTierNuke` (`LowTierNukes` = Tier I, II, and `-ga` I); routes Cure on Light weather/day; splits Enfeebling into `Dia`, `MndEnfeebles`, and `IntEnfeebles`.
5. **`job_post_midcast()` (lines 183–240):**
   - **Elemental Magic:** Layers `MagicBurst` / `ResistantMagicBurst`, `Zodiac Ring` (Fodder + matching day), `sets.element[elem]`, and `RecoverMP` / `RecoverBurst` (`Seidr Cotehardie`) when MP% is below `state.RecoverMode`.
   - **Geomancy:**
     - If `Geo-` is cast with `Blaze of Glory` active and `sets.buff['Blaze of Glory']` is non-empty, equips it and **locks `head`** (`blazelocked = true`) until `job_pet_change()` unlocks it.
     - **Idris → Solstice Swap on Entrust:** When casting an `Indi-` spell with `Entrust` active, if `sets.midcast.Geomancy.main == 'Idris'` and `Solstice` is available, automatically swaps `main="Solstice"` (since Idris's `Geomancy +10` does not apply to Entrusted Indis, whereas `Solstice` gives `Indi Duration +15` and Conserve MP).
6. **`job_aftercast()` & `job_buff_change()` (lines 242–292):**
   - Tracks `last_indi` and `last_geo` for the distance HUD and `check_geo()`.
   - Updates `classes.CustomIdleGroups` (`'Indi'`) when `player.indi` changes, and creates Windower Timers (`indi_duration = 290` seconds for Indi, `60s` for Sleep/Sleepga, `90s` for Sleep II/Sleepga II).
   - Suppresses immediate idle gear swap after `Geo-`, `Mending Halation`, and `Radial Arcana` (`eventArgs.handled = true`) so `job_pet_change` handles the Luopan transition cleanly.

### Tick Automation (`job_tick` → `check_geo`) & Live Luopan Distance HUD

- **`check_geo()` (lines 548–588)** — runs automatically when `AutoBuffMode ~= 'Off'` outside cities:
  1. Casts `Indi-<autoindi>` if no Indi is up or `last_indi ~= autoindi`.
  2. Fires `Entrust` + `Indi-<autoentrust>` on `autoentrustee` whenever Entrust (ID `93`) is ready (and in combat if `CombatEntrustOnly` is `true`).
  3. If Luopan is out:
     - Dismisses with `Full Circle` if Luopan is `> 50` yalms away.
     - Fires `Ecliptic Attrition` (ID `244`) once per Luopan if `AutoGeoAbilities` is `true` and `Bolster` is not active.
  4. If no Luopan is out and `autogeo ~= 'None'` (and either `<bt>` exists or `autogeo` is a buff bubble):
     - Fires `Blaze of Glory` (ID `247`) first if in combat, `AutoGeoAbilities` is `true`, and `Bolster` is not active.
     - Casts `Geo-<autogeo> <bt>`.
- **`check_buff()` (lines 684–697):** Maintains `Haste`, `Refresh`, `Stoneskin`, `Aquaveil`, and `Phalanx` under `AutoBuffMode = Auto`.
- **Live Luopan / Indi Distance Overlay (`prerender`, lines 590–682):**
  - Renders a right-aligned green/white text box at `(-200, 175)` showing every mob (for debuff bubbles in `debuff_list`, highlighting `<bt>` in coral red) or party member (for buff bubbles) within `6 + model_size` yalms of your Luopan (`Geo-`) and yourself (`Indi-`), automatically filtering out Trusts, avatars, and pets via `ignore_list`.

> [!WARNING]
> **Code Gotchas Discovered in GEO Gear Files**
> 1. **`Gimlic_Geo_Gear.lua` trailing space in `"Amalric Coif "`:** Lines 67, 104, 118, 123, 129, 188, 193, 219, 220, 222, 223, 243, 245 have `"Amalric Coif "` (trailing space) — GearSwap exact-matches item names, so those slots will silently fail to equip unless the trailing space is removed.
> 2. **`Voicelessbicep_Geo_Gear.lua` line 334 (`sets.HPDown`):** Uses `back=idle_jse_back` instead of `back=gear.idle_jse_back` (resolves to `nil`, leaving the back slot unswapped during HP-down).
> 3. **Both characters leave `sets.midcast.Geomancy.Indi` with `main="Solstice"`:** On `Voicelessbicep`, this overrides `main="Idris"` from `sets.midcast.Geomancy` on **all** self-cast `Indi-` spells! For maximum potency on self-Indi spells, `Idris` (`Geomancy +10`) should stay in `main` for `sets.midcast.Geomancy.Indi`, letting `GEO.lua` line 235 handle swapping to `Solstice` only during `Entrust`.
> 4. **Both characters leave `sets.buff['Blaze of Glory'] = {}` empty** (no Relic hat swap/lock triggered).

---

## Character Customizations & Key Gear Sets

### Voicelessbicep (`Voicelessbicep_Geo_Gear.lua` + `Voicelessbicep-Items.lua` + `PorterPacker\Voicelessbicep_GEO.lua`)

- **Flagship REMA & Weapons:**
  - **`Idris`** (Ergon Club — Geomancy `+10`, Pet DT `-25%`) + **`Dunna`** (Handbell) + **`Solstice`** (Indi Duration) + **`Genmei Shield`** + **`Ammurapi Shield`** + **`Malignance Pole`** (PDT/MDT/MEVA).
  - `sets.weapons.Idris = {main='Idris', sub='Nehushtan'}` | `sets.weapons.Nehushtan = {main='Nehushtan', sub='Genmei Shield'}`.
- **Custom Ambuscade Capes (`Nantosuelta's Cape`):**
  - `gear.nuke_jse_back`: `INT+20`, `Mag. Acc+20 / Mag. Dmg.+20`, `INT+10`, `MAB+10`, `DT-5%`
  - `gear.idle_jse_back`: `VIT+20`, `Eva+20 / MEva+20`, `Evasion+10`, `Pet: "Regen"+10`, `Pet: DT-5%`
- **JSE & Endgame Armor:**
  - **Relic (`Bagua +3`):** Full 5/5 `+3` (`Bagua Galero/Tunic/Mitaines/Pants/Sandals +3`) — covers `Bolster`, `Concentric Pulse`, `Radial Arcana`, `Mending Halation`, `Full Circle`, nukes, and pet regen.
  - **Artifact (`Geomancy`):** `Geomancy Tunic +3`, `Geo. Mitaines +3`, `Geo. Sandals +3`, `Geomancy Pants +2`, `Geo. Galero +2`.
  - **Empyrean:** `Azimuth Hood +1`, `Azimuth Coat +1`, `Azimuth Gaiters +1`.
  - **Odyssey / Other:** Full `Nyame` 5/5 (used across `idle.PDT`, `idle.Pet` body/legs, and `defense.PDT`/`MDT`/`MEVA`), `Bagua Charm +2`, `Amalric Coif +1` & `Amalric Gages +1`, `Shneddick Ring` (movement speed in idle/DT), `Ea Hat`/`Houppelande`/`Slops` (Magic Burst).
- **Key Sets Summary:**
  - **Geomancy Midcast:** `Idris` + `Genmei Shield` + `Dunna` + `Vanya Hood` + `Bagua Charm +2` + `Vedic Coat` + `Geo. Mitaines +3` + `Defending Ring` + `Austerity Belt +1` + `Vanya Slops` + `Medium's Sabots` (Indi swaps `Solstice` [see gotcha above], `idle_jse_back`, `Bagua Pants +3`, `Azimuth Gaiters +1`).
  - **Luopan Idle (`sets.idle.Pet`):** `Idris` + `Genmei Shield` + `Dunna` + `Azimuth Hood +1` + `Bagua Charm +2` + `Handler's Earring` + `+1` + `Nyame Mail` + `Geo. Mitaines +3` + `Defending Ring` + `Shneddick Ring` + `idle_jse_back` (`Pet: Regen+10, Pet: DT-5%`) + `Isa Belt` + `Nyame Flanchard` + `Bagua Sandals +3`.
  - **Nuking (`Elemental Magic` / `HighTierNuke`):** `Idris` + `Ammurapi Shield` + `Bagua +3` / `Amalric Gages +1` / `Nyame Flanchard` / `Metamor. Ring +1` / `Freke Ring` / `nuke_jse_back`.
- **Setup & Lockstyle:** `autoindi = "Haste"`, `autogeo = "Frailty"`, `indi_duration = 290`, Macro Book `10` Page `4`, `/lockstyleset 1`, runs `lua unload SKillchains`.

### Gimlic (`Gimlic_Geo_Gear.lua` + `Gimlic-Items.lua` + `PorterPacker\Gimlic_GEO.lua`)

- **Weapons & Bells:**
  - Geomancy: `Dowser's Wand` + `Genbu's Shield` + `Filiae Bell` (`Solstice` for Indi); Nuking/Enfeebling: `Daybreak` + `Ammurapi Shield`; Idle: `Bolelabunga` / `Malignance Pole`; Melee: `Nehushtan` (`Genmei Shield` or dual `Nehushtan`).
- **Custom Ambuscade Capes (`Nantosuelta's Cape`):**
  - `gear.nuke_jse_back`: `INT+20`, `Mag. Acc+20 / Mag. Dmg.+20`, `MAB+10`
  - `gear.idle_jse_back`: `HP+60`, `Eva+20 / MEva+20`, `Pet: "Regen"+10`
- **JSE & Endgame Armor (tracked in `PorterPacker/data/Gimlic_GEO.lua`):**
  - **Relic (`Bagua +3`):** Full 5/5 `+3` (`Bagua Galero/Tunic/Mitaines/Pants/Sandals +3`).
  - **Artifact (`Geomancy`):** `Geo. Galero +2`, `Geo. Tunic +2`, `Geomancy Mitaines +2`, `Geomancy Pants +3`, `Geo. Sandals +3`.
  - **Empyrean (`Azimuth +1`):** Full 5/5 `+1` (`Hood` and `Gaiters` in Lua; Coat/Gloves/Tights packed for lockstyle).
  - **Odyssey / Other:** Full `Nyame` 5/5 (PDT/MDT idle & defense), `Bagua Charm +2`, `Jhakri +2`, `Shneddick Ring` (in defense sets), `Ea` Magic Burst pieces (`Hat`, `Houppelande`, `Slops`).
- **Key Differences vs. Voicelessbicep:**
  - Uses `Dowser's Wand` + `Filiae Bell` instead of `Idris` + `Dunna`, `Daybreak` for nukes/enfeebles, `Geomancy Pants +3` (better FC/enfeebling legs than Voi's `+2`), `Moonbeam Cape` in `idle.Pet` (instead of `idle_jse_back`!), and `Psycloth Lappas` in `idle.Pet`.
  - **Setup & Lockstyle:** `autoindi = "Haste"`, `autogeo = "Frailty"`, `indi_duration = 290`, Macro Book `10` Page `4`, `/lockstyleset 11` (Santa `7`, Swimsuit `8`, Halloween `10`), runs `lua unload SKillchains`.

### Balullu & Friendlessvirus (Alt Summary)

- Both `Balullu_Geo_Gear.lua` and `Friendlessvirus_Geo_Gear.lua` are identical uncustomized Selindrile baseline templates (`Solstice`/`Dunna`, `Merlinic` nuke legs, `autoindi = 'Torpor'`, `autogeo = 'Frailty'`).

---

## Related Notes

- [FFXI GearSwap and Character Profiles](./README.md)
- `FFXI Windower Overview`
- [FFXI Addon — GearSwap](./GearSwap-Engine.md)
- `FFXI Addon — PorterPacker`
