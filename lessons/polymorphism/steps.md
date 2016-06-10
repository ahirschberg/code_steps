{{ 1 }}
The following is a simple explanation of polymorphism
{{ 2 }}
The type on the left of the `=` is the compile-time type of the variable `o`, set to `Set<String>`. The compiler checks to see if this matches the compile-time type on the right of the equals sign.

In this case, the type on the right is `HashSet<String>`. If we were to look at the code for `HashSet`, we would see a class header including `HashSet<E> implements Set<E>`, so this line compiles.
{{ 3 }}
`HashSet` extends from `Object`, so this line compiles.
{{ 4 }}
Uh oh...
