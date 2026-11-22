# FFXI GearSwap — RNG (Ranger)

> [!NOTE]
> **Quick Reference**
> - **Logic File:** `C:\Windower\addons\GearSwap\data\RNG.lua` (`385` lines)
> - **Character Status:** `Voicelessbicep` **CUSTOM** (~20 diff) | `Balullu` & `Friendlessvirus` **CUSTOM** (identical, ~14 diff) | `Gimlic` **NONE**
> - **Default AutoWS / Food (`RNG.lua`):** `autows = "Last Stand"` | `rangedautows = "Last Stand"` | `autofood = 'Soy Ramen'`
> - **Custom Defaults:** `Voicelessbicep` swaps default weapon/bow to `Eminent Bow` + `Stone Arrow`; `Balullu`/`Friendlessvirus` keep `Fomalhaut` + `Chrono Bullet` and customize RA/Snapshot gear

Code and gear reference for `RNG.lua` ammo protection, Flurry/Double Shot/Barrage automation, and character gear overrides.

---

## Job-Specific Modes & Keybinds

### Job States (`RNG.lua` & `user_job_setup`)
- **Job-level toggles (`RNG.lua`):**
  - `state.AutoAmmoMode` (default `true`): Enables `check_ammo()` out-of-combat ammo restocking/pouch checking in `job_tick()`.
  - `state.UseDefaultAmmo` (default `true`): Automatically swaps ammo per action (`Default`, `WS`, `Acc`, `Magic`, `MagicAcc`, `Unlimited`) and restores `Default` ammo in `job_aftercast`.
- **HUD Init (`init_job_states`):**
  - Left: `Capacity`, `AutoRuneMode`, `AutoTrustMode`, `AutoWSMode`, `AutoShadowMode`, `AutoFoodMode`, `RngHelper`, `AutoStunMode`, `AutoDefenseMode`.
  - Right: `AutoBuffMode`, `AutoSambaMode`, `Weapons`, `OffenseMode`, `RangedMode`, `WeaponskillMode`, `IdleMode`, `Passive`, `RuneElement`, `TreasureMode`.
- **Custom Mode Options (`Voicelessbicep` / `Balullu` / `Friendlessvirus`):**
  - `state.OffenseMode`: `'Normal'`, `'Acc'`
  - `state.HybridMode`: `'Normal'`, `'DTLite'`, `'DT'`
  - `state.RangedMode`: `'Normal'`, `'Acc'`, `'Fodder'`
  - `state.WeaponskillMode`: `'Match'`, `'Normal'`, `'Acc'`
  - `state.IdleMode`: `'Normal'`, `'PDT'`
  - `state.Weapons`: `'Default'`, `'DualWeapons'`, `'DualSavageWeapons'`, `'DualEviscerationWeapons'`, `'DualMagicWeapons'`, `'DualMalevolence'`

### Local Keybinds (`user_job_setup()`)
| Keybind | Action | Purpose |
| :--- | :--- | :--- |
| `Alt+~` (`!`` `) | `/ra <t>` | Fire ranged attack |
| `Alt+Backspace` | `/ja "Bounty Shot" <t>` | Apply Treasure Hunter / Bounty Shot |
| `Win+F7` | `gs c toggle RngHelper` | Toggle automatic ranged attack loop |
| `Win+~` (`@`` `) | `gs c cycle SkillchainMode` | Cycle Skillchain mode |
| `Alt+R` | `gs c weapons MagicWeapons;gs c update` | Attempt swap to `MagicWeapons` *(note: `state.Weapons` uses `DualMagicWeapons`)* |
| `Ctrl+Q` | `gs c weapons SingleWeapon;gs c update` | Attempt swap to `SingleWeapon` |

---

## Job-Specific Commands (`//gs c ...`)

- **`//gs c statusammo [ammo name]`** — Sets `statusammo` to force a specific status bullet/arrow (e.g., `Animikii Bullet` or custom ammo) during `Ranged Attack` precast, or clears `statusammo` back to `nil` when omitted, and refreshes the Display HUD.

---

## Job Logic Highlights (`RNG.lua`)

- **`check_ammo_precast` & `job_midcast` (Ammo Safety):**
  - Aborts and clears `Hauksbok*` or `Animikii Bullet` if equipped during a normal `Ranged Attack` (so one-of-a-kind/high-value WS ammo is never fired away), re-equipping `sets.weapons[state.Weapons.value].ammo` or `DefaultAmmo[WeaponType].Default` and alerting chat (`"Abort: Don't shoot your good ammo!"`).
  - Under `Unlimited Shot` on a WeaponSkill, equips `MagicAccUnlimited` / `MagicUnlimited` / `Unlimited` ammo.
  - Otherwise selects `WS` / `Acc` / `Magic` / `MagicAcc` / `Default` ammo per action and warns in chat if `count_available_ammo < 15`.
- **`job_precast` & `job_post_precast`:**
  - Sets `state.CombatWeapon:set(player.equipment.range)` on `Ranged Attack`.
  - On melee WSs while wielding a Bow (`WeaponType[range] == 'Bow'`), equips `Hauksbok Arrow` if available.
  - Handles `Moonshade Earring` swap above `3200` effective TP (`MagicalAccMaxTP`/`MagicalMaxTP` for elemental WSs, `RangedAccMaxTP`/`RangedMaxTP` for Archery/Marksmanship, `AccMaxTP`/`MaxTP` for melee).
  - Applies `sets.precast.RA[Weapons].Flurry` / `.Flurry2` (or generic `Flurry`/`Flurry2`) when `Flurry` I/II is active (`lastflurry == 1` or `2`), then equips `statusammo` if set.
- **`job_post_midcast`**: Stacks `sets.buff.Camouflage`, `sets.buff['Double Shot']` (nested by `Weapons`, `RangedMode`, and `'AM'` Aftermath group), and `sets.buff.Barrage` on `Ranged Attack`.
- **`job_buff_change`**: Tracks Aftermath (`AM` in `CustomRangedGroups`) for `Armageddon`/`Gandiva` (Lv.1–3), `Gastraphetes` (Lv.3), and `Annihilator`/`Yoichinoyumi` (`Aftermath`).
- **`job_update`**: Pressing `Pause` (`gs c update user`) outside cities auto-casts `/ja "Velocity Shot" <me>` if inactive.
- **`job_aftercast` & `job_tick()`**: Restores `DefaultAmmo[WeaponType].Default` after actions when `UseDefaultAmmo` is enabled; `job_tick()` runs `check_ammo()`.

---

## Character Customizations

- **`Gimlic`:** **NONE** (`Gimlic_Rng_Gear.lua` does not exist).
- **`Voicelessbicep` (`Voicelessbicep_Rng_Gear.lua` — Custom, ~20 diff):**
  - Overrides `WeaponType`: replaces `'Fail-Not'` with `['Eminent Bow'] = "Bow"`.
  - Overrides `DefaultAmmo.Bow`: sets all Bow ammo slots (`Default`, `WS`, `Acc`, `Magic`, `MagicAcc`, `Unlimited`, `MagicUnlimited`, `MagicAccUnlimited`) to `"Stone Arrow"` (instead of `Eminent Arrow` / `Hauksbok Arrow`).
  - Overrides `sets.weapons.Default` to `{main="Kustawi +1", sub="Nusku Shield", range="Eminent Bow"}` (keeping `Fomalhaut` on `DualWeapons`, `DualSavageWeapons`, `DualEviscerationWeapons`, `DualMalevolence`, `DualMagicWeapons`).
  - Macro book `19` (`NIN`/`DNC`/default: p1, `DRG`: p3).
- **`Balullu` & `Friendlessvirus` (`Balullu_Rng_Gear.lua`, `Friendlessvirus_Rng_Gear.lua` — Identical Custom, ~14 diff):**
  - Keeps `Fail-Not`/`Fomalhaut`/`Ataktos` and `sets.weapons.Default = {main="Kustawi +1", sub="Nusku Shield", range="Fomalhaut"}` (`Chrono Bullet` / `Orichalc. Bullet` / `Hauksbok Bullet`).
  - Removes `ring1="Crepuscular Ring"` from `sets.precast.RA` and `legs="Adhemar Kecks +1"` from `sets.precast.RA.Flurry2`.
  - Replaces `Crepuscular Ring` / `Ilabrat Ring` in `sets.midcast.RA` & `.Acc` with `ring1="Regal Ring", ring2="Dingir Ring"`, and in `.Fodder` with `ring1="Ilabrat Ring", ring2="Rajas Ring"`.
  - Macro book `19` (`NIN`/`DNC`/default: p1, `DRG`: p3).

---

## Related Notes

- [FFXI GearSwap and Character Profiles](./README.md)
- `FFXI Windower Overview`
- `FFXI Windower Addons Catalog`
- [FFXI Addon — GearSwap](./GearSwap-Engine.md)
- `FFXI Addon — AutoRA`
