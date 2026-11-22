# FFXI GearSwap — COR (Corsair)

> [!NOTE]
> **Quick Reference**
> - **Logic File:** [COR.lua](file:///C:/Windower/addons/GearSwap/data/COR.lua)
> - **Defaults (`COR.lua`):** `autows = 'Leaden Salute'` | `rangedautows = 'Last Stand'` | `autofood = 'Sublime Sushi'` | `ammostock = 198` | `state.LuzafRing = true` | `state.AutoAmmoMode = true` | `state.UseDefaultAmmo = true`
> - **Character Customization Status:**
>   - `Voicelessbicep`, `Balullu`, `Friendlessvirus`: **CUSTOM** *(identical across all three; 126 diff lines vs upstream `Selindrile_Cor_Gear.lua`, including `user_job_lockstyle()`)*
>   - `Gimlic`: **NONE** *(no `Gimlic_Cor_Gear.lua` file)*

---

## Job-Specific Modes & Keybinds

### States (`COR.lua` & `user_job_setup`)
- `state.LuzafRing`: `true` / `false` (equips `Luzaf's Ring` on rolls and `Double-Up`)
- `state.CompensatorMode`: `Always`, `300`, `1000`, `Never` (allows swapping `Compensator` + `sets.precast.CorsairRoll.main` (`Rostam`) when TP is below threshold, then re-equips and re-locks weapon set aftercast)
- `state.AutoAmmoMode`: `true` / `false` (tick-driven ammo restocking up to `ammostock = 198`)
- `state.UseDefaultAmmo`: `true` / `false` (re-equips `gear.RAbullet` aftercast)
- `state.Weapons` *(custom override)*: `Default`, `DualWeapons`, `DualSavageWeapons`, `DualLeadenRanged`, `DualLeadenMelee`, `DualAeolian`, `DualLeadenMeleeAcc`, `DualRanged`, `None`

### Local Keybinds (`Voicelessbicep` / `Balullu` / `Friendlessvirus`)
| Keybind | Command | Function |
| :--- | :--- | :--- |
| ``Ctrl+` `` / ``Alt+` `` | `gs c cycle ElementalMode` / `gs c elemental quickdraw` | Cycle element / fire matching Quick Draw shot |
| `Ctrl+Backspace` / `Win+Backspace` / `Alt+Backspace` | `/ja "Double-up"` / `/ja "Snake Eye"` / `/ja "Fold"` | Core roll management |
| `Ctrl+Alt+Win+Backspace` | `/ja "Crooked Cards" <me>` | Crooked Cards |
| `Ctrl+\` / `Alt+\` | `/ja "Random Deal"` / `/ja "Bolter's Roll"` | Random Deal / Bolter's Roll |
| `Ctrl+Alt+Win+\` | `gs c toggle LuzafRing` | Toggle Luzaf's Ring |
| `Win+F7` | `gs c toggle RngHelper` | Toggle auto-ranged attack helper |
| `Alt+R` / `Ctrl+Q` / `Alt+Q` | `gs c weapons DualSavageWeapons` / `DualAeolian` / `DualLeadenRanged` | Weapon set swaps |
| `Win+Q` | `gs c weapons DualKustawi;gs c update` | *(Custom bind; no `DualKustawi` set defined — see `DualRanged`)* |
| `Win+Pause` | `roller roll` | **Overrides global `AutoBuffMode`** to trigger `Roller` addon |

---

## Job-Specific Commands (`//gs c ...`)

- `//gs c elemental quickdraw`: Fires `/ja "<ElementalMode> Shot" <t>` using `data.elements.quickdraw_of`.

---

## Job Logic Highlights (`COR.lua`)

- **Dagger -> Sword WS Remap (`job_filtered_action`):** When WS ID `16` (`Wasp Sting`, i.e., a dagger is equipped) is available, remaps `Savage Blade` -> `Evisceration` and `Circle Blade` -> `Aeolian Edge`.
- **Bullet Safety & Checks (`do_bullet_checks` / `job_midcast` / `job_precast`):**
  - Strictly aborts ranged attacks and ranged WSs if `Animikii Bullet` or `Hauksbok Bullet` is equipped (re-equipping `sets.weapons[state.Weapons.value].ammo` or `gear.RAbullet`).
  - Auto-pulls `Trump Card` from Mog Satchel if missing on `CorsairShot`.
  - Prevents shooting/WSing with `gear.QDbullet` when remaining count would leave Quick Draw empty; prints low-ammo warnings at `<= options.ammo_warning_limit` (`15`).
- **Quick Draw & Flurry Gear (`job_post_precast`):**
  - On non-Light/Dark `CorsairShot` in `Fodder` mode, equips `sets.precast.CorsairShot.Damage` and dynamically picks the highest potency waist among single-element Obi, `Hachirin-no-Obi`, and distance-scaled `Orpheus's Sash` (`>=5%` threshold).
  - Equips `sets.precast.RA.Flurry` / `Flurry2` when Flurry I/II is detected, and `sets.precast.FoldDoubleBust` on `Fold` with 2x Bust.
- **Aftercast & Roll Info:** Re-equips and disables `main`/`range` after `CompensatorMode` roll swaps, calls `display_roll_info(spell)` (lucky/unlucky numbers and bonus), and restores `gear.RAbullet` if `UseDefaultAmmo` is true.
- **Triple Shot & Aftermath:** Equips `sets.buff['Triple Shot']` (and `RangedMode` variant) on RA midcast; appends `AM` ranged group when `Death Penalty` + `Aftermath: Lv.3` are active.

---

## Character Customizations

### `Voicelessbicep` / `Balullu` / `Friendlessvirus` (CUSTOM — identical files)
- **Macro Book (`select_default_macro_book`):** Book `11` — `NIN`=2, `DNC`=1, `RNG`=9, `DRG`=5, fallback=`10` *(stock fallback is page `2`)*.
- **Lockstyle (`user_job_lockstyle`):** Forces `/lockstyleset 001` across all Sword/Dagger/Shield combinations *(stock uses `001`–`004` per grip style)*.
- **Ammo & Bullets:** `gear.RAbullet = "Chrono Bullet"`, `gear.WSbullet = "Chrono Bullet"`, `gear.MAbullet = "Orichalc. Bullet"`, `gear.QDbullet = "Animikii Bullet"`, `options.ammo_warning_limit = 15`.
- **Weapon Sets:**
  - `Default`: `{main="Naegling", sub="Nusku Shield", range="Fomalhaut"}`
  - `DualWeapons`: `{main="Naegling", sub="Blurred Knife +1", range="Fomalhaut"}`
  - `DualSavageWeapons`: `{main="Naegling", sub="Blurred Knife +1", range="Ataktos"}`
  - `DualLeadenRanged`: `{main="Rostam", sub="Tauret", range="Fomalhaut"}`
  - `DualLeadenMelee`: `{main="Naegling", sub="Atoyac", range="Fomalhaut"}`
  - `DualAeolian`: `{main="Rostam", sub="Tauret", range="Ataktos"}`
  - `DualLeadenMeleeAcc`: `{main="Naegling", sub="Blurred Knife +1", range="Fomalhaut"}`
  - `DualRanged`: `{main="Rostam", sub="Kustawi +1", range="Fomalhaut"}`
- **Key Gear Overrides vs Stock Template:** Uses `Malignance` instead of `Nyame` for idle/DT/defense, `Laksa. Trews +3` instead of `Nyame Flanchard` for `Leaden Salute`/`Wildfire`/`Aeolian Edge`, `Caro Necklace`/`Baetyl Pendant` instead of `Comm. Charm +2`, `Lanun Frac +1` instead of `+3`, `Nisroch Jerkin`/`Meghanada Visor +2`/`Adhemar Kecks` for RA midcast, and omits `autows_list` (uses `COR.lua` defaults `Leaden Salute` / `Last Stand`).

### `Gimlic` (NONE)
- No Corsair gear file exists for `Gimlic`.

---

## Related Notes

- [FFXI GearSwap and Character Profiles](./README.md)
- `FFXI Windower Overview`
- [FFXI Addon — GearSwap](./GearSwap-Engine.md)
- `FFXI Addon — Roller`
