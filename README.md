
# Lean IFCA Demo

Proyecto mínimo de Lean 4 con Mathlib para probar la compilación,
la auditoría axiomática y la verificación de demostraciones
matemáticas en los nodos HPC del IFCA.

El repositorio incluye dos experimentos independientes:

1. Compilación y auditoría de un teorema sobre divisores.
2. Verificación de un teorema elemental mediante Lake Comparator.

## Versiones

- Lean: `v4.35.0`, fijado en `lean-toolchain`.
- Mathlib: `v4.35.0`, fijada en `lakefile.toml`.

Lean 4.35.0 incorpora los comandos `lake check` y
`lake comparator`.

## Archivos del proyecto

| Archivo | Función |
|---|---|
| `lean-toolchain` | Versión de Lean |
| `lakefile.toml` | Configuración de Lake y Mathlib |
| `lake-manifest.json` | Revisiones exactas de dependencias |
| `LeanIfcaDemo.lean` | Entrada de la biblioteca |
| `LeanIfcaDemo/Basic.lean` | Teorema sobre divisores |
| `Audit.lean` | Auditoría axiomática |
| `Challenge.lean` | Enunciado de referencia para Comparator |
| `Solution.lean` | Demostración para Comparator |
| `comparator.json` | Configuración de Comparator |

## Preparación

Requisitos:

- Git
- Lean/Elan
- Acceso a Internet
- Linux y bubblewrap para Comparator

Desde la raíz del proyecto:

```bash
lake update
lake exe cache get
lake build
```

La caché de Mathlib evita compilar toda la biblioteca
desde cero.

`lake update` genera `lake-manifest.json`. Este archivo
debe incluirse en el repositorio para reproducir las
versiones exactas de las dependencias y permitir
el funcionamiento de Comparator.

## Experimento A: compilación y auditoría

### Teorema matemático

Todo natural `n ≥ 2` que no es primo tiene un divisor
`d` tal que:

- `2 ≤ d`
- `d ∣ n`
- `d ≤ Nat.sqrt n`

`Nat.sqrt` es la raíz cuadrada entera.

El teorema se denomina:

`LeanIfcaDemo.exists_small_factor`

Su demostración está en `LeanIfcaDemo/Basic.lean`
y utiliza Mathlib, sin `sorry` ni axiomas propios.

### Compilación

```bash
lake build
```

Este comando compila la biblioteca, pero no ejecuta
automáticamente `Audit.lean`.

### Auditoría axiomática

```bash
lake env lean Audit.lean
```

La auditoría comprueba los axiomas utilizados por
el teorema y sus dependencias.

Admite únicamente los axiomas estándar:

- `propext`
- `Classical.choice`
- `Quot.sound`

También admite cualquier subconjunto de ellos.

Rechaza `sorryAx`, utilizado por demostraciones
incompletas.

### Prueba negativa

En una rama de prueba, sustituir temporalmente
la demostración de `exists_small_factor` por `by sorry`.

`lake build` puede terminar con una advertencia,
pero la auditoría debe detectar `sorryAx`.

Restaurar la demostración original al finalizar.

## Experimento B: Lake Comparator

Desde Lean 4.35.0, Lake incorpora Comparator
para verificar que una solución demuestra el mismo
enunciado que una especificación de referencia.

Este experimento es independiente del anterior.

### Teorema elegido

Para todo número natural `n`:

`n + 0 = n`

Nombre del teorema:

`ComparatorDemo.demo_add_zero`

### Challenge.lean

Contiene el enunciado de referencia con un `sorry`:

```lean
import Mathlib

namespace ComparatorDemo

theorem demo_add_zero (n : Nat) : n + 0 = n := by
  sorry

end ComparatorDemo
```

El `sorry` del challenge representa una demostración
pendiente. No es la solución que se pretende validar.

### Solution.lean

Contiene la demostración:

```lean
import Mathlib

namespace ComparatorDemo

theorem demo_add_zero (n : Nat) : n + 0 = n := by
  exact Nat.add_zero n

end ComparatorDemo
```

### comparator.json

Configura los módulos, el teorema y los axiomas
permitidos:

```json
{
  "challenge_module": "Challenge",
  "solution_module": "Solution",
  "theorem_names": [
    "ComparatorDemo.demo_add_zero"
  ],
  "definition_names": [],
  "permitted_axioms": [
    "propext",
    "Quot.sound",
    "Classical.choice"
  ]
}
```

### Ejecución

En Linux, con `bubblewrap` instalado y operativo:

```bash
lake comparator
```

Comparator construye y exporta los módulos en un
entorno aislado y comprueba:

1. Que el enunciado del teorema coincide en ambos módulos.
2. Que la demostración utiliza únicamente axiomas permitidos.
3. Que la demostración es aceptada por el kernel de Lean.

Para añadir comprobadores externos:

```bash
lake comparator --paranoid
```

La opción `--paranoid` puede aumentar considerablemente
el tiempo y los recursos necesarios.

### Independencia respecto a Basic.lean

Comparator solo compara los teoremas indicados
en `comparator.json`.

En este ejemplo comprueba exclusivamente
`ComparatorDemo.demo_add_zero`.

No compara ni audita el teorema
`LeanIfcaDemo.exists_small_factor` de `Basic.lean`.

Los módulos Challenge y Solution tampoco importan
`LeanIfcaDemo.Basic`.

De este modo se pueden ilustrar por separado:

- La compilación y auditoría axiomática.
- La comparación entre una especificación y su solución.

### Prueba negativa de Comparator

Para comprobar que Comparator rechaza una solución
incompleta, modificar temporalmente `Solution.lean`:

```lean
import Mathlib

namespace ComparatorDemo

theorem demo_add_zero (n : Nat) : n + 0 = n := by
  sorry

end ComparatorDemo
```

Ejecutar:

```bash
lake comparator
```

La comprobación debe fallar porque `sorryAx`
no figura entre los axiomas permitidos.

Restaurar la demostración con `Nat.add_zero` al terminar.

## Comprobación adicional: lake check

Lean 4.35.0 incorpora también:

```bash
lake check
```

Este comando construye los objetivos predeterminados
del proyecto, comprueba sus exportaciones con el
kernel de Lean y rechaza axiomas no estándar.

También puede ejecutarse:

```bash
lake check --paranoid
```

A diferencia de Comparator, `lake check` no necesita
dos módulos con el mismo enunciado.

En este proyecto, el objetivo predeterminado es
la biblioteca `LeanIfcaDemo`.

## Resumen de comandos

| Comando | Objetivo |
|---|---|
| `lake build` | Compilar la biblioteca |
| `lake env lean Audit.lean` | Auditar el teorema sobre divisores |
| `lake comparator` | Verificar la solución de `n + 0 = n` |
| `lake comparator --paranoid` | Añadir verificadores externos |
| `lake check` | Comprobar los objetivos predeterminados |

## Datos para el formulario del IFCA

Para el experimento de compilación:

| Campo | Valor |
|---|---|
| Repositorio | `https://github.com/beltranc1979/lean-ifca-demo.git` |
| Comando | `lake build` |
| Módulo | `LeanIfcaDemo.Basic` |
| Teorema | `LeanIfcaDemo.exists_small_factor` |

Para el experimento de Comparator:

| Campo | Valor |
|---|---|
| Repositorio | `https://github.com/beltranc1979/lean-ifca-demo.git` |
| Comando | `lake comparator` |
| Módulo de referencia | `Challenge` |
| Módulo de solución | `Solution` |
| Teorema | `ComparatorDemo.demo_add_zero` |

El segundo experimento requiere un entorno Linux
compatible con el aislamiento de `bubblewrap`.

## Publicación en GitHub

Subir los archivos fuente y de configuración a la
raíz del repositorio, conservando la subcarpeta
`LeanIfcaDemo`.

Incluir el `lake-manifest.json` generado por Lake.

No subir los productos de compilación de `.lake`.

## Alcance

`lake build` comprueba la compilación del proyecto.

`Audit.lean` inspecciona las dependencias axiomáticas
del teorema seleccionado.

`lake comparator` compara una solución con un
enunciado de referencia y verifica la demostración
mediante el kernel.

`lake check` comprueba los objetivos predeterminados
del proyecto y sus dependencias axiomáticas.

Ninguno de estos procedimientos sustituye la revisión
matemática del enunciado que se desea demostrar.
