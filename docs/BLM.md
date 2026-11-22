# FFXI GearSwap — BLM (Black Mage)

> [!NOTE]
> **Quick Reference**
> - **Logic File:** [BLM.lua](file:///C:/Windower/addons/GearSwap/data/BLM.lua)
> - **Defaults (`BLM.lua`):** `autows = 'Myrkr'` | `autofood = 'Pear Crepe'` | `state.DeathMode = 'Off'` | `state.AutoManawell = true` | `state.RecoverMode = '35%'`
> - **Character Customization Status:**
>   - `Gimlic`, `Balullu`, `Friendlessvirus`: **CUSTOM** *(identical across all three; 179 diff lines vs upstream `Selindrile_Blm_Gear.lua`)*
>   - `Voicelessbicep`: **STOCK** *(matches `Selindrile_Blm_Gear.lua`)*

---

## Job-Specific Modes & Keybinds

### States (`BLM.lua` & `user_job_setup`)
- `state.DeathMode`: `Off`, `Single`, `Lock` (resets after `Death` cast when set to `Single`)
- `state.AutoManawell`: `true` / `false` (auto-uses `Manawell` before `Impact` or high-cost `OccultAcumen` spells when MP is insufficient)
- `state.RecoverMode`: `35%`, `60%`, `Always`, `Never` (equips `sets.RecoverMP` / `sets.RecoverBurst` when MPP is below threshold and neither `Manafont` nor `Manawell` is active)
- `state.CastingMode` *(custom override)*: `Normal`, `Resistant`, `Fodder`, `Proc`, `OccultAcumen`
- `state.IdleMode` *(custom override)*: `Normal`, `PDT`, `DTHippo`
- `state.OffenseMode` *(custom override)*: `Normal` (no `HybridMode` override)
- `state.Weapons` *(custom override)*: `None`, `BurstWeapons`, `Khatvanga`, `Lathi`

### Local Keybinds (`Gimlic` / `Balullu` / `Friendlessvirus` & Stock)
| Keybind | Command | Function |
| :--- | :--- | :--- |
| ``Ctrl+` `` / ``Shift+Ctrl+` `` | `gs c cycle ElementalMode` / `cycleback ElementalMode` | Cycle active nuke element |
| ``Alt+` `` | `/ma "Aspir III" <t>` | Cast Aspir III |
| ``Win+` `` | `gs c cycle MagicBurstMode` | Cycle `Off` / `Single` / `Lock` |
| `Ctrl+Q` | `gs c weapons Khatvanga;gs c set CastingMode OccultAcumen` | Switch to Khatvanga + Occult Acumen |
| `Alt+Q` | `gs c weapons Default;gs c reset CastingMode;gs c reset DeathMode;gs c reset MagicBurstMode` | Reset weapons & casting/death/burst modes |
| `Alt+R` | `gs c set DeathMode Single;gs c set MagicBurstMode Single` | Prep single Death + Magic Burst |
| `Win+F9` | `gs c cycle DeathMode` | Cycle Death mode |
| `Win+F10` | `gs c cycle RecoverMode` | Cycle MP recovery mode (`Spaekona's Coat +3`) |
| `Alt+\` | `/ja "Manawell" <me>` | Activate Manawell |
| ``Ctrl+Win+` `` | `/ja "Parsimony" <me>` | SCH subjob Parsimony |
| `Alt+Pause` | `gs c toggle AutoSubMode` | Toggle auto Sublimation + Myrkr |
| `Ctrl+Backspace` / `Alt+Backspace` / `Win+Backspace` | `/ma "Stun" <t>` / `/ja "Enmity Douse" <t>` / `/ja "Alacrity" <me>` | Stun / Enmity Douse / Alacrity |
| `Alt+=` / `Win+=` | `/ja "Light Arts" <me>` / `/ja "Addendum: White" <me>` | SCH Light Arts / Addendum: White |
| `Ctrl+Del` / `Alt+Del` / `Win+Del` | `/ja "Dark Arts" <me>` / `/ja "Addendum: Black" <me>` / `/ja "Manifestation" <me>` | SCH Dark Arts / Addendum: Black / Manifestation |

---

## Job-Specific Commands (`//gs c ...`)

`job_self_command` routes `//gs c elemental <subcommand> [target]` to `handle_elemental`:
- `//gs c elemental nuke [target]`: Casts `Banish II`/`Banish` (`Light`), `Comet` (`Dark`), or highest available single-target nuke (`VI` if >=100 JP spent, down through `I`) in current `ElementalMode`.
- `//gs c elemental smallnuke [target]`: Casts Tier II or Tier I nuke.
- `//gs c elemental tier1` .. `tier6 [target]`: Casts specific tier of current element.
- `//gs c elemental aga` / `aga1` / `aga2` / `aga3` / `aja [target]`: Casts highest available `-ja`/`-ga` or specific tier.
- `//gs c elemental ara [target]` | `helix [target]` | `ancientmagic [target]` | `ancientmagic2 [target]`: Casts `-ra`, Helix, AM I, or AM II.
- `//gs c elemental enfeeble [target]` | `bardsong [target]` | `ninjutsu [target]`: Casts elemental enfeeble, Threnody, or `: Ni` ninjutsu.
- `//gs c elemental spikes` | `enspell` | `weather`: Self-casts Spikes, Enspell, or SCH Storm (or `Klimaform` if Storm is active; `Phalanx` if `/RDM`).

---

## Job Logic Highlights (`BLM.lua`)

- **Pretarget Auto-Manawell:** If `state.AutoManawell` is enabled, cancels `Impact` (or `OccultAcumen` spells `Impact`, `Meteor`, `Thundaja`, `Blizzaja`, `Firaja`, `Thunder VI`, `Blizzard VI` when `actual_cost(spell) > player.mp`), triggers `/ja "Manawell" <me>`, and reschedules the spell 1s later.
- **Precast & Custom Classes:** Sets `gear.default.obi_back` / `obi_waist` for Cure, LowTierNuke/Helix, or HighTierNuke/`Death`/`Comet`. Sets `classes.CustomClass` to `Death`, `Proc`, or `OccultAcumen`. Forces `sets.precast.FC.Death` in `job_post_precast` when `DeathMode ~= 'Off'` and swaps Moonshade Earring at `>3200` effective TP.
- **Midcast Layering:** Handles non-`Death` spells during `DeathMode` using `.Death` variants (falling back to `sets.precast.FC.Death`). For nukes, layers `MagicBurst` / `ResistantMagicBurst`, `Sorcerer's Ring` (Fodder, `<75%` HP, `<1000` TP), `Zodiac Ring` (Fodder on matching day), `sets.element[spell.element]`, and `sets.RecoverMP` / `sets.RecoverBurst` / `sets.ResistantRecoverBurst` based on `RecoverMode`. Keeps `sets.buff['Mana Wall']` equipped during DT/Tank idle in combat.
- **Aftercast & Timers:** Creates 60s (`Sleep`/`Sleepga`) and 90s (`Sleep II`/`Sleepga II`) Windower timers; resets `DeathMode` after `Death` when set to `Single`.
- **Idle/Melee/Defense & Tick:** Applies `Sublimation` / `DTSublimation`, `latent_refresh` (`<51%` MPP), `latent_refresh_grip` (staff + unlocked weapons), `TPEat`, `idle.Death`, and `sets.buff['Mana Wall']`. `job_tick` auto-maintains `Dark Arts` (`/SCH`, out of cities) and runs `check_buff` (`Reraise`, `Haste`, `Refresh`, `Stoneskin`, `Klimaform`) and `check_buffup`.

---

## Character Customizations

### `Gimlic` / `Balullu` / `Friendlessvirus` (CUSTOM — identical files)
- **Macro Book:** `set_macro_page(1, 7)` (all subjobs).
- **Weapon Sets:**
  - `BurstWeapons`: `{main=gear.grioavolr_nuke_staff, sub="Enki Strap"}`
  - `Lathi`: `{main="Lathi", sub="Enki Strap"}`
  - `Khatvanga`: `{main="Khatvanga", sub="Bloodrain Strap"}`
- **Custom Setup & Waists:** Adds `Fodder` to `state.CastingMode`; drops `state.HybridMode` override; sets `gear.obi_cure_waist = "Witful Belt"`, `gear.obi_low_nuke_waist = "Sekhmet Corset"`, `gear.obi_high_nuke_waist = "Refoccilation Stone"`.
- **Custom Capes:** `gear.nuke_jse_back` (`Taranus's Cape`, INT+20, M.Acc/M.Dmg+20, INT+10, MAB+10) and `gear.stp_jse_back` (`Taranus's Cape`, DEX+20, Acc/Atk+20, Store TP+10).
- **Key Gear Overrides vs Stock Template:** Uses pre-Odyssey/pre-Agwu gear across nuking, enfeebling, idle, and DT sets (`Daybreak` + `Ammurapi Shield` and `Lathi` + `Enki Strap` instead of `Bunzi's Rod` / `Mpaca's Staff`; `gear.merlinic_nuke_body`/`feet`, `Mallquis Cuffs +2`, `Jhakri` WS/idle pieces, `Hagondes Hat +1`/`Cuffs +1`/`Pants +1` PDT/MDT, `Bolelabunga` + `Genmei Shield` idle, `Ea Hat`/`Ea Houppelande`/`Ea Slops` + `Grioavolr` for `MagicBurst`, `Spaekona's Coat +3` for `RecoverMP`, `Khatvanga` + `Seraphic Ampulla` + `Merlinic` occult pieces for `OccultAcumen`, `Blistering Sallet +1` for `HPCure`).

### `Voicelessbicep` (STOCK)
- Unmodified copy of `Selindrile_Blm_Gear.lua` (newer upstream baseline with `Bunzi's Rod`, `Mpaca's Staff`, `Nyame`, `Agwu's`, `Ea +1`, `Amalric Doublet +1`, and `sets.engaged.DT`).

---

## Related Notes

- [FFXI GearSwap and Character Profiles](./README.md)
- `FFXI Windower Overview`
- [FFXI Addon — GearSwap](./GearSwap-Engine.md)
