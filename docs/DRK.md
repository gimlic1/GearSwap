# FFXI GearSwap — DRK (Dark Knight)

> [!NOTE]
> **Quick Reference**
> - **Logic File:** [DRK.lua](file:///C:/Windower/addons/GearSwap/data/DRK.lua)
> - **Defaults (`DRK.lua`):** `autows = 'Resolution'` | `autofood = 'Soy Ramen'` | `state.Stance = 'Hasso'` | `state.DrainSwapWeaponMode = 'Never'` *(overridden to `'Always'` in gear file)*
> - **Character Customization Status:**
>   - `Balullu`, `Friendlessvirus`: **CUSTOM (Minimal)** *(identical; 6 diff lines vs `Selindrile_Drk_Gear.lua`)*
>   - `Voicelessbicep`: **STOCK** *(matches `Selindrile_Drk_Gear.lua`)*
>   - `Gimlic`: **NONE** *(no `Gimlic_Drk_Gear.lua` file)*

---

## Job-Specific Modes & Keybinds

### States (`DRK.lua` & `user_job_setup`)
- `state.Stance`: `Hasso`, `Seigan`, `None` (auto-reset to `None` when subjob is not `SAM`)
- `state.DrainSwapWeaponMode`: `Always`, `Never`, `300`, `1000` *(gear file puts `Always` first)* — swaps to `sets.DrainWeapon` (`Misanthropy` + `Alber Strap`) for `Drain II` / `Drain III` when TP is below threshold, then restores weapon set aftercast
- `state.Passive`: `None`, `MP`, `Twilight`
- `state.Weapons`: `Montante`, `Anguta`

### Local Keybinds (All Characters)
| Keybind | Command | Function |
| :--- | :--- | :--- |
| ``Ctrl+` `` | `/ja "Hasso" <me>` | Activate Hasso |
| ``Alt+` `` | `/ja "Seigan" <me>` | Activate Seigan |
| ``Win+` `` | `gs c cycle SkillchainMode` | Cycle SkillchainMode |

---

## Job-Specific Commands (`//gs c ...`)

- `DRK.lua` leaves `job_self_command` undefined; weapon/stance/drain-swap modes use standard Selindrile commands (`//gs c cycle Stance`, `//gs c cycle DrainSwapWeaponMode`, `//gs c cycle Weapons`).

---

## Job Logic Highlights (`DRK.lua`)

- **Auto-Buff WS Precast (`job_precast`):** When `AutoBuffMode ~= 'Off'`:
  - `Entropy`: triggers `Consume Mana` if ready and `Sekkanoki` is not active (1s delay).
  - `/SAM` subjob: triggers `Sekkanoki` (`TP > 1850` and no `Consume Mana`) or `Meditate` 1s before WS.
- **Souleater & MaxTP Handling:** `job_post_precast` swaps Moonshade / Lugra day earrings, and forces `sets.buff.Souleater` on WS and melee sets (`DefenseMode == 'None'`) while `Souleater` is active.
- **Dark Magic & Drain Weapon Swap (`job_post_midcast` / `job_aftercast`):**
  - Layers `sets.buff['Nether Void']` (`Absorb`/`Drain`), `sets.buff['Dark Seal']` (`Absorb`/`Dread Spikes`/`Drain II`/`Drain III`), and `sets.DrainWeapon` (`Drain II`/`Drain III` per `DrainSwapWeaponMode`).
  - Aftercast restores `sets.weapons[state.Weapons.value]` if `DrainWeapon` was swapped in; also creates 60s `Sleep`/`Sleepga` timers when `UseCustomTimers` is true and resets `MagicBurstMode == 'Single'`.
- **Melee Groups & Tick:** Appends `Adoulin` (`Ionis` in Adoulin) and `AM` (`Liberator` + `Aftermath: Lv.3`). `job_tick` maintains `Hasso`/`Seigan` when engaged (`/SAM` with 2H weapon), auto-casts `Dread Spikes` (`AutoBuffMode ~= 'Off'`, combat) and uses `Last Resort`, `Scarlet Delirium`, plus `/WAR` `Berserk` & `Aggressor` in combat.

---

## Character Customizations

### `Balullu` & `Friendlessvirus` (CUSTOM — identical files)
- **Macro Book (`select_default_macro_book`):** Book `15` — `WAR`=2, `SAM`=3, `DNC`=4, `THF`=1, fallback=`5`.
- **Weapon Sets:** `Montante` (`Montante +1`/`Utu Grip`) and `Anguta` (`Anguta`/`Utu Grip`); `sets.DrainWeapon = {main="Misanthropy", sub="Alber Strap"}`.
- **Gear Overrides vs Stock Template (6 diff lines):** Replaces `ring1="Moonbeam Ring"` with `ring1="Gelatinous Ring +1"` (paired with `ring2="Moonlight Ring"`, `Tartarus Platemail`, `Sulev. Gauntlets +2`) in the three PDT/MDT defense sets (`sets.defense.PDT`, `sets.defense.MDTReraise`, `sets.defense.MDT`).

### `Voicelessbicep` (STOCK)
- Unmodified `Selindrile_Drk_Gear.lua` (`ring1="Moonbeam Ring"` in defense sets).

### `Gimlic` (NONE)
- No Dark Knight gear file exists for `Gimlic`.

---

## Related Notes

- [FFXI GearSwap and Character Profiles](./README.md)
- `FFXI Windower Overview`
- [FFXI Addon — GearSwap](./GearSwap-Engine.md)
