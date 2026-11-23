# FFXI GearSwap — DRG (Dragoon)

> [!NOTE]
> **Quick Reference**
> - **Logic File:** `C:\Windower\addons\GearSwap\data\DRG.lua` — **CUSTOMIZED BY GIMLIC** (hooks `check_breath()` in `job_tick()` and adds automatic `Spirit Bond` in `check_buff()`)
> - **Character Gear Files & Customization Status:**
>   - `Gimlic\Gimlic_Drg_Gear.lua` — **Heavily customized flagship DRG** (`Trishula`, `Gungnir`, `Naegling`, `Exalted Staff`, full `Vishap +3` & `Pteroslaver +3`, `Gleti's`, `Nyame`, `Hjarrandi Breast.`, `Hybrid` offense mode, custom `check_breath()` + `AutoBreathMode`, lockstyle `3`)
>   - `Voicelessbicep\Voicelessbicep_Drg_Gear.lua` — **Heavily customized DRG** (`Gungnir`, `Dream Bell`, `Pteroslaver +3`, `Vishap +3` legs/feet, `Geirskogul` default AutoWS, custom `check_breath()` + city `use_equipment_items()` Potion Tank helper, lockstyle `3`)
>   - `Balullu\Balullu_Drg_Gear.lua` & `Friendlessvirus\Friendlessvirus_Drg_Gear.lua` — **Identical baseline templates** *(warning: do NOT define `check_breath()`, which `DRG.lua` now calls!)*
> - **Default Weapons:** `Gimlic`: `'Trishula'`, `'Gungnir'`, `'Naegling'`, `'Staff'` | `Voicelessbicep`: `'Gungnir'`, `'club'`
> - **Default AutoWS / Food:** `Gimlic`: `autows = 'Stardiver'` | `Voicelessbicep`: `autows = 'Geirskogul'` | Both: `autofood = 'Red Curry Bun'`
> - **Default Macro Book / Lockstyle:** Book `1`, Page `9` (all subjobs) | `/lockstyleset 3` (`Gimlic` also runs `lua load SKillchains`)
> - **Key Automation Flags:** `AutoBreathMode = true` *(custom, `Win+F1`)*, `AutoBondMode = true`, `AutoJumpMode = false` (`Win+F7`), `Stance = 'Hasso'` (`Ctrl+Alt+Win+~`)

Comprehensive code, command, and character gear reference for Gimlic's heavily customized Selindrile Dragoon setup — including Gimlic's direct edits to `DRG.lua` and custom Wyvern Auto-Healing-Breath engine.

---

## Job-Specific Modes & Keybinds

### Job States & Modes (`DRG.lua` + Gear Overrides)

| State / Mode | Options / Default | Defined / Overridden In | Purpose |
| :--- | :--- | :--- | :--- |
| `state.OffenseMode` | `Gimlic`: `'Normal'`, `'SomeAcc'`, `'Acc'`, `'FullAcc'`, `'Fodder'`, **`'Hybrid'`** / `Voicelessbicep`: omits `'Hybrid'` | `*_Drg_Gear.lua` | Melee engaged tier (`Gimlic` adds a `Hybrid` DT/melee tier with `Loess Barbuta +1`, `Hjarrandi Breastplate`, `Defending`/`Vocane`) |
| `state.WeaponskillMode` | `'Match'`, `'Normal'`, `'SomeAcc'`, `'Acc'`, `'FullAcc'`, `'Fodder'` | `*_Drg_Gear.lua` | WS accuracy/damage tier (`Fodder` swaps heavily into `Gleti's` on Gimlic) |
| `state.HybridMode` | `'Normal'` | `*_Drg_Gear.lua` | Secondary hybrid layer (kept single-option; Gimlic uses `OffenseMode = Hybrid` instead) |
| `state.PhysicalDefenseMode` | `'PDT'`, `'PDTReraise'` | `*_Drg_Gear.lua` | `F10` lock (`PDTReraise` layers `Twilight Helm` + `Twilight Mail`) |
| `state.MagicalDefenseMode` | `'MDT'`, `'MDTReraise'` | `*_Drg_Gear.lua` | `F11` lock (`MDTReraise` layers `Twilight` RR) |
| `state.ResistDefenseMode` | `'MEVA'` | `*_Drg_Gear.lua` | `F12` magic evasion lock (`Gimlic` uses full `Nyame` 5/5) |
| `state.IdleMode` | `'Normal'`, `'PDT'`, `'Refresh'`, `'Reraise'` | `*_Drg_Gear.lua` | Idle profile (`Reraise` equips `Twilight Helm` + `Twilight Mail`) |
| `state.Passive` | `'None'`, `'MP'`, `'Twilight'` | `*_Drg_Gear.lua` | Passive overlay (`MP` = `Ethereal Earring` + `Flume Belt +1`; `Twilight` = auto-reraise) |
| `state.Weapons` | `Gimlic`: `'Trishula'`, `'Gungnir'`, `'Naegling'`, `'Staff'` / `Voicelessbicep`: `'Gungnir'`, `'club'` | `*_Drg_Gear.lua` | Main weapon + `Utu Grip` |
| `state.Stance` | `'Hasso'`, `'Seigan'`, `'None'` | `DRG.lua` | Auto-maintained `/SAM` stance when engaged with a 2H polearm |
| `state.AutoJumpMode` | `false` (bool) | `DRG.lua` | Auto-fires Jumps & `Spirit Link` when engaged and `player.tp < 501` |
| `state.AutoBondMode` | `true` (bool) | `DRG.lua` | Auto-pairs `Spirit Bond` before `Restoring Breath` (when pet `<75%` HP) and cancels `Spirit Bond` right after |
| `state.AutoBreathMode` *(custom)* | `true` (bool) | `Gimlic_Drg_Gear.lua` & `Voicelessbicep_Drg_Gear.lua` | Toggles Gimlic's custom `check_breath()` automatic party/wyvern healing breath engine |

### Job-Specific Keybinds (`Gimlic_Drg_Gear.lua` & `Voicelessbicep_Drg_Gear.lua`)

*(Modifier key legend: `^` = `Ctrl`, `!` = `Alt`, `@` = `Win`)*

| Keybind | Command | Action |
| :--- | :--- | :--- |
| `Ctrl+~` (`^` + `` ` ``) | `input /ja "Hasso" <me>` | Activate `Hasso` (`/SAM`) |
| `Alt+~` (`!` + `` ` ``) | `input /ja "Seigan" <me>` | Activate `Seigan` (`/SAM`) |
| `Win+~` (`@` + `` ` ``) | `gs c cycle SkillchainMode` | Cycle Skillchain helper mode |
| `Ctrl+Alt+Win+~` | `gs c cycle Stance` | Cycle auto-stance (`Hasso` / `Seigan` / `None`) |
| `Win+F1` | `gs c toggle AutoBreathMode` | Toggle Gimlic's custom `AutoBreathMode` (`check_breath()`) |
| `Win+F7` | `gs c toggle AutoJumpMode` | Toggle automatic Jump + `Spirit Link` rotation under 501 TP |
| `Ctrl+F11` | `gs c cycle MagicalDefenseMode` | Cycle `MDT` / `MDTReraise` |
| `Ctrl+\` | `input /ma "Protectra V" <me>` | Cast `Protectra V` *(inherited bind; non-applicable on DRG)* |
| `Win+\` | `input /ma "Shellra V" <me>` | Cast `Shellra V` *(inherited bind)* |
| `Alt+\` | `input /ma "Reraise IV" <me>` | Cast `Reraise IV` *(inherited bind)* |

---

## Job-Specific Commands (`//gs c ...`)

`DRG.lua`'s `job_self_command()` (line 202) is intentionally empty; all DRG controls operate through Selindrile's standard state/variable commands (`Sel-SelfCommands.lua`):

| Command | Arguments | Behavior | Macro Example |
| :--- | :--- | :--- | :--- |
| `//gs c toggle AutoBreathMode` | None | Enables/disables Gimlic's custom Wyvern auto-healing-breath loop (`check_breath()`). | `/con gs c toggle AutoBreathMode` |
| `//gs c toggle AutoJumpMode` | None | Toggles automatic Jump & `Spirit Link` rotation while engaged under `501` TP. | `/con gs c toggle AutoJumpMode` |
| `//gs c toggle AutoBondMode` | None | Toggles auto-`Spirit Bond` wrapping around `Restoring Breath`. | `/con gs c toggle AutoBondMode` |
| `//gs c cycle Stance` *(or `set Stance Hasso`)* | `Hasso`, `Seigan`, `None` | Selects which `/SAM` stance `check_hasso()` maintains automatically. | `/con gs c set Stance Seigan` |
| `//gs c autows <WS>` | `Stardiver`, `Camlann's Torment`, `Impulse Drive`, `Sonic Thrust`, `Drakesbane`, `Geirskogul`, `Savage Blade` | Changes `autows` for `AutoWSMode` (`Ctrl+Alt+Win+F7`). | `/con gs c autows Impulse Drive` |
| `//gs c autows tp <num>` | e.g., `1000`, `1750`, `2000` | Sets TP threshold for `AutoWSMode` (e.g., high TP for `Impulse Drive` or `Savage Blade`). | `/con gs c autows tp 1750` |
| `//gs c weapons <Set>` | `Trishula`, `Gungnir`, `Naegling`, `Staff` (`Gimlic`) | Directly equips a named weapon set. | `/con gs c weapons Naegling` |
| `//gs c cycle OffenseMode` | `Normal` → `Hybrid` (`Gimlic`) | Cycles melee sets (including Gimlic's `Hybrid` DT/melee set). | `/con gs c set OffenseMode Hybrid` |

---

## How the Job Logic Works (`DRG.lua` + Custom `check_breath`)

### Precast, Midcast & Wyvern Breath Pipeline

1. **`job_precast()` (lines 73–102):**
   - **`/SAM` Auto-WS Buffing:** When `AutoBuffMode ~= 'Off'` and `/SAM`, firing a `WeaponSkill` automatically prepends:
     - **`Sekkanoki`** (ID `140`) if `player.tp > 1850`, OR
     - **`Meditate`** (ID `134`) if off cooldown,
     canceling the WS and re-issuing it 1 second later.
   - **Auto-`Spirit Bond` on `Restoring Breath`:** When using `Restoring Breath` with `AutoBondMode = true`, if Wyvern is `< 75%` HP, target is `> 44%` HP, and both `Restoring Breath` (ID `239`) & `Spirit Bond` (ID `149`) are ready, fires `Spirit Bond` first and `Restoring Breath` 1s later.
2. **`job_post_precast()` (lines 104–129):**
   - Replaces `Moonshade Earring` with `sets.MaxTP` / `sets.AccMaxTP` when effective TP `> 3200`.
   - For any JA ending in `'Jump'`, supports OffenseMode-keyed variants (`sets.precast.JA[spell.english][state.OffenseMode.value]`).
3. **Healing Breath Trigger & Potency Gear (`job_post_midcast`, `job_aftercast`, `job_pet_aftercast`, `find_breath_hpp`):**
   - **`find_breath_hpp()` (lines 305–319):** Dynamically sets `Breath_HPP` threshold based on subjob and whether `sets.midcast.HB_Trigger.head` contains `'Vishap'` or `'Drachen'`:
     - Mage subjobs (`WHM`/`BLM`/`RDM`/`SMN`/`BLU`/`SCH`/`GEO`): **`65%`** with Vishap/Drachen head (`45%` without).
     - Hybrid subjobs (`PLD`/`DRK`/`BRD`/`NIN`/`RUN`): **`45%`** with Vishap/Drachen head (`35%` without).
   - **`job_post_midcast()` (lines 133–139):** When casting any Magic spell while `25% < player.hpp < Breath_HPP` with Wyvern out, equips `sets.midcast.HB_Trigger` (`Vishap Armet +3` + `Moonbeam Cape`) to trigger Healing Breath at the higher HP threshold.
   - **`job_aftercast()` (lines 153–165):** Holds **`sets.HealingBreath`** (`Ptero. Armet +3`, `Dragoon's Collar +2`, `Brigantia's Mantle`, `Vishap Brais +3`, `Ptero. Greaves +3`) after a breath-triggering spell, `Steady Wing`, or `Restoring Breath` (setting `petWillAct = os.clock()` and `eventArgs.handled = true` so idle/melee gear doesn't overwrite it before the Wyvern breathes!). Holds `sets.SmitingBreath` on `Smiting Breath`.
   - **`job_pet_aftercast()` (lines 147–151):** Automatically sends `cancel spirit bond` once `Restoring Breath` finishes when `AutoBondMode` is `true`.
4. **`update_melee_groups()` (lines 180–195):** Appends `'Adoulin'` (under Ionis in Adoulin zones), `'AM'` (`Ryunohige` + `Aftermath: Lv.3`), and `'SpiritSurge'` (`Spirit Surge` active).

### Tick Automation (`job_tick`, lines 206–212)

`DRG.lua`'s `job_tick()` executes four loops in order:

1. **`check_hasso()` (lines 219–237):** While engaged as `/SAM` with a 2H weapon and neither Hasso nor Seigan active, automatically casts `Hasso` (ID `138`) or `Seigan` (ID `139`) matching `state.Stance`.
2. **`check_jump()` (lines 239–268):** When `AutoJumpMode = true`, engaged, and `player.tp < 501`, cascades through:
   - `Spirit Jump` (ID `166`) → `Soul Jump` (ID `167`) → `Jump` (ID `158`) → `High Jump` (ID `159`) → `Spirit Link` (ID `162`, only if Wyvern is out and `pet.tp > 350`).
3. **`check_buff()` (lines 270–303):** When `AutoBuffMode ~= 'Off'` and `player.in_combat`:
   - Summons Wyvern via **`Call Wyvern`** (ID `163`) if not out.
   - **[Gimlic Custom Edit — line 279]:** Automatically activates **`Spirit Bond`** (ID `149`) when Wyvern is within `6.25` yalms!
   - Maintains subjob offensive buffs: `/DRK` `Last Resort` (ID `87`), `/WAR` `Berserk` (ID `1`) and `Aggressor` (ID `4`).
4. **`check_breath()` — [Gimlic Custom Hook, line 210 in `DRG.lua`, implemented in `Gimlic_Drg_Gear.lua` & `Voicelessbicep_Drg_Gear.lua`]:**
   - Scans `party[1..party.count]` while `AutoBreathMode = true`, `Engaged`, and Wyvern is out.
   - Triggers when any living party member within `14` yalms drops below `Breath_HPP - 15` (e.g., `< 50%` on mage subjob with `Vishap Armet`, `< 45%` on non-mage default `Breath_HPP = 60`) OR when `pet.hpp < 50`:
     1. **`Deep Breathing`** (ID `164`) if party member `< 30%` HP and pet `< 6.25` yalms.
     2. **`Spirit Bond`** (ID `149`) if pet `< 6.25` yalms.
     3. **`Restoring Breath`** (ID `239`) (`5.1s` tickdelay).
     4. **`Dia`** (`<t>`) if `/WHM` or `/RDM` (on `Gimlic`, gated by `party[i].hpp < Breath_HPP - 15`).
     5. **`Stone`** (`<t>`) if `/BLM` or `/RDM` (`Gimlic` only).
     6. **`Steady Wing`** (ID `70`) if pet `< 6.25` yalms (`Gimlic` only).
   - **Voicelessbicep Extra (`use_equipment_items`, lines 359–423):** `Voicelessbicep`'s `check_breath()` also calls `use_equipment_items()`, which uses `extdata` to check charge counts on `"Moogle's Largesse"`, `"Moggiebag"`, `"Hi-Potion Tank"`, and `"Ether Tank"` while in cities and fires `/console gs c useitem back "Hi-Potion Tank"`.

> [!WARNING]
> **Code Bugs & Gotchas Discovered in DRG Files**
> 1. **Unquoted `buffactive[amnesia]` in `DRG.lua` (line 279) & `check_breath()` (lines 377/381/385/397):** `amnesia` is an undefined global (`nil`), so `not buffactive[amnesia]` is always `true` (doesn't actually guard against Amnesia; should be `not silent_check_amnesia()` or `not buffactive['amnesia']`).
> 2. **Alt safety (`Balullu` / `Friendlessvirus`):** Because `DRG.lua` line 210 calls `check_breath()` directly, loading DRG on `Balullu` or `Friendlessvirus` (whose gear files do not define `check_breath()`) will throw a Lua `attempt to call global 'check_breath' (a nil value)` error every tick unless guarded with `if check_breath and check_breath() then`.
> 3. **`Gimlic_Drg_Gear.lua` line 168 (`sets.precast.WS['Leg Sweep']`):** Has `neck="Fotia Belt"` instead of `neck="Fotia Gorget"`.
> 4. **`Gimlic_Drg_Gear.lua` line 282 (`sets.engaged.Hybrid`):** Has capitalized `Head="Loess Barbuta +1"` — GearSwap requires lowercase `head`, so `Flam. Zucchetto +2` remains equipped instead of `Loess Barbuta +1`.
> 5. **`Voicelessbicep_Drg_Gear.lua` line 108 (`sets.precast.WS`):** Typo `ear1="Brutal Earing"` (missing an `r` in `Earring`), and lines 90–91 (`Self_Healing`/`Cure_Received`) assign `ring2` twice (overwriting `Kunaji Ring` with `Vocane Ring`).
> 6. **`Voicelessbicep_Drg_Gear.lua` `use_equipment_items()`:** Runs on every `job_tick()` in cities and always sends `useitem back "Hi-Potion Tank"` whenever *any* of the 4 lockable items has charges remaining (even if the tank is on cooldown or another item had charges).

---

## Character Customizations & Key Gear Sets

### Gimlic (`Gimlic_Drg_Gear.lua` + `Gimlic-Items.lua` + `PorterPacker\Gimlic_DRG.lua`)

- **Weapons & REMA:**
  - `sets.weapons.Trishula` *(default)*: **`Trishula`** (Aeonic Polearm) + `Utu Grip`
  - `sets.weapons.Gungnir`: **`Gungnir`** (Relic Polearm) + `Utu Grip`
  - `sets.weapons.Naegling`: **`Naegling`** (Ambuscade Sword — Savage Blade)
  - `sets.weapons.Staff`: `Exalted Staff` + `Utu Grip` *(also defines `sets.weapons.club = {main="Dream Bell"}`)*
- **Dynamic Subjob Earring Logic (lines 255–259):**
  - Automatically sets `gear.DRGEar2` to **`Ethereal Earring`** (damage→MP for Healing Breath) on `/WHM`, `/RDM`, or `/BLU`, and **`Sherida Earring`** on melee subjobs (`/SAM`, `/WAR`, etc.)!
- **Full JSE +3 & Endgame Wardrobe (tracked in `PorterPacker/data/Gimlic_DRG.lua`):**
  - **Artifact (`Vishap +3`):** Full 5/5 `+3` (`Vishap Armet/Mail/Brais/Greaves +3`, `Vis. Fng. Gaunt. +3`)
  - **Relic (`Pteroslaver +3`):** Full 5/5 `+3` (`Ptero. Armet/Mail/Brais/Greaves +3`, `Ptero. Fin. G. +3`)
  - **Odyssey / High-Tier:** `Gleti's Mask/Cuirass/Gauntlets/Breeches/Boots`, full `Nyame` 5/5 (`MEVA` + WSD slots), `Hjarrandi Breastplate`, `Dragoon's Collar +2`, `Brigantia's Mantle`, `Loess Barbuta +1`, `Carmine Mask/Cuisses/Greaves +1`, `Chozoron Coselete` (idle Refresh), `Flamma +2` (5/5), `Sulevia's +2`, `Valorous` augmented pieces (`valorous_fc_body/hands`, `valorous_refresh_hands`, `valorous_treasure_legs`).
- **Key Sets Summary:**
  - **Engaged (`Normal`):** `Ginsen` + `Flam. Zucchetto +2` + `Vim Torque +1` + `Telos` / `gear.DRGEar2` + `Hjarrandi Breast.` + `Nyame Gauntlets` + `Petrov` / `Niqmaddu Ring` + `Brigantia's Mantle` + `Windbuffet Belt +1` + `Ptero. Brais +3` + `Flam. Gambieras +2`.
  - **Engaged (`Fodder`):** Swaps in `Gleti's Cuirass`, `Nyame Flanchard`, `Brutal` + `Sherida`, `Ioskeha Belt`.
  - **Engaged (`Hybrid`):** Layers `Loess Barbuta +1` *(fix `Head`→`head`)*, `Dragoon's Collar +2`, `Hjarrandi Breastplate`, `Vocane` + `Defending Ring`.
  - **Jumps (`Jump` / `High` / `Soul` / `Spirit`):** `Flam. Zucchetto +2` + `Ganesha's Mala` + `Telos` / `Sherida` + `Pteroslaver Mail +3` + `Vis. Fng. Gaunt. +3` + `Petrov` / `Niqmaddu` + `Brigantia's Mantle` + `Windbuffet Belt +1` + `Vishap Brais +3` + `Vishap Greaves +3`.
  - **Weaponskills:**
    - **Base / `Stardiver`:** `Knobkierrie` + `Ptero. Armet +3` (`Flam. Zucchetto +2` in `Fodder`) + `Dgn. Collar +2` (`Fotia Gorget` on Stardiver) + `Thud` / `Sherida` + `Gleti's Cuirass` + `Sulev. +2` (`Gleti's` in `Fodder`) + `Regal` / `Niqmaddu` + `Fotia Belt`.
    - **`Camlann's Torment`:** `Nyame Helm/Mail` + `Ptero. Fin. G. +3` + `Vishap Brais +3` + `Ishvara Earring`.
    - **`Sonic Thrust`:** `Nyame` (Head/Body/Legs/Feet) + `Ptero. Fin. G. +3`.
    - **`Impulse Drive`:** `Ptero. Armet +3` + `Ptero. Fin. G. +3` (`Gleti's Mask/Boots` in `Fodder`).
    - **`Drakesbane`:** `Gleti's Mask/Gauntlets/Boots` + `Hjarrandi Breast.` + `Sherida Earring`.
    - **`Geirskogul`:** `Fotia Gorget` + `Ptero. Fin. G. +3` + `Ishvara Earring` + `Vishap Brais +3`.
    - **`Leg Sweep`:** Full `Flamma +2` M.Acc set + `Flamma Ring`.
  - **JA & Breath Sets:** `Angon` (`Angon` + `Ptero. Fin. G. +3`), `Spirit Link` (`Vishap Armet +3`, `Pratik Earring`, `Pteroslaver Greaves +3`), `Call Wyvern` (`Pteroslaver Mail +3`, `Dragoon's Collar +2`), `Deep Breathing` (`Ptero. Armet +3`), `Steady Wing` (`Lancer's Earring`, `Vishap Brais +3`, `Ptero. Greaves +3`), `HealingBreath` (`Ptero. Armet +3`, `Dragoon's Collar +2`, `Brigantia's Mantle`, `Vishap Brais +3`, `Ptero. Greaves +3`), `SmitingBreath` (`Ptero. Armet +3`, `Adad Amulet`, `Enmerkar Earring`, `Incarnation Sash`, `Pteroslaver Brais +3`).
- **Setup & Lockstyle:** `autows = 'Stardiver'`, `autofood = 'Red Curry Bun'`, Macro Book `1` Page `9`, `/lockstyleset 3` (Santa `7`, Swimsuit `8`, Halloween `10`), auto-loads `Skillchains`.

### Voicelessbicep (`Voicelessbicep_Drg_Gear.lua` + `Voicelessbicep-Items.lua`)

- **Weapons:** `sets.weapons.Gungnir = {main="Gungnir", sub="Utu Grip"}` (default) and `sets.weapons.club = {main="Dream Bell"}` (`Trishula` commented out).
- **Default AutoWS / Food:** `autows = 'Geirskogul'` (Relic WS), `autofood = 'Red Curry Bun'`.
- **Dynamic Subjob Earring:** Uses `Ethereal Earring` on `/WHM`/`/RDM`/`/BLU`, and `Mache Earring +1` on melee subjobs.
- **Key Gear Differences vs. Gimlic:**
  - **JSE:** `Pteroslaver +3` (Head/Body/Hands/Feet), `Vishap Brais/Greaves +3`, `Vishap Armet +2`, `Pteroslaver Brais +1`, `Dragoon's Collar +2`.
  - **Engaged (`Normal`):** `Focal Orb` + `Pteroslaver Armet/Mail +3` + `Dragoon's Collar +2` + `Sulevia's Gauntlets/Cuisses +2` + `Vocane` / `Rajas Ring` + `Flam. Gambieras +2` (switches to `valorous_wsd_body` + `valorous_acc_hands` + `Regal`/`Niqmaddu` on `SomeAcc`–`Fodder`).
  - **WS Sets:** Defines `Stardiver`, `Drakesbane`, and `Geirskogul` (`valorous_wsd_body` + `Vishap Brais +3` + `Pteroslaver Finger Gauntlets +3` + `Ishvara Earring` + `Rufescent Ring`).
  - **Idle:** Full `Pteroslaver +3` + `Crimson Cuisses` (`Carmine Cuisses +1` in `Kiting`).
  - **Custom `check_breath()`:** Same core logic as Gimlic, minus `Stone` and `Steady Wing`, plus the city `use_equipment_items()` Potion Tank helper.
- **Setup & Lockstyle:** Macro Book `1` Page `9`, `/lockstyleset 3`.

### Balullu & Friendlessvirus (Alt Summary)

- `Balullu_Drg_Gear.lua` and `Friendlessvirus_Drg_Gear.lua` are identical uncustomized Selindrile baseline templates. **Note:** Do not load DRG on these alts without either adding a stub `check_breath()` or guarding line 210 of `DRG.lua`.

---

## Related Notes

- [FFXI GearSwap and Character Profiles](./README.md)
- `FFXI Windower Overview`
- [FFXI Addon — GearSwap](./GearSwap-Engine.md)
- `FFXI Addon — PorterPacker`
