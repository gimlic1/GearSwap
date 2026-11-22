# FFXI GearSwap — SCH (Scholar)

> [!NOTE]
> **Quick Reference**
> - **Logic File:** `C:\Windower\addons\GearSwap\data\SCH.lua` (`1044` lines)
> - **Character Status:** `Gimlic` **CUSTOM** (~110 diff) | `Balullu` & `Friendlessvirus` **CUSTOM** (identical, ~108 diff) | `Voicelessbicep` **STOCK**
> - **Default AutoWS / Food (`SCH.lua`):** `autows = 'Realmrazer'` | `autofood = 'Pear Crepe'`
> - **Weapon Profiles (`Gimlic` / `Balullu` / `Friendlessvirus`):** `None`, `Akademos`, `Khatvanga`

Code and gear reference for `SCH.lua` stratagem mapping, Immanence skillchain macros, grimoire/burst logic, and character gear overrides.

---

## Job-Specific Modes & Keybinds

### Job States (`SCH.lua` & `user_job_setup`)
- **Job-level states (`SCH.lua`):**
  - `state.RecoverMode`: `'35%'`, `'60%'`, `'Always'`, `'Never'`
  - Tracks all 10 stratagems + `Klimaform`, `Sublimation: Activated`, and `Enlightenment` in `state.Buff`.
- **HUD Init (`init_job_states`):**
  - Left: `Capacity`, `AutoRuneMode`, `AutoTrustMode`, `AutoNukeMode`, `AutoWSMode`, `AutoShadowMode`, `AutoFoodMode`, `AutoStunMode`, `AutoDefenseMode`.
  - Right: `AutoBuffMode`, `Weapons`, `OffenseMode`, `WeaponskillMode`, `IdleMode`, `Passive`, `RuneElement`, `RecoverMode`, `ElementalMode`, `CastingMode`, `TreasureMode`.
- **Mode Options (`Gimlic` / `Balullu` / `Friendlessvirus`):**
  - `state.OffenseMode`: `'Normal'`
  - `state.CastingMode`: `'Normal'`, `'Resistant'`, `'Proc'`, `'OccultAcumen'`, `'9k'`
  - `state.IdleMode`: `'Normal'`, `'PDT'`
  - `state.HybridMode`: `'Normal'`, `'PDT'`
  - `state.Weapons`: `'None'`, `'Akademos'`, `'Khatvanga'`

### Local Keybinds (`user_job_setup()`)
| Keybind | Action | Purpose |
| :--- | :--- | :--- |
| `Ctrl+~` (`^`` `) | `gs c cycle ElementalMode` | Cycle active element |
| `Alt+~` (`!`` `) | `gs c scholar power` | `Rapture` (Light) / `Ebullience` (Dark) |
| `Win+~` (`@`` `) | `gs c cycle MagicBurstMode` | Cycle Magic Burst (`Off`, `Single`, `Lock`) |
| `Ctrl+Q` | `gs c weapons Khatvanga;gs c set CastingMode OccultAcumen` | Swap to Occult Acumen Khatvanga nuke mode |
| `Alt+Q` | `gs c weapons default;gs c reset CastingMode` | Restore default staff/casting mode |
| `Win+F10` | `gs c cycle RecoverMode` | Cycle MP recovery threshold |
| `Win+F8` | `gs c toggle AutoNukeMode` | Toggle auto-nuking |
| `Alt+Pause` | `gs c toggle AutoSubMode` | Toggle automatic `Sublimation` (+ `Myrkr`) upkeep |
| `Ctrl+Win+~` (`@^`` `) | `/ja "Parsimony" <me>` | Half MP cost (Dark Arts) |
| `Ctrl+Backspace` | `/ma "Stun" <t>` | Cast Stun |
| `Alt+Backspace` | `gs c scholar speed` | `Celerity` (Light) / `Alacrity` (Dark) |
| `Win+Backspace` | `gs c scholar aoe` | `Accession` (Light) / `Manifestation` (Dark) |
| `Ctrl+=` | `/ja "Dark Arts" <me>` | Activate Dark Arts |
| `Alt+=` | `/ja "Light Arts" <me>` | Activate Light Arts |
| `Ctrl+\` | `/ma "Protect V" <t>` | Cast Protect V |
| `Win+\` | `/ma "Shell V" <t>` | Cast Shell V |
| `Alt+\` | `/ma "Reraise III" <me>` | Cast Reraise III |

---

## Job-Specific Commands (`//gs c ...`)

- **`//gs c scholar <stratagem>`** — Arts-agnostic stratagem dispatcher:
  - `light` / `dark`: Activates `Light Arts` / `Dark Arts`, or `Addendum: White` / `Addendum: Black` if already in that Art.
  - `cost` (`Penury`/`Parsimony`), `speed` (`Celerity`/`Alacrity`), `aoe` (`Accession`/`Manifestation`), `power` (`Rapture`/`Ebullience`), `duration` (`Perpetuance`, Light only), `accuracy` (`Altruism`/`Focalization`), `enmity` (`Tranquility`/`Equanimity`), `skillchain` (`Immanence`, Dark only), `addendum` (`Addendum: White`/`Black`).
- **`//gs c showcharge`** — Prints `~~~Current Stratagem Charges Available: [N]~~~` (also auto-called `1s` after any `Scholar` JA).
- **`//gs c elemental <subcommand> [target]`**:
  - `nuke` / `smallnuke` / `tier1`..`tier6` / `ara` / `aga` / `helix` (`Helix II` at >= 1200 JP) / `enfeeble` / `bardsong` / `spikes` / `enspell` / `weather` (`Klimaform` if matching storm active, else `<Element>storm II` at > 99 JP).
  - `skillchain1`: 2-step Immanence SC + party `<scall21>` callout for `state.ElementalMode` (`Fire`→Liquefaction, `Wind`→Detonation, `Lightning`→Impaction, `Light`→Transfixion, `Earth`→Scission, `Ice`→Induration, `Water`→Reverberation, `Dark`→Compression).
  - `skillchain2`: 2-step Tier 2 Immanence SC (`Fire`/`Light`→Fusion, `Wind`/`Lightning`→Fragmentation, `Earth`/`Dark`→Gravitation, `Ice`/`Water`→Distortion).
  - `skillchain3`: 3-step Fire chain (`Liquefaction` → `Fusion`, Fire mode only).
  - `skillchain4` / `skillchain6`: Forces `CastingMode = 'Proc'` and executes a 4-step or 6-step Immanence chain.
  - `wsskillchain`: Opens with staff WS (`Rock Crusher`, `Starburst`, `Omniscience`, `Earth Crusher`, or `Shell Crusher`) and closes with `Immanence` + Tier 1 nuke/helix.
  - `endskillchain`: Closes an open SC with `Immanence` + element spell.

---

## Job Logic Highlights (`SCH.lua`)

- **`job_precast` & `job_post_precast`**:
  - Chooses `obi_cure_*`, `obi_low_nuke_*`, or `obi_high_nuke_*`.
  - Supports `Proc` and `OccultAcumen` custom classes; overlays `sets.precast.FC.Arts` when Arts are active; swaps `Moonshade Earring` at `> 3200` TP on WSs.
- **`job_post_midcast`**:
  - Calls `apply_grimoire_bonuses()`: applies `Perpetuance` (White Enhancing), `Rapture` (Cure/Curaga), `Penury`/`Parsimony`, and `Celerity`/`Alacrity` on matching weather.
  - Overlays `sets.buff['Light Arts']` / `['Dark Arts']` on Enfeebling Magic and Elemental Enfeebles.
  - On Elemental Magic (non-Impact): applies `HelixBurst` / `ResistantHelixBurst` or `MagicBurst` / `ResistantMagicBurst`; in non-Resistant mode applies `Zodiac Ring` (`Fodder` on matching day), `sets.buff['Klimaform']` (matching weather), `sets.element[spell.element]`, and `sets.buff['Ebullience']`; always checks `Immanence` (`sets.buff['Immanence']`) and `RecoverMode` (`RecoverBurst` / `RecoverMP`).
- **`job_customize_idle_set`**: Overlays `sets.buff.Sublimation` / `sets.buff.DTSublimation` when Sublimation is charging; applies `latent_refresh`, `latent_refresh_grip` (staff), and `TPEat` when `mpp < 51`.
- **`job_tick()`**:
  - `check_arts()`: Auto-activates `Dark Arts` when no Arts are active and `AutoArts` (in combat) or `AutoBuffMode` is on.
  - `check_buff()` (`Auto`: `Haste`, `Stoneskin`, `Klimaform` in combat) and `check_buffup()` (`Default` list).

---

## Character Customizations

- **`Voicelessbicep`:** **STOCK** (`Voicelessbicep_Sch_Gear.lua` matches `Selindrile_Sch_Gear.lua`).
- **`Gimlic` (`Gimlic_Sch_Gear.lua` — Custom, ~110 diff) & `Balullu` / `Friendlessvirus` (`Balullu_Sch_Gear.lua`, `Friendlessvirus_Sch_Gear.lua` — Identical Custom, ~108 diff):**
  - `Gimlic` and `Balullu`/`Friendlessvirus` share almost the exact same customization (only 3 lines differ in `sets.idle`).
  - **Shared Overrides vs Stock:**
    - `user_job_setup()`: Defines `obi_cure_back = "Tempered Cape +1"`, `obi_cure_waist = "Witful Belt"`, `obi_low_nuke_waist = "Refoccilation Stone"`, `obi_high_nuke_waist = "Refoccilation Stone"`.
    - `sets.MagicBurst`: Uses `{main="Akademos", sub="Enki Strap", neck="Mizu. Kubikazari", hands="Amalric Gages +1", ring1="Mujin Band", ring2="Locus Ring", feet="Jhakri Pigaches +2"}` (removes stock `Agwu`'s/`Bunzi's Rod` `MagicBurst`, `HelixBurst`, and `ResistantHelixBurst`).
    - `sets.midcast['Elemental Magic']` & `sets.midcast.Helix`: Replaces `Bunzi's Rod`, `Agwu's Cap`/`Pigaches`, `Amalric Doublet +1`, `Amalric Nails +1`, and `Ghastly Tathlum +1` with `Daybreak` + `Ammurapi Shield`, `Dosis Tathlum`, `gear.merlinic_nuke_head` / `body` / `feet`, `Mallquis Cuffs +2`, and `gear.ElementalObi`.
    - `sets.midcast['Dia II']` & `sets.midcast['Bio II']`: Combined with `sets.TreasureHunter`.
    - `sets.precast.WS['Myrkr']`: Uses `Staunch Tathlum +1`, `Amalric Doublet` (NQ), `Yamabuki-no-Obi`, `Medium's Sabots`.
    - `sets.idle`: Uses `Bolelabunga` + `Genmei Shield` (instead of `Mpaca's Staff` + `Umbra Strap`); `sets.idle.PDT` / `defense.PDT` / `defense.MDT` / `engaged.PDT` use `Hagondes Pants +1` and `Flax Sash` (instead of `Nyame Flanchard` and `Carrier's Sash`).
  - **Difference between `Gimlic` and `Balullu`/`Friendlessvirus`:**
    - `Gimlic` `sets.idle`: `body="Shamash Robe"`, `back="Moonbeam Cape"`.
    - `Balullu`/`Friendlessvirus` `sets.idle`: `body="Jhakri Robe +2"`, `back="Umbra Cape"`.
  - **Macro Book:** Book `18`, page `1` for all subjobs.

---

## Related Notes

- [FFXI GearSwap and Character Profiles](./README.md)
- `FFXI Windower Overview`
- `FFXI Windower Addons Catalog`
- [FFXI Addon — GearSwap](./GearSwap-Engine.md)
