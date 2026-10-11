# GDD — "Pokémon Evolution Black" (título de trabajo)

> Documento de diseño generado el 2026-10-10 a partir del contenido de la carpeta del proyecto
> (escenas, scripts y arte). Cada sección distingue lo que **ya existe** en el proyecto
> (✅ Confirmado) de lo que es **inferencia o propuesta** (🟡 Propuesta) y lo que **falta definir** (❓ Pendiente).
> Edítalo libremente: es un documento vivo.

---

## 1. Concepto

| | |
|---|---|
| **Título de trabajo** | `pokemon evolution black` (nombre del proyecto Godot). El tilesheet se llama `pokemonfan_hannas_story`, así que "Hannas Story" parece ser el nombre del repo/historia. ❓ Definir título final. |
| **Género** | ✅ RPG de aventura 2D con vista cenital, estilo Pokémon (gimnasios, Liga, criaturas). |
| **Plataforma** | ✅ PC (Godot 4.7, Forward Plus; hay configuración específica para Windows/D3D12). 🟡 Exportar también a Linux. |
| **Motor** | ✅ Godot 4.7 |
| **Estilo visual** | ✅ Pixel art con tiles de 32 px y sprites de personaje de 256 px escalados. |
| **Idioma** | ✅ Español (todo el texto del juego está en español). |
| **Pitch** | 🟡 *Dos montañas rivales, Monte Sol y Monte Luna, dividieron la región en dos creencias. Algo antiguo despierta entre ambas y tú, un entrenador novato que parte desde el puerto, recorrerá la región para desentrañarlo.* |

> ⚠️ **Nota legal:** el juego usa el universo y la terminología de Pokémon (Liga Pokémon, gimnasios, Pokéball en los tiles). Mientras sea un proyecto personal/fan game no hay problema, pero **no se puede publicar ni vender** con esa propiedad intelectual. Si el objetivo es distribuirlo, habrá que crear criaturas, nombres y símbolos propios.

---

## 2. Historia y mundo

### 2.1 Introducción (✅ implementada en `intro.gd`)
Siete escenas con texto que se escribe letra a letra. Cada una tiene su ilustración:

1. "Hace mucho tiempo, en esta región, dos montañas dominaban estas tierras..." — mapa de la región con el Sol a la izquierda y la Luna a la derecha.
2. "Al norte se alzaba **Monte Sol**, una montaña venerada por quienes buscaban su luz y su poder."
3. "Al sur se encontraba **Monte Luna**, rodeado de misterio y venerado por quienes seguían la fuerza de la noche."
4. "Durante generaciones, los seguidores de ambos montes convivieron separados..."
5. "Pero con el paso del tiempo, sus creencias comenzaron a enfrentarse."
6. "Algo antiguo despertó entre las dos montañas..."
7. "Y una nueva historia estaba a punto de comenzar." — ilustración de un entrenador mirando una ciudad portuaria.

### 2.2 Temas centrales (🟡 inferidos)
- **Dualidad Sol/Luna:** luz frente a noche. Se refleja en el arte (tiles verdes/dorados frente a tiles morados/oscuros) y en los protagonistas (rojo frente a azul).
- **Un conflicto de creencias** que escala hasta despertar "algo antiguo". Las *Ruinas Ancestrales* del mapa son el candidato natural.

### 2.3 Geografía (✅ del mapa `arte/referencia/mapa_region.png`)
La **Región Sol y Luna** tiene una isla principal y dos islas satélite.

**Isla principal**

| Lugar | Función |
|---|---|
| **Ciudad Puerto** | ⭐ **Inicio** del juego. |
| Ciudad Costa | Gimnasio **Agua**. |
| Pueblo Campo | Gimnasio **Planta**. |
| Pueblo Rocas | Gimnasio **Roca**. |
| Lago Cristal | Gimnasio **Psíquico**. |
| Pueblo Bosque | Pueblo sin gimnasio indicado. |
| Pueblo Faro | Pueblo sin gimnasio indicado. |
| Ciudad Desierto | Ciudad en la zona árida, sin gimnasio indicado. |
| **Ciudad Central** | Ciudad grande en el centro de la isla, con Centro Pokémon. |
| Ruinas Ancestrales | Zona de ruinas y cuevas, en el noroeste. 🟡 Clave de la trama. |
| **Ciudad Montaña** | **Liga Pokémon**, en las cumbres nevadas del norte. |

**Isla Norte — Monte Sol**

| Lugar | Función |
|---|---|
| Monte Sol | Montaña sagrada dorada. |
| Pueblo Sol | Gimnasio **Hada**. |
| Pueblo Iceberg | Gimnasio **Hielo**. |

**Isla Sur — Monte Luna**

| Lugar | Función |
|---|---|
| Monte Luna | Montaña oscura con cueva violeta. |
| Pueblo Luna | Gimnasio **Fantasma**. |
| Pueblo Playa | Gimnasio **Lucha**. |

Total: **8 gimnasios** + Liga. Los tipos de los gimnasios (Agua, Planta, Roca, Psíquico, Hada, Hielo, Fantasma, Lucha) ya definen el roster de criaturas que hará falta.

> ❓ La isla Norte lleva el nombre "Monte Sol" y la Sur "Monte Luna", pero la intro dice que Sol está al norte y Luna al sur: coincide. En cambio el mapa de la intro (escena 1) pone el Sol a la izquierda y la Luna a la derecha. Conviene decidir una orientación y mantenerla en todo el arte.

### 2.4 Protagonistas (✅)
El jugador puede ser **chico** o **chica** (dos escenas separadas: `protagonista_m.tscn` y `protagonista_f.tscn`).

| | Protagonista M | Protagonista F |
|---|---|---|
| Aspecto | Pelo plateado, ojos azules, gorra roja y blanca, chaqueta roja, mochila oscura, zapatillas rojas | Pelo negro con mechas azules, ojos azules, chaleco negro sobre camiseta blanca, pantalón corto, mochila azul, zapatillas azules |
| Paleta | Rojo (🟡 asociado al Sol) | Azul (🟡 asociado a la Luna) |
| Hoja de sprites | `arte/personajes/protagonista_m_hoja.png` | `arte/personajes/protagonista_f_hoja.png` |

❓ Nombres, trasfondo y motivación de ambos. ❓ Rival, familia, profesor/a y antagonistas.

---

## 3. Jugabilidad

### 3.1 Bucle principal (🟡 propuesto)
Explorar → encontrar criaturas / NPCs → combatir → fortalecer el equipo → vencer al líder del gimnasio → avanzar a la siguiente zona → … → Liga.

### 3.2 Controles (✅ en código)
Usa las acciones por defecto de Godot:
- **Mover:** `ui_left / ui_right / ui_up / ui_down` (flechas del teclado, también mando).
- **Aceptar / avanzar texto:** `ui_accept` (Enter / Espacio).

Movimiento libre en 8 direcciones a **150 px/s** (no por casillas como en los Pokémon originales). 🟡 Decidir si se mantiene el movimiento libre o se pasa a movimiento por rejilla de 32 px, que encaja mejor con el tileset.

### 3.3 Exploración (✅ parcial)
- Cenital, con cámara que sigue al jugador (`Camera2D` dentro del protagonista).
- Animaciones de caminata en 4 direcciones (`abajo`, `arriba`, `izquierda`, `derecha`) a 8 FPS. Al quedarse quieto, la animación se detiene.
- El mapa (`region.tscn`) es un `TileMapLayer` ya pintado con tiles de 32 px.

### 3.4 Combate (❓ no existe todavía)
Propuesta mínima para la primera versión:
- Por turnos, 1 contra 1.
- 4 movimientos por criatura, con tipo, poder y precisión.
- Tabla de ventajas de tipos (mínimo Agua / Planta / Roca / Psíquico / Hada / Hielo / Fantasma / Lucha).
- Acciones: Luchar, Mochila, Equipo, Huir.

### 3.5 Evolución (🟡 inferida del título)
El título "evolution" sugiere que la evolución es el eje del juego. ❓ Definir si evolucionan por nivel, objeto, vínculo, o por la **energía del Sol y de la Luna** (encaja con la trama).

### 3.6 Captura, equipo y objetos (❓)
Sin definir. Se sugiere equipo de 6, captura con bolas y una mochila con pocas categorías.

### 3.7 Progresión (🟡)
8 medallas de gimnasio, Liga y el misterio de las dos montañas como arco final.

---

## 4. Contenido

### 4.1 Criaturas (❓)
No hay ninguna creada aún. Mínimo para una "rebanada vertical": 1 inicial + 3 salvajes + 1 criatura de gimnasio, con su línea evolutiva. Cada criatura debería ser un archivo de datos (`Resource`), no código.

### 4.2 NPCs y diálogo (❓)
Sin implementar. El efecto de texto de `intro.gd` se puede reutilizar para los diálogos.

### 4.3 Mapas (🟡 en curso)
- `region.tscn` es el mapa principal (✅ existe pintado).
- Falta separar interiores (casas, gimnasios, Centro Pokémon, cuevas) en escenas propias.

---

## 5. Arte y sonido

### 5.1 Arte (✅)
Todo el arte fue generado con IA (nombres `ChatGPT Image…` e `Imagen de ChatGPT…`) en estilo pixel art.

| Archivo | Uso | Estado |
|---|---|---|
| `arte/personajes/protagonista_m_hoja.png` | Hoja de sprites del protagonista M (6 columnas × 4 filas: abajo, arriba, izquierda, derecha) | En uso |
| `arte/personajes/protagonista_f_hoja.png` | Hoja de sprites del protagonista F | En uso |
| `arte/tiles/tileset_region.png` | Tilesheet de 32 px usado en `region.tscn` (48 columnas): terreno, agua, costa, montañas, edificios, faros, barcos, muelles, nieve y desierto | En uso |
| `arte/tiles/tileset_hannas_story_sin_usar.png` | Variante del tilesheet con zonas moradas (Luna), árboles muertos, tumbas y cristales | Sin usar |
| `arte/tiles/tileset_sol_luna_sin_usar.png` | Otra variante de tilesheet con paleta Sol/Luna | Sin usar |
| `arte/referencia/mapa_region.png` | **Mapa de la región** con los nombres de ciudades y gimnasios | Referencia de diseño |
| `arte/intro/intro_*.png` (8) | Ilustraciones de la intro | 7 en uso; `…210339` (el Sol sobre la montaña con una multitud) no está en la intro |

🟡 Falta: sprites de criaturas, retratos, interfaz de combate, iconos de objetos, fuente propia (hoy usa la fuente por defecto de Godot).
⚠️ Los sprites de 256 px se reducen a 0.25 (en `protagonista_m`) o a 0.125 (dentro de `region`); conviene normalizar el tamaño real del personaje respecto al tile de 32 px.

### 5.2 Sonido y música (❓)
No hay ningún archivo de audio. Hace falta al menos: música de intro, de exploración, de combate, y efectos de menú, pasos y golpes.

---

## 6. Arquitectura técnica

### 6.1 Estructura actual del proyecto (reorganizada el 2026-10-11)

```
project.godot
├─ escenas/intro/          intro.tscn + intro.gd
├─ escenas/mundo/          region.tscn
├─ escenas/placeholders/   control.tscn, pokemon_evolution_black.tscn (vacías)
├─ escenas/interiores/ · escenas/combate/   (vacías, por construir)
├─ personajes/jugador/     protagonista_m / protagonista_f (.tscn + .gd)  ← M es la escena principal
├─ arte/                   personajes/ · tiles/ · intro/ · referencia/
├─ datos/ · sistemas/ · ui/ · audio/        (vacías, por construir)
└─ docs/GDD.md
```

### 6.2 Problemas detectados (✅ verificados leyendo el código)

1. **La escena principal es `protagonista_m.tscn`** (`run/main_scene` apunta a su uid), no la intro ni el mapa. Al ejecutar el juego solo aparece el personaje.
2. **`protagonista_f.gd` no llama a `move_and_slide()`**: la protagonista animaría pero no se movería. `protagonista_m.gd` sí lo hace.
3. **La intro termina sin hacer nada**: en la última escena se queda quieta y no cambia a otra escena.
4. **El mapa no tiene colisiones**: el TileSet declara una capa de física, pero ninguna casilla tiene polígono de colisión, así que el jugador atraviesa agua, árboles y edificios.
5. **No hay selección de protagonista**: las dos escenas existen pero nada permite elegir.
6. **Escalas inconsistentes**: M a 0.25, y dentro de `region` a 0.125.
7. **Colisión del personaje**: en M la colisión es hija del sprite (y se escala con él); en F cuelga del `CollisionShape2D` el `Camera2D`. Conviene unificar.
8. **Dos escenas vacías** (`control.tscn` y `pokemon evolution black.tscn`) que sobran o están a medias.
9. ~~Archivos pesados mezclados en la raíz~~ — resuelto: ordenados en `arte/`.
10. **No hay repositorio git** en la carpeta (es un ZIP), así que no hay historial.

### 6.3 Arquitectura propuesta (🟡)

```
res://
├─ escenas/        menu, intro, mundo, interiores, combate
├─ personajes/     jugador, npc
├─ datos/          criaturas/*.tres, movimientos/*.tres, objetos/*.tres
├─ sistemas/       game_state.gd (autoload), combate.gd, dialogo.gd, guardado.gd
├─ ui/             cuadro de diálogo, menú, HUD de combate
├─ arte/           sprites, tiles, ilustraciones, fuentes
└─ audio/          musica, sfx
```

- **Autoload `GameState`:** equipo, objetos, medallas, banderas de historia y posición.
- **Datos como `Resource`:** criaturas, movimientos y objetos en archivos `.tres`.
- **Combate:** máquina de estados (elegir → ejecutar → resolver → comprobar derrota).
- **Guardado:** JSON en `user://`.
- **Transiciones entre mapas:** nodo `Area2D` con destino y punto de aparición.

---

## 7. Hoja de ruta

### Hito 0 — Arreglos de base (pequeños)
- [ ] Poner `intro.tscn` como escena principal y que al terminar cargue el mundo.
- [ ] Corregir `move_and_slide()` en la protagonista.
- [ ] Añadir colisiones al TileSet (agua, árboles, edificios, acantilados).
- [ ] Unificar escala del personaje y de la cámara.
- [ ] Ordenar carpetas y borrar o completar escenas vacías.

### Hito 1 — Rebanada vertical (el "juego en miniatura")
- [ ] Menú de inicio + elección de protagonista.
- [ ] Ciudad Puerto jugable con 2 interiores y 2 NPCs con diálogo.
- [ ] Ruta con hierba alta y encuentros aleatorios.
- [ ] Combate 1 contra 1 con 1 inicial y 3 salvajes.
- [ ] Guardar y cargar partida.

### Hito 2 — Primer gimnasio
- [ ] Ciudad Costa con gimnasio de **Agua** y su líder.
- [ ] Medalla, tienda y Centro Pokémon.

### Hito 3 — Mundo completo
- [ ] Los otros 7 gimnasios, las islas Sol y Luna y las Ruinas Ancestrales.
- [ ] Evolución, captura y el arco "algo antiguo despertó".
- [ ] Liga en Ciudad Montaña.

### Hito 4 — Pulido
- [ ] Música y efectos, ajuste de dificultad, pruebas y exportación.

---

## 8. Preguntas abiertas
1. ¿Es un fan game personal o piensas publicarlo? (decide si hay que crear criaturas propias)
2. ¿Qué papel juega exactamente la **evolución** (el título del juego)?
3. ¿Quién es el antagonista: seguidores de Sol, de Luna, o "algo antiguo"?
4. ¿Movimiento libre o por casillas?
5. ¿Cuántas criaturas tendrá la primera versión jugable?
6. ¿Se mantiene el arte generado con IA o se reemplazará más adelante?
7. Nombre definitivo del juego.
