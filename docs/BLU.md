# FFXI GearSwap — BLU (Blue Mage)

> [!NOTE]
> **Quick Reference**
> - **Logic File:** [BLU.lua](file:///C:/Windower/addons/GearSwap/data/BLU.lua)
> - **Defaults (`BLU.lua`):** `autows = 'Chant Du Cygne'` *(overridden to `'Expiacion'` in `Gimlic` / `Voicelessbicep`)* | `autofood = 'Soy Ramen'` | `state.LearningMode = false` | `state.AutoUnbridled = false`
> - **Character Customization Status:**
>   - `Balullu`, `Friendlessvirus`: **CUSTOM** *(identical; 244 diff lines vs upstream `Selindrile_Blu_Gear.lua`, including a custom `check_trust()` override)*
>   - `Gimlic`: **CUSTOM (Minimal)** *(2 diff lines vs `Selindrile_Blu_Gear.lua`: `sets.Learning` uses `Magus Bazubands` instead of `Assim. Bazu. +3`)*
>   - `Voicelessbicep`: **STOCK** *(matches `Selindrile_Blu_Gear.lua`)*

---

## Job-Specific Modes & Keybinds

### States (`BLU.lua` & Character Overrides)
- `state.LearningMode`: `false` / `true` (locks `sets.Learning` hands across precast, midcast, engaged, and idle)
- `state.AutoUnbridled`: `false` / `true` (auto-casts `Unbridled Learning` before Unbridled spells)
- `state.ExtraMeleeMode`: `None`, `MP`, `SuppaBrutal`, `DWEarrings`, `DWMax`
- `state.CastingMode`:
  - `Gimlic` / `Voicelessbicep`: `Normal`, `SIRD`, `Resistant`, `FullMacc`, `Fodder`, `Proc`
  - `Balullu` / `Friendlessvirus`: `Normal`, `Resistant`, `Fodder`, `Proc`
- `state.Weapons`:
  - `Gimlic` / `Voicelessbicep`: `Tizbron`, `Tizalmace`, `None`, `Almace`, `MeleeClubs`, `HybridWeapons`, `Naegbron`, `Naegmace`
  - `Balullu` / `Friendlessvirus`: `Tizalmace`, `Sequence`, `None`, `Almace`, `MagicWeapons`, `MeleeClubs`, `MaccWeapons`, `HybridWeapons`

### Local Keybinds (All Characters)
| Keybind | Command | Function |
| :--- | :--- | :--- |
| ``Ctrl+` `` / ``Win+` `` / ``Alt+` `` | `/ja "Chain Affinity"` / `/ja "Efflux"` / `/ja "Burst Affinity"` | Core BLU affinity JAs |
| ``Ctrl+Alt+Win+` `` | `gs c cycle SkillchainMode` *(Note: overwritten below by `MagicBurstMode`)* | Cycle MagicBurstMode (`Off`/`Single`/`Lock`) |
| `Ctrl+Backspace` | `/ja "Unbridled Learning"` -> `/ja "Diffusion"` -> `/ma "Mighty Guard"` | Auto Unbridled Diffusion Mighty Guard |
| `Alt+Backspace` | `/ja "Unbridled Learning"` -> `/ja "Diffusion"` -> `/ma "Carcharian Verve"` | Auto Unbridled Diffusion Carcharian Verve |
| `Win+Backspace` | `/ja "Convergence" <me>` | Convergence |
| `Win+F10` | `gs c toggle LearningMode` | Toggle Learning Mode |
| `Win+F8` | `gs c toggle AutoNukeMode` | Toggle Auto-Nuke |
| `Ctrl+Alt+Win+F7` | `gs c toggle AutoWSMode` | Toggle Auto-WS |
| `Alt+R` | `gs c weapons None;gs c update` | Unlock/clear weapon set |
| `Win+Q` / `Ctrl+Q` / `Alt+Q` | `gs c weapons MaccWeapons` / `Almace` / `HybridWeapons` | Quick weapon set swaps |

---

## Job-Specific Commands (`//gs c ...`)

- `//gs c curecheat`: Equips `sets.HPDown` (lowers max HP) and casts `Magic Fruit <me>` 1s later to trigger Cure-potency/MP-efficient self-healing.

---

## Job Logic Highlights (`BLU.lua`)

- **Club WS Remapping (`job_filtered_action`):** When a club is equipped (WS ID `160` `Shining Strike` available), automatically remaps sword WSs: `Chant du Cygne` -> `Realmrazer`, `Sanguine Blade` -> `Flash Nova`, `Flat Blade` -> `Brainshaker`, `Expiacion` -> `Judgment`, `Vorpal Blade` -> `True Strike`, `Savage Blade` -> `Black Halo`.
- **Unbridled Auto-Cast (`job_filter_precast`):** Blocks Unbridled spells unless `Unbridled Learning` or `Unbridled Wisdom` is active; if `AutoUnbridled`, `buffup`, or `AutoBuffMode ~= 'Off'` and recast is ready, fires `/ja "Unbridled Learning" <me>` and schedules the spell 1s later.
- **Spell Mapping (`job_get_spell_map`):** Categorizes Blue Magic into `Physical`, `PhysicalAcc`, `PhysicalStr`, `PhysicalDex`, `PhysicalVit`, `PhysicalAgi`, `PhysicalInt`, `PhysicalMnd`, `PhysicalChr`, `PhysicalHP`, `Magical`, `MagicalMnd`, `MagicalChr`, `MagicalVit`, `MagicalDex`, `MagicalAgi`, `MagicAccuracy`, `Breath`, `Stun`, `Healing`, `SkillBasedBuff`, `Buff`.
- **Midcast & Aftercast:** Handles `UnlockedHealing` / `UnlockedAoEHealing` / `Self_Healing` and `Hachirin-no-Obi` on Healing; applies `MagicBurst` (with `Burst Affinity` or `Azure Lore`), `Zodiac Ring`, `sets.element[spell.element]`, and `TreasureHunter` (`Tag`) on Magical spells; layers active `state.Buff` sets (`Burst Affinity`, `Chain Affinity`, `Convergence`, `Diffusion`, `Efflux`); resets `MagicBurstMode` if `Single`.
- **Melee Groups & Tick:** Appends `AM` melee group when `Tizona` + `Aftermath: Lv.3` are active. `job_tick` maintains `Light Arts` (`/SCH`), runs `check_buff` (`Erratic Flutter`, `Battery Charge`, `Refresh`, `Nat. Meditation`, `Mighty Guard`; plus `Berserk`/`Aggressor` when `/WAR` in combat), and runs `check_buffup` (`Default` and `Cleave` buff lists).

---

## Character Customizations

### `Balullu` & `Friendlessvirus` (CUSTOM — identical files)
- **Macro Book (`select_default_macro_book`):** Book `2` — Pages: `DNC`=4, `NIN`=5, `WAR`=7, `RUN`=3, `THF`=2, `RDM`=1, fallback=6.
- **Weapon Sets:** `Tizalmace` (`Tizona`/`Almace`), `Tizbron` (`Tizona`/`Thibron`), `MeleeClubs` (`Nehushtan` x2), `Almace` (`Almace`/`Sequence`), `Sequence` (`Sequence`/`Almace`), `Kaja` (`Naegling`/`Almace`), `MagicWeapons` (`Nibiru Cudgel` x2), `MaccWeapons` (`Iris` x2), `HybridWeapons` (`Vampirism` x2).
- **Custom Capes & Obi Vars:** `Rosmerta's Cape` variants (`da_jse_back`, `stp_jse_back`, `crit_jse_back`, `wsd_jse_back`, `nuke_jse_back`) + `gear.obi_cure_waist = "Luminary Sash"`, `gear.obi_nuke_waist = "Yamabuki-no-Obi"`, `gear.obi_cure_back = "Tempered Cape +1"`.
- **Gear & Trust Overrides:** Uses `Nibiru Cudgel` x2 / `Jhakri +2` / `Iris` x2 / `Mafic Cudgel` / `Malignance` (without `Nyame`, `Bunzi's Rod`, `Sakpata's Sword`, or `Luhlaza +3` legs/feet). Adds a custom `check_trust()` override summoning `Yoran-Oran (UC)`, `Koru-Moru`, `Qultada`, `Ulmia`, and `Selh'teus`. Omits `autows_list` (falls back to `BLU.lua` `Chant Du Cygne`).

### `Gimlic` (CUSTOM — 2 diff lines vs Stock)
- Identical to upstream `Selindrile_Blu_Gear.lua` (`autows = 'Expiacion'`, `autows_list` per weapon set, `Bunzi's Rod` / `Sakpata's Sword` / `Nyame` / `Maxentius` / `Assim. Bazu. +3` / `Luhlaza +3`), except `sets.Learning = {hands="Magus Bazubands"}` instead of `Assim. Bazu. +3`.

### `Voicelessbicep` (STOCK)
- Unmodified `Selindrile_Blu_Gear.lua` (`sets.Learning = {hands="Assim. Bazu. +3"}`).

---

## Related Notes

- [FFXI GearSwap and Character Profiles](./README.md)
- `FFXI Windower Overview`
- [FFXI Addon — GearSwap](./GearSwap-Engine.md)
- `FFXI Addon — bluguide`
- `FFXI Addon — BLUAlert`
