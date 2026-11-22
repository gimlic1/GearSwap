# FFXI Addon — GearSwap

> [!NOTE]
> **Quick Reference**
> - **Path:** `C:\Windower\addons\GearSwap\`
> - **Author / Version:** Byrth / `0.940` *(Selindrile fork `Selindrile/GearSwap`)*
> - **Commands:** `//gs`, `//gearswap`
> - **Load Status:** Autoload (`settings.xml`)
> - **Origin:** Third-Party (`https://github.com/Selindrile/GearSwap.git`, branch `master`, with local edits)

Event-driven equipment-swapping engine that intercepts outgoing action text and incoming game packets, runs sandboxed user job Luas, and injects `0x050`/`0x051` equip packets around every action phase.

## What the Code Does
GearSwap separates its core Lua engine (`gearswap.lua` + core modules) from sandboxed user job files (`data/`), with Selindrile's `libs/Sel-*.lua` and `Mote-*.lua` helper libraries available via `include()`:

1. **Sandboxed User Environment (`refresh.lua`):** `load_user_files()` searches `GearSwap/libs/`, `data/<char>/`, `data/common/`, and `data/` for `<player>_<job>.lua` (or `<job>.lua` / `default.lua`), loads it via `setfenv(..., user_env)` with restricted Windower/Lua helpers (`equip`, `set_combine`, `cancel_spell`, `change_target`, `cast_delay`, `disable`, `enable`, `sets`, `player`, `buffactive`, `world`, `pet`, `alliance`), and runs `get_sets()`.
2. **Outgoing Command Interception (`triggers.lua` & `flow.lua`):**
   - `outgoing text` intercepts `/ma`, `/ja`, `/ws`, `/ra`, `/item`, `/pet`, `/bstpet`, and `/ms` commands, resolves the resource and target, and filters through `filter_pretarget()`.
   - `equip_sets()` runs the lifecycle pipeline: `filtered_action` (if filtered) → `pretarget` (allows `change_target`, `cancel_spell`, `pretarget_cast_delay`) → builds a `proposed_packet` (`0x01A` action, `0x037` usable item, or `0x036` menu/trade item) and stores it in `command_registry[ts]` → `precast` (returns `true` to block the original text command) → `precast_send_check()` / `send_action()` → `midcast`, which injects the held `proposed_packet` immediately after equipping midcast gear.
3. **Equipment Resolution & Packet Injection (`equip_processing.lua`, `flow.lua`):** `unpack_equip_list()` diffs `equip_list` against `update_equipment()` (combining `items.equipment` with pending `injected_equipment_registry` chunks), checks wearability (`check_wearable()`, job/level/race/Superior level) and encumbrance (`0x01B`), matches `augments` via `extdata` and `bag` constraints, and packs swaps in `Priorities` order—injecting one `0x051` equipset packet when swapping 3+ slots, or individual `0x050` packets for 1–2 slots.
4. **Incoming Packet State & Action Completion (`packet_parsing.lua`, `triggers.lua`):**
   - `parse.i[0x028]` parses action packets for the player/pet to trigger `aftercast` / `pet_aftercast` (on completion or interruption `param == 28787` / out-of-range / paralysis) and `pet_midcast`.
   - `parse.i[0x029]` handles action-message interruptions and target deaths.
   - Additional parsers maintain live state and dispatch user events: `0x00A`/`0x00B` (zone & job-on-zone), `0x00E` (`pet_status_change`), `0x01B` (job levels & encumbrance unlocks), `0x01E`/`0x01F`/`0x020` (inventory state), `0x037` (`indi_change` & `pet_change`), `0x050`/`0x117` (confirming injected equip swaps), `0x053` (Trust summon failures), `0x05E` (conquest), `0x061` (`sub_job_change` & stats), `0x062` (skills), `0x063` v9 (`buff_change` & `buff_refresh`), `0x067`/`0x068` (pet TP), `0x076` (`party_buff_change`), `0x0DF`/`0x0E2` (vitals), and outgoing `0x050`/`0x051`/`0x100` (tracking manual swaps and job changes).

## Commands & Usage
- `//gs c <string>` — Forward `<string>` to the loaded user file's `self_command()`.
- `//gs equip <set_path|naked>` — Equip a set from `user_env.sets` (or `sets.naked`).
- `//gs load|l <file>` / `//gs reload|r` — Load a specific Lua file or reload the current character/job file.
- `//gs enable|disable [slot|all]` — Enable/disable swapping for specific slots, `all` slots, or the entire user file when no slot is given.
- `//gs export [inventory|all|wearable|sets|xml]` — Export gear/sets to Lua or SpellCast XML (`export.lua`).
- `//gs validate [sets|inv] [filter]` — Cross-check `sets` against inventory or vice versa (`validate.lua`).
- `//gs showswaps` / `//gs debugmode` / `//gs demomode` / `//gs eval <lua>` — Diagnostics and dry-run modes (`eval` requires `debugmode`).

## Events, Packets & Technical Hooks
- **Windower Events:** `load`, `unload`, `addon command`, `incoming chunk`, `outgoing chunk`, `outgoing text`, `status change`, `login` *(user Luas may also register wrapped/raw events via `user_windower`)*
- **Packets:**
  - Incoming: `0x00A`, `0x00B`, `0x00E`, `0x01B`, `0x01E`, `0x01F`, `0x020`, `0x028`, `0x029`, `0x037`, `0x050`, `0x053`, `0x05E`, `0x061`, `0x062`, `0x063`, `0x067`, `0x068`, `0x076`, `0x0DF`, `0x0E2`, `0x117`
  - Outgoing: Monitored `0x050`, `0x051`, `0x100`; Injected `0x01A` (action), `0x036` (trade/menu item), `0x037` (usable item), `0x050` (equip), `0x051` (equipset)
- **Dependencies / Libraries:** `files`, `strings`, `tables`, `logger`, `lists`, `queues`, `sets`, `texts`, `pack`, `bit`, `socket`, `mime`, `resources`, `extdata`, `actions`, `packets`, plus GearSwap core modules (`helper_functions`, `packet_parsing`, `statics`, `equip_processing`, `targets`, `user_functions`, `refresh`, `export`, `validate`, `flow`, `triggers`) and `libs/` (`Sel-*`, `Mote-*`, `Modes`, `Snaps-RngHelper`, `organizer-lib`, `closetCleaner`)

## Local Settings & Customizations
GearSwap has no `settings.xml`; configuration and job Luas live under `data/` (including local `Gimlic/` and `Voicelessbicep/` profiles—see [FFXI GearSwap and Character Profiles](./README.md)). Local non-`data/` modifications in this `Selindrile/GearSwap` checkout:
- `libs/organizer-lib.lua`: Expanded `ward_ids` from `{8,10,11,12}` to `{8,10,11,12,13,14,15,16}` to cover Mog Wardrobes 5–8.
- `libs/Sel-Stahp.lua`: Guarded `sets.Cure_Received` checks with `and not targetsSelf` (plus commented debug lines).
- `README.md`: Replaced Selindrile's setup notes with standard Windower GearSwap command documentation.

## Related Notes
- [FFXI GearSwap and Character Profiles](./README.md)
- `FFXI Windower Overview`
- `FFXI Windower Addons Catalog`
