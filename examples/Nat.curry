--- Natural numbers defined in Peano representation.
--- Thus, each natural number is constructor by a `Z` (zero)
--- or `S` (successor) constructor.
data Nat = Z | S Nat

-- Addition on natural numbers.
add :: Nat -> Nat -> Nat
add Z     n = n
add (S m) n = S(add m n)

--- Multiplication on natural numbers.
mul :: Nat -> Nat -> Nat
mul Z     _ = Z
mul (S m) n = add n (mul m n)

main :: Nat
main = add (S Z) (S Z)

-- Try to compact this module with:
--     > curry-compactflat --main main Nat
