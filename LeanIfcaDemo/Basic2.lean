import Mathlib.Data.Nat.Prime.Defs

namespace LeanIfcaDemo

/--
Todo natural no primo mayor o igual que 2 tiene un divisor no trivial
menor o igual que su raíz cuadrada entera.
-/
theorem exists_small_factor_2
    (n : ℕ)
    (hn : 2 ≤ n)
    (hnp : ¬ Nat.Prime n) :
    ∃ d : ℕ, 2 ≤ d ∧ d ∣ n ∧ d ≤ Nat.sqrt n := by
  sorry

end LeanIfcaDemo
