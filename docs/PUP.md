# FFXI GearSwap — PUP (Puppetmaster)

> [!NOTE]
> **Quick Reference**
> - **Logic File:** `C:\Windower\addons\GearSwap\data\PUP.lua` *(unmodified Selindrile core with packet-tracked Pet Enmity + predictive Pet WS gear swapping)*
> - **Character Gear Files & Customization Status:**
>   - `Gimlic\Gimlic_Pup_Gear.lua` — **Heavily customized flagship PUP** (`Kenkonken`, `Godhands`, `Xiucoatl`, `Animator P +1`, full `Foire +3`, `Pitre +3`, `Karagoz +1`, `Mpaca's`, `Taeon` Pet-DT Tank set, custom Water/Fire/Light Tank maneuvers, lockstyle `9`)
>   - `Voicelessbicep\Voicelessbicep_Pup_Gear.lua`, `Balullu\Balullu_Pup_Gear.lua`, `Friendlessvirus\Friendlessvirus_Pup_Gear.lua` — **Identical baseline templates** (older Selindrile clones using `Ohtas`/`Godhands`, no custom lockstyle or JSE +3 overrides)
> - **Default Weapons (`Gimlic`):** `PetWeapons` (`Kenkonken` + `Animator P +1`) | Other sets: `None`, `Godhands`, `Xiucoatl`, `Trial` (`Knuckles of Trials`)
> - **Default AutoWS / Food:** `Gimlic`: `autows = 'Stringing Pummel'` (`PUP.lua` base: `'Victory Smite'`) | `autofood = 'Akamochi'`
> - **Default Macro Book / Lockstyle (`Gimlic`):** Book `20`, Page `2` (all subjobs) | `/lockstyleset 9` *(also runs `lua load SKillchains`)*
> - **Key Automation Flags:** `AutoPuppetMode = false` (`Win+F8`), `AutoRepairMode = true` (`Win+F7`, `repairhpp = 45`), `AutoDeployMode = true`, `AutoPetMode = true`, `PetWSGear = true`, `PetEnmityGear = true`, `deactivatehpp = 85`

Comprehensive code, command, and character gear reference for Kevin's Selindrile Puppetmaster setup, centered on `Gimlic`'s Mythic `Kenkonken` / `Godhands` / `Xiucoatl` Puppetmaster build.

---

## Job-Specific Modes & Keybinds

### Job States & Modes (`PUP.lua` + `Gimlic_Pup_Gear.lua`)

| State / Mode | Options / Default | Defined / Overridden In | Purpose |
| :--- | :--- | :--- | :--- |
| `state.OffenseMode` | `'Normal'`, `'Acc'`, `'FullAcc'`, `'Fodder'` | `*_Pup_Gear.lua` | Master melee accuracy/DPS tier |
| `state.HybridMode` | `'Pet'`, `'DT'`, `'Normal'` *(defaults to `'Pet'`!)* | `*_Pup_Gear.lua` | Master engaged hybrid mode — defaults to `sets.engaged.Pet` (Master + Pet dual-haste/stats) |
| `state.WeaponskillMode` | `'Match'`, `'Normal'`, `'Acc'`, `'FullAcc'`, `'Fodder'` | `*_Pup_Gear.lua` | Master WS set selection |
| `state.IdleMode` | `'Normal'`, `'PDT'`, `'Refresh'` | `*_Pup_Gear.lua` | Idle set when pet is not engaged |
| `state.PhysicalDefenseMode` | `'PDT'` | `*_Pup_Gear.lua` | `F10` master PDT lock |
| `state.Weapons` | `Gimlic`: `'PetWeapons'`, `'None'`, `'Godhands'`, `'Xiucoatl'`, `'Trial'` *(others: `'None'`, `'Godhands'`, `'PetWeapons'`)* | `*_Pup_Gear.lua` | Main H2H weapon + `Animator P +1` (`Gimlic` defaults to `PetWeapons` = `Kenkonken`) |
| `state.PetMode` | `'None'`, `'Melee'`, `'Ranged'`, `'HybridRanged'`, `'Tank'`, `'LightTank'`, `'Magic'`, `'Heal'`, `'Nuke'` | `PUP.lua` | Current automaton combat role; auto-detected from Head + Frame when `AutoPetMode` is `true` |
| `state.AutoManeuvers` | `'Default'`, `'Melee'`, `'Ranged'`, `'HybridRanged'`, `'Tank'`, `'LightTank'`, `'Magic'`, `'Heal'`, `'Nuke'` | `PUP.lua` | Which `defaultManeuvers` preset `AutoBuffMode` maintains (`'Default'` follows `state.PetMode`) |
| `state.AutoPuppetMode` | `false` (bool) | `PUP.lua` | Auto-casts `Activate` / `Deus Ex Automata`, auto-`Deploy`s on monster target, and `Deactivate`s low-MP mage pets |
| `state.AutoRepairMode` | `true` (bool) | `PUP.lua` | Automatically casts `Repair` (with `Automat. Oil +3`) when `pet.hpp < repairhpp` (`45%`) |
| `state.AutoDeployMode` | `true` (bool) | `PUP.lua` | Automatically sends `/pet Deploy <t>` when Master engages a monster within 20 yalms while pet is idle |
| `state.AutoPetMode` | `true` (bool) | `PUP.lua` | Automatically updates `state.PetMode` whenever pet is summoned/changed |
| `state.PetWSGear` | `true` (bool) | `PUP.lua` | Predictively swaps into `sets.midcast.Pet.PetWSGear[PetMode]` whenever `pet.tp >= 1000` |
| `state.PetEnmityGear` | `true` (bool) | `PUP.lua` | Predictively swaps into `sets.midcast.Pet.PetEnmityGear` when Pet `Provoke` (`Fire`) or `Flashbulb` (`Light`) recast is up |
| `state.PartyChatWS` | `false` (bool) | `PUP.lua` | Announces automaton weaponskills in `/p` using auto-translate |

### Job-Specific Keybinds (`*_Pup_Gear.lua`)

| Keybind | Command | Action |
| :--- | :--- | :--- |
| `Win+~` (`@` + `` ` ``) | `gs c cycle SkillchainMode` | Cycle Skillchain helper mode |
| `Win+F8` | `gs c toggle AutoPuppetMode` | Toggle automatic `Activate` / `Deus Ex Automata` / `Deploy` / MP-`Deactivate` |
| `Win+F7` | `gs c toggle AutoRepairMode` | Toggle automatic `Repair` below `45%` pet HP |
| `Win+Pause` *(global)* | `gs c cycle AutoBuffMode` | Toggle automatic Maneuver upkeep while pet is engaged |

---

## Job-Specific Commands (`//gs c ...`)

| Command | Arguments | Behavior | Macro Example |
| :--- | :--- | :--- | :--- |
| `//gs c maneuver` | None | Checks `defaultManeuvers[state.PetMode]` in order and casts the first maneuver whose active count is below its target `Amount`. Prints `"Current Maneuvers match Default"` if all match. | `/con gs c maneuver` |
| `//gs c maneuver <1..8>` | Slot index `1`–`8` | Directly fires the `N`th maneuver listed in `defaultManeuvers[state.PetMode]`. | `/con gs c maneuver 1` |
| `//gs c set PetMode <Mode>` | `Melee`, `Ranged`, `HybridRanged`, `Tank`, `LightTank`, `Magic`, `Heal`, `Nuke` | Manually overrides `state.PetMode` (turn off `AutoPetMode` if you don't want auto-detection to overwrite it on summon). | `/con gs c set PetMode Tank` |
| `//gs c set AutoManeuvers <Preset>` | `Default` or any PetMode name | Overrides which maneuver preset `AutoBuffMode` maintains independently of detected `PetMode`. | `/con gs c set AutoManeuvers LightTank` |
| `//gs c toggle PetWSGear` | None | Enables/disables predictive `PetWSGear` swap at `pet.tp >= 1000`. | `/con gs c toggle PetWSGear` |
| `//gs c toggle PetEnmityGear` | None | Enables/disables predictive `PetEnmityGear` swap for `Provoke`/`Flashbulb`. | `/con gs c toggle PetEnmityGear` |
| `//gs c toggle AutoDeployMode` | None | Toggles automatic `/pet Deploy <t>` when Master engages. | `/con gs c toggle AutoDeployMode` |
| `//gs c toggle PartyChatWS` | None | Toggles `/p` announcement of automaton weaponskills. | `/con gs c toggle PartyChatWS` |
| `//gs c autows <WS>` | e.g., `Stringing Pummel`, `Victory Smite`, `Shijin Spiral` | Changes `autows` (Gimlic defaults to `Stringing Pummel`). | `/con gs c autows Victory Smite` |

---

## How the Job Logic Works (`PUP.lua`)

### Automaton Role Detection (`get_pet_mode`, lines 329–369)

Whenever `job_pet_change` fires (and `AutoPetMode` is `true`), `PUP.lua` inspects `pet.frame` and `pet.head` to assign `state.PetMode`:

| Automaton Frame | Automaton Head | Detected `state.PetMode` |
| :--- | :--- | :--- |
| `Sharpshot Frame` | `Valoredge Head` or `Harlequin Head` | `HybridRanged` |
| `Sharpshot Frame` | Any other head (`Sharpshot`, etc.) | `Ranged` |
| `Valoredge Frame` | `Soulsoother Head` | `Tank` |
| `Valoredge Frame` | Any other head (`Valoredge`, etc.) | `Melee` |
| Any non-Sharpshot/Valoredge | `Sharpshot Head` or `Stormwaker Head` | `Magic` |
| Any non-Sharpshot/Valoredge | `Spiritreaver Head` | `Nuke` |
| `Harlequin Frame` | `Harlequin Head` | `Melee` |
| `Harlequin Frame` | Any other head (not caught above) | `LightTank` |
| `Stormwaker Frame` | `Soulsoother Head` / `Valoredge Head` / other | `Heal` / `Melee` / `Magic` |

### Predictive Pet WS & Pet Enmity Swapping

Because FFXI's packet timing for automaton weaponskills and `Provoke`/`Flashbulb` arrives too late for normal `pet_midcast` gear swaps to count, `PUP.lua` uses **predictive swapping** inside `job_customize_idle_set()` (lines 226–254) and `job_customize_melee_set()` (lines 256–271):

1. **Pet WS Predictive Swap (`PetWSGear`):**
   - `job_tick()` watches `pet.tp` every tick; the moment `pet.tp` crosses `1000` (upward or downward), it runs `gs c update`.
   - When `pet.status == 'Engaged'` and `pet.tp > 999`:
     - If Master is **Idle**, swaps into `sets.midcast.Pet.PetWSGear[state.PetMode]` (overlays `sets.buff.Overdrive` if `Overdrive` is active).
     - If Master is **Engaged**, swaps into `PetWSGear` **only while `player.tp < 999`** (so Master's own WS gear isn't disrupted).
2. **Pet Enmity Predictive Swap (`PetEnmityGear`):**
   - A raw `action` event listener (lines 151–162) tracks automaton `category 11` actions:
     - `param == 1945` (**Provoke**) → sets `PupVokeReady = os.clock() + 23` (`PupVokeRecast = 23s`) and triggers `gs c forceequip`.
     - `param == 1947` (**Flashbulb**) → sets `PupFlashReady = os.clock() + 38` (`PupFlashRecast = 38s`) and triggers `gs c forceequip`.
   - Whenever `PupVokeReady < now` with a `Fire Maneuver` active OR `PupFlashReady < now` with a `Light Maneuver` active, equips `sets.midcast.Pet.PetEnmityGear` until the automaton fires the enmity move.
3. **Pet Magic Midcast (`job_pet_midcast`, lines 134–149):** Only equips standard `sets.midcast.Pet.*` sets for pet **magic** (`Cure`, `Enfeebling Magic`, `Elemental Magic`).
4. **Master Kenkonken AM3 Group (`update_melee_groups`, lines 392–400):** Appends `'AM'` to `classes.CustomMeleeGroups` whenever `main == "Kenkonken"` and `Aftermath: Lv.3` is active.
5. **Auto-Deploy (`job_status_change`, lines 187–191):** Engaging a monster within `20` yalms while pet is Idle auto-sends `/pet Deploy <t>` when `AutoDeployMode` is `true`.

### Tick Automation (`job_tick`, lines 309–322)

Runs in strict priority order:
1. **`check_repair()` (lines 435–448):** If `AutoRepairMode` is `true`, `pet.hpp < 45` (`repairhpp`), `Repair` (ID `206`) is ready, and `Automat. Oil +3` is available → fires `/ja "Repair" <me>`.
2. **`check_auto_pet()` (lines 402–433):** When `AutoPuppetMode` is `true` outside cities:
   - No pet → fires `Activate` (ID `205`), else `Deus Ex Automata` (ID `115`).
   - Pet is Idle & mage (`pet.max_mp > 50`) & `pet.mpp < 10` & `pet.hpp >= deactivatehpp` (`85%` on Gimlic) → fires `Deactivate` (ID `208`) to reset MP.
   - Pet is Idle & player targets a `MONSTER` → fires `/pet "Deploy" <t>` (ID `207`).
3. **`check_maneuver()` (lines 450–473):** When `AutoBuffMode ~= 'Off'` and pet is `Engaged` and Maneuver recast (ID `210`) is ready, scans `defaultManeuvers[state.AutoManeuvers or state.PetMode]` and fires any maneuver whose active buff count is below `Amount`.
4. **Pet TP Crossing Watch:** Triggers `gs c update` whenever `pet.tp` crosses `1000`.

> [!WARNING]
> **Code Bugs & Gotchas Discovered in `Gimlic_Pup_Gear.lua`**
> 1. **Line 94 (`sets.precast.JA['Overdrive']`):** Has typo `bdoy="Pitre Tobe +3"` instead of `body="Pitre Tobe +3"`, so `Pitre Tobe +3` does **not** swap on Overdrive precast!
> 2. **Line 96 (`sets.precast.JA['Role Reversal']`):** Lists `feet="Pitre Churidars +3"` — `Pitre Churidars +3` are **legs**, while `Role Reversal` is actually enhanced by **`Pitre Babouches +3`** (which Gimlic owns in `PorterPacker/data/Gimlic_PUP.lua`!).
> 3. **`sets.midcast.Pet.PetEnmityGear = {}` is empty:** Even though `state.PetEnmityGear` defaults to `true`, no enmity gear is assigned to this set yet.
> 4. **Duplicate `sets.precast.WS['Asuran Fists']`:** Defined twice (lines 144–147 and 159–162 — harmless, inherited from Selindrile template).
> 5. **`sets.engaged.DT` uses WS gear:** Inherited from Selindrile's template (`Lilitu Headpiece`, `Caro Necklace`, `herculean_wsd_body`), so `HybridMode = DT` currently swaps into WS gear rather than Master DT gear (`Malignance` / `Mpaca's`).

---

## Character Customizations & Key Gear Sets

### Gimlic (`Gimlic_Pup_Gear.lua` + `Gimlic-Items.lua` + `PorterPacker\Gimlic_PUP.lua`)

- **Weapons & REMA:**
  - `sets.weapons.PetWeapons` *(default)*: **`Kenkonken`** (Mythic H2H) + `Animator P +1`
  - `sets.weapons.Godhands`: **`Godhands`** (Aeonic H2H) + `Animator P +1`
  - `sets.weapons.Xiucoatl`: **`Xiucoatl`** (Oboro Su5 H2H) + `Animator P +1`
  - `sets.weapons.Trial`: `Knuckles of Trials` + `Animator P +1`
- **Custom Maneuver Overrides (`defaultManeuvers`):**
  - **`Tank` (customized by Kevin):** **`Fire x1`**, **`Light x1`**, **`Water x1`** (changed from stock `Earth x1, Fire x1, Light x1` — noted with inline comments `--normally 1` on Earth and `-- normally 0` on Water, likely for Overdrive / magic-heavy or Regen/Auto-Repair-focused tanking).
  - Other presets follow stock defaults: `Melee` (`Fire/Thunder/Wind`), `Ranged` (`Wind x3`), `HybridRanged` (`Wind/Fire/Light`), `LightTank` (`Earth/Fire/Light`), `Magic` (`Light/Ice/Dark`), `Heal` (`Light x2 / Dark`), `Nuke` (`Ice x2 / Dark`).
- **Full JSE +3 & Empyrean +1 Wardrobe (tracked in `PorterPacker/data/Gimlic_PUP.lua`):**
  - **Artifact (`Foire +3`):** Full 5/5 `+3` (`Foire Taj/Tobe/Dastanas/Churidars/Babouches +3`)
  - **Relic (`Pitre +3`):** Full 5/5 `+3` (`Pitre Taj/Tobe/Dastanas/Churidars/Babouches +3`)
  - **Empyrean (`Karagoz +1`):** Full 5/5 `+1` (`Karagoz Cappello/Farsetto/Guanti/Pantaloni/Scarpe +1`)
  - **Odyssey / Ambuscade / Other:** `Mpaca's Cap`, `Mpaca's Gloves`, `Mpaca's Boots`, `Tali'ah Turban/Sera. +2`, `Hizamaru +2` (5/5), `Malignance Gloves/Boots`, `Anwig Salade`, `Taeon` Pet-DT Tank pieces (`Tabard`, `Gloves`, `Tights`, `Boots`), `Buffoon's Collar +1`, `Shulmanu Collar`, `Klouskap Sash +1`, `Visucius's Mantle`, `Dispersal Mantle`, `Enmerkar Earring`, `Handler's Earring +1`, `Domesticator's Earring`, `Rimeice Earring`, dual `Varar Ring +1`, `C. Palug Ring`.
- **Key Sets Summary:**
  - **JA Enhancers:** `Maneuver` (`Karagoz Farsetto +1`, `Foire Dastanas +3`, `Visucius's Mantle`, `Buffoon's Collar +1`), `Repair` (`Automat. Oil +3`, `Foire Babouches +3`), `Tactical Switch` (`Karagoz Scarpe +1`), `Ventriloquy` (`Foire Churidars +3`), `Overdrive` (`Pitre Tobe +3` — fix `bdoy` typo), `Role Reversal` (should be `Pitre Babouches +3`).
  - **Pet Engaged Idle (`sets.idle.Pet.Engaged`):** `Pitre Taj/Tobe/Dastanas +3` + `Foire Churidars +3` + `Mpaca's Boots` + `Shulmanu Collar` + `Enmerkar` / `Domesticator's Earring` + dual `Varar Ring +1` + `Visucius's Mantle` + `Klouskap Sash +1`.
  - **Pet Tank Engaged (`Tank` / `LightTank`):** Overlays `Anwig Salade` (`Pet: DT-10%`), `Taeon Gloves/Tights/Boots`, `Handler's Earring +1`, and `Isa Belt`.
  - **Predictive `PetWSGear`:** `Karagoz Cappello +1` + `Shulmanu Collar` + `Enmerkar` / `Handler's +1` + `Taeon Tabard` + `Mpaca's Gloves/Boots` + dual `Varar Ring +1` (`C. Palug Ring` on `Melee`) + `Dispersal Mantle` + `Incarnation Sash` + `Tali'ah Sera. +2`.
  - **Master + Pet Engaged (`sets.engaged.Pet`, default HybridMode):** `Tali'ah Turban +2` + `Shulmanu Collar` + `Rimeice` / `Enmerkar Earring` + `Pitre Tobe/Dastanas +3` + `Niqmaddu` / `Epona's Ring` + `Visucius's Mantle` + `Klouskap Sash +1` + `Karagoz Pantaloni +1` + `Mpaca's Boots`.
  - **Master WS (`sets.precast.WS` / `Stringing Pummel`):** `Mpaca's Cap` + `Foire Tobe +3` + `Pitre Dastanas +3` + `Hiza. Hizayoroi +2` + `Herculean Boots` (`TA+4`) + `Niqmaddu` / `Regal Ring` + `Moonshade` / `Brutal Earring` + `Visucius's Mantle` (`Stringing Pummel` swaps `Fotia Gorget` + `Fotia Belt`).
- **Setup & Lockstyle:** `autows = "Stringing Pummel"`, `deactivatehpp = 85`, Macro Book `20` Page `2`, `/lockstyleset 9` (Santa `7`, Swimsuit `8`, Halloween `10`), auto-loads `Skillchains`.

### Voicelessbicep, Balullu & Friendlessvirus (Alt Summary)

- `Voicelessbicep_Pup_Gear.lua`, `Balullu_Pup_Gear.lua`, and `Friendlessvirus_Pup_Gear.lua` are **byte-for-byte identical** older Selindrile baseline templates (`Ohtas` / `Godhands`, stock `Earth/Fire/Light` Tank maneuvers, `Cirque Scarpe +2`, `Midnights` on Maneuver, `Anwig Salade` + `Taeon Tabard` + `Tali'ah +2`, no `set_lockstyle()`).

---

## Related Notes

- [FFXI GearSwap and Character Profiles](./README.md)
- `FFXI Windower Overview`
- [FFXI Addon — GearSwap](./GearSwap-Engine.md)
- `FFXI Addon — autocontrol`
- `FFXI Addon — PetTP`
- `FFXI Addon — PorterPacker`
