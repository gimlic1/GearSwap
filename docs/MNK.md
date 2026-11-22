# FFXI GearSwap — MNK (Monk)

> [!NOTE]
> **Quick Reference**
> - **Logic File:** [MNK.lua](file:///C:/Windower/addons/GearSwap/data/MNK.lua)
> - **Defaults (`MNK.lua`):** `autows = 'Victory Smite'` *(overridden to `'Tornado Kick'` on `Voicelessbicep`)* | `autofood = 'Soy Ramen'` *(overridden to `'Red Curry Bun'` on `Voicelessbicep`)* | `state.AutoBoost = false`
> - **Character Customization Status:**
>   - `Voicelessbicep`: **CUSTOM** *(141 diff lines vs `Selindrile_Mnk_Gear.lua`: adds `Trial` weapon set, `autows = 'Tornado Kick'`, `autofood = 'Red Curry Bun'`)*
>   - `Balullu`, `Friendlessvirus`: **CUSTOM** *(identical; 133 diff lines vs `Selindrile_Mnk_Gear.lua`)*
>   - `Gimlic`: **STOCK** *(matches `Selindrile_Mnk_Gear.lua`)*

---

## Job-Specific Modes & Keybinds

### States (`MNK.lua` & Custom Overrides)
- `state.AutoBoost`: `false` / `true` (prepends `Warcry` if `/WAR`, or `Boost`, before Weaponskills)
- `state.OffenseMode` *(custom)*: `Normal`, `SomeAcc`, `Acc`, `FullAcc`, `Fodder` *(stock: `Normal`, `Acc`, `FullAcc`)*
- `state.WeaponskillMode` *(custom)*: `Match`, `Normal`, `SomeAcc`, `Acc`, `FullAcc`, `Fodder`
- `state.PhysicalDefenseMode` *(custom)*: `PDT`, `HP` *(stock: `PDT`)*
- `state.IdleMode` *(custom)*: `Normal`, `PDT`
- `state.Weapons`:
  - `Voicelessbicep`: `Godhands`, `Staff`, `ProcStaff`, `ProcClub`, `Barehanded`, `ProcSword`, `ProcGreatSword`, `ProcScythe`, `ProcPolearm`, `ProcGreatKatana`, **`Trial`**
  - `Balullu` / `Friendlessvirus` / `Gimlic`: same list without `Trial`

### Local Keybinds (All Characters)
| Keybind | Command | Function |
| :--- | :--- | :--- |
| ``Ctrl+` `` | `/ja "Boost" <me>` | Activate Boost |
| ``Alt+` `` | `/ja "Perfect Counter" <me>` | Activate Perfect Counter |
| `Ctrl+Backspace` | `/ja "Mantra" <me>` | Activate Mantra |
| ``Win+` `` | `gs c cycle SkillchainMode` | Cycle SkillchainMode |

---

## Job-Specific Commands (`//gs c ...`)

- `MNK.lua` leaves `job_self_command` empty; modes are controlled via `//gs c toggle AutoBoost`, `//gs c cycle OffenseMode`, `//gs c cycle Weapons`, etc.

---

## Job Logic Highlights (`MNK.lua`)

- **Precast Auto-Warcry/Boost (`job_precast`):** When `AutoBoost` or `AutoBuffMode ~= 'Off'`, if `AutoBoost` is true:
  - Uses `/ja "Warcry" <me>` (`/WAR`, 1s delay) or `/ja "Boost" <me>` (2.5s delay) before firing the Weaponskill.
- **Post-Precast Buff Gear (`job_post_precast`):**
  - Swaps Moonshade Earring at `>3200` effective TP.
  - Equips `sets.buff.ImpetusWS` (fallback `sets.buff.Impetus` / `Bhikku Cyclas +1`) on `Ascetic's Fury` and `Victory Smite` when `Impetus` is active.
  - Equips `sets.FootworkWS` (`Shukuyu Sune-Ate`) on `Dragon Kick` and `Tornado Kick` when `Footwork` is active.
  - Equips `sets.precast.JA['Boost'].OutOfCombat` when using `Boost` out of combat.
- **Melee & Idle Buff Layering:** Unless `OffenseMode == 'FullAcc'`, layers `sets.buff.Impetus` and `sets.buff.Footwork` on melee sets; layers `sets.buff.Boost` on both melee and idle sets while `Boost` is active.
- **Melee Groups & Tick:** Appends `Footwork` (when not in `Hundred Fists`), `AM` (`Glanzfaust` + `Aftermath: Lv.3`), and `HF` (`Hundred Fists`). `job_tick` (`AutoBuffMode ~= 'Off'` in combat) auto-uses `Chakra` (`HPP < 51`), `Impetus`, `Focus` (when neither `Aggressor` nor `Focus` is active), and `/WAR` `Berserk` & `Aggressor`.

---

## Character Customizations

### `Balullu` & `Friendlessvirus` (CUSTOM — identical files)
- **Macro Book (`select_default_macro_book`):** Book `20` — `DNC`=5, `NIN`=4, `THF`=6, `RUN`=7, fallback=`6`.
- **Weapon Sets:** `Godhands`, `Barehanded`, `Staff` (`Malignance Pole`/`Bloodrain Strap`), plus Abyssea/VW proc sets (`Terra's Staff`, `Mafic Cudgel`, `Ark Sword`, `Lament`, `Ark Scythe`, `Pitchfork +1`, `Hardwood Katana`).
- **Key Gear Overrides vs Stock Template:** Adds `SomeAcc` and `Fodder` tiers for WS and Engaged sets (`Ken. Samue`, `Adhemar Wrist. +1`, `Niqmaddu Ring`, `Gere Ring`, `Segomo's Mantle`, `Samnuha Tights`, `Ryuo Tekko`, `Mummu +2` crit/acc pieces); adds `sets.defense.HP` and `sets.idle.PDT` (`Genmei Kabuto`, `Malignance Tabard`/`Gloves`, `herculean_dt_legs`, `Hippo. Socks +1` instead of `Nyame`); uses `Respite Cloak` / `Toro Cape` / `Flax Sash` for `MEVA`.

### `Voicelessbicep` (CUSTOM — `Balullu` + 10 lines)
- Inherits all `Balullu` customizations above, plus:
  - `autows = 'Tornado Kick'`
  - `autofood = 'Red Curry Bun'` *(commented `--autofood = 'Sublime Sushi'`)*
  - Adds `'Trial'` to `state.Weapons` with `sets.weapons.Trial = {main="Knuckles of Trials"}`.

### `Gimlic` (STOCK)
- Unmodified `Selindrile_Mnk_Gear.lua` (`Normal`/`Acc`/`FullAcc` modes, `Nyame` idle/defense sets, `Malignance` DT melee sets).

---

## Related Notes

- [FFXI GearSwap and Character Profiles](./README.md)
- `FFXI Windower Overview`
- [FFXI Addon — GearSwap](./GearSwap-Engine.md)
