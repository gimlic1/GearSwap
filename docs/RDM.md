# FFXI GearSwap — RDM (Red Mage)

> [!NOTE]
> **Quick Reference**
> - **Logic File:** `C:\Windower\addons\GearSwap\data\RDM.lua` (`715` lines)
> - **Character Status:** `Voicelessbicep`, `Balullu`, `Friendlessvirus` **CUSTOM** (all 3 identical, ~92 diff vs Selindrile) | `Gimlic` **NONE**
> - **Default AutoWS / Food (`RDM.lua`):** `autows = "Savage Blade"` | `autofood = 'Pear Crepe'`
> - **Custom Weapon Options:** Added `Sequence`, `Almace`, `DualBlackHalo`, `BowMacc`; removed `EnspellDW` from `state.Weapons`

Code and gear reference for `RDM.lua` hybrid melee/nuking/enfeebling/enhancing automation and shared character overrides.

---

## Job-Specific Modes & Keybinds

### Job States (`RDM.lua` & `user_job_setup`)
- **Job-level states (`RDM.lua`):**
  - `state.RecoverMode`: `'35%'`, `'60%'`, `'Always'`, `'Never'` (equips `RecoverMP` / `RecoverBurst` when MP% drops below threshold during Elemental nuking).
- **HUD Init (`init_job_states`):**
  - Left: `Capacity`, `AutoRuneMode`, `AutoTrustMode`, `AutoNukeMode`, `AutoWSMode`, `AutoShadowMode`, `AutoFoodMode`, `AutoStunMode`, `AutoDefenseMode`.
  - Right: `AutoBuffMode`, `AutoSambaMode`, `Weapons`, `OffenseMode`, `WeaponskillMode`, `IdleMode`, `Passive`, `RuneElement`, `RecoverMode`, `ElementalMode`, `CastingMode`, `TreasureMode`.
- **Custom Mode Options (`Voicelessbicep` / `Balullu` / `Friendlessvirus`):**
  - `state.OffenseMode`: `'Normal'`, `'Acc'`, `'FullAcc'`
  - `state.HybridMode`: `'Normal'`, `'DT'`
  - `state.WeaponskillMode`: `'Match'`, `'Proc'`
  - `state.AutoBuffMode`: `'Off'`, `'Auto'`, `'AutoMelee'`
  - `state.CastingMode`: `'Normal'`, `'Resistant'`, `'Fodder'`, `'Proc'`
  - `state.IdleMode`: `'Normal'`, `'PDT'`, `'MDT'`, `'DTHippo'`
  - `state.PhysicalDefenseMode`: `'PDT'`, `'NukeLock'`
  - `state.Weapons`: `'None'`, `'Naegling'`, `'Sequence'`, `'DualWeapons'`, `'DualWeaponsAcc'`, `'DualEvisceration'`, `'DualClubs'`, `'DualAeolian'`, `'DualProcDaggers'`, `'EnspellOnly'`

### Local Keybinds (`user_job_setup()`)
| Keybind | Action | Purpose |
| :--- | :--- | :--- |
| `Ctrl+~` (`^`` `) | `gs c cycle ElementalMode` | Cycle active element for `//gs c elemental ...` |
| `Win+~` (`@`` `) | `gs c cycle MagicBurstMode` | Cycle Magic Burst (`Off`, `Single`, `Lock`) |
| `Ctrl+Alt+Win+~` | `/ja "Accession" <me>` | `/SCH` AoE white magic stratagem |
| `Ctrl+Backspace` | `/ja "Saboteur" <me>` | Enfeebling potency/duration boost |
| `Alt+Backspace` | `/ja "Spontaneity" <t>` | Instant-cast next spell |
| `Win+Backspace` | `/ja "Composure" <me>` | Enhancing duration + self-buff extension |
| `Win+F8` | `gs c toggle AutoNukeMode` | Toggle auto-nuking |
| `Alt+=` | `/ja "Penury" <me>` | `/SCH` white magic MP cost reduction |
| `Win+=` | `/ja "Parsimony" <me>` | `/SCH` black magic MP cost reduction |
| `Ctrl+Delete` | `/ja "Dark Arts" <me>` | `/SCH` Dark Arts |
| `Alt+Delete` | `/ja "Addendum: Black" <me>` | `/SCH` Addendum: Black |
| `Win+Delete` | `/ja "Manifestation" <me>` | `/SCH` AoE black magic stratagem |
| `Ctrl+\` | `/ma "Protect V" <t>` | Cast Protect V |
| `Win+\` | `/ma "Shell V" <t>` | Cast Shell V |
| `Alt+\` | `/ma "Reraise" <me>` | Cast Reraise |
| `Win+F10` | `gs c cycle RecoverMode` | Cycle MP recovery nuke threshold |
| `Ctrl+R` | `set skipprocweapons true; reset weaponskillmode; weapons Default; set unlockweapons false` | Restore default weapon setup |
| `Ctrl+Q` | `set weapons enspellonly; set unlockweapons true` | Swap to 1-dmg Enspell weapon set |
| `Alt+R` | `set skipprocweapons true; reset weaponskillmode; set weapons none` | Unlock weapons |
| `Alt+Q` | `set skipprocweapons false; set weapons DualProcDaggers; set weaponskillmode proc` | Swap to Proc daggers |

---

## Job-Specific Commands (`//gs c ...`)

- **`//gs c elemental <subcommand> [target]`** (handled by `handle_elemental()`):
  - `nuke`: Picks `Banish II`→`Banish` (`Light`), `Comet` (`Dark`), or highest available tier (`V` with >99 JP spent, else `IV`→`I`) for `state.ElementalMode`.
  - `smallnuke`: Cycles `Tier II` → `Tier I`.
  - `tier1`..`tier6`: Direct cast of `state.ElementalMode` tier.
  - `ara` / `aga` / `ninjutsu` / `helix` / `enfeeble` / `bardsong`: Casts `-ra`, `-ga` (prefers `-ga II` for Wind/Earth/Water), Ninjutsu `: Ni`, Helix, Elemental Enfeeble, or Threnody.
  - `spikes` / `enspell`: Casts `<Element> Spikes` or `En<element>` (Tier I if `/NIN` or `/DNC`, Tier II otherwise).
  - `weather`: Casts `Phalanx` if subjob ~= `SCH`; otherwise casts `Klimaform` if matching storm is active, else casts the matching Storm.

---

## Job Logic Highlights (`RDM.lua`)

- **`job_precast`**:
  - Bypasses precast swapping (`eventArgs.handled = true`) when `Chainspell` is active.
  - Selects `gear.obi_cure_*`, `gear.obi_low_nuke_*`, or `gear.obi_high_nuke_*`.
  - Auto-upgrades `Phalanx` cast on a non-self target to `/ma "Phalanx II" <target>`.
  - Applies `classes.CustomClass = 'Proc'` when `CastingMode == 'Proc'`.
- **`job_post_midcast`**:
  - **Elemental:** Applies `sets.MagicBurst` / `sets.ResistantMagicBurst`, `Zodiac Ring` on matching day in `Fodder`, `sets.element[spell.element]`, and `RecoverMP` / `RecoverBurst` / `ResistantRecoverBurst` based on `state.RecoverMode`.
  - **Enfeebling:** With `Stymie` + `Resistant` mode, upgrades to `.Fodder` potency enfeebling set; overlays `sets.buff.Saboteur` when active.
  - **Enhancing:** Equips base `Enhancing Magic`, overlays `sets.buff.ComposureOther` on other players when `Composure` is active, then applies `sets.Self_Phalanx` (self `Phalanx II`) or spell/map set, plus `.DW` variant when dual-wielding with unlocked/None weapons.
- **`job_customize_melee_set`**: When `state.Weapons.value:contains('Enspell')` and an `enspell` is tracked, overlays `sets.element.enspell[element]` and dynamically selects `Obi of <element>`, `Hachirin-no-Obi`, or `Orpheus's Sash` based on weather/day intensity vs. `15` baseline (`>= 5` threshold).
- **`job_aftercast` & `update_melee_groups`**:
  - Creates `60s`/`90s` Timers for `Sleep`/`Sleepga`/`Sleep II` if `UseCustomTimers` is enabled; resets `Single` MagicBurstMode; tracks active Enspell and appends `'Enspell'`/`'Enspell2'` and `'AM'` (when wielding `Murgleis` with `Aftermath: Lv.3`).
- **`job_tick()`**:
  - `check_arts()`: Maintains `Composure` and `/SCH` `Light Arts` when `AutoArts` (combat) or `AutoBuffMode` is active.
  - `check_buff()`: `Auto` list (`Refresh III`, `Haste II`, `Aurorastorm` idle, `Reraise`) and `AutoMelee` list (`Haste II`, `Temper II` engaged).
  - `check_buffup()` presets: `Default`, `MageBuff`, `FullMeleeBuff`, `MeleeBuff`, `Odin`, `Tolba`, `HybridCleave`.

---

## Character Customizations

- **`Gimlic`:** **NONE** (`Gimlic_Rdm_Gear.lua` does not exist).
- **`Voicelessbicep`, `Balullu`, `Friendlessvirus`:** **IDENTICAL CUSTOM** (`~92` diff lines vs `Selindrile_Rdm_Gear.lua`).
  - **Weapons:** Adds `Sequence` (`Sequence`/`Ammurapi Shield`), `Almace` (`Almace`/`Ammurapi Shield`), `DualBlackHalo` (`Kaja Rod`/`Thibron`), and swaps `BowMacc` to `{range="Kaja Bow", ammo=empty}`. Overrides `DualClubs` to `{main="Nehushtan", sub="Nehushtan"}` (instead of `Maxentius`/`Thibron`) and removes `EnspellDW` from `state.Weapons`.
  - **Key Gear Overrides:**
    - `sets.idle`: `Bolelabunga` + `Sacro Bulwark` (instead of `Mpaca's Staff` + `Umbra Strap`); `sets.idle.PDT` uses `Terra's Staff` + `Oneiros Grip`.
    - `sets.MagicBurst`: Uses NQ `Ea Hat` / `Ea Houppelande` / `Ea Slops` (instead of `+1`).
    - `sets.midcast['Elemental Magic']` & WS (`Sanguine Blade`, `Seraph Blade`, `Aeolian Edge`, `Impact`, `Dark Magic`): Uses `gear.merlinic_nuke_head` / `gear.merlinic_nuke_feet` and `Dosis Tathlum` instead of `Bunzi's Hat` / `Amalric Nails +1` / `Ghastly Tathlum +1`.
    - `sets.midcast['Enfeebling Magic']`: Uses `Luminary Sash` (instead of `Obstin. Sash`); `.Resistant` adds `range="Kaja Bow"` (`ammo=empty`); adds `sets.midcast['Dia II']`, `sets.midcast['Dia III']`, `sets.midcast['Bio II']`, `sets.midcast['Bio III']`.
    - `sets.engaged.*DT`: Uses `Hagondes Cuffs +1` and `Hagondes Pants +1` instead of `Nyame Gauntlets` / `Malignance Tights`.
  - **Setup / Macro / Lockstyle:** Removed `autows_list` table at the bottom (uses `RDM.lua`'s default `Savage Blade`). Macro book `8` (`DNC`/`NIN`: p4, `BLM`: p2, default: p3). Dynamic `user_job_lockstyle()` selecting `/lockstyleset 021` or `022` by DW main/sub weapon skill, `030` (`/WHM`/Light Arts), `031` (`/BLM`/Dark Arts), or `032` default.

---

## Related Notes

- [FFXI GearSwap and Character Profiles](./README.md)
- `FFXI Windower Overview`
- `FFXI Windower Addons Catalog`
- [FFXI Addon — GearSwap](./GearSwap-Engine.md)
