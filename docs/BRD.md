# FFXI GearSwap — BRD (Bard)

> [!NOTE]
> **Quick Reference**
> - **Logic File:** [BRD.lua](file:///C:/Windower/addons/GearSwap/data/BRD.lua)
> - **Defaults (`BRD.lua`):** `autows = "Rudra's Storm"` | `autofood = 'Pear Crepe'` | `state.ExtraSongsMode = 'None'` | `state.AutoSongMode = false` | `state.RecoverMode = '35%'`
> - **Character Customization Status:**
>   - `Gimlic`, `Balullu`, `Friendlessvirus`: **CUSTOM** *(identical across all three; 119 diff lines vs upstream `Selindrile_Brd_Gear.lua`)*
>   - `Voicelessbicep`: **STOCK** *(matches `Selindrile_Brd_Gear.lua`)*

---

## Job-Specific Modes & Keybinds

### States (`BRD.lua` & `user_job_setup`)
- `state.ExtraSongsMode`: `None`, `Dummy`, `DummyLock`, `FullLength`, `FullLengthLock` (non-`Lock` values auto-reset after song midcast)
- `state.AutoSongMode`: `false` / `true` (tick-driven self-buff songs: `Honor March` -> `Valor Minuet V` -> `Blade Madrigal`; auto-resets on zone change)
- `state.RecoverMode`: `35%`, `60%`, `Always`, `Never` (for elemental nukes)
- `state.UseCustomTimers`: `false` (toggled in `user_job_setup`)
- `info.ExtraSongInstrument`: `'Blurred Harp +1'` | `info.ExtraSongs = 1`
- `state.OffenseMode`: `Normal`, `Acc` *(custom omits `HybridMode`)*
- `state.CastingMode`: `Normal`, `Resistant`, `AoE`
- `state.IdleMode`: `Normal`, `NoRefresh`, `DT`
- `state.Weapons` *(custom)*: `None`, `Aeneas`, `DualWeapons`, `DualNaegling`, `DualTauret`, `DualNukeWeapons`

### Local Keybinds (`Gimlic` / `Balullu` / `Friendlessvirus`)
| Keybind | Command | Function |
| :--- | :--- | :--- |
| ``Ctrl+` `` | `gs c cycle ExtraSongsMode` | Cycle dummy/extra song instrument mode |
| ``Alt+` `` | `/ma "Chocobo Mazurka" <me>` | Cast Chocobo Mazurka |
| ``Win+` `` | `gs c cycle MagicBurstMode` | Cycle MagicBurstMode |
| `Win+F10` | `gs c cycle RecoverMode` | Cycle RecoverMode |
| `Win+F8` | `gs c toggle AutoNukeMode` | Toggle AutoNukeMode |
| `Alt+Q` / `Ctrl+Q` | `gs c weapons NukeWeapons` / `gs c weapons Swords` | *(See warning below)* |

> [!WARNING]
> **Weapon Bind Mismatch in Custom BRD Files**
> `Alt+Q` (`NukeWeapons`) and `Ctrl+Q` (`Swords`) in `Gimlic` / `Balullu` / `Friendlessvirus` reference weapon set names not defined in `sets.weapons` (which defines `Aeneas`, `DualWeapons`, `DualNaegling`, `DualTauret`, `DualNukeWeapons`). Stock `Voicelessbicep` additionally binds `Alt+R` (`gs c weapons None;gs c update`) and defines `Naegling`, `DualAeolian`, and `autows_list`.

---

## Job-Specific Commands (`//gs c ...`)

- `BRD.lua` leaves `job_self_command` empty; all song/buff/weapon controls use standard Selindrile state commands (`//gs c cycle ExtraSongsMode`, `//gs c toggle AutoSongMode`, `//gs c set ExtraSongsMode Dummy`, etc.).

---

## Job Logic Highlights (`BRD.lua`)

- **Dagger -> Sword WS Remap (`job_filtered_action`):** When WS ID `32` (`Fast Blade`, i.e., a sword is equipped) is available, remaps `Rudra's Storm` -> `Savage Blade`.
- **Smart Targeting & Auto-Pianissimo (`job_pretarget` / `job_filter_precast`):**
  - If `Pianissimo` is active and target is `<t>` with no/monster target, re-prompts with `<stpt>`. If `Pianissimo` is not active and target is none/monster, redirects to `<me>`.
  - When casting a friendly song on a party member/NPC/Trust (`spell.target.in_party`) without `Pianissimo` active, cancels the cast, executes `/ja "Pianissimo" <me>`, and reschedules the song 1.1s later.
- **Song Gear & Nightingale Handling (`job_precast` / `job_post_precast` / `job_midcast` / `job_post_midcast`):**
  - Enemy songs without a specific FC set use `classes.CustomClass = 'SongDebuff'`.
  - When `Nightingale` is active, `job_post_precast` replicates full midcast layering (`DaurdablaDummy` / `SongEffect` / `SongDebuff`, spell/map-specific sets, and `sets.midcast.Daurdabla` for `FullLength`) at precast time since songs resolve immediately.
  - Supports `.DW` weapon swaps (`sets.midcast.SongEffect.DW`, `sets.midcast.SongDebuff.DW`) when `can_dual_wield` is true, and resets non-`Lock` `ExtraSongsMode` after midcast.
- **Melee Groups & Tick:** Appends `AM` when `Carnwenhan` + `Aftermath: Lv.3` are active. `job_tick` runs `check_song()` (`AutoSongMode`: `Honor March`, `Valor Minuet V`, `Blade Madrigal` with `FullLength`), `check_buff()` (`Refresh`, `Phalanx`, `Stoneskin`, `Blink` when `Idle`), and `check_buffup()`. Resets `AutoSongMode` on zone change.

---

## Character Customizations

### `Gimlic` / `Balullu` / `Friendlessvirus` (CUSTOM — identical files)
- **Macro Book:** `set_macro_page(10, 10)` (all subjobs).
- **Weapon Sets:**
  - `Aeneas`: `{main="Aeneas", sub="Genmei Shield"}`
  - `DualWeapons`: `{main="Aeneas", sub="Blurred Knife +1"}`
  - `DualNaegling`: `{main="Naegling", sub="Blurred Knife +1"}`
  - `DualTauret`: `{main="Tauret", sub="Blurred Knife +1"}`
  - `DualNukeWeapons`: `{main="Malevolence", sub="Malevolence"}`
- **Instrument & Song Gear Highlights:**
  - `Blurred Harp +1` for extra song / AoE Lullaby / `Magic Finale`; `Marsyas` for `Honor March`, `Mazurka`, and single-target `SongDebuff` / `Lullaby`.
  - `Kali` (with `Genmei Shield` or DW `Kali`/`Kali`) for `SongEffect` and `SongDebuff`; `Daybreak` + `Ammurapi Shield` for resistant debuffs, nukes, and `Dispelga` FC; `Bihu +1` JA pieces (`Nightingale`/`Troubadour`/`Soul Voice`); `Fili +1` song pieces; `Brioso Slippers +1`.
  - Pre-Odyssey idle/DT/melee sets (`Respite Cloak`, `Chironic` refresh pieces, `Ayanmo +2` idle/melee, `Bleating Mantle` / `Letalis Mantle` instead of `Intarabus's Cape` melee/magic JSE vars and `Nyame`/`Bunzi's Hat`).

### `Voicelessbicep` (STOCK)
- Unmodified `Selindrile_Brd_Gear.lua` (includes `Bunzi's Hat`, `Nyame` idle/DT/defense, `Mpaca's Staff`, `Naegling`/`DualAeolian` weapon sets, `gear.melee_jse_back` / `gear.magic_jse_back`, and `autows_list`).

---

## Related Notes

- [FFXI GearSwap and Character Profiles](./README.md)
- `FFXI Windower Overview`
- [FFXI Addon — GearSwap](./GearSwap-Engine.md)
- `FFXI Addon — Singer`
