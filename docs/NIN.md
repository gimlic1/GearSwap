# FFXI GearSwap — NIN (Ninja)

> [!NOTE]
> **Quick Reference**
> - **Logic File:** [NIN.lua](file:///C:/Windower/addons/GearSwap/data/NIN.lua)
> - **Defaults (`NIN.lua`):** `autows = "Blade: Shun"` | `autofood = 'Soy Ramen'` | `state.Stance = 'Innin'` | `utsusemi_ni_cancel_delay = .1` *(overridden to `.06` in gear file; `utsusemi_cancel_delay = .3`)*
> - **Character Customization Status:**
>   - `Balullu`, `Friendlessvirus`: **CUSTOM** *(identical; 29 diff lines vs `Selindrile_Nin_Gear.lua`)*
>   - `Voicelessbicep`: **STOCK** *(matches `Selindrile_Nin_Gear.lua`)*
>   - `Gimlic`: **NONE** *(no `Gimlic_Nin_Gear.lua` file)*

---

## Job-Specific Modes & Keybinds

### States (`NIN.lua` & `user_job_setup`)
- `state.Stance`: `Innin`, `Yonin`, `None` (tick-maintained in combat)
- `state.ElementalMode`: `Fire`, `Water`, `Lightning`, `Earth`, `Wind`, `Ice`, `Light`, `Dark`
- `state.OffenseMode`: `Normal`, `SomeAcc`, `Acc`, `FullAcc`, `Fodder`, `Crit`
- `state.CastingMode`: `Normal`, `Proc`, `Resistant`
- `state.ExtraMeleeMode`: `None`, `SuppaBrutal`, `DWEarrings`, `DWMax`
- `state.Weapons`:
  - `Balullu` / `Friendlessvirus`: `Heishi`, `LowBuff`, `MagicWeapons`, `ProcDagger`, `ProcSword`, `ProcGreatSword`, `ProcScythe`, `ProcPolearm`, `ProcGreatKatana`, `ProcKatana`, `ProcClub`, `ProcStaff`
  - `Voicelessbicep` *(Stock)*: omits `LowBuff`

### Local Keybinds (`Balullu` / `Friendlessvirus` & Stock)
| Keybind | Command | Function |
| :--- | :--- | :--- |
| ``Ctrl+` `` / ``Alt+` `` | `/ja "Innin" <me>` / `/ja "Yonin" <me>` | Activate Innin / Yonin |
| ``Win+` `` | `gs c cycle SkillchainMode` | Cycle SkillchainMode |
| `Alt+R` | `gs c set WeaponskillMode Proc;gs c set CastingMode Proc;gs c update` | Enter Abyssea/VW Proc mode |
| `Ctrl+R` | `gs c set WeaponskillMode Normal;gs c set CastingMode Normal;gs c update` *(Stock also includes `gs c weapons Default;`)* | Exit Proc mode back to Normal |

---

## Job-Specific Commands (`//gs c ...`)

- `//gs c elemental nuke [target]`: Casts highest ready Elemental Ninjutsu (`San` -> `Ni` -> `Ichi`) in current `ElementalMode`.
- `//gs c elemental San|Ni|Ichi [target]`: Casts specific tier (`San`, `Ni`, or `Ichi`) of current element *(note: checked case-sensitively against `S{'San','Ni','Ichi'}` after `:lower()`, so only `nuke` and `proc` match lowercase)*.
- `//gs c elemental proc [target]`: Casts `<Element>: Ni` for proccing.
- `//gs c SubJobEnmity`: Automated enmity/tank rotation based on subjob (`/RUN` `Flash`/`Swordplay`, `/BLU` AoE/enmity spells, `/DRK` `Stun`/`Souleater`/`Last Resort`/`Arcane Circle`, `/WAR` `Provoke`/`Warcry`/`Defender`/`Aggressor`/`Berserk`, `/DNC` Step/`Animated Flourish`), falling back to `check_auto_tank_ws()`.

---

## Job Logic Highlights (`NIN.lua`)

- **Ammo Protection (`job_pretarget`):** Cancels `Ranged Attack` and `Sange` if `Togakushi Shuriken` or `Happo Shuriken` is equipped.
- **Mijin Gakure Nagi Swap:** Unlocks weapon slots during `Mijin Gakure` if `sets.precast.JA['Mijin Gakure'].main == 'Nagi'` and re-locks them aftercast.
- **Elemental Ninjutsu & Futae (`job_post_midcast` / `job_aftercast`):** Applies `sets.MagicBurst`, `Zodiac Ring` (on matching day in `Normal`/`Fodder`), `sets.element[spell.element]`, and `sets.buff.Futae` (`Hattori Tekko +1`); resets `MagicBurstMode == 'Single'` aftercast.
- **Migawari / Stance / Dusk Kiting (`job_customize_*`):**
  - Layers `sets.buff.Yonin` (when `DefenseMode` is `None` or `Evasion`), `sets.buff.Innin` (`Normal`/`Fodder` offense, `DefenseMode == 'None'`), and `sets.buff.Migawari` onto melee/idle sets.
  - Applies `sets.DuskKiting` during Dusk-to-Dawn movement when idle.
- **Melee Groups & Tick:** Appends `AM` when `Nagi` + `Aftermath: Lv.3` are active. `job_tick` maintains `Innin`/`Yonin` in combat, runs `check_buff()` (`Migawari: Ichi`, plus `/WAR` `Berserk`/`Aggressor` when not defensive), `check_buffup()`, and `SubJobEnmity` when `AutoTankMode` is active.

---

## Character Customizations

### `Balullu` & `Friendlessvirus` (CUSTOM — identical files)
- **Macro Book (`select_default_macro_book`):** `set_macro_page(1, 12)` (all subjobs).
- **Custom Capes & Delays:** `gear.wsd_jse_back` (`Andartia's Mantle` STR+20, Acc/Atk+20, WSD+10%) and `gear.da_jse_back` (`Andartia's Mantle` DEX+20, Acc/Atk+20, DA+10%); `utsusemi_cancel_delay = .3`, `utsusemi_ni_cancel_delay = .06`.
- **Weapon Sets Overrides vs Stock:**
  - `Heishi`: `{main="Heishi Shorinken", sub="Kanaria"}` *(stock sub: `Kunimitsu`)*
  - `Savage`: `{main="Naegling", sub="Kanaria"}` *(stock sub: `Kunimitsu`)*
  - `Evisceration`: `{main="Tauret", sub="Kanaria"}` *(stock sub: `Kunimitsu`)*
  - `LowBuff`: `{main="Heishi Shorinken", sub="Blurred Knife +1"}` *(added to `state.Weapons`)*
  - `MagicWeapons`: `{main="Ochu", sub="Ochu"}` *(stock: `Kunimitsu`/`Tauret`)*
  - Plus full Abyssea/VW proc weapon sets (`Chicken Knife II`, `Ark Sword`, `Lament`, `Ark Scythe`, `Pitchfork +1`, `Hardwood Katana`, `Kanaria`, `Dream Bell +1`, `Terra's Staff`).
- **Gear Overrides vs Stock Template:** Uses `gear.herculean_dt_legs` instead of `Nyame Flanchard` in `Enmity`, `Aeolian Edge`, `idle`, and `defense.MEVA`; uses `Dosis Tathlum` instead of `Ghastly Tathlum +1` in `Aeolian Edge` and `NinjutsuDebuff`.

### `Voicelessbicep` (STOCK)
- Unmodified `Selindrile_Nin_Gear.lua` (`Kunimitsu` offhand, `Nyame Flanchard`, `Ghastly Tathlum +1`, no `LowBuff` in `state.Weapons`).

### `Gimlic` (NONE)
- No Ninja gear file exists for `Gimlic`.

---

## Related Notes

- [FFXI GearSwap and Character Profiles](./README.md)
- `FFXI Windower Overview`
- [FFXI Addon — GearSwap](./GearSwap-Engine.md)
