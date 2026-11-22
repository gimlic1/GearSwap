# FFXI GearSwap — SMN (Summoner)

> [!NOTE]
> **Quick Reference**
> - **Logic File:** `C:\Windower\addons\GearSwap\data\SMN.lua` (`943` lines)
> - **Character Status:** `Balullu` & `Friendlessvirus` **CUSTOM** (identical, ~54 diff) | `Voicelessbicep` **STOCK** | `Gimlic` **NONE**
> - **Default AutoWS / Food (`SMN.lua`):** `autows = 'Spirit Taker'` | `autofood = 'Akamochi'`
> - **Weapon Profiles (`Balullu` / `Friendlessvirus`):** `None`, `Gridarvor` (`Gridarvor`/`Elan Strap +1`), `Khatvanga` (`Khatvanga`/`Bloodrain Strap`)

Code and gear reference for `SMN.lua` Blood Pact routing, Astral Conduit gear locking, Elemental Siphon automation, and `Balullu`/`Friendlessvirus` gear overrides.

---

## Job-Specific Modes & Keybinds

### Job States (`SMN.lua` & `user_job_setup`)
- **Job-level toggles (`SMN.lua`):**
  - `state.PactSpamMode` (default `false`): Re-fires the last `BloodPactRage` immediately when BP Rage recast hits `0` in `job_pet_aftercast`.
  - `state.AutoFavor` (default `true`): Maintains `Avatar's Favor` whenever a pet is summoned.
  - `state.AutoConvert` (default `true`): Triggers `/ja Convert <me>` on `/RDM` during `Astral Conduit` if MP is insufficient for two pacts.
  - `ConduitLock` (default `true`): Locks all pet midcast gear slots while `Astral Conduit` is active to prevent swap lag between rapid pacts.
- **HUD Init (`init_job_states`):**
  - Left: `Capacity`, `AutoRuneMode`, `AutoTrustMode`, `AutoNukeMode`, `PactSpamMode`, `AutoWSMode`, `AutoShadowMode`, `AutoFoodMode`, `AutoStunMode`, `AutoDefenseMode`.
  - Right: `AutoBuffMode`, `Weapons`, `OffenseMode`, `WeaponskillMode`, `IdleMode`, `Passive`, `RuneElement`, `ElementalMode`, `CastingMode`, `TreasureMode`.
- **Mode Options (`Balullu` / `Friendlessvirus`):**
  - `state.OffenseMode`: `'Normal'`, `'Acc'`
  - `state.CastingMode`: `'Normal'`, `'Resistant'`, `'OccultAcumen'`
  - `state.IdleMode`: `'Normal'`, `'PDT'`
  - `state.Weapons`: `'None'`, `'Gridarvor'`, `'Khatvanga'`

### Local Keybinds (`user_job_setup()`)
| Keybind | Action | Purpose |
| :--- | :--- | :--- |
| `Alt+~` (`!`` `) | `/ja "Release" <me>` | Release current avatar/spirit |
| `Win+~` (`@`` `) | `gs c cycle MagicBurst` | Cycle Magic Burst *(note: state is `MagicBurstMode`)* |
| `Ctrl+~` (`^`` `) | `gs c toggle PactSpamMode` | Toggle automatic Blood Pact Rage repeat |
| `Alt+Pause` | `gs c toggle AutoSubMode` | Toggle `/SCH` Sublimation automation |
| `Ctrl+Q` | `gs c weapons Khatvanga;gs c set CastingMode OccultAcumen` | Swap to Occult Acumen Khatvanga nuke mode |
| `Alt+Q` | `gs c weapons default;gs c reset CastingMode` | Restore default weapon/casting mode |

---

## Job-Specific Commands (`//gs c ...`)

- **`//gs c pact <type>`** — Avatar-agnostic Blood Pact execution (uses `Shortcuts` for targeting):
  - `cure`, `curaga`, `buffoffense`, `buffdefense`, `buffspecial`, `buffspecial2`, `debuff1`, `debuff2`, `sleep`, `nuke2`, `nuke4`, `bp70`, `bp75`, `bp99`, `physical`, `magical`, `astralflow` (requires `Astral Flow` active).
- **`//gs c siphon`** — Full automated `Elemental Siphon` sequence (`handle_siphoning()`):
  - Releases active avatar (remembers to re-summon afterward), optionally casts `/SCH` storm if weather opposes day or matches spirit, summons optimal `Spirit` (matching weather or day), executes `Elemental Siphon`, releases spirit (unless a spirit was already out), and re-summons the previous avatar.
- **`//gs c petweather`** — On `/SCH`, casts the storm spell matching the currently summoned avatar's element.
- **`//gs c conduitlock`** — Toggles `ConduitLock` (`true`/`false`), controlling whether `Astral Conduit` locks pet midcast gear.
- **`//gs c elemental <subcommand> [target]`** — Same elemental nuke/helix/enfeeble/bardsong/spikes/enspell/weather helper (`weather` casts `Phalanx` on `/RDM`, else `Klimaform`/Storm).

---

## Job Logic Highlights (`SMN.lua`)

- **`job_filter_precast`**:
  - Prevents re-summoning the same avatar if `pet.hpp > 50`; if summoning a different avatar while a pet is out, cancels the cast, runs `/pet Release <me>`, and schedules `/ma "<Avatar>" <me>` `2s` later.
  - During `Astral Conduit`, if `player.mp < 2 * actual_cost(spell)`, automatically restores MP before the pact via `Myrkr` (TP >= 1000), `Sublimation` (`/SCH` Complete), or `Convert` (`/RDM` with `AutoConvert`).
- **`job_aftercast` & `job_pet_midcast`**:
  - Blood Pacts are `Ability`-type actions whose pet execution occurs after player aftercast: `job_aftercast` sets `petWillAct = os.clock()`, equips `get_pet_midcast_set` + `.AM` (`Aftermath: Lv.3`) + `.Acc` (`CastingMode == 'Resistant'`) + `[pet.name]` overrides, and locks all slots if `Astral Conduit` + `ConduitLock` are enabled (unlocking automatically if switching to a different pact or when `Astral Conduit` wears / pet disappears).
  - `job_pet_midcast` equips pet midcast gear for `Spirit` magic casts.
- **`job_customize_idle_set`**:
  - Applies `sets.buff.Sublimation`/`DTSublimation`, `latent_refresh`/`latent_refresh_grip`/`TPEat` (`mpp < 51`), and when `pet.isvalid`: `sets.perp.Day`, `sets.perp.Weather`, `sets.perp[pet.name]`, `sets.idle.Avatar.Favor` (`Avatar's Favor` active), and `sets.idle.Avatar.Engaged` / `[pet.name]`.
- **`job_tick()`**:
  - `check_favor()` — Maintains `Avatar's Favor` when `AutoFavor` is on and a pet is active.
  - `check_buff()` (`Auto`: `Reraise`, `Haste`, `Refresh`, `Stoneskin`) and `check_buffup()` (`Default`).

---

## Character Customizations

- **`Gimlic`:** **NONE** (`Gimlic_Smn_Gear.lua` does not exist).
- **`Voicelessbicep`:** **STOCK** (`Voicelessbicep_Smn_Gear.lua` matches `Selindrile_Smn_Gear.lua`).
- **`Balullu` & `Friendlessvirus` (`Balullu_Smn_Gear.lua`, `Friendlessvirus_Smn_Gear.lua` — Identical Custom, ~54 diff):**
  - **Custom Capes (`Campestres's Cape`):** `magic_jse_back` (`Pet: MAcc/MDmg+20, Eva/MEva+20, Pet: Regen+10`), `phys_jse_back` (`Pet: Acc/RAcc/Atk/RAtk+20, Eva/MEva+20, Pet: Haste+10`).
  - **Key Gear Overrides vs Stock:**
    - Replaces `ammo="Epitaph"` with `ammo="Sancus Sachet +1"` across all BP Ward/Rage, `Myrkr`, `Summoning Magic`, `Avatar`/`Spirit` Idle, `Defense`, and `Engaged` sets.
    - Replaces `Mpaca's Staff` + `Umbra Strap` in `sets.idle` with `main="Bolelabunga", sub="Genmei Shield"`, in `sets.resting` with `main="Chatoyant Staff"`, and replaces `sub="Umbra Strap"` in `Idle.PDT`/`Avatar`/`Spirit` sets with `sub="Oneiros Grip"`.
    - Elemental/Divine nuking (`Elemental Magic`, `Divine Magic`) swaps `Bunzi's Hat` / `Amalric Nails +1` / `Ghastly Tathlum +1` to `gear.merlinic_nuke_head` / `gear.merlinic_nuke_feet` / `Dosis Tathlum`.
  - **Macro Book:** Book `17`, page `4`.

---

## Related Notes

- [FFXI GearSwap and Character Profiles](./README.md)
- `FFXI Windower Overview`
- `FFXI Windower Addons Catalog`
- [FFXI Addon — GearSwap](./GearSwap-Engine.md)
- `FFXI Addon — PetTP`
