# FFXI GearSwap — THF (Thief)

> [!NOTE]
> **Quick Reference**
> - **Logic File:** `C:\Windower\addons\GearSwap\data\THF.lua` (`326` lines)
> - **Character Status:** **CUSTOMIZED ON ALL 4** — `Gimlic` (~167 diff), `Voicelessbicep` (~147 diff), `Balullu` & `Friendlessvirus` (identical, ~126 diff)
> - **AutoWS / Food Overrides:** `THF.lua` default `Rudra's Storm` | `Gimlic`: `autows = "Savage Blade"` | `Voicelessbicep`: `autows = "Shark Bite"` | `Balullu`/`Friendlessvirus`: stock `Rudra's Storm`
> - **Weapon Profiles:** Added `Taming` (`Gimlic`/`Voicelessbicep`), `AccAeneas`, `AccSavage`, `MagicWeapons` across custom profiles

Thorough code and gear reference for `THF.lua` Treasure Hunter / SATA / Ambush automation and per-character customizations across all 4 accounts.

---

## Job-Specific Modes & Keybinds

### Job States (`THF.lua` & `user_job_setup`)
- **Job-level states (`THF.lua` / `Sel-TreasureHunter` / `user_job_setup`):**
  - `state.TreasureMode`: `'None'`, `'Tag'`, `'SATA'`, `'Fulltime'` (default `'Tag'` via `Sel-TreasureHunter.lua`; cycled with `Win+T` in globals).
  - `state.AmbushMode`: boolean (default `false`), overlays `sets.Ambush` (`Plunderer's Vest`) during WSs (when SA/TA inactive) and melee.
  - `state.ExtraMeleeMode`: `'None'`, `'Suppa'`, `'DWMax'`, `'Parry'` (cycled with `Alt+F11`).
- **HUD Init (`init_job_states`):**
  - Left: `Capacity`, `AutoRuneMode`, `AutoTrustMode`, `AutoWSMode`, `AutoShadowMode`, `AutoFoodMode`, `AutoStunMode`, `AutoDefenseMode`.
  - Right: `AutoBuffMode`, `AutoSambaMode`, `Weapons`, `OffenseMode`, `WeaponskillMode`, `IdleMode`, `Passive`, `RuneElement`, `TreasureMode`.
- **Custom Mode Options (all 4 characters):**
  - `state.OffenseMode`: `'Normal'`, `'SomeAcc'`, `'Acc'`, `'FullAcc'`, `'Fodder'`
  - `state.HybridMode`: `'Normal'`, `'DT'`
  - `state.WeaponskillMode`: `'Match'`, `'Normal'`, `'SomeAcc'`, `'Acc'`, `'FullAcc'`, `'Fodder'`, `'Proc'` *(removes `'DT'` from stock)*
  - `state.IdleMode`: `'Normal'`, `'Sphere'`
  - `state.Weapons`:
    - `Gimlic` / `Voicelessbicep`: `'Taming'`, `'Aeneas'`, `'AccAeneas'`, `'Savage'`, `'AccSavage'`, `'ProcWeapons'`, `'MagicWeapons'`, `'Evisceration'`, `'Throwing'`, `'SwordThrowing'`, `'Bow'`
    - `Balullu` / `Friendlessvirus`: same list without `'Taming'`

### Local Keybinds (`user_job_setup()`)
| Keybind | Action | Purpose |
| :--- | :--- | :--- |
| `Ctrl+~` (`^`` `) | `/ja "Flee" <me>` | Movement speed burst |
| `Alt+~` (`!`` `) | `/ra <t>` | Ranged attack (e.g., `Raider's Bmrng.` / `Albin Bane` TH tag) |
| `Win+~` (`@`` `) | `gs c cycle SkillchainMode` | Cycle Skillchain mode |
| `Win+F10` | `gs c toggle AmbushMode` | Toggle `sets.Ambush` overlay |
| `Ctrl+Backspace` | `/item "Thief's Tools" <t>` | Use Thief's Tools on target |
| `Alt+Backspace` | `/ja "Hide" <me>` | Activate Hide |
| `Ctrl+Q` | `gs c weapons ProcWeapons;gs c set WeaponSkillMode proc;` | Swap to Proc daggers + WS mode |
| `Alt+Q` | `gs c weapons SwordThrowing` | Swap to `Naegling` + Boomerang set |
| `Ctrl+R` / `Alt+R` | `Voicelessbicep`/`Balullu`/`Friendlessvirus`: `^r` Default + match, `!r` `MagicWeapons` | *(Gimlic remaps these to **`Ctrl+G`** and **`Alt+G`** to avoid conflict!)* |
| `Ctrl+\` | `/ja "Despoil" <t>` | Despoil target |
| `Alt+\` | `/ja "Mug" <t>` | Mug target |

---

## Job-Specific Commands (`//gs c ...`)

- `THF.lua` leaves `job_self_command` empty; TH and job states are controlled via `//gs c cycle TreasureMode`, `//gs c toggle AmbushMode`, `//gs c cycle ExtraMeleeMode`, `//gs c weapons <Set>`, and `//gs c autows <WS>`.

---

## Job Logic Highlights (`THF.lua`)

- **`job_filtered_action`**: When a **Sword** is equipped (`available_ws:contains(32)`, Fast Blade), remaps `Rudra's Storm` → `/ws "Savage Blade" <target>`.
- **`job_post_precast`**:
  - On `Aeolian Edge` or `Cyclone` with `TreasureMode ~= 'None'`, equips `sets.TreasureHunter` and returns immediately.
  - Replaces `Moonshade Earring` above `3200` effective TP (`AccMaxTP` when not in SA/TA, else `MaxTP`).
  - Overlays `sets.Ambush` on WSs when `AmbushMode == true` and neither `Sneak Attack` nor `Trick Attack` is active.
  - Equips `sets.TreasureHunter` on `Sneak Attack`, `Trick Attack`, or any `WeaponSkill` when `TreasureMode` is `'SATA'` or `'Fulltime'`.
- **`job_post_midcast`**: Equips `sets.TreasureHunter` on `Ranged Attack` whenever `TreasureMode ~= 'None'`.
- **`job_aftercast` & `job_post_aftercast`**:
  - Clears `state.Buff['Sneak Attack']`, `['Trick Attack']`, and `['Feint']` after a completed WS so idle/engaged gear equips cleanly.
  - If `Feint` is active, overlays `sets.buff.Feint` (plus `sets.TreasureHunter` in `SATA`/`Fulltime`).
- **`get_custom_wsmode` & `job_handle_equipping_gear`**:
  - Dynamically constructs `'SA'`, `'TA'`, or `'SATA'` WS variant tags (`sets.precast.WS[spell].SA` / `.TA` / `.SATA`).
  - Blocks normal idle/engaged swaps while `Sneak Attack` or `Trick Attack` is active, keeping `sets.buff['Sneak Attack']` / `['Trick Attack']` (plus TH if `SATA`/`Fulltime`) equipped via `have_buff()`.
- **`job_customize_melee_set`**: Applies `sets.Ambush` (if `AmbushMode == true`) and `sets.TreasureHunter` (if `TreasureMode == 'Fulltime'`).
- **`job_update` & `update_melee_groups`**: Runs `th_update()` from `Sel-TreasureHunter.lua` and appends `'AM'` melee group when wielding `Vajra` with `Aftermath: Lv.3`.
- **`job_tick()`**: `check_buff()` auto-maintains `/WAR` `Berserk` and `Aggressor` in combat when `AutoBuffMode ~= 'Off'` outside cities.

---

## Character Customizations

All 4 characters share customized `sets.weapons`, WS tweaks (`Rudra's Storm` / `Mandalic Stab` / `Shark Bite` / `Savage Blade` / `Aeolian Edge` without `Nyame` or `Pill. Armlets +3` in TA/SATA), empty `sets.buff['Trick Attack'] = {}`, `Suppanomimi` in `sets.engaged`, `Mummu Jacket +1/+2` in `Acc`/`FullAcc`, `Moonbeam Ring` in `PDT`/`DT`, and a **custom `check_trust()` override** (removing `autows_list` at the bottom of the file).

### `Gimlic` (`Gimlic_Thf_Gear.lua` — Custom, ~167 diff)
- **AutoWS / Keybinds:** `autows = "Savage Blade"`, `rangedautows = "Last Stand"`, `autofood = 'Soy Ramen'`. Rebinds `^g` (Default weapons + Match WS) and `!g` (`MagicWeapons`) instead of `^r` / `!r`.
- **Weapons:** Adds `Taming` (`Taming Sari` / `Thief's Knife`); uses `Blurred Knife +1` as default off-hand for `Aeneas`/`Savage`/`Evisceration`/`SwordThrowing`; `Throwing` uses `Taming Sari` + `Thief's Knife` + `Albin Bane`; adds `AccAeneas` (`Aeneas`/`Tauret`), `AccSavage` (`Naegling`/`Tauret`), and `MagicWeapons` (`Malevolence` x2).
- **Gear Highlights:**
  - `sets.TreasureHunter`: `{head="White Rarab Cap +1", hands="Plunderer's Armlets", waist="Chaac Belt", feet="Skulk. Poulaines +1"}` (NQ Plunderer's + White Rarab Cap +1).
  - `sets.engaged`: Unique **`Gleti's` full 5-piece set** (`Gleti's Mask`, `Cuirass`, `Gauntlets`, `Breeches`, `Boots`, `Focal Orb`, `Loricate Torque +1`, `Defending Ring`, `Suppanomimi`, `Brutal Earring`).
  - `JA` tweaks: `Hide` uses `Pillager's Vest +1`; `Steal` adds `Pill. Armlets +1`; `Perfect Dodge` uses NQ `Plunderer's Armlets`.
  - `Acc`/`FullAcc` engaged use `Mummu Jacket +1`; `Evisceration.FullAcc` uses `Mummu Jacket +1`.
- **Trusts / Lockstyle / Macros:**
  - `set_lockstyle()` runs `/lockstyleset 2` (notes: `regular 2, stanta 7, swimsuit 8, halloween 10`) AND reloads `Skillchains` (`lua reload SKillchains`).
  - `check_trust()` summons `AAEV`, `Cherukiki` (with `Apururu (UC)` and `Monberaux` commented out), `Koru-Moru`, `Qultada`, `Ulmia`.
  - Macro Book `2` (`DNC`/default: p10, `WAR`: p9, `NIN`: p8).

### `Voicelessbicep` (`Voicelessbicep_Thf_Gear.lua` — Custom, ~147 diff)
- **AutoWS / Keybinds:** `autows = "Shark Bite"`, `rangedautows = "Last Stand"`, `autofood = 'Soy Ramen'`. Keeps `^r` / `!r` weapon binds.
- **Weapons & Gear Highlights:**
  - Keeps `Taming` weapon set, but `sets.weapons.Throwing` uses `Aeneas` + `Blurred Knife +1` + `Raider's Bmrng.` (same as `Balullu`).
  - `sets.TreasureHunter` matches `Gimlic` (`White Rarab Cap +1` + NQ `Plunderer's Armlets`).
  - `sets.engaged`: Uses **NQ `Mummu` 5-piece** (`Mummu Bonnet`, `Jacket`, `Wrists`, `Kecks`, `Gamashes`, `Focal Orb`, `Defending Ring`, `Vocane Ring`); `Acc`/`FullAcc` and `Evisceration.FullAcc` use `Mummu Jacket +2`.
- **Trusts / Lockstyle / Macros:**
  - No `set_lockstyle()` override.
  - `check_trust()` summons `AAEV`, `Apururu (UC)`, `Koru-Moru`, `Qultada`, `Ulmia`.
  - Macro Book `2` (`DNC`/default: p10, `WAR`: p9, `NIN`: p8).

### `Balullu` & `Friendlessvirus` (`Balullu_Thf_Gear.lua`, `Friendlessvirus_Thf_Gear.lua` — Identical Custom, ~126 diff)
- **AutoWS / Weapons:** No `autows` override (inherits `Rudra's Storm` from `THF.lua`). Omits `Taming` from `state.Weapons`; keeps `Aeneas`, `AccAeneas`, `Savage`, `AccSavage`, `ProcWeapons`, `MagicWeapons`, `Evisceration`, `Throwing`, `SwordThrowing`, `Bow`.
- **Gear Highlights:**
  - `sets.TreasureHunter` keeps `Plunderer's Armlets +1` + `Chaac Belt` + `Skulk. Poulaines +1` (no `White Rarab Cap +1`); `Perfect Dodge` uses `Plunderer's Armlets +1`.
  - `sets.engaged` uses standard DD TP gear (`Dampening Tam`, `Adhemar Jacket +1`, `Adhemar Wrist. +1`, `Samnuha Tights`, `gear.herculean_ta_feet`, `Aurgelmir Orb +1`, `Suppanomimi`, `Sherida Earring`).
- **Trusts / Macros:** Same `check_trust()` as `Voicelessbicep` (`AAEV`, `Apururu (UC)`, `Koru-Moru`, `Qultada`, `Ulmia`). Macro Book `5` (`DNC`: p8, `WAR`: p7, `NIN`: p10, default: p6).

---

## Related Notes

- [FFXI GearSwap and Character Profiles](./README.md)
- `FFXI Windower Overview`
- `FFXI Windower Addons Catalog`
- [FFXI Addon — GearSwap](./GearSwap-Engine.md)
- `FFXI Addon — thtracker`
