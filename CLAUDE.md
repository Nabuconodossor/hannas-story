# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> Este archivo lo leen los agentes (y las personas) que colaboran en el proyecto. Está en español porque el equipo, el juego y los docs están en español. **Responde a los colaboradores en español** y escribe código, identificadores y textos del juego en español.

## Qué es este proyecto

Juego de rol 2D de vista cenital, estilo Pokémon, hecho en **Godot 4.7** (Forward Plus). Título de trabajo: "pokemon evolution black"; la historia se llama "Hannas Story". Dos montañas rivales (Monte Sol y Monte Luna) dividen una región en dos creencias; el jugador, un entrenador novato que parte de Ciudad Puerto, descubre qué despertó entre ellas. Hay 8 gimnasios y una Liga.

- Repositorio público: `Nabuconodossor/hannas-story`, rama `main`.
- Es un **fan game**: usa terminología de Pokémon y arte generado con IA. No se puede vender ni publicar como producto con esa propiedad intelectual; si algún día se distribuye, hay que crear criaturas, nombres y símbolos propios.
- **`docs/GDD.md` es el documento de diseño.** Léelo antes de cualquier trabajo de diseño (geografía, gimnasios, hoja de ruta). Separa lo confirmado (✅), lo propuesto (🟡) y lo pendiente (❓). Ojo: su sección 6.2 ("Problemas detectados") está parcialmente desactualizada; ver "Estado actual" abajo, que es más reciente.

## Estado actual (2026-10-11)

Funciona:
- Protagonista M: caminar en 4 direcciones, animaciones `idle_*`, colisiones.
- Mapa `region.tscn` pintado (~49 000 celdas, ~50 tiles distintos) con colisiones en agua, árboles/arbustos, acantilados, barco y vallas.
- Escena de prueba `escenas/pruebas/prueba_mapa.tscn` para comprobar colisiones sin recorrer el mapa grande.
- Intro narrada (`escenas/intro/`).

No existe todavía (ver hoja de ruta en el GDD, sección 7):
- La intro no enlaza con el mundo (al terminar no cambia de escena) y `run/main_scene` apunta al protagonista suelto, no a la intro ni al mapa.
- Selección de protagonista M/F, interiores, combate, criaturas, NPCs/diálogo, guardado, audio.
- `protagonista_f` no tiene animaciones `idle_*` ni el arte nuevo; su script es la versión antigua de M.

## Cómo ejecutar y verificar

No hay sistema de build, tests ni linter. Godot está instalado como **Flatpak** (no hay binario `godot` en el PATH):

```bash
flatpak run org.godotengine.Godot --path .                                   # escena principal
flatpak run org.godotengine.Godot --path . res://escenas/pruebas/prueba_mapa.tscn   # una escena concreta
flatpak run org.godotengine.Godot --headless --path . --import               # reimporta assets nuevos
```

Un agente no ve la ventana del juego ni pulsa teclas. Para verificar comportamiento sin interfaz, escribe un script de prueba que herede de `SceneTree`, instancia la escena, simula entrada con `Input.action_press("ui_up")` durante N `physics_frame` y comprueba la posición final; ejecútalo con `--headless --script res://_prueba.gd`. Así se comprobaron las colisiones. Dos detalles:
- El Flatpak **no ve `/tmp`**: el script debe estar dentro del proyecto. **Bórralo al terminar** (y su `.uid`); no lo commitees.
- La posición del personaje es su origen, unos 13 px por encima de los pies (el hitbox está en los pies), así que al chocar con un obstáculo el origen queda por encima del borde del tile. Es correcto.

Cuando solo puedas comprobar que la escena carga sin errores, dilo así; no afirmes que "se ve bien" sin haberlo visto.

## Estructura (carpetas en español; pon cada archivo nuevo donde corresponda)

- `escenas/intro/` — `intro.tscn` + `intro.gd`. Un `AnimatedSprite2D` con las 7 ilustraciones como frames; el array `escenas` de textos va alineado por índice con los frames; el texto se escribe con `visible_characters`; `ui_accept` salta o avanza. Tras la última escena no hace nada.
- `escenas/mundo/region.tscn` — mapa principal: un `TileMapLayer` (tiles de 32 px de `arte/tiles/tileset_region.png`, 48 columnas) con `protagonista_m.tscn` como hijo. Su TileSet es externo: `datos/tileset_region.tres`.
- `escenas/pruebas/` — salas de prueba. `prueba_mapa.tscn` tiene un parche rotulado por cada tipo de tile que bloquea o se camina. **Cualquier interacción nueva con el jugador (puertas, carteles, hierba, saltos de mapa…) se prueba aquí primero**, no en el mapa grande.
- `escenas/interiores/`, `escenas/combate/`, `sistemas/`, `ui/`, `audio/` — vacías (git no guarda carpetas vacías; se crean al poner algo). Reservadas para lo que planea el GDD. `datos/` solo contiene el TileSet por ahora.
- `escenas/placeholders/` — dos escenas `Control` vacías (`control.tscn`, `pokemon_evolution_black.tscn`).
- `personajes/jugador/` — `protagonista_m` y `protagonista_f` (`.tscn` + `.gd`): `CharacterBody2D` + `AnimatedSprite2D` (frames de 256 px) + `Camera2D`, movimiento con las acciones `ui_*` por defecto (sin InputMap propio) a `velocidad` = 150. `protagonista_m_prueba.*` es una copia experimental antigua que nada referencia.
- `arte/` — `personajes/` (hojas de sprites y originales de IA), `tiles/`, `intro/` (`intro_01`..`07` en orden de frames), `referencia/` (mapa de la región, solo referencia de diseño). Los assets sin usar llevan el sufijo `_sin_usar`.

## Cómo trabajar aquí

**Cambios mínimos.** Edita solo lo necesario. No reescribas ni "limpies" un script o escena que funciona, y no cambies la forma en que el equipo programó algo (por ejemplo los `if` anidados de los scripts de movimiento). Si un cambio toca más de lo pedido, explícalo y pregunta antes. Di qué archivos vas a tocar antes de tocarlos cuando el cambio sea grande.

**Git y colaboración.**
- Los `.tscn` y `.tres` son texto pero se fusionan mal. `region.tscn` (~800 KB, mapa en base64 en `tile_map_data`) **no se puede fusionar a mano**: avisa en el equipo antes de pintar en él para que dos personas no lo modifiquen a la vez. Lo mismo vale para `datos/tileset_region.tres`.
- Commitea siempre los `.uid` y los `.import` junto al archivo que acompañan. **No** commitees `.godot/` (caché, ya ignorado).
- Los commits hechos hasta ahora están en español y describen el qué y el porqué; sigue ese estilo.
- Antes de hacer `push`, confirma con quien te lo pide; el repositorio es público.

**Editar escenas y recursos.**
- Prefiere el editor de Godot. Si editas un `.tscn`/`.tres` a mano, haz cambios pequeños, no toques los `unique_id` ni los `uid` existentes y comprueba después que la escena carga (headless o abriéndola).
- Mover o renombrar assets: hazlo en el editor. Desde la shell, mueve también el `.import`/`.uid` y reescribe las rutas `res://` en `.tscn`, `.gd` y `.import`. Borrar `.godot/` fuerza una reimportación limpia.
- Un asset nuevo necesita importarse (`--import` o abrir el editor) para generar su `.import` y `uid` antes de referenciarlo; ese `.import` se commitea.

**Colisiones del mapa.** Los tiles que bloquean tienen un polígono cuadrado de tile completo en la capa de física 0 de `datos/tileset_region.tres`. Se añaden en el editor (pestaña TileSet → Física → polígono del tile) o en el texto del `.tres` con una línea como `X:Y/0/physics_layer_0/polygon_0/points = PackedVector2Array(-16, -16, 16, -16, 16, 16, -16, 16)`. Bloquean hoy: agua `36,0` `38,0` `40,0`; arbustos/árboles `4,0` `4,1` `5,0` `5,1` `8,0` `8,1` `9,0` `9,1` y `16..21,11..12`; acantilados `14,9` `14,10` `15,9` `15,10`; barco `7,29`; vallas `22,16` `23,16` `29,16` `30,16`. Se caminan: hierba, arena, suelo de piedra, puentes y tierra `9,3`.

**Arte nuevo del personaje.** Las hojas de IA suelen venir con fondo magenta o con cuadrícula de transparencia pintada. Se recortan con transparencia real (clave de color + `PIL`), se parten en celdas de 256×256 y se montan en una hoja de 6 columnas. La hoja actual de M, `arte/personajes/protagonista_m_hoja_gemini.png`, tiene: filas 1–4 = caminar `abajo`, `arriba`, `izquierda`, `derecha` (la derecha es la izquierda espejada); fila 5 = poses quietas (frente, espalda, izquierda, derecha y dos expresiones). Conserva los originales de IA en `arte/personajes/`.

## Trampas conocidas

- **`CollisionShape2D` debe ser hijo directo del `CharacterBody2D`.** En `protagonista_m.tscn` colgaba del `AnimatedSprite2D`, y así el jugador no tenía hitbox y atravesaba todo. Está corregido; no lo vuelvas a anidar. (En `protagonista_f.tscn` el hitbox es hijo directo, pero el `Camera2D` cuelga del `CollisionShape2D`.)
- `run/main_scene` es `protagonista_m.tscn` (uid `ydxm4m2s2fww`), no la intro ni el mapa.
- Los dos scripts del protagonista son casi duplicados pero ya **no están sincronizados**: M tiene `ultima_direccion` e `idle_<dirección>`; F sigue con `sprite.stop()`. Si cambias el movimiento de uno, decide con el equipo si el otro debe seguirlo.
- Escala del sprite: `protagonista_m.tscn` usa 0.25 y su instancia dentro de `region.tscn` 0.125 (256 px × 0.125 = 32 px, un tile). `prueba_mapa.tscn` usa 0.125 también.
- `region.tscn` tiene `format=4` (tile data) y el TileSet es externo: no vuelvas a embeberlo.
- Las hojas viejas de personaje (`protagonista_*_hoja.png`) son RGB con un tablero de ajedrez pintado en lugar de alfa real; las nuevas sí tienen alfa.

## Siguientes pasos acordados

Orden sugerido (detalle en el GDD, sección 7): arranque desde la intro hacia `region.tscn`, elección de protagonista, entradas a interiores y cambio de mapa (`Area2D` con destino y punto de aparición), hierba alta y encuentros, y luego combate. Antes de empezar una de estas, revisa el GDD y pregunta si hay decisiones abiertas (sección 8: movimiento libre vs. por casillas, papel de la evolución, antagonista, nombre definitivo).
