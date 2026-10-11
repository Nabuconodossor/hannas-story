# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Godot 4.7 (Forward Plus) 2D top-down Pokémon-style RPG fan game, working title "pokemon evolution black" (the story is "Hannas Story"). All in-game text, identifiers (`velocidad`, `escenas`, animation names) and docs are in Spanish; keep new code and text in Spanish to match.

There is no build system, test suite, linter or git repo. Everything is done through the Godot editor: open `project.godot` with Godot 4.7, or run from the CLI with `flatpak run org.godotengine.Godot --path .` (Godot is installed as a Flatpak, there is no `godot` binary in PATH; add `res://escenas/mundo/region.tscn` or `res://escenas/intro/intro.tscn` to run a specific scene). `.godot/` is git-ignored cache.

## Architecture

Folder layout (Spanish names; put new files in the matching folder):

- `escenas/intro/` — `intro.tscn` + `intro.gd`, narrated intro. A single `AnimatedSprite2D` holds the 7 illustrations as frames; `intro.gd` finds the `AnimatedSprite2D` and `Label` via `find_child`, keeps the `escenas` text array index-aligned with the sprite frames, and types text out with `visible_characters`. `ui_accept` skips typing / advances. It does nothing after the last scene (no scene change yet).
- `escenas/mundo/region.tscn` — main world map: a `TileMapLayer` (32px tiles from `arte/tiles/tileset_region.png`, 48 columns) with `protagonista_m.tscn` instanced as its child. Its TileSet lives in `datos/tileset_region.tres` (extracted from the scene so it can be edited in the TileSet editor). The map uses only ~50 distinct tiles (water `40,0` is ~67% of the 49k cells); 32 of them have a full-tile square collision polygon (water, trees/bushes, cliffs, boat, fences). Grass, sand, stone ground, bridges and dirt `9,3` are walkable. New blocking tiles need their polygon added in `tileset_region.tres`.
- `escenas/pruebas/prueba_mapa.tscn` — small test room (same TileSet) with one labelled patch per blocking/walkable tile type, for checking player interactions without crossing the big map.
- `escenas/interiores/`, `escenas/combate/`, `sistemas/`, `ui/`, `audio/` — empty, reserved for what the GDD plans (interiors, battle, autoloads, UI, sound); `datos/` only holds the tileset so far.
- `escenas/placeholders/` — two empty `Control` scenes (`control.tscn`, `pokemon_evolution_black.tscn`).
- `personajes/jugador/` — `protagonista_m` and `protagonista_f` (`.tscn` + `.gd`): `CharacterBody2D` + `AnimatedSprite2D` (256px frames, animations `abajo`/`arriba`/`izquierda`/`derecha`; M also has `idle_*`, played by `protagonista_m.gd` via `ultima_direccion`, F has none yet) + `Camera2D`. Movement uses the default `ui_*` input actions (no custom InputMap) at `velocidad` = 150.
- `arte/` — `personajes/` (sprite sheets, 6x4 grid of 256px, RGB with a baked-in checkerboard instead of real alpha), `tiles/`, `intro/` (`intro_01`..`07` in frame order), `referencia/` (region map, design reference only). Unused assets carry a `_sin_usar` suffix.
- `docs/GDD.md` — living design document (geography, 8 gyms, roadmap, known problems). Read it before design-level work; it separates confirmed facts from proposals.

## Gotchas

- `run/main_scene` is `protagonista_m.tscn` (uid `ydxm4m2s2fww`), not the intro or the map; the intro does not chain into the world.
- The two protagonist scripts are duplicates; keep them in sync.
- `CollisionShape2D` must be a direct child of the `CharacterBody2D`; in `protagonista_m.tscn` it used to hang under `AnimatedSprite2D`, which gave the player no hitbox at all (fixed, keep it that way).
- `personajes/jugador/protagonista_m_prueba.{gd,tscn}` is an old experimental copy (other sprite sheets); nothing references it.
- Character sprite scale differs between `protagonista_m.tscn` (0.25) and its instance in `region.tscn` (0.125).
- Move or rename assets inside the Godot editor when possible. If done from the shell, move the `.import` / `.uid` file along and rewrite the `res://` paths in `.tscn`, `.gd` and `.import` files; deleting `.godot/` (cache) forces a clean reimport.
