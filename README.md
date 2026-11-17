# Lean IFCA Demo

Proyecto mínimo de Lean con Mathlib para probar la compilación y la auditoría
axiomática de un teorema desde un repositorio público de GitHub.

## Resultado formalizado

Todo natural `n ≥ 2` que no es primo tiene un divisor `d` tal que:

- `2 ≤ d`;
- `d ∣ n`;
- `d ≤ Nat.sqrt n`.

`Nat.sqrt` es la raíz cuadrada entera, redondeada hacia abajo. El resultado se
formula para naturales; no incluye enteros negativos. La prueba usa la
caracterización `Nat.prime_def_le_sqrt` de Mathlib, sin `sorry` ni axiomas propios.

## Versiones

- Lean: `v4.24.0`, fijado en `lean-toolchain`.
- Mathlib: `v4.24.0`, fijada en `lakefile.toml`.

## Archivos

| Archivo | Función |
| --- | --- |
| `lean-toolchain` | Versión de Lean. |
| `lakefile.toml` | Configuración y dependencia de Mathlib. |
| `LeanIfcaDemo.lean` | Entrada de la biblioteca. |
| `LeanIfcaDemo/Basic.lean` | Enunciado y demostración. |
| `Audit.lean` | Informe y rechazo de axiomas no estándar. |
| `.gitignore` | Excluye descargas y productos de compilación. |

## Preparación y comprobación

Requisitos: Git, Lean/Elan y acceso a Internet. Desde la raíz del proyecto:

```bash
lake update
lake exe cache get
lake build
lake env lean Audit.lean
```

La caché evita compilar Mathlib desde cero. La primera ejecución requiere
espacio en disco y tiempo para descargar las dependencias.

`lake update` genera `lake-manifest.json`. Una vez comprobado el proyecto,
conviene añadir ese archivo al repositorio para conservar las revisiones
exactas de todas las dependencias. No se incluye un manifiesto inventado:
lo genera Lake al resolver las dependencias.

`lake build` compila la biblioteca; no ejecuta automáticamente `Audit.lean`.
El último comando realiza la auditoría y debe terminar sin errores.
Acepta únicamente `propext`, `Classical.choice` y `Quot.sound`, o un subconjunto
(incluido el conjunto vacío). Rechaza también `sorryAx`.

## Datos para el formulario del IFCA

| Casilla | Valor |
| --- | --- |
| Repositorio | `https://github.com/TU_USUARIO/lean-ifca-demo.git` |
| Comando | `lake build` |
| Módulo | `LeanIfcaDemo.Basic` |
| Teorema | `LeanIfcaDemo.exists_small_factor` |

Sustituye `TU_USUARIO` por tu usuario de GitHub. Para este proyecto, el script
Bash del formulario debe descargar la caché con `lake_project exe cache get`
antes de ejecutar la compilación, después de instalar la versión de Lean.
La auditoría añadida al formulario comprueba el teorema indicado y sus
dependencias. No necesita ejecutar el archivo `Audit.lean` del repositorio.

Lean 4.24.0 permite `lake build` y esta auditoría; no ofrece `lake check`.

## Publicación en GitHub

Crea un repositorio público. Sube el contenido de esta carpeta a su raíz,
conservando la subcarpeta `LeanIfcaDemo`. `lakefile.toml` y `lean-toolchain`
deben quedar directamente en la raíz del repositorio. No subas el ZIP como
único archivo ni los productos de `.lake`.

## Prueba negativa opcional

En una rama de prueba, sustituye temporalmente la demostración por `by sorry`.
`lake build` puede terminar con una advertencia, pero `lake env lean Audit.lean`
y la auditoría del formulario deben fallar por la dependencia de `sorryAx`.
Restaura la demostración completa al terminar.

## Alcance de la comprobación

La auditoría comprueba las dependencias axiomáticas del teorema indicado.
No usa un núcleo independiente ni sustituye la revisión del enunciado.
Este paquete se ha revisado estáticamente; no se ha ejecutado su compilación
en el entorno donde se preparó.
