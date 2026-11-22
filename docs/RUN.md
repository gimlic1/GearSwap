# FFXI GearSwap — RUN (Rune Fencer)

> [!NOTE]
> **Quick Reference**
> - **Logic File:** `C:\Windower\addons\GearSwap\data\RUN.lua` (`540` lines)
> - **Character Status:** `Balullu` & `Friendlessvirus` **CUSTOM** (identical, ~212 diff) | `Voicelessbicep` **STOCK** | `Gimlic` **NONE**
> - **Default AutoWS / Food (`RUN.lua`):** `autows = 'Resolution'` | `autofood = 'Miso Ramen'`
> - **Custom Weapon Profiles (`Balullu` / `Friendlessvirus`):** `None`, `Aettir`, `Lionheart`, `DualWeapons` (`Firangi` / `Reikiko`)

Code and gear reference for `RUN.lua` rune/tanking automation and `Balullu`/`Friendlessvirus` custom defensive/hybrid builds.

---

## Job-Specific Modes & Keybinds

### Job States (`RUN.lua` & `user_job_setup`)
- **Job-level states (`RUN.lua`):**
  - `state.Stance`: `'Hasso'`, `'Seigan'`, `'None'` (auto-maintained on `/SAM` with Great Sword).
  - `state.Steps`: `'Quickstep'`, `'Box Step'`, `'Stutter Step'` (used in `/DNC` `SubJobEnmity`).
- **HUD Init (`init_job_states`):**
  - Left: `Capacity`, `AutoRuneMode`, `AutoTrustMode`, `AutoTankMode`, `AutoWSMode`, `AutoShadowMode`, `AutoFoodMode`, `AutoNukeMode`, `AutoStunMode`, `AutoDefenseMode`.
  - Right: `AutoBuffMode`, `AutoSambaMode`, `Weapons`, `OffenseMode`, `WeaponskillMode`, `Stance`, `IdleMode`, `Passive`, `RuneElement`, `PhysicalDefenseMode`, `MagicalDefenseMode`, `ResistDefenseMode`, `TreasureMode`.
- **Custom Mode Options (`Balullu` / `Friendlessvirus` vs Stock):**
  - `state.OffenseMode`: `'Normal'`, `'SomeAcc'`, `'Acc'`, `'HighAcc'`, `'FullAcc'` *(stock: `'Normal'`, `'Acc'`, `'FullAcc'`)*
  - `state.HybridMode`: `'Normal'`, `'DTLite'`, `'Tank'` *(stock: `'Tank'`, `'Tank_HP'`, `'Normal'`, `'DTLite'`)*
  - `state.WeaponskillMode`: `'Match'`, `'Normal'`, `'SomeAcc'`, `'Acc'`, `'HighAcc'`, `'FullAcc'`
  - `state.CastingMode`: `'Normal'`, `'SIRD'` *(default flipped to `'Normal'` first)*
  - `state.MagicalDefenseMode`: `'MDT_HP'`, `'BDT_HP'`, `'MDT'`, `'BDT'` *(stock: `'MDT_HP'`, `'MDT'`)*
  - `state.ResistDefenseMode`: `'MEVA_HP'`, `'MEVA'`, `'Death'`, `'Charm'`, `'DTCharm'` *(stock: `'MEVA'`, `'MEVA_HP'`)*
  - `state.IdleMode`: `'Normal'`, `'Tank'`, `'KiteTank'`, `'Sphere'` *(stock: `'Tank'`, `'KiteTank'`)*
  - `state.Weapons`: `'None'`, `'Aettir'`, `'Lionheart'`, `'DualWeapons'`

### Local Keybinds (`user_job_setup()`)
| Keybind | Action | Purpose |
| :--- | :--- | :--- |
| `Alt+~` (`!`` `) | `gs c SubJobEnmity` | Trigger subjob enmity rotation |
| `Win+~` (`@`` `) | `gs c cycle RuneElement` | Cycle active rune (`Ignis`..`Tenebrae`) |
| `Ctrl+~` (`^`` `) | `gs c RuneElement` | Cast selected `RuneElement` (global handler) |
| `Win+Pause` | `gs c toggle AutoRuneMode` | Toggle automatic 3-rune upkeep |
| `Ctrl+Delete` | `/ja "Provoke" <stnpc>` | Subtarget Provoke |
| `Alt+Delete` | `/ma "Cure IV" <stal>` | Subtarget Cure IV |
| `Win+Delete` | `/ma "Flash" <stnpc>` | Subtarget Flash |
| `Ctrl+\` | `/ma "Protect IV" <t>` | Cast Protect IV |
| `Win+\` | `/ma "Shell V" <t>` | Cast Shell V |
| `Alt+\` | `/ma "Crusade" <me>` | Cast Crusade |
| `Ctrl+Backspace` | `/ja "Lunge" <t>` | Elemental Lunge burst |
| `Win+Backspace` | `/ja "Gambit" <t>` | Gambit elemental debuff |
| `Alt+Backspace` | `/ja "Rayke" <t>` | Rayke elemental resist down |
| `Win+F8` | `gs c toggle AutoTankMode` | Toggle `Crusade` → `Flash` → `Foil` → `SubJobEnmity` loop |
| `Win+F10` | `gs c toggle TankAutoDefense` | Lock tanking defense mode via `Sel-Stahp` |
| `Ctrl+Alt+Win+~` | `gs c cycle SkillchainMode` | Cycle Skillchain mode |
| `Alt+R` | `gs c weapons Lionheart;gs c update` | Swap to `Lionheart` DD weapon set |

---

## Job-Specific Commands (`//gs c ...`)

- **`//gs c subjobenmity`** — Targets `MONSTER` and runs subjob enmity actions:
  - `/BLU`: `Sheep Song` → `Soporific` → `Geist Wall` → `Stinking Gas` → `Jettatura` → `Blank Gaze` → `check_auto_tank_ws()`.
  - `/DRK`: Cancels `Souleater`/`Last Resort` when tanking (`HybridMode ~= 'Normal'` or `DefenseMode ~= 'None'`); cycles `Stun` → `Souleater` → `Last Resort` → `Weapon Bash` → `Arcane Circle` → `check_auto_tank_ws()`.
  - `/WAR`: Cancels `Berserk` when tanking; cycles `Provoke` → `Warcry` → `Defender` → `Aggressor` → `Berserk` → `check_auto_tank_ws()`.
  - `/DNC`: Cycles `state.Steps` (`Quickstep`/`Box Step`/`Stutter Step`) under 3 FMs, `Animated Flourish` at 3+, or steps up to 5 FMs.

---

## Job Logic Highlights (`RUN.lua`)

- **`job_filter_precast`**: If `Valiance` is on cooldown and `Vallation` is ready (and `Valiance` isn't already active), automatically falls back to `/ja "Vallation" <me>`.
- **`job_precast`**:
  - Equips `sets.precast.JA['Vivacious Pulse'][state.RuneElement.value]` when using `Vivacious Pulse`.
  - When `AutoBuffMode ~= 'Off'` on `/SAM` before a WS, auto-fires `Sekkanoki` (at `TP > 1850`) or `Meditate` `1s` before executing the WS.
- **`job_post_precast`**:
  - Swaps `Moonshade Earring` above `3200` effective TP (`AccMaxTP` / `MaxTP`).
  - On `Lunge` / `Swipe`, equips `Hachirin-no-Obi` if `weather_rune_match()` is true and applies `sets.element[spell.element]`.
- **`job_post_midcast`**: Overlays `sets.buff.Embolden` on Enhancing Magic when `Embolden` is active.
- **`job_customize_melee_set` & `job_customize_defense_set`**:
  - Overlays `sets.buff.Battuta` while `Battuta` is active (on melee sets, and on `Physical` defense sets while engaged).
  - Defense sets also overlay `sets[state.ExtraDefenseMode.value]`.
- **`job_customize_idle_set`**: Applies `sets.latent_refresh` and `sets.latent_refresh_grip` (for Great Sword / Staff when `Weapons == 'None'` or `UnlockWeapons`) at `mpp < 51`.
- **`update_melee_groups`**: Appends `'AM'` when wielding `Epeolatry` with `Aftermath: Lv.3`.
- **`job_tick()` Automation**:
  1. `check_hasso()` — Maintains `Hasso`/`Seigan` on `/SAM` with two-handed weapons.
  2. `check_buff()` — Maintains `buff_spell_lists[state.AutoBuffMode]` (`Auto`: `Crusade` Combat, `Temper` Engaged, `Phalanx` Always, `Refresh` Idle) plus in-combat `Swordplay` and `/DRK` `Last Resort` or `/WAR` `Berserk`/`Aggressor`.
  3. `check_buffup()` — Presets `Default`, `Tank`, `Full`, `Melee`.
  4. `AutoTankMode` loop — `check_flash_foil()` (`Crusade` → `Flash` → `Foil`) then `gs c SubJobEnmity` every `1.5s`.

---

## Character Customizations

- **`Gimlic`:** **NONE** (`Gimlic_Run_Gear.lua` does not exist).
- **`Voicelessbicep`:** **STOCK** (`Voicelessbicep_Run_Gear.lua` matches `Selindrile_Run_Gear.lua`).
- **`Balullu` & `Friendlessvirus` (`Balullu_Run_Gear.lua`, `Friendlessvirus_Run_Gear.lua` — Identical Custom, ~212 diff):**
  - **Weapons:** `Aettir` (`Aettir`/`Utu Grip`), `Lionheart` (`Lionheart`/`Utu Grip`), `DualWeapons` (`Firangi`/`Reikiko`).
  - **Custom Capes (`Ogma's cape`):** `enmity_jse_back` (`HP+60, Eva/MEva+20, MEva+10, Enmity+10, DT-5%`), `stp_jse_back` (`DEX+20, Acc/Atk+20, STP+10`), `da_jse_back` (`STR+20, Acc/Atk+20, DA+10`).
  - **Key Gear Overrides (pre-Nyame / Empyrean+1 / Relic+1 era):**
    - Adds `sets.Enmity.SIRDT` (`Fu. Bandeau +1`, `Runeist's Coat +3`, `Carmine Cuisses +1`, `Erilaz Greaves +1`, `Audumbla Sash`); replaces `Nyame` pieces in `Enmity`, `Tank`, `Idle`, `PDT`, `MDT`, `BDT`, `MEVA`, `Death`, and `Charm` sets with `Fu. Bandeau +1`, `Erilaz Galea +1`, `Futhark Coat +1`, `Runeist's Coat +3`, `Erilaz Gauntlets +1`, `Eri. Leg Guards +1`, `Rune. Trousers +3`, `Erilaz Greaves +1`, `Meghanada Visor +2`, and `gear.herculean_dt_*`.
    - `sets.idle`: Uses `gear.herculean_refresh_hands` instead of `Regal Gauntlets`; adds `sets.idle.Weak`.
    - `sets.midcast['Enhancing Magic']`: Uses `Runeist's Mitons +3`; `sets.midcast['Blue Magic'].DT` points to `sets.Enmity.SIRDT`.
    - `sets.engaged.*`: Adds `SomeAcc` and `HighAcc` tiers across `Normal` and `DTLite`, plus `SomeAcc.Tank` and `HighAcc.Tank`; replaces `Aurgelmir Orb +1` with `Yamarang` / `C. Palug Stone`.
  - **Macro Book / Lockstyle:** Book `19` (`DNC`: p4, `RDM`/`SCH`/default: p5, `BLU`: p6, `WAR`: p7, `SAM`: p8, `DRK`: p9, `NIN`: p10). `user_job_lockstyle()` sets `/lockstyleset 034` when `Lionheart` is selected, else `/lockstyleset 033`.

---

## Related Notes

- [FFXI GearSwap and Character Profiles](./README.md)
- `FFXI Windower Overview`
- `FFXI Windower Addons Catalog`
- [FFXI Addon — GearSwap](./GearSwap-Engine.md)
