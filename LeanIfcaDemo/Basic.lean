import Mathlib.Data.Nat.Prime.Defs

namespace LeanIfcaDemo

/--
Todo natural no primo mayor o igual que 2 tiene un divisor no trivial
menor o igual que su raíz cuadrada entera.
-/
theorem exists_small_factor
    (n : ℕ)
    (hn : 2 ≤ n)
    (hnp : ¬ Nat.Prime n) :
    ∃ d : ℕ, 2 ≤ d ∧ d ∣ n ∧ d ≤ Nat.sqrt n := by
  classical
  apply Classical.byContradiction
  intro h
  apply hnp
  apply Nat.prime_def_le_sqrt.mpr
  refine ⟨hn, ?_⟩
  intro d hd hbound hdvd
  exact h ⟨d, hd, hdvd, hbound⟩

end LeanIfcaDemo
