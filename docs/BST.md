# FFXI GearSwap — BST (Beastmaster)

> [!NOTE]
> **Quick Reference**
> - **Logic File:** [BST.lua](file:///C:/Windower/addons/GearSwap/data/BST.lua)
> - **Defaults (`BST.lua`):** `autows = 'Cloudsplitter'` | `autofood = 'Akamochi'` | `target_distance = 6` | `state.AutoFightMode = true` | `state.AutoReadyMode = false` | `state.AutoCallPet = false` | `state.PetMode = 'Tank'` | `state.RewardMode = 'Theta'` | `UnleashLock = true`
> - **Character Customization Status:**
>   - `Gimlic`, `Balullu`, `Friendlessvirus`: **CUSTOM** *(identical across all three; 68 diff lines vs upstream `Selindrile_Bst_Gear.lua`)*
>   - `Voicelessbicep`: **STOCK** *(matches `Selindrile_Bst_Gear.lua`)*

---

## Job-Specific Modes & Keybinds

### States (`BST.lua` & `user_job_setup`)
- `state.AutoFightMode`: `true` (auto-sends `/pet Fight <t>` on engaging a monster within 20 yalms if pet is idle)
- `state.AutoReadyMode`: `false` / `true` (tick-driven Ready usage when pet is engaged and charges > 0; resets on zone change)
- `state.AutoCallPet`: `false` / `true` (auto-calls pet out of cities using `Bestial Loyalty` then `Call Beast`)
- `state.PetMode`: `Tank`, `DD` (appended to `CustomIdleGroups` when pet is valid)
- `state.RewardMode`: `Theta`, `Zeta`, `Eta` (selects `Pet Food` ammo and auto-Reward trigger `<34%` pet HP)
- `state.JugMode` *(custom override)*: `ScissorlegXerin`, `BlackbeardRandy`, `AttentiveIbuki`, `DroopyDortwin`, `WarlikePatrick`, `AcuexFamiliar` *(stock adds `FatsoFargann`)*
- `state.CorrelationMode`: `Neutral`, `Favorable`
- `state.IdleMode` *(custom override)*: `Normal`, `Refresh`, `Reraise` *(stock adds `SingleWield`)*
- `state.Weapons`: `None`, `PetPDTAxe`, `DualWeapons`

### Local Keybinds (`Gimlic` / `Balullu` / `Friendlessvirus` & Stock)
| Keybind | Command | Function |
| :--- | :--- | :--- |
| `Ctrl+F7` | `gs c cycle JugMode` | Cycle preferred Jug pet (auto-echoes `DisplayPetInfo`) |
| `Alt+F7` | `gs c cycle CorrelationMode` | Cycle `Neutral` / `Favorable` (switches `Ready` head) |
| `Win+F7` | `gs c cycle PetMode` | Cycle `Tank` / `DD` pet idle mode |
| `Ctrl+Backspace` | `gs c cycle RewardMode` | Cycle `Theta` / `Zeta` / `Eta` |
| `Win+F8` | `gs c toggle AutoReadyMode` | Toggle auto-Ready spam |
| ``Alt+` `` | `gs c ready default` | Fire default Ready move for current pet |

---

## Job-Specific Commands (`//gs c ...`)

- `//gs c ready [default|aoe|buff|debuff|physical|magical]`: Sends pet to Fight if idle on a monster, or executes the mapped Ready move for the active pet (falls back to `Sic` if unmapped). Aborts in cities, without a pet, or at 0 charges.
- `//gs c showcharge`: Prints current Ready charges (`0`–`3`, dynamically calculated from `sic_recast` merits, `>100` JP bonus, `Charmer's Merlin`, and `Desultor Tassets`/`Gleti's Breeches`, floored at `10s`/charge).
- `//gs c displaypetinfo`: Prints species/job info for current `state.JugMode`.
- `//gs c unleashlock`: Toggles `UnleashLock` (auto-disabling all gear slots during `Unleash` after a Ready move so Ready gear stays locked).

---

## Job Logic Highlights (`BST.lua`)

- **Out-of-Range WS Cancel & Bestial Loyalty Fallback:** Cancels WSs (except `Mistral Axe` and `Bora Axe`) beyond `target_distance` (`6`). If `Bestial Loyalty` is on cooldown, `job_filter_precast` falls back to `/ja "Call Beast" <me>`.
- **HQ Broth Auto-Upgrade:** In `job_precast`, `Bestial Loyalty` checks `item_available(...)` for HQ broths (e.g., `Vis. Broth` -> `PonderingPeter`, `Bubbly Broth` -> `BouncingBertha`, `Windy Greens` -> `SwoopingZhivago`, `Venomous Broth` -> `FluffyBredo`, etc.) and equips the matching broth automatically.
- **Ready Precast/Aftercast & Pet TP Bonus:** Equips `ReadyRecast` / `ReadyRecastDW` on `Monster` actions (`precast`), then equips `MagicReady` / `DebuffReady` / `PhysicalDebuffReady` / `MultiHitReady` / `Pet.WS` in `job_aftercast`, adding `sets.midcast.Pet.TPBonus` (`Nukumi Manoplas +1`) if `pet.tp < 1900` (or `<2400` for non-Warrior pets).
- **Killer Instinct & Mekira WS:** Equips `sets.buff['Killer Instinct']` during WS if active; uses `Mekira` WS mode (`Gavialis Helm`) for `Ruinator` on `Water`/`Wind`/`Ice` days.
- **Auto-Tick (`job_tick`):** Auto-uses `Reward` when `pet.hpp < 34`, auto-summons pet if `AutoCallPet` is on, and fires `Fight` / `gs c ready` when `AutoReadyMode` is on.

---

## Character Customizations

### `Gimlic` / `Balullu` / `Friendlessvirus` (CUSTOM — identical files)
- **Macro Book (`select_default_macro_book`):** `DNC`=(6,16), `NIN`=(4,16), `THF`=(6,20), `RUN`=(7,20), fallback=(6,20). *(Stock uses book 16 across all subjobs.)*
- **Weapon Sets & Augmented Axes:**
  - `PetPDTAxe`: `{main="Izizoeksi"}` | `DualWeapons`: `{main="Izizoeksi", sub="Hunahpu"}`
  - Custom `Kumbhakarna` augments: `gear.PHYKumbha1` (Pet Atk+20, DA+4/Crit+4, TP Bonus+180), `gear.PHYKumbha2` (Pet Acc+18, TP Bonus+160), `gear.PDTMABKumbha` (Pet MAB+20, Pet PDT-4%, TP Bonus+200), `gear.MABKumbha` (Pet MAB+19, TP Bonus+160). *(Note: `PDTMABKumbha` and `MABKumbha` values are swapped vs stock template.)*
- **Gear Overrides vs Stock Template:** Drops `Gleti's` / `Nyame` / `Agwu's Axe` / `Crep. Earring` / `autows_list` in favor of `Desultor Tassets` + `Charmer's Merlin` (`ReadyRecast`), `Valorous` pet head/body/legs/feet (`DebuffReady`), `Ankusa Gloves +1` (`idle.Pet.Engaged`), `Genmei Kabuto` (`PDT`/`MDT`), `Taeon Tabard` (`FastRecast`/`Pet.WS`), `Buquwik Cape` (`WS.Fodder`), `Dosis Tathlum` (`Primal Rend`). Omits post-2020 jug broth sets (`WeevilFamiliar` through `SultryPatrice`).

### `Voicelessbicep` (STOCK)
- Unmodified `Selindrile_Bst_Gear.lua` (includes `Gleti's` Ready/Recast gear, `Agwu's Axe`, `Nyame` defense/hybrid sets, `SingleWield` idle mode, full jug list, and `autows_list` mapping `PetPDTAxe`/`DualWeapons` to `Ruinator`).

---

## Related Notes

- [FFXI GearSwap and Character Profiles](./README.md)
- `FFXI Windower Overview`
- [FFXI Addon — GearSwap](./GearSwap-Engine.md)
