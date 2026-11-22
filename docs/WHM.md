# FFXI GearSwap — WHM (White Mage)

> [!NOTE]
> **Quick Reference**
> - **Logic File:** `C:\Windower\addons\GearSwap\data\WHM.lua` *(unmodified Selindrile core)*
> - **Character Gear Files & Customization Status:**
>   - `Gimlic\Gimlic_Whm_Gear.lua` — **Heavily customized** (`Mjollnir` + `Yagrush`, full AF/Relic `+3`, `Ebers +1`, `Shamash Robe`, custom `check_heal()` / `AutoHealMode`, lockstyle `6`)
>   - `Voicelessbicep\Voicelessbicep_Whm_Gear.lua` — **Heavily customized** (`Yagrush`, `Piety Briault +3`, `Theophany +2`, `Ebers +1`, custom `check_heal()` / `AutoHealMode`, lockstyle `6`)
>   - `Balullu\Balullu_Whm_Gear.lua` — **Customized** (`Izcalli`, `Piety Briault +3`, `Theophany +2`, custom `check_heal()` with full `party.count` loop, lockstyle `6`)
>   - `Friendlessvirus\Friendlessvirus_Whm_Gear.lua` — **Baseline template** (older Selindrile clone; `Izcalli`, no `AutoHealMode` / `check_heal()`)
> - **Default Weapons:** `None` (unlocked for Cure/StatusRemoval swaps) | Melee sets: `Gimlic` (`Mjollnir`, `Yagrush`, `DualWeapons`) / `Voicelessbicep` (`MeleeWeapons` = `Yagrush`+`Ammurapi`, `DualWeapons` = `Yagrush`+`Bolelabunga`)
> - **Default AutoWS / Food:** `autows = 'Mystic Boon'` (`autowstp = 1000`) | `autofood = 'Miso Ramen'`
> - **Default Macro Book / Lockstyle:** Book `4`, Page `10` (`Gimlic` / `Voicelessbicep` / `Balullu`) | `/lockstyleset 6` (`Gimlic` also runs `lua unload SKillchains`)
> - **Key Automation Flags:** `AutoArts = true` (global), `AutoCaress = true`, `BlockLowDevotion = true`, `Gambanteinn = false`, `AutoHealMode = false` *(custom)*

Comprehensive code, command, and character gear reference for Kevin's Selindrile White Mage setup across `Gimlic`, `Voicelessbicep`, `Balullu`, and `Friendlessvirus`.

---

## Job-Specific Modes & Keybinds

### Job States & Modes (`WHM.lua` + Gear Overrides)

| State / Mode | Options / Default | Defined / Overridden In | Purpose |
| :--- | :--- | :--- | :--- |
| `state.OffenseMode` | `'Normal'`, `'Acc'` | `*_Whm_Gear.lua` | Melee engaged accuracy tier (`Ayanmo +2` sets) |
| `state.CastingMode` | `'Normal'`, `'Resistant'` | `*_Whm_Gear.lua` | Swaps `Elemental Magic`, `Drain`/`Aspir`, `Stun`, `Enfeebling` between normal and M.Acc sets (also supports `Proc` / `Fodder` in `WHM.lua`) |
| `state.IdleMode` | `'Normal'`, `'PDT'`, `'MDT'` *(Balullu/FV omit `MDT`)* | `Gimlic` / `Voicelessbicep` | Idle gear profile; `Normal` enables latent refresh (`Fucho-no-Obi` / `Oneiros Grip`) + `TPEat` (`Chrys. Torque`) under 51% MP |
| `state.PhysicalDefenseMode` | `'PDT'` | `*_Whm_Gear.lua` | `F10` physical defense lock |
| `state.MagicalDefenseMode` | `'MDT'` | `*_Whm_Gear.lua` | `F11` magical defense lock |
| `state.ResistDefenseMode` | `'MEVA'` | `*_Whm_Gear.lua` | `F12` magic evasion lock (`Inyanga +2` / `Telchine` / `Warder's Charm +1`) |
| `state.Weapons` | `'None'`, `'DualWeapons'`, `'MeleeWeapons'` | `*_Whm_Gear.lua` | When not `'None'`, routes all Cures into `MeleeCure*` sets so TP is not lost swapping staves/clubs |
| `state.ElementalMode` | `'Light'`, `'Dark'`, `'Fire'`, `'Ice'`, `'Wind'`, `'Earth'`, `'Lightning'`, `'Water'` | `WHM.lua` | Drives `//gs c elemental ...` nukes, storms, spikes, helix, and Banish/Holy selection |
| `state.AutoCaress` | `true` (bool) | `WHM.lua` | Auto-prepends `/ja "Divine Caress" <me>` before `-na` spells (excludes `Erase`, `Esuna`, `Sacrifice`) |
| `state.Gambanteinn` | `false` (bool) | `WHM.lua` | Equips `Gambanteinn` on `Cursna` midcast if available (ignored if subjob is `NIN`/`DNC` with `sets.midcast.DWCursna`) |
| `state.BlockLowDevotion` | `true` (bool) | `WHM.lua` | Cancels `Devotion` when WHM is below 50% HP to prevent low-MP transfers |
| `state.AutoBuffMode` | `'Off'`, `'Auto'` (etc. via `Sel-Include`) | `Sel-Include` + `WHM.lua` | Drives `check_arts()` and `check_buff()` (`Reraise IV`, `Haste`, `Aurorastorm`, `Refresh`, `Stoneskin`) |
| `state.AutoHealMode` *(custom)* | `false` (bool) | `Gimlic` / `Voicelessbicep` / `Balullu` | Custom flag for Kevin's `check_heal()` routine *(see Gotchas below)* |

### Job-Specific Keybinds (`*_Whm_Gear.lua`)

*(Modifier key legend: `^` = `Ctrl`, `!` = `Alt`, `@` = `Win`)*

| Keybind | Command | Action | Notes |
| :--- | :--- | :--- | :--- |
| `Ctrl+~` (`^` + `` ` ``) | `input /ma "Arise" <t>` | Cast `Arise` on target | All 4 characters |
| `Alt+~` (`!` + `` ` ``) | `input /ja "Penury" <me>` | Activate `Penury` (half MP) | `/SCH` strategem |
| `Win+~` (`@` + `` ` ``) | `gs c cycle MagicBurstMode` | Cycle `MagicBurstMode` (`Off`, `Single`, `Lock`) | Used for Holy/nukes |
| `Ctrl+Alt+Win+~` | `gs c toggle AutoCaress` | Toggle automatic `Divine Caress` | Before `-na` spells |
| `Ctrl+Backspace` | `input /ja "Sacrosanctity" <me>` | Cast `Sacrosanctity` | Party MDT buff |
| `Alt+Backspace` | `input /ja "Accession" <me>` | Activate `Accession` | AoE white magic (`/SCH`) |
| `Win+Backspace` | `input /ma "Aurora Storm" <me>` | Cast `Aurorastorm` | Triggers Light Weather Cure sets |
| `Alt+Pause` | `gs c toggle AutoSubMode` | Toggle auto-`Sublimation` | `/SCH` MP maintenance |
| `Alt+=` | `input /ja "Sublimation" <me>` | Manual `Sublimation` | Activate or discharge |
| `Ctrl+Delete` | `input /ja "Dark Arts" <me>` | Switch to `Dark Arts` | `/SCH` |
| `Alt+Delete` | `input /ja "Addendum: Black" <me>` | Activate `Addendum: Black` | `/SCH` |
| `Win+Delete` | `input /ja "Manifestation" <me>` | Activate `Manifestation` | AoE black magic (`/SCH`) |
| `Ctrl+\` | `input /ma "Protectra V" <me>` | Cast `Protectra V` | Party Defense |
| `Win+\` | `input /ma "Shellra V" <me>` | Cast `Shellra V` | Party MDT |
| `Alt+\` | `input /ma "Reraise IV" <me>` | Cast `Reraise IV` | Self Reraise |
| `Win+F1` | `gs c toggle AutoHealMode` | Toggle custom `AutoHealMode` | `Gimlic`, `Voicelessbicep`, `Balullu` |
| `Ctrl+Pause` / `Win+F2` | `gs c toggle AutoShadowMode` | Toggle automatic `Utsusemi` shadows | `Gimlic`, `Voicelessbicep` (`Win+F2` added locally) |

---

## Job-Specific Commands (`//gs c ...`)

All handlers below live in `WHM.lua` (`job_self_command`, lines 374–382) or Selindrile's core self-commands (`Sel-SelfCommands.lua`) that read WHM's tables.

| Command | Arguments | Behavior | Macro Example |
| :--- | :--- | :--- | :--- |
| `//gs c smartcure [target]` | Optional mob ID or player name; defaults to `<t>` (or `<me>` if target is self/monster/none) | Auto-casts **`Arise`** if target is dead (`status 2/3`). Otherwise estimates missing HP (exact HP for alliance members, `1800` max HP estimate for non-alliance) and picks the best off-cooldown tier (`<250`: Cure I→II, `<400`: Cure II→III→I, `<900`: Cure III→IV→V, `<1400`: Cure V→IV→VI→III, `>=1400`: Cure VI→V→IV→III). On `MONSTER` targets, fires Cure IV→III→II. | `/con gs c smartcure <stpc>` |
| `//gs c elemental nuke [target]` | Uses `state.ElementalMode`; optional target ID/name | If `Light`, cascades through `Holy II` → `Holy` → `Banish III` → `Banish II` → `Banish` based on recast & MP. For all other elements, tries Tier II → Tier I. | `/con gs c elemental nuke <t>` |
| `//gs c elemental smallnuke [target]` | Uses `state.ElementalMode` | Fires Tier II → Tier I nuke of current element (even when set to `Light`). | `/con gs c elemental smallnuke <t>` |
| `//gs c elemental tier1..tier6 [target]` | `tier1` through `tier6` | Casts exact tier nuke of `state.ElementalMode`. | `/con gs c elemental tier2 <t>` |
| `//gs c elemental weather` | None | If `/RDM`, casts `Phalanx <me>`. Otherwise casts matching Storm spell; if targeting self/non-party and Storm is already active without `Klimaform`, casts `Klimaform <me>`. | `/con gs c elemental weather` |
| `//gs c elemental spikes` / `enspell` | None | Casts matching `<Element> Spikes` or `En<element>` on `<me>`. | `/con gs c elemental spikes` |
| `//gs c elemental ara` / `aga` / `helix` / `enfeeble` / `bardsong` | Optional target | Casts matching `-ra`, `-ga`, Helix, Elemental Enfeeble, or Threnody for `state.ElementalMode`. | `/con gs c elemental helix <t>` |
| `//gs c buffup [list]` | `Default` (default) or `Melee` | Walks `buff_spell_lists[list]` in `WHM.lua` until every listed buff is active (`Default`: Reraise IV, Shellra V, Protectra V, Auspice, Haste, Aquaveil, Aurorastorm, Stoneskin, Blink, Phalanx; `Melee`: Reraise IV, Haste, Boost-STR, Shellra V, Protectra V, Auspice). | `/con gs c buffup Melee` |
| `//gs c toggle AutoCaress` | None | Toggles auto-`Divine Caress` before `-na` spells. | `/con gs c toggle AutoCaress` |
| `//gs c toggle Gambanteinn` | None | Toggles `Gambanteinn` swap for `Cursna`. | `/con gs c toggle Gambanteinn` |
| `//gs c toggle BlockLowDevotion` | None | Toggles `<50% HP` safety block on `Devotion`. | `/con gs c toggle BlockLowDevotion` |

---

## How the Job Logic Works (`WHM.lua`)

### Casting Pipeline (`precast` → `midcast` → `aftercast`)

1. **`job_precast()` (lines 182–205):**
   - **Auto-Divine Caress:** For any `StatusRemoval` spell *except* `Erase`, `Esuna`, and `Sacrifice`, if `state.AutoCaress` is `true`, `Divine Caress` (recast ID `32`) is ready, and player is not Amnesia'd, it cancels the spell, fires `/ja "Divine Caress" <me>`, and reschedules the `-na` spell 1 second later.
   - **Low-HP Devotion Guard:** If `state.BlockLowDevotion` is `true` and WHM is below `50%` HP while `Devotion` (ID `28`) is off cooldown, cancels the ability with a chat warning.
   - Sets `classes.CustomClass = 'Proc'` when `CastingMode == 'Proc'`.
2. **`job_post_precast()` (lines 207–218):**
   - On `WeaponSkill`, if the chosen WS set contains `Moonshade Earring` and `get_effective_player_tp() > 3200`, swaps to `sets.MaxTP[spell.english] or sets.MaxTP` (e.g., `sets.MaxTP.Dagan` uses `Etiolation` + `Evans Earring`).
3. **`job_get_spell_map()` (lines 278–326) — Cure/Curaga Weather, Day, Solace & Melee Routing:**
   - **Curaga:** Returns `LightWeatherCuraga` if Light weather is active (e.g., `Aurorastorm` → equips `Chatoyant Staff` + `Hachirin-no-Obi`), else `LightDayCuraga` on Lightsday.
   - **Cure:** Branches on 3 axes:
     - `state.Weapons.value ~= 'None'` → `Melee*` sets (preserves main/sub weapons and TP).
     - `state.Buff['Afflatus Solace']` → `*CureSolace` sets (equips `Ebers Bliaut +1` for Stoneskin bonus).
     - `world.weather_element == 'Light'` → `LightWeather*` (`Chatoyant Staff` + `Hachirin-no-Obi`), else `world.day_element == 'Light'` → `LightDay*` (`Hachirin-no-Obi`).
   - **Enfeebling Magic:** Maps `Dia*` → `Dia` (TH-combined), White Magic / `Frazzle` / `Distract` → `MndEnfeebles` (`Alaunus's Cape`), Black Magic enfeebles → `IntEnfeebles` (`Acuity Belt +1`).
4. **`job_post_midcast()` (lines 220–256):**
   - **StatusRemoval:** Layers `sets.buff['Divine Caress']` (`Ebers Mitts +1`, `Mending Cape`) whenever `Divine Caress` is active. On `Cursna`, applies `sets.midcast.DWCursna` if `/NIN` or `/DNC`, otherwise swaps `main="Gambanteinn"` if `state.Gambanteinn` is enabled.
   - **BarElement:** Layers `sets.midcast.BarElement.LightArts` if defined while `Light Arts` or `Addendum: White` is active.
   - **Elemental Magic:** Layers `sets.MagicBurst`, `Zodiac Ring` (in `Fodder` mode on matching day), and `sets.element[spell.element]`.
5. **`job_aftercast()` (lines 258–267):**
   - Creates a 60s Windower timer for `Sleep` / `Sleepga` if `UseCustomTimers` is enabled.
   - Resets `MagicBurstMode` after a single nuke if set to `Single`.

### Idle Customization & Tick Automation (`job_customize_idle_set`, `job_tick`)

- **`job_customize_idle_set()` (lines 329–359):**
  - If `Sublimation: Activated`, layers `sets.buff.Sublimation` or `sets.buff.DTSublimation` (`waist="Embla Sash"`).
  - In `Normal`/`Sphere` idle below `51%` MP: equips `sets.latent_refresh` (`Fucho-no-Obi`), `sets.latent_refresh_grip` (`Oneiros Grip` when using a Staff & weapons unlocked), and `sets.TPEat` (`Chrys. Torque`) if `player.tp > 10`.
- **`job_tick()` (lines 384–389):** Runs `check_arts()` → `check_buff()` → `check_buffup()`:
  - **`check_arts()`:** Outside cities, when `buffup ~= ''`, `(AutoArts and in_combat)`, or `AutoBuffMode ~= 'Off'`, automatically activates **`Afflatus Solace`** (ID `29`, only if neither Solace nor Misery is up) and **`Light Arts`** (ID `228`, when `/SCH` and no Arts active). Also called on `Pause/Break` (`//gs c update user`).
  - **`check_buff()`:** When `AutoBuffMode` is `'Auto'` outside cities, maintains `Reraise IV`, `Haste`, `Aurorastorm`, `Refresh`, and `Stoneskin`.
  - **`check_buffup()`:** Sequentially casts all missing spells from `buff_spell_lists[buffup]` until complete.

> [!WARNING]
> **Code Bugs & Gotchas Discovered in WHM Files**
> 1. **`WHM.lua` line 290 (upstream Selindrile typo):** Returns `'"MeleeLightWeatherCureSolace'` with an extra leading `"` — so `MeleeLightWeatherCureSolace` will never match while meleeing in Light weather with Solace up.
> 2. **Custom `check_heal()` is currently NOT wired into `job_tick()`:** `Gimlic`, `Voicelessbicep`, and `Balullu` all define `state.AutoHealMode` (`Win+F1`) and a custom `check_heal()` function (Doom/Charm → Status Removals → Arise/Devotion → `/SCH` Accession+Stoneskin), but `WHM.lua`'s `job_tick()` only calls `check_arts()`, `check_buff()`, and `check_buffup()`. Because `user_job_tick()` is not defined to call `check_heal()`, toggling `Win+F1` currently has no effect (Kevin uses `FFXI Addon — HealBot` for active auto-healing).
> 3. **Bugs inside `check_heal()` if ever re-enabled:**
>    - On `Gimlic` and `Voicelessbicep`, the Doom/Charm and Debuff loops were narrowed to `for i=1,1 do` (only checks `party[1]`; `Balullu` still has `for i=1,party.count do`).
>    - `party[i].buffactive.poision` (misspelled `poison`), `party[i].buffactive.Curse` (capital `C`), and `/ma "Stone Skin" <me>` (space in `Stoneskin`).
>    - Lua operator precedence bugs: `not party[i].name == 'Clintbeastwood'` and `not party[i].name == player.name` evaluate `(not string) == string` (always `false`), so Blindna and Devotion checks will not trigger as intended (use `~=`).
> 4. **Gear slot / name typos in `Gimlic_Whm_Gear.lua`:**
>    - `state.Weapons` lists `'MeleeWeapons'`, but `Gimlic` defines `sets.weapons.Mjollnir` and `sets.weapons.Yagrush` (no `sets.weapons.MeleeWeapons`!). Selecting `MeleeWeapons` via `F7` won't equip a single-wield mace unless `state.Weapons` is updated to include `'Mjollnir','Yagrush'`.
>    - `sets.midcast.Regen` has `body="Piety Briault+3"` (missing space and uses `Briault` instead of `Bliaut` — `Gimlic` has `Piety Bliaut +3` elsewhere and in PorterPacker; `Voicelessbicep`/`Balullu` also have `Piety Briault+3` missing space).
>    - `sets.precast.JA['Devine Caress']` is misspelled (`Devine` vs `Divine`; note `Divine Caress` potency is actually evaluated on midcast via `sets.buff['Divine Caress']`).

---

## Character Customizations & Key Gear Sets

### Gimlic (`Gimlic_Whm_Gear.lua` + `Gimlic-Items.lua` + `PorterPacker\Gimlic_WHM.lua`)

- **Weapons & REMA:**
  - `sets.weapons.Mjollnir`: `Mjollnir` + `Ammurapi Shield`
  - `sets.weapons.Yagrush`: `Yagrush` + `Ammurapi Shield`
  - `sets.weapons.DualWeapons`: `Mjollnir` + `Yagrush`
  - Utility/Casting clubs & staves: `Queller Rod`, `Bolelabunga`, `Daybreak`, `Beneficus`, `Vadose Rod`, `Mafic Cudgel`, `Rubicundity`, `Chatoyant Staff`, `gear.gada_enhancing_club` (`Enh. Mag. eff. dur. +6`), `gear.grioavolr_fc_staff` (`FC+7`), `gear.grioavolr_nuke_staff` (`MBD+8, MAB+30`)
- **Full JSE +3 & Empyrean +1 Wardrobe (also tracked in `PorterPacker/data/Gimlic_WHM.lua`):**
  - **Artifact (`Theophany +3`):** Full 5/5 `+3` (`Theophany Cap +3`, `Theo. Bliaut +3`, `Theophany Mitts +3`, `Theophany Pantaloons +3`, `Theo. Duckbills +3`)
  - **Relic (`Piety +3`):** Full 5/5 `+3` (`Piety Cap +3`, `Piety Bliaut +3`, `Piety Mitts +3`, `Piety Pantaln. +3`, `Piety Duckbills +3`)
  - **Empyrean (`Ebers +1`):** Full 5/5 `+1` (`Ebers Cap +1`, `Ebers Bliaut +1`, `Ebers Mitts +1`, `Ebers Pantaloons +1`, `Ebers Duckbills +1`)
- **Key Sets Summary:**
  - **Idle:** `Bolelabunga` / `Genbu's Shield` / `Homiliary` / `Befouled Crown` / `Shamash Robe` / `Nyame Gauntlets` / dual `Stikini Ring +1` / `Assid. Pants +1` / `Chironic Slippers` (`Refresh+2`). PDT uses `Mafic Cudgel` + `Piety Bliaut +3` + `Defending Ring`; MDT uses `Daybreak` + `Inyanga Jubbah +2`.
  - **Cure / CureSolace:** `Queller Rod` + `Sors Shield` + `Theophany Cap/Mitts +3` + `Theo. Bliaut +3` (or `Ebers Bliaut +1` under Solace) + `Nourish. +1` / `Glorious Earring` + `Janniston Ring` / `Menelaus's Ring` + `Alaunus's Cape` + `Ebers Pantaloons +1` + `Kaykaus Boots`. Light Weather swaps to `Chatoyant Staff` + `Curatio Grip` + `Hachirin-no-Obi`.
  - **Cursna & StatusRemoval:** `Yagrush` + `Ammurapi Shield` + `Ebers Cap/Bliaut +1` + `Debilis Medallion` + `Meili Earring` + `Fanatic Gloves` + `Haoma's` / `Menelaus's Ring` + `Theophany Pantaloons +3` + `Vanya Clogs`. `Erase` adds `Cleric's Torque +2`.
  - **Fast Cast:** `Grioavolr` (`FC+7`) + `Clerisy Strap +1` + `Impatiens` + `Clr. Torque +2` + `Inyanga Jubbah +2` + `Fanatic Gloves` + `Kishar`/`Lebeche` + `Witful Belt` + `Lengo Pants` + `Regal Pumps +1`. Cure FC layers `Ebers Pantaloons +1` → `Doyen Pants` + `Hygieia Clogs +1`.
  - **Enhancing / BarElement:** `Gada` (`Dur+6`) + `Ammurapi` + `Telchine` (Head/Body/Hands/Legs) + `Embla Sash` + `Theo. Duckbills +3`. `BarElement` uses `Beneficus` + 4/5 `Ebers +1` + `Piety Pantaln. +3`.
  - **JA Enhancers:** `Benediction` (`Piety Bliaut +3`), `Devotion` (`Piety Cap +3`), `Martyr` (`Piety Mitts +3`), `Afflatus Misery` (`Piety Pantaln. +3`), `Afflatus Solace` (`Ebers Bliaut +1`, `Piety Duckbills +3`).
- **Setup & Lockstyle:** Macro Book `4`, Page `10`; `/lockstyleset 6` (comment notes seasonal sets: Santa `7`, Swimsuit `8`, Halloween `10`); automatically runs `lua unload SKillchains`.

### Voicelessbicep (`Voicelessbicep_Whm_Gear.lua` + `Voicelessbicep-Items.lua`)

- **Weapons:**
  - `sets.weapons.MeleeWeapons`: `Yagrush` + `Ammurapi Shield` *(matches `state.Weapons` properly!)*
  - `sets.weapons.DualWeapons`: `Yagrush` + `Bolelabunga`
  - Uses `Yagrush` in both `sets.midcast.Cursna` and `sets.midcast.StatusRemoval` (same mythic AoE `-na` capability as Gimlic).
- **Key Differences vs. Gimlic:**
  - **JSE Tier:** `Piety Briault +3`, `Theophany +2` (Body/Hands/Legs/Feet), `Piety +1` (Legs/Feet), `Ebers +1` (5/5), `Gende. Caubeen +1` on Cure head (instead of `Theophany Cap +3`).
  - **Idle:** `Piety Briault +3` + `Clr. Torque +2` + `Chironic Gloves/Slippers` (`Refresh+2`) + `Bifrost` / `Serket Ring` (instead of Gimlic's `Shamash Robe` + `Nyame Gauntlets` + dual `Stikini +1`).
  - **Fast Cast:** Omits `Doyen Pants` on Cure FC (uses `Ebers Pantaloons +1` + `Hygieia Clogs +1`), keeps `Doyen Pants` on Stoneskin FC.
  - **JA Precast:** Only defines `sets.precast.JA.Benediction = {body="Piety Briault +3"}`.
  - **Lockstyle:** `/lockstyleset 6` (does not unload `Skillchains`). Macro Book `4`, Page `10`.

### Balullu & Friendlessvirus (Alt Summary)

- **`Balullu` (`Balullu_Whm_Gear.lua`):** Customized WHM alt using `Izcalli` + `Ammurapi Shield` (`MeleeWeapons`) / `Nehushtan` (`DualWeapons`), `Grioavolr` + `Clemency Grip` on `Cursna`/`StatusRemoval` (no `Yagrush`), `Piety Briault +3`, `Theophany +2`, `Vrikodara Jupon` on PDT idle, and `AutoHealMode` (`Win+F1`) with the full `for i=1,party.count` loop in `check_heal()`. Lockstyle `6`, Macro Book `4`, Page `10`.
- **`Friendlessvirus` (`Friendlessvirus_Whm_Gear.lua`):** Older Selindrile baseline clone (`Izcalli`, `Piety Briault +1`, `Theophany +3` hands/legs/feet from template, Macro Book `6` Page `3`, no `AutoHealMode`).

---

## Related Notes

- [FFXI GearSwap and Character Profiles](./README.md)
- `FFXI Windower Overview`
- [FFXI Addon — GearSwap](./GearSwap-Engine.md)
- `FFXI Addon — HealBot`
- `FFXI Addon — PorterPacker`
