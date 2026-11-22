# FFXI GearSwap and Character Profiles

> [!NOTE]
> **Quick Reference**
> - **Framework:** [Selindrile/GearSwap](https://github.com/Selindrile/GearSwap) (`GearSwap v0.940`, cloned directly in `C:\Windower\addons\GearSwap\`)
> - **Required Dependencies:** Addons `Shortcuts`, `Cancel`, `Itemizer` | Plugins `Timers`, `Run` *(all autoloaded)*
> - **Data Path:** `C:\Windower\addons\GearSwap\data\`
> - **Character Folders:** `Gimlic`, `Voicelessbicep`, `Balullu`, `Friendlessvirus` (plus templates in `Selindrile/`, shared globals in `User/`, and non-Sel luas in `common/`)

Reference for the local Selindrile GearSwap architecture, character job coverage, shared defaults, and combat/automation keybinds.

---

## Character Roster & Job Files (`addons/GearSwap/data/`)

Each character uses Selindrile's split architecture: top-level `JOB.lua` logic files automatically load `<Character>/<Character>_<Job>_Gear.lua`, `<Character>-globals.lua`, `<Character>-Items.lua`, and `<Character>_Crafting.lua`.

| Character / Folder | Job Gear Files | Extras |
| :--- | :--- | :--- |
| **`Gimlic`** | `13` jobs: `BLM`, `BLU`, `BRD`, `BST`, `DRG`, `GEO`, `MNK`, `PLD`, `PUP`, `SCH`, `THF`, `WAR`, `WHM` | `Gimlic-globals.lua`, `Gimlic-Items.lua`, `Gimlic_Crafting.lua`, `Saves/` |
| **`Voicelessbicep`** *(alias `bic`)* | All `22` jobs (`BLM` through `WHM`) | `Voicelessbicep-globals.lua`, `Voicelessbicep-Items.lua`, `Voicelessbicep_Crafting.lua`, `Saves/` |
| **`Balullu`** | All `22` jobs (`BLM` through `WHM`) | `Balullu-globals.lua`, `Balullu-Items.lua`, `Balullu_Crafting.lua`, `Rename.bat` |
| **`Friendlessvirus`** | All `22` jobs (`BLM` through `WHM`) | `Friendlessvirus-globals.lua`, `Friendlessvirus-Items.lua`, `Friendlessvirus_Crafting.lua`, `Rename.bat` |
| **`User/`** | Cross-character shared `user-globals.lua` | Fallback/global settings & binds |
| **`common/`** | Non-Selindrile GearSwaps (`Character_Job.lua` naming) | `skillup.lua` + `Gearswap-Skillup-master/` |
| **`Selindrile/`** | Upstream reference templates (`Rename.bat` for cloning to a new char) | Keep unmodified as clean baseline |

---

## Job-by-Job Deep-Dive Notes (`Notes/Gaming/FFXI/GearSwap/`)

Every job below has its own dedicated note covering all Selindrile `<JOB>.lua` modes, keybinds, `//gs c ...` commands, automation logic, and your character-specific customizations.

### Flagship Heavily Tuned Jobs (WHM, GEO, PUP, DRG — plus PLD & THF)
| Job | Note | Customization Highlights |
| :--- | :--- | :--- |
| **WHM** | [FFXI GearSwap — WHM (White Mage)](./WHM.md) | Heavy custom gear on **Gimlic** (`Mjollnir`/`Yagrush`, `Theo +3`/`Piety +3`), **Voicelessbicep** (`Yagrush`), and **Balullu** (`Izcalli`) + custom `AutoHealMode` (`check_heal()`) & code gotchas |
| **GEO** | [FFXI GearSwap — GEO (Geomancer)](./GEO.md) | Flagship **Voicelessbicep** (`Idris` + `Dunna`, `Bagua +3`/`Geo +3`/`Nyame`) & **Gimlic** (`Bagua +3`/`Geo +3`), live Luopan/Indi HUD, `autoindi`/`autogeo`/`autoentrust` commands |
| **PUP** | [FFXI GearSwap — PUP (Puppetmaster)](./PUP.md) | Flagship **Gimlic** (`Kenkonken`/`Godhands`/`Xiucoatl`, `Foire +3`/`Pitre +3`/`Mpaca's`, custom `Tank` maneuvers, `PetMode` auto-detection & predictive `PetWSGear`) |
| **DRG** | [FFXI GearSwap — DRG (Dragoon)](./DRG.md) | Customized `DRG.lua` (`check_breath()`, auto-`Spirit Bond`), **Gimlic** (`Trishula`/`Gungnir`/`Naegling`, `Vishap +3`/`Ptero +3`/`Gleti's`) & **Voicelessbicep** (`Gungnir`/`Geirskogul`) |
| **PLD** | [FFXI GearSwap — PLD (Paladin)](./PLD.md) | Heavily customized on **Gimlic** (`Burtgang`/`Aegis`/`Sakpata`/`Cab +3`, `BurtgangTP()`), **Voicelessbicep**, and **Balullu`/`Friendlessvirus` |
| **THF** | [FFXI GearSwap — THF (Thief)](./THF.md) | Customized on all 4 characters (`Gimlic` `Savage Blade` / `Gleti's`, `Voicelessbicep` `Shark Bite`, `Balullu`/`Friendlessvirus` `Rudra's`) |

### All Other Jobs (Commands, Modes & Character Overrides)
| Job | Note | Customized Characters |
| :--- | :--- | :--- |
| **BLM** | [FFXI GearSwap — BLM (Black Mage)](./BLM.md) | `Gimlic`, `Balullu`, `Friendlessvirus` (`Voicelessbicep` stock) |
| **BLU** | [FFXI GearSwap — BLU (Blue Mage)](./BLU.md) | `Balullu`, `Friendlessvirus`; minimal `Gimlic` (`Voicelessbicep` stock) |
| **BRD** | [FFXI GearSwap — BRD (Bard)](./BRD.md) | `Gimlic`, `Balullu`, `Friendlessvirus` (`Voicelessbicep` stock) |
| **BST** | [FFXI GearSwap — BST (Beastmaster)](./BST.md) | `Gimlic`, `Balullu`, `Friendlessvirus` (`Voicelessbicep` stock) |
| **COR** | [FFXI GearSwap — COR (Corsair)](./COR.md) | `Voicelessbicep`, `Balullu`, `Friendlessvirus` (`Gimlic` none) |
| **DNC** | [FFXI GearSwap — DNC (Dancer)](./DNC.md) | `Balullu`, `Friendlessvirus` (`Voicelessbicep` stock, `Gimlic` none) |
| **DRK** | [FFXI GearSwap — DRK (Dark Knight)](./DRK.md) | Minimal `Balullu`, `Friendlessvirus` (`Voicelessbicep` stock, `Gimlic` none) |
| **MNK** | [FFXI GearSwap — MNK (Monk)](./MNK.md) | `Voicelessbicep`, `Balullu`, `Friendlessvirus` (`Gimlic` stock) |
| **NIN** | [FFXI GearSwap — NIN (Ninja)](./NIN.md) | `Balullu`, `Friendlessvirus` (`Voicelessbicep` stock, `Gimlic` none) |
| **RDM** | [FFXI GearSwap — RDM (Red Mage)](./RDM.md) | `Voicelessbicep`, `Balullu`, `Friendlessvirus` (`Gimlic` none) |
| **RNG** | [FFXI GearSwap — RNG (Ranger)](./RNG.md) | `Voicelessbicep`, `Balullu`, `Friendlessvirus` (`Gimlic` none) |
| **RUN** | [FFXI GearSwap — RUN (Rune Fencer)](./RUN.md) | `Balullu`, `Friendlessvirus` (`Voicelessbicep` stock, `Gimlic` none) |
| **SAM** | [FFXI GearSwap — SAM (Samurai)](./SAM.md) | `Balullu`, `Friendlessvirus` (`Voicelessbicep` stock, `Gimlic` none) |
| **SCH** | [FFXI GearSwap — SCH (Scholar)](./SCH.md) | `Gimlic`, `Balullu`, `Friendlessvirus` (`Voicelessbicep` stock) |
| **SMN** | [FFXI GearSwap — SMN (Summoner)](./SMN.md) | `Balullu`, `Friendlessvirus` (`Voicelessbicep` stock, `Gimlic` none) |
| **WAR** | [FFXI GearSwap — WAR (Warrior)](./WAR.md) | `Voicelessbicep`, `Balullu`, `Friendlessvirus` (`Gimlic` stock) |

---

## Global Defaults (`user-globals.lua` / Character Globals)

- `latency = 0.75` | `conserveshadows = false`
- `state.DisplayMode = true` (bottom-screen mode HUD)
- `state.ReEquip = true` (auto-reequip weapon set if disarmed/empty)
- `state.AutoArts = true` (auto-maintain Light/Dark Arts & Afflatus Solace)
- `state.AutoLockstyle = true` (auto-lockstyle on load and weapon swap)
- `state.CancelStoneskin = true` (auto-cancel Stoneskin when slept)
- `state.SkipProcWeapons = true` (hide Aby/Voidwatch proc weapon sets during normal cycling)
- `state.NotifyBuffs`: `false` in `User/user-globals.lua`, `true` in character overrides

---

## Selindrile GearSwap Keybind & Macro Cheat Sheet

*(From `C:\Windower\addons\GearSwap\data\Cheat Sheet.txt` & `user-globals.lua`)*

### Offense, Weapons & Automation
| Keybind | Console / Macro Command | Function |
| :--- | :--- | :--- |
| `F7` | `gs c cycle Weapons` | Cycle weapon sets |
| `Win+F7` | `gs c toggle RngHelper` | Automatic ranged attacks (`//gs c autows` sets WS) |
| `Ctrl+Alt+Win+F7` | `gs c toggle AutoWSMode` | Toggle automatic Weaponskill (`//gs c autows <WS>`, `//gs c autows tp 1250`) |
| `Ctrl+Alt+F7` | `gs c toggle AutoFoodMode` | Toggle automatic food usage |
| `Win+F8` | `gs c toggle AutoNukeMode` | Toggle auto-nuking on supported mage jobs |
| `Ctrl+F8` | `gs c toggle AutoStunMode` | Toggle auto-stun (uses `libs/Sel-MonsterAbilities.lua`) |
| `Alt+F8` | `gs c toggle AutoDefenseMode` | Auto-swap into defensive gear against listed monster TP moves |
| `Ctrl+Alt+Win+F8` | `gs c toggle AutoTrustMode` | Auto-summon Trusts |
| `Win+Pause` | `gs c toggle AutoBuffMode` | Toggle job-dependent auto-buffing (`//gs c autoindi Focus`, `//gs c autogeo Malaise`) |
| `F9` | `gs c cycle OffenseMode` | Cycle accuracy/offense tier (`Normal`, `Acc`, `Fodder`, etc.) |
| `Ctrl+F9` | `gs c cycle HybridMode` | Cycle hybrid melee/DT mode (`Normal`, `PDT`, `MDT`, etc.) |
| `Alt+F9` | `gs c cycle WeaponskillMode` | Cycle Weaponskill accuracy/damage mode |
| `Win+F9` | `gs c cycle RangedMode` | Cycle ranged accuracy mode |

### Defense, Idle, Casting & Utility
| Keybind | Console / Macro Command | Function |
| :--- | :--- | :--- |
| `F10` / `Ctrl+F10` | `gs c set DefenseMode Physical` / `cycle PhysicalDefenseMode` | Lock/cycle Physical defense ("Oh Shit" PDT/Evasion lock) |
| `Alt+F10` | `gs c toggle Kiting` | Lock movement-speed gear in idle/defense sets |
| `Win+F10` | Job-specific toggle | e.g., THF `AmbushMode`, BLU `LearningMode`, PLD/RUN `TankAutoDefense`, BRD `ExtraSongsMode` (`Ctrl+~`), BLM `MagicBurstMode` (`Win+~`) |
| `F11` / `Ctrl+F11` | `gs c set DefenseMode Magical` / `cycle MagicalDefenseMode` | Lock/cycle Magical defense (MDT / Magic Evasion) |
| `Alt+F11` | `gs c cycle ExtraDefenseMode` / `ExtraMeleeMode` | Job-specific extra defense (PLD) or extra melee modes |
| `Win+F11` | `gs c cycle CastingMode` | Cycle casting modes (Normal, Resistant, Fodder, Proc) |
| `F12` / `Ctrl+F12` | `gs c set DefenseMode Resist` / `cycle ResistDefenseMode` | Lock/cycle Resist defense (MEVA, Charm, Death) |
| `Win+F12` | `gs c cycle IdleMode` | Cycle idle sets (Refresh, Regen, PDT, etc.) |
| `Alt+F12` | `gs c reset DefenseMode` | Unlock active defense lock |
| `Pause/Break` | `gs c update user` | Refresh HUD display and re-equip current state gear |
| `Ctrl+Alt+Win+F12` | `gs reload` | Reload GearSwap to pick up `.lua` edits or reset states |
| `Ctrl+Alt+Win+Pause` | `gs org` | Run `Organizer` to pull current job's gear from storage |
| `Ctrl+T` | `gs c cycle TreasureMode` | Cycle Treasure Hunter mode (`Tag`, `Fulltime`, `SATA`) |
| `Alt+T` | `/target <bt>` | Target claimed battle target |
| `Alt+P` / `Win+P` | `gs equip sets.Self_Healing` / `sets.Sheltered` | Swap reactive Cure-Received / Sheltered Ring gear |
| `Ctrl+Z` | Capacity Mode | Auto-uses CP rings and keeps CP cape equipped |

> [!WARNING]
> **Capacity Mode (`Ctrl+Z`) & Item Usage Gotchas**
> - Keep Capacity Point items (`Mecisto. Mantle`, `Capacity/Trizek/Facility/Vocation Ring`) in **Inventory or Mog Satchel** — NOT in Mog Wardrobes. Wardrobes report incorrect recast timers to Selindrile's Capacity Mode check. Use `Ctrl+Win+Alt+Z` (pull from satchel) and `Ctrl+Alt+Z` (put back) from `init.txt`.
> - Usable item syntax: `gs c useitem <slot> <item name>` (e.g., `gs c useitem ring2 Warp Ring`, or `gs c useitem back "Hi-Ether Tank"` as used in `scripts/Ether.txt`).

---

## Related Notes

- `FFXI Windower Overview`
- `FFXI Windower Addons Catalog`
- `FFXI Custom Addons, Scripts, and Packet Notes`
