# FFXI GearSwap — WAR (Warrior)

> [!NOTE]
> **Quick Reference**
> - **Logic File:** `C:\Windower\addons\GearSwap\data\WAR.lua` (`309` lines)
> - **Character Status:** `Voicelessbicep`, `Balullu`, `Friendlessvirus` **CUSTOM** (all 3 identical, ~20 diff vs Selindrile) | `Gimlic` **STOCK**
> - **Default AutoWS / Food (`WAR.lua`):** `autows = "Ukko's Fury"` | `autofood = 'Soy Ramen'`
> - **Weapon Profiles:** `Chango`, `DualWeapons` (`Firangi`/`Reikiko`), `Greatsword` (`Montante +1`), plus Abyssea/VW `Proc*` weapons

Code and gear reference for `WAR.lua` stance/buff/WS automation and shared character defensive tweaks.

---

## Job-Specific Modes & Keybinds

### Job States (`WAR.lua` & `user_job_setup`)
- **Job-level states (`WAR.lua`):**
  - `state.Stance`: `'Hasso'`, `'Seigan'`, `'None'` (maintained on `/SAM` with two-handed weapons; auto-reset to `'None'` if subjob is not `SAM`).
  - Tracks `Brazen Rush`, `Warrior's Charge`, `Mighty Strikes`, `Retaliation`, `Restraint`, `Aftermath`, `Aftermath: Lv.3`, `Hasso`, `Seigan` in `state.Buff`.
- **HUD Init (`init_job_states`):**
  - Left: `Capacity`, `AutoRuneMode`, `AutoTrustMode`, `AutoWSMode`, `AutoShadowMode`, `AutoFoodMode`, `AutoStunMode`, `AutoDefenseMode`.
  - Right: `AutoBuffMode`, `AutoSambaMode`, `Weapons`, `OffenseMode`, `WeaponskillMode`, `Stance`, `IdleMode`, `Passive`, `RuneElement`, `TreasureMode`.
- **Mode Options (all 4 characters):**
  - `state.OffenseMode`: `'Normal'`, `'SomeAcc'`, `'Acc'`, `'FullAcc'`, `'Fodder'`
  - `state.WeaponskillMode`: `'Match'`, `'Normal'`, `'SomeAcc'`, `'Acc'`, `'FullAcc'`, `'Fodder'`
  - `state.HybridMode`: `'Normal'`
  - `state.PhysicalDefenseMode`: `'PDT'`, `'PDTReraise'`
  - `state.MagicalDefenseMode`: `'MDT'`, `'MDTReraise'`
  - `state.ResistDefenseMode`: `'MEVA'`
  - `state.IdleMode`: `'Normal'`, `'PDT'`, `'Refresh'`, `'Reraise'`
  - `state.Passive`: `'None'`, `'Twilight'`
  - `state.Weapons`: `'Chango'`, `'DualWeapons'`, `'Greatsword'`, `'ProcDagger'`, `'ProcSword'`, `'ProcGreatSword'`, `'ProcScythe'`, `'ProcPolearm'`, `'ProcGreatKatana'`, `'ProcClub'`, `'ProcStaff'`

### Local Keybinds (`user_job_setup()`)
| Keybind | Action | Purpose |
| :--- | :--- | :--- |
| `Ctrl+~` (`^`` `) | `/ja "Hasso" <me>` | Activate `/SAM` Hasso |
| `Alt+~` (`!`` `) | `/ja "Seigan" <me>` | Activate `/SAM` Seigan |
| `Win+~` (`@`` `) | `gs c cycle SkillchainMode` | Cycle Skillchain mode |
| `Alt+R` | `gs c weapons Greatsword;gs c update` | Swap to `Greatsword` (`Montante +1`) set |

---

## Job-Specific Commands (`//gs c ...`)

- `WAR.lua` does not define custom `job_self_command` subcommands; all state toggling/cycling uses Selindrile's global commands (`//gs c cycle Stance`, `//gs c weapons ...`, `//gs c toggle AutoBuffMode`, `//gs c toggle AutoWSMode`).

---

## Job Logic Highlights (`WAR.lua`)

- **`job_filtered_action`**: When a **Great Sword** (`available_ws:contains(48)`, Resolution) is equipped, automatically remaps Great Axe WSs:
  - `Upheaval` → `Resolution`
  - `Ukko's Fury` → `Ground Strike`
- **`job_precast`**: When `AutoBuffMode ~= 'Off'` and firing a WeaponSkill, cancels the WS, triggers a buff JA, and re-schedules the WS `1s` later in priority order:
  1. `Warcry` if `player.tp < 2250` and `Blood Rage` is not active
  2. `/SAM` `Sekkanoki` if `player.tp > 1850`
  3. `/SAM` `Meditate` if off cooldown
- **`job_customize_melee_set`**: Overlays `sets.buff.Retaliation` and `sets.buff.Restraint` when active in `HybridMode == 'Normal'` and non-`Acc` OffenseModes.
- **`job_post_precast`**:
  - Replaces `Moonshade Earring` at `> 3200` effective TP (`AccMaxTP` / `MaxTP`) with daytime `Lugra Earring` swaps (`AccDayMaxTPWSEars`, `DayMaxTPWSEars`, `AccDayWSEars`, `DayWSEars`).
  - Overlays `Charge` / `Mighty Strikes` WS variants (`ACCWSMightyCharge`, `ACCWSCharge`, `ACCWSMighty` / `WSMightyCharge`, `WSCharge`, `WSMighty`) when `Warrior's Charge`/`Brazen Rush` or `Mighty Strikes` are active.
- **`job_aftercast` & `job_buff_change`**: Tracks `lastwarcry = player.name` when the player casts `Warcry` (so `WAR.lua`/libs know if your own Warcry TP Bonus is active).
- **`update_melee_groups`**: Appends `'Adoulin'` (`Ionis`), `'Charge'` (`Brazen Rush`/`Warrior's Charge`), `'Mighty'` (`Mighty Strikes`), and `'AM'` (`Conqueror` AM3 or `Bravura`/`Ragnarok` Aftermath).
- **`job_tick()` Automation**:
  1. `check_hasso()` — Maintains `Hasso`/`Seigan` when engaged on `/SAM` with a two-handed weapon.
  2. `check_buff()` — In combat with `AutoBuffMode ~= 'Off'`, maintains `Retaliation` → `Restraint` → `Blood Rage` → `Berserk` → `Aggressor`.

---

## Character Customizations

- **`Gimlic`:** **STOCK** (`Gimlic_War_Gear.lua` matches `Selindrile_War_Gear.lua`).
- **`Voicelessbicep`, `Balullu`, `Friendlessvirus` (`Voicelessbicep_War_Gear.lua`, `Balullu_War_Gear.lua`, `Friendlessvirus_War_Gear.lua` — Identical Custom, ~20 diff):**
  - **Gear Overrides vs Stock:**
    - `sets.idle` & `sets.defense.PDT` / `MDT` / `MEVA`: Replaces `head="Nyame Helm"` with `head="Genmei Kabuto"`, and replaces `ring1="Gelatinous Ring +1"` in `PDT`/`MDT`/`MEVA` with `ring1="Moonbeam Ring"`.
  - **Macro Book / Lockstyle Overrides:**
    - Removes the explicit `player.sub_job == 'NIN'` branch in `select_default_macro_book()` (falls back to Book `3`, page `5`; `SAM`: p3, `DNC`: p4, `THF`: p1).
    - Removes `user_job_lockstyle()` (`/lockstyleset 017` in stock).

---

## Related Notes

- [FFXI GearSwap and Character Profiles](./README.md)
- `FFXI Windower Overview`
- `FFXI Windower Addons Catalog`
- [FFXI Addon — GearSwap](./GearSwap-Engine.md)
