# FFXI GearSwap — DNC (Dancer)

> [!NOTE]
> **Quick Reference**
> - **Logic File:** [DNC.lua](file:///C:/Windower/addons/GearSwap/data/DNC.lua)
> - **Defaults (`DNC.lua`):** `autows = "Rudra's Storm"` | `autofood = 'Soy Ramen'` | `state.AutoPrestoMode = true` | `state.DanceStance = 'None'` | `state.UseAltStep = true`
> - **Character Customization Status:**
>   - `Balullu`, `Friendlessvirus`: **CUSTOM** *(identical; 16 diff lines vs `Selindrile_Dnc_Gear.lua`)*
>   - `Voicelessbicep`: **STOCK** *(matches `Selindrile_Dnc_Gear.lua`)*
>   - `Gimlic`: **NONE** *(no `Gimlic_Dnc_Gear.lua` file)*

---

## Job-Specific Modes & Keybinds

### States (`DNC.lua` & `user_job_setup`)
- `state.MainStep`: `Box Step`, `Quickstep`, `Feather Step`, `Stutter Step`
- `state.AltStep`: `Feather Step`, `Quickstep`, `Stutter Step`, `Box Step`
- `state.UseAltStep`: `true` / `false` (alternates `CurrentStep` between `Main` and `Alt` after each step)
- `state.AutoPrestoMode`: `true` / `false` (auto-uses `Presto` before steps when `<3` Finishing Moves and TP > 99)
- `state.DanceStance`: `None`, `Saber Dance`, `Fan Dance` (tick-maintained while in combat)
- `state.ExtraMeleeMode`: `None`, `Suppa`, `DWEarrings`, `DWMax`
- `state.Weapons`: `Aeneas`, `LowBuff`

### Local Keybinds (All Characters)
| Keybind | Command | Function |
| :--- | :--- | :--- |
| ``Win+` `` | `gs c step` | Execute current configured step (`Main`/`Alt`) |
| ``Ctrl+Alt+Win+` `` | `gs c toggle usealtstep` | Toggle alternating Main/Alt steps |
| ``Ctrl+Win+` `` / ``Alt+Win+` `` | `gs c cycle mainstep` / `gs c cycle altstep` | Cycle primary / alternate step |
| ``Ctrl+` `` / ``Alt+` `` | `/ja "Saber Dance" <me>` / `/ja "Fan Dance" <me>` | Activate Saber / Fan Dance |
| `Ctrl+\` / `Alt+\` | `/ja "Chocobo Jig II" <me>` / `/ja "Spectral Jig" <me>` | Chocobo Jig II / Spectral Jig |
| `Alt+Backspace` / `Ctrl+Backspace` | `/ja "Reverse Flourish" <me>` / `/ja "No Foot Rise" <me>` | Reverse Flourish / No Foot Rise |
| `Shift+~` *(not in chat)* | `gs c cycle SkillchainMode` | Cycle SkillchainMode |

---

## Job-Specific Commands (`//gs c ...`)

- `//gs c step`: Executes `/ja "<Main or Alt Step>" <t>` based on `state.UseAltStep` and `state.CurrentStep`.
- Standard state commands: `//gs c cycle mainstep`, `//gs c cycle altstep`, `//gs c toggle usealtstep`.

---

## Job Logic Highlights (`DNC.lua`)

- **Auto-Buff WS Precast (`job_precast`):** When `AutoBuffMode ~= 'Off'` and TP > `999 + step_cost()` *(where `step_cost()` accounts for `Setan Kober` `-40` and `Horos T. Shoes +2/+3` `-10/-20`)*:
  1. If `<3` Finishing Moves and Step/Presto ready while engaged -> cancels WS, runs `gs c step`, reschedules WS 2.3s later.
  2. If `>=3` FMs -> auto-fires `Climactic Flourish` (or `Building Flourish` if Climactic on cooldown) 1s before WS.
  3. If `/SAM` -> auto-fires `Sekkanoki` (TP > 1850) or `Meditate` 1s before WS.
- **Auto-Presto & Climactic Layering:** `job_precast` auto-prepends `Presto` to Steps when `<3` FMs (`level >= 77`, `AutoPrestoMode`, engaged, TP > 99). `job_post_precast` layers `sets.buff['Climactic Flourish']` during WS when active.
- **Aftercast Reverse Flourish:** Automatically schedules `/ja "Reverse Flourish" <me>` 1.5s after a `Climactic Flourish` WS if `>=3` FMs remain and TP < 999; cycles `CurrentStep` after step completion.
- **Melee Groups & Tick:** Appends `Saber` (`Saber Dance`) and `AM` (`Terpsichore` + `Aftermath: Lv.3`) melee groups. `job_tick` maintains `DanceStance` in combat and `AutoBuffMode` (`No Foot Rise` when 0 FMs; `/WAR` `Berserk`/`Aggressor`).

---

## Character Customizations

### `Balullu` & `Friendlessvirus` (CUSTOM — identical files)
- **Macro Book (`select_default_macro_book`):** Book `9` — `WAR`=10, `NIN`=1, `SAM`=9, `THF`=8, fallback=`10`.
- **Weapon Sets:** `Aeneas` (`Aeneas`/`Taming Sari`) and `LowBuff` (`Aeneas`/`Blurred Knife +1`).
- **Custom Capes:** `gear.stp_jse_back` (`Senuna's Mantle` DEX+20, Acc/Atk+20, STP+10) and `gear.wsd_jse_back` (`Senuna's Mantle` DEX+20, Acc/Atk+20, WSD+10%).
- **Gear Overrides vs Stock Template (16 diff lines):** Upgrades `Enmity`, `idle`, `defense.PDT`, and `defense.MDT` sets with **Nyame** pieces (`Nyame Helm`, `Nyame Mail`, `Nyame Gauntlets`, `Nyame Flanchard`) in place of `Genmei Kabuto` / `Dampening Tam` / `Meg. Cuirie +2` / `Malignance Gloves` / `herculean_dt_legs`, and uses `Shadow Mantle` on `idle` instead of `Moonlight Cape`.

### `Voicelessbicep` (STOCK)
- Unmodified `Selindrile_Dnc_Gear.lua` (retains `Genmei Kabuto`, `Dampening Tam`, `Malignance Gloves`, `herculean_dt_legs` in Enmity/Idle/Defense sets).

### `Gimlic` (NONE)
- No Dancer gear file exists for `Gimlic`.

---

## Related Notes

- [FFXI GearSwap and Character Profiles](./README.md)
- `FFXI Windower Overview`
- [FFXI Addon — GearSwap](./GearSwap-Engine.md)
