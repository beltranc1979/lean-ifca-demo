module

import LeanIfcaDemo.Basic
import Lean
import Lean.Util.CollectAxioms

#print axioms LeanIfcaDemo.exists_small_factor

-- Además de mostrar los axiomas, rechaza cualquier axioma no estándar.
open Lean Elab Command in
run_cmd do
  let name := `LeanIfcaDemo.exists_small_factor
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  let axioms ← liftCoreM <| Lean.collectAxioms name
  unless axioms.all (fun ax => allowed.contains ax) do
    throwError "Auditoría rechazada: {name} depende de axiomas no permitidos: {axioms}"
  logInfo m!"Auditoría superada para {name}: {axioms}"
