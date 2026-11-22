# FFXI GearSwap — SAM (Samurai)

> [!NOTE]
> **Quick Reference**
> - **Logic File:** `C:\Windower\addons\GearSwap\data\SAM.lua` (`328` lines)
> - **Character Status:** `Balullu` & `Friendlessvirus` **CUSTOM** (identical, ~122 diff) | `Voicelessbicep` **STOCK** | `Gimlic` **NONE**
> - **Default AutoWS / Food (`SAM.lua`):** `autows = 'Tachi: Fudo'` | `rangedautows = 'Apex Arrow'` | `autofood = 'Soy Ramen'`
> - **Custom Weapon Profiles (`Balullu` / `Friendlessvirus`):** `Dojikiri` (`Dojikiri Yasutsuna`), `ProcWeapon` (`Norifusa +1`), `Bow` (`Norifusa +1` + `Cibitshavore`)

Code and gear reference for `SAM.lua` stance/WS automation and `Balullu`/`Friendlessvirus` Reraise & pre-Nyame defensive builds.

---

## Job-Specific Modes & Keybinds

### Job States (`SAM.lua` & `user_job_setup`)
- **Job-level states (`SAM.lua`):**
  - `state.Stance`: `'Hasso'`, `'Seigan'`, `'None'`
- **HUD Init (`init_job_states`):**
  - Left: `Capacity`, `AutoRuneMode`, `AutoTrustMode`, `AutoWSMode`, `AutoShadowMode`, `AutoFoodMode`, `AutoStunMode`, `AutoDefenseMode`.
  - Right: `AutoBuffMode`, `AutoSambaMode`, `Weapons`, `OffenseMode`, `WeaponskillMode`, `Stance`, `IdleMode`, `Passive`, `RuneElement`, `TreasureMode`.
- **Custom Mode Options (`Balullu` / `Friendlessvirus` vs Stock):**
  - `state.HybridMode`: `'Normal'`, `'DTLite'`, `'PDT'`, `'Reraise'` *(adds `'Reraise'`)*
  - `state.PhysicalDefenseMode`: `'PDT'`, `'PDTReraise'` *(adds `'PDTReraise'`)*
  - `state.MagicalDefenseMode`: `'MDT'`, `'MDTReraise'` *(adds `'MDTReraise'`)*
  - `state.IdleMode`: `'Normal'`, `'Reraise'` *(adds `'Reraise'`)*
  - `state.Weapons`: `'Dojikiri'`, `'ProcWeapon'`, `'Bow'`

### Local Keybinds (`user_job_setup()`)
| Keybind | Action | Purpose |
| :--- | :--- | :--- |
| `Ctrl+~` (`^`` `) | `/ja "Hasso" <me>` | Activate Hasso |
| `Alt+~` (`!`` `) | `/ja "Seigan" <me>` | Activate Seigan |
| `Alt+Backspace` | `/ja "Third Eye" <me>` | Activate Third Eye |
| `Win+~` (`@`` `) | `gs c cycle SkillchainMode` | Cycle Skillchain mode |
| `Ctrl+Alt+Win+~` (`!@^`` `) | `gs c cycle Stance` | Cycle auto-stance (`Hasso` / `Seigan` / `None`) |
| `Alt+R` | `set skipprocweapons false; weapons ProcWeapon; set WeaponskillMode Proc; update` | Swap to Proc weapon/WS mode |
| `Ctrl+R` | `set skipprocweapons true; weapons Default; set WeaponskillMode Normal; update` | Restore default weapon/WS mode |
| `Ctrl+Q` | `weapons Bow; update` | Swap to Bow weapon set |

---

## Job-Specific Commands (`//gs c ...`)

- `SAM.lua` defines an empty `job_self_command`; all cycling/toggling uses Selindrile's global commands (`//gs c cycle Stance`, `//gs c weapons ...`, `//gs c toggle AutoBuffMode`, `//gs c toggle AutoWSMode`).

---

## Job Logic Highlights (`SAM.lua`)

- **`job_filtered_action`**: When a **Polearm** (`available_ws:contains(112)`, Double Thrust) is equipped, automatically remaps Great Katana WSs:
  - `Tachi: Fudo` → `Stardiver`
  - `Tachi: Shoha` → `Impulse Drive`
  - `Tachi: Rana` → `Penta Thrust`
  - `Tachi: Gekko` → `Sonic Thrust`
  - `Tachi: Hobaku` → `Leg Sweep`
- **`job_precast`**: When `AutoBuffMode ~= 'Off'` and using any WeaponSkill, cancels the WS, fires a TP/WS JA, and re-schedules the WS `1s` later in priority order:
  1. `Sekkanoki` if `player.tp > 1850`
  2. `Meditate` if off cooldown
  3. `Hagakure` if `player.tp < 1500` and not `Sekkanoki`
- **`job_post_precast`**:
  - Replaces `Moonshade Earring` at `> 3200` effective TP (`RangedAccMaxTP` / `RangedMaxTP` for Archery, else `AccMaxTP` / `MaxTP` with daytime `Lugra Earring` `AccDayMaxTPWSEars`/`DayMaxTPWSEars`/`AccDayWSEars`/`DayWSEars` support).
  - Overlays `sets.buff.Sekkanoki` and `sets.buff.Sengikori` when active.
- **`job_customize_melee_set`**: Overlays `sets.buff.Hasso` (when `Hasso` active, `DefenseMode == 'None'`, `OffenseMode ~= 'FullAcc'`) or `sets.buff['Third Eye']` (when `Seigan` + `Third Eye` active and not in `Acc` modes).
- **`job_post_midcast`**: Locks `sets.Reraise` when `HybridMode == 'Reraise'`, `PhysicalDefenseMode == 'PDTReraise'`, or `MagicalDefenseMode == 'MDTReraise'`.
- **`job_aftercast` & `job_buff_change`**:
  - Auto-cancels `Meikyo Shisui` after a WS if `player.tp < 750`.
  - Equips and locks (`disable('feet')`) `sets.buff['Meikyo Shisui']` on activation, re-enabling `feet` when `Meikyo Shisui` wears.
- **`update_melee_groups`**: Appends `'Adoulin'` (in Adoulin with `Ionis`) and `'AM'` (wielding `Kogarasumaru` with `Aftermath: Lv.3`).
- **`job_tick()`**:
  - `check_hasso()` — Maintains `Hasso` or `Seigan` when engaged with a two-handed weapon and not amnesic.
  - `check_buff()` — In combat with `AutoBuffMode ~= 'Off'`, maintains `/DRK` `Last Resort` or `/WAR` `Berserk` / `Aggressor`.

---

## Character Customizations

- **`Gimlic`:** **NONE** (`Gimlic_Sam_Gear.lua` does not exist).
- **`Voicelessbicep`:** **STOCK** (`Voicelessbicep_Sam_Gear.lua` matches `Selindrile_Sam_Gear.lua`).
- **`Balullu` & `Friendlessvirus` (`Balullu_Sam_Gear.lua`, `Friendlessvirus_Sam_Gear.lua` — Identical Custom, ~122 diff):**
  - **Weapons:** `Dojikiri` (`Dojikiri Yasutsuna` / `Utu Grip`), `ProcWeapon` (`Norifusa +1` / `Bloodrain Strap`), `Bow` (`Norifusa +1` / `Utu Grip` + `Cibitshavore` / `Eminent Arrow`).
  - **Capes (`Smertrios's Mantle`):** `ws_jse_back` (`STR+20, Acc/Atk+20, WSD+10%`), `stp_jse_back` (`DEX+20, Acc/Atk+20, Acc+10, STP+10`).
  - **Key Gear Overrides:**
    - Adds `Reraise` mode variants across Idle (`sets.idle.Reraise`, `sets.idle.Weak.Reraise`), Defense (`PDTReraise`, `MDTReraise`), and Engaged (`sets.engaged.*.Reraise`).
    - Replaces `Nyame` / `Sacro Breastplate` / `Wakido Kabuto +3` pieces with `Loess Barbuta +1`, `Tartarus Platemail`, `Amm Greaves`, `Hiza. Haramaki +2`, `Flamma Dirs +2`, `Ynglinga Sallet`, and `Flam. Zucchetto +2` across Idle, Resting, Defense, PDT, and DTLite sets.
    - `sets.precast.Step`: Uses `Tartarus Platemail` and `Founder's Greaves`; `sets.midcast.RA` uses `Buquwik Cape` + `Flax Sash` (instead of `stp_jse_back` + `Carrier's Sash`).
  - **Macro Book:** Book `1` (`WAR`/default: p1, `THF`: p2, `DNC`: p3, `NIN`: p10).

---

## Related Notes

- [FFXI GearSwap and Character Profiles](./README.md)
- `FFXI Windower Overview`
- `FFXI Windower Addons Catalog`
- [FFXI Addon — GearSwap](./GearSwap-Engine.md)
