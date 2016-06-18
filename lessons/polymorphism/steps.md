{{ 1 }}
# Java Polymorphism
How the compiler checks for valid polymorphism in java.
{{ 2 }}
The type on the left of the `=` is the compile-time type of the variable `o`, set to `Set<String>`. The compiler checks to see if this matches the compile-time type on the right of the equals sign.

In this case, the type on the right is `HashSet<String>`. If we were to look at the code for `HashSet`, we would see a class header including `HashSet<E> implements Set<E>`, so this line compiles.
{{ 3 }}
`HashSet` extends from `Object`, so this line compiles.
{{ 4 }}
This line doesn't compile. Why?

Although *we* know that `o` is instantiated as a `HashSet<String>`, the compiler does not. At compile time, only the type on the left of the equals sign is looked at. The compiler only checks whether the type given to `o`, `Object`, has `Set` as a parent class or interface.
