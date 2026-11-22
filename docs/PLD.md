# FFXI GearSwap — PLD (Paladin)

> [!NOTE]
> **Quick Reference**
> - **Logic File:** `C:\Windower\addons\GearSwap\data\PLD.lua` (`599` lines)
> - **Character Status:** **HEAVILY CUSTOMIZED** across all 4 characters (`Gimlic`, `Voicelessbicep`, `Balullu`, `Friendlessvirus`)
> - **Default AutoWS / Food (`PLD.lua`):** `autows = 'Savage Blade'` | `autofood = 'Miso Ramen'`
> - **Primary Weapon Profiles:** `Gimlic` (`BurtgangAegis`, `TP`, `TP2`, `NaeglingAegis`); `Voicelessbicep` / `Balullu` / `Friendlessvirus` (`DeaconAegis`, `SequenceAegis`, `SequenceBlurred`)

Comprehensive code and gear reference for Selindrile's `PLD.lua` tanking automation and the heavily customized character gear profiles.

---

## Job-Specific Modes & Keybinds

### Job States (`PLD.lua` & `user_job_setup`)
- **Job-level toggles (`PLD.lua`):**
  - `state.AutoEmblem` (default `true`): Automatically fires `/ja "Divine Emblem" <me>` before `Flash` when off cooldown.
  - `state.AutoCover` (default `false`): Helper `check_cover(Protectee)` triggers `/ja Cover <player>` if HP < 85% and distance < 10.
  - `state.AutoMajesty` (default `true`): Automatically maintains `Majesty` while in combat.
  - `state.Stance`: `'Hasso'`, `'Seigan'`, `'None'` (used when `/SAM` with a two-handed weapon; auto-reset to `'None'` if subjob is not `SAM`).
  - `state.CurrentStep`: `'Box Step'`, `'Quickstep'` (cycles after each step when `/DNC`).
- **HUD Init (`init_job_states`):**
  - Left column: `Capacity`, `AutoRuneMode`, `AutoTrustMode`, `AutoTankMode`, `AutoWSMode`, `AutoShadowMode`, `AutoFoodMode`, `AutoStunMode`, `AutoDefenseMode`.
  - Right column: `AutoBuffMode`, `AutoSambaMode`, `Weapons`, `OffenseMode`, `WeaponskillMode`, `Stance`, `IdleMode`, `Passive`, `RuneElement`, `PhysicalDefenseMode`, `MagicalDefenseMode`, `ResistDefenseMode`, `CastingMode`, `TreasureMode`.
- **Custom Mode Options (all 4 characters):**
  - `state.HybridMode`: `'Tank'`, `'DDTank'`, `'BreathTank'`, `'Dawn'`, `'NoShellTank'`, `'Normal'`
  - `state.CastingMode`: `'Normal'`, `'SIRD'`
  - `state.Passive`: `'None'`, `'AbsorbMP'`
  - `state.PhysicalDefenseMode`: `'PDT'`, `'PDT_HP'`, `'Tank'`
  - `state.MagicalDefenseMode`: `'BDT'`, `'MDT_HP'`, `'AegisMDT'`, `'AegisNoShellMDT'`, `'OchainMDT'`, `'OchainNoShellMDT'`, `'MDT_Reraise'`
  - `state.ResistDefenseMode`: `'MEVA'`, `'MEVA_HP'`, `'Death'`, `'Charm'`
  - `state.IdleMode`: `'Normal'`, `'Tank'`, `'KiteTank'`, `'PDT'`, `'MDT'`, `'Refresh'`, `'Reraise'`
  - `state.ExtraDefenseMode`: `'None'`, `'MP'`, `'Twilight'`

### Local Keybinds (`user_job_setup()` across all 4 characters)
*(Note: all 4 characters comment out `^q` Kiting and `!q` PDT binds from Selindrile's template.)*

| Keybind | Action | Purpose |
| :--- | :--- | :--- |
| `Alt+~` (`!`` `) | `gs c SubJobEnmity` | Executes subjob-specific enmity/tank action |
| `Ctrl+Backspace` | `/ja "Shield Bash" <t>` | Stun/enmity JA |
| `Win+Backspace` | `/ja "Cover" <stpt>` | Cover selected party member |
| `Alt+Backspace` | `/ja "Sentinel" <me>` | Physical DT + enmity spike |
| `Win+=` | `/ja "Chivalry" <me>` | TP-to-MP recovery |
| `Alt+=` | `/ja "Palisade" <me>` | Shield block rate boost |
| `Ctrl+Delete` | `/ja "Provoke" <stnpc>` | Subtarget Provoke |
| `Alt+Delete` | `/ma "Cure IV" <stal>` | Alliance subtarget Cure IV |
| `Win+Delete` | `/ma "Flash" <stnpc>` | Subtarget Flash |
| `Alt+F11` | `gs c cycle ExtraDefenseMode` | Cycle `None` → `MP` → `Twilight` overlay |
| `Win+~` (`@`` `) | `gs c cycle RuneElement` | Cycle `/RUN` rune element |
| `Ctrl+Pause` | `gs c toggle AutoRuneMode` | Toggle auto-rune maintenance |
| `Win+F8` | `gs c toggle AutoTankMode` | Toggle `job_tick()` auto-Flash + `SubJobEnmity` loop |
| `Win+F10` | `gs c toggle TankAutoDefense` | Maintain tanking defense mode via `Sel-Stahp` |
| `Ctrl+Alt+Alt+~` (`^@!`` `) | `gs c cycle SkillchainMode` | Cycle Skillchain lock mode |

---

## Job-Specific Commands (`//gs c ...`)

- **`//gs c RuneElement`** — Casts `/ja "<state.RuneElement.value>" <me>` (for `/RUN`).
- **`//gs c SubJobEnmity`** — Context-sensitive enmity rotation when targeting a monster (`player.target.type == "MONSTER"`):
  - `/RUN`: `Swordplay`.
  - `/BLU` (when not moving): `Sheep Song` → `Soporific` → `Geist Wall` → `Stinking Gas` → `Jettatura` → `Blank Gaze` → fallback `check_auto_tank_ws()`.
  - `/DRK`: Cancels `Souleater`/`Last Resort` if `HybridMode ~= 'Normal'` or `DefenseMode ~= 'None'`; cycles `Stun` → `Souleater` → `Last Resort` → `Arcane Circle` → `check_auto_tank_ws()`.
  - `/WAR`: Cancels `Defender` in `DD` hybrid modes or `Berserk` in non-`Normal`/non-`DD` hybrid modes; cycles `Provoke` → `Warcry` → `Defender` → `Aggressor` → `Berserk` → `check_auto_tank_ws()`.
  - `/DNC`: Cycles `CurrentStep` (`Box Step` / `Quickstep`) when under 3 Finishing Moves, `Animated Flourish` at 3+ FMs, or steps up to 5 FMs.

---

## Job Logic Highlights (`PLD.lua`)

- **`job_filtered_action`**: When a **Club/Spear** skill set containing WS ID `172` (`Flash Nova`) is detected (`available_ws:contains(172)`), remaps Sword WSs automatically:
  - `Chant du Cygne` → `True Strike`
  - `Savage Blade` → `Realmrazer`
  - `Sanguine Blade` → `Flash Nova`
- **`job_precast`**: If casting `Flash`, `AutoEmblem` is `true`, not amnesic, and `Divine Emblem` (`abil_recasts[80]`) + `Flash` (`spell_recasts[112]`) are ready, cancels the direct `Flash`, uses `/ja "Divine Emblem" <me>`, and schedules `/ma "Flash" <target>` `1s` later.
- **`job_post_precast`**: Handles Moonshade Earring replacement above `3200` effective TP (`AccMaxTP` / `MaxTP`) and daytime `Lugra Earring` swaps (`AccDayMaxTPWSEars`, `DayMaxTPWSEars`, `AccDayWSEars`, `DayWSEars`) when `not classes.DuskToDawn`.
- **`job_aftercast`**: Cycles `state.CurrentStep` after any completed `step` ability.
- **`job_tick()` Automation Priority**:
  1. `check_majesty()` — Uses `Majesty` in combat when `AutoMajesty` is enabled.
  2. `check_hasso()` — Maintains `Hasso`/`Seigan` on `/SAM` with two-handed weapons.
  3. `check_buff()` — When `AutoBuffMode ~= 'Off'` outside cities, maintains `buff_spell_lists[state.AutoBuffMode]` (`Auto`: `Crusade`, `Reprisal`, `Phalanx`) and `Majesty` in combat.
  4. `check_buffup()` — Processes queued `//gs c buffup` (`Default`: `Crusade`, `Reprisal`, `Haste`, `Refresh`, `Aquaveil`, `Stoneskin`, `Blink`, `Regen`, `Phalanx`).
  5. `AutoTankMode` loop — When engaged in combat targeting a monster and stationary, runs `check_flash()` (2s delay) and otherwise fires `gs c SubJobEnmity` (1s delay). *(Note: `--if BurtgangTP() then return true end` is commented out in `PLD.lua`.)*
- **Idle / Melee / Defense Hooks**:
  - `job_customize_idle_set`: Applies `sets.latent_refresh` at `mpp < 51` and `sets.latent_regen` at `hpp < 71` in `Normal` or `Sphere` idle modes.
  - `job_customize_melee_set` & `job_customize_defense_set`: Overlays `sets[state.ExtraDefenseMode.value]` (`MP` or `Twilight`) whenever `ExtraDefenseMode ~= 'None'`.
  - `update_melee_groups`: Appends `'AM'` custom melee group when wielding `Burtgang` with `Aftermath: Lv.3`.
  - `update_defense_mode`: Appends `'Kheshig Blade'` defense group when equipped; sets `CombatForm` to `'DW'` on `/NIN` or `/DNC` when off-hand is not a shield (`Aegis`, `Ochain`, `Svalinn`, `Priwen`, or `*Shield*`).
  - `job_update`: Maps `state.RuneElement` to `RuneResist` / `RuneDamage` and resets `state.Stance` to `'None'` if subjob is not `SAM`.

---

## Character Customizations

All four characters replace Selindrile's stock `Nyame` / `Sakpata` defaults with bespoke Ochain/Aegis, `Souveran`, `Reverence`, `Caballarius`, and `Tartarus` tanking sets, expanded `HybridMode`/`DefenseMode` tables, and `Twilight`/`Death`/`Charm`/`OchainMDT`/`AegisMDT` defense sets.

### `Gimlic` (`Gimlic_Pld_Gear.lua` — Custom, ~513 diff)
- **Weapons (`state.Weapons`):** `'None'`, `'BurtgangAegis'`, `'TP'`, `'TP2'`, `'NaeglingAegis'` (commented options: `DeaconAegis`, `SequenceAegis`, `SequenceBlurred`).
  - `BurtgangAegis`: `Burtgang` / `Aegis` | `NaeglingAegis`: `Naegling` / `Aegis` | `TP`: `Burtgang` / `Naegling` | `TP2`: `Burtgang` / `Joyeuse` (plus `DeaconAegis`, `SequenceBlurred`, `SequenceAegis`, `DualWeapons` defined).
- **Capes:** `gear.fastcast_jse_back` (`Rudianos's Mantle`: `INT+20, Eva/MEva+20, MEva+10, FC+10%, PDT-10%`) & `gear.enmity_jse_back` (`HP+60, Eva/MEva+20, HP+20, Enmity+10`).
- **Custom Functions & Buff Lists:**
  - Defines `BurtgangTP()` helper: auto-fires `Atonement` at `mob.hpp <= 20` and `TP >= 1000`, else `Flash`.
  - Overrides `buff_spell_lists.Auto` to add `Cocoon` (`Defense Boost`, SpellID `547`, `Always`) alongside `Crusade`, `Reprisal`, and `Phalanx` (`Enlight II` commented out).
- **Gear Highlights:**
  - `Burtgang` mainhand across `Enmity`, `Idle`, `Defense`, and `Engaged` sets (`Ochain` default shield in `PDT`/`Tank`/`Engaged`, `Aegis` in `MDT`/`BDT`/`OchainMDT`/`AegisMDT`).
  - Artifact/Relic +3 upgrades: `Cab. Breeches +3` (`Invincible`), `Cab. Leggings +3` (`Sentinel`, `Reraise`/`Weak`), `Cab. Coronet +3` (`Rampart`), `Cab. Surcoat +3` (`Fealty`/`Cover`), `Cab. Gauntlets +3` (`Chivalry`/`Shield Bash`), `Rev. Surcoat +3`, `Rev. Leggings +3`.
  - Uses `Sakpata's Helm` / `Plate` / `Gauntlets` / `Cuisses` / `Leggings` in base `sets.engaged`, `Sakpata's Gauntlets` & `Leggings` across DT/Idle/Tank sets, `Sakpata's Sword` in `FC` & `Phalanx`, `Yorium Gauntlets` in `Enmity`/`Phalanx`, `Chozoron Coselete` in `Idle`/`Refresh`, `Founder's Corona` in `MEVA`/`Death`/`Charm`/MDT sets, `Nicander's Necklace` + dual `Eshmun's Ring` in `sets.buff.Doom`, and `gear.valorous_treasure_legs` in `sets.TreasureHunter`.
  - `sets.latent_refresh = {waist="Fucho-no-obi", neck="Parade Gorget"}`.
- **Macro Book / Lockstyle:** Book `5` (`NIN`: p2, `DNC`: p4, `RDM`: p6, `BLU`: p8, `RUN`: p9, default/`WAR`: p1). Lockstyle `/lockstyleset 1` via `set_lockstyle()`.

### `Voicelessbicep` (`Voicelessbicep_Pld_Gear.lua` — Custom, ~351 diff)
- **Weapons (`state.Weapons`):** `'None'`, `'DeaconAegis'`, `'SequenceAegis'`, `'SequenceBlurred'` (also defines `sets.weapons.DualWeapons = {main="Sequence", sub="Demersal Degen +1"}`).
- **Gear Highlights:**
  - Uses `Mafic Cudgel` + `Ochain` as default `Enmity`, `Idle`, `PDT`, and `Engaged` weapon/shield, `Malignance Sword` in `precast.FC` and `defense.MEVA`, `Vampirism` in `midcast.FastRecast`, `Deacon Sword` in `Cure` / `Self_Healing` / `Phalanx`, and `Colada` in `Enhancing Magic`.
  - Uses `Souv. Handsch. +1`, `Macabre Gaunt. +1`, `Sulev. Gauntlets +2`, and `Jumalik Mail` / `Helm` instead of `Sakpata`'s armor or `Caballarius +3` pieces (`Cab. Gauntlets +1`, `Cab. Leggings +1`, `Rev. Surcoat +3`, `Rev. Leggings +3`).
  - `sets.latent_refresh = {waist="Fucho-no-obi", neck="Parade Gorget"}`; `Hercules' Ring` in `sets.idle` & `sets.idle.Refresh`.
- **Macro Book / Lockstyle:** Book `5` (same page mapping as `Gimlic`). Lockstyle `/lockstyleset 1` via `set_lockstyle()`.

### `Balullu` & `Friendlessvirus` (`Balullu_Pld_Gear.lua`, `Friendlessvirus_Pld_Gear.lua` — Identical Custom, ~332 diff)
- **Weapons & Gear:** Identical to `Voicelessbicep` except:
  - Uses `Stikini Ring +1` (dual) in `sets.idle` and `Dark Ring` in `sets.idle.Refresh`.
  - `sets.latent_refresh = {waist="Fucho-no-obi"}` (no `Parade Gorget`).
  - Does **not** define `set_lockstyle()` (falls back to global lockstyle behavior).
- **Macro Book:** Book `4` (`NIN`: p2, `DNC`: p4, `RDM`: p6, `BLU`: p8, `RUN`: p9, default/`WAR`: p1).

---

## Related Notes

- [FFXI GearSwap and Character Profiles](./README.md)
- `FFXI Windower Overview`
- `FFXI Windower Addons Catalog`
- [FFXI Addon — GearSwap](./GearSwap-Engine.md)
