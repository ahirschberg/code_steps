{{ 1 }}
The following is a simple explanation of polymorphism
{{ 2 }}
The type on the left of the `=` is the compile-time type of the variable `o`, set to `Set<String>`. The compiler checks to see if this matches the compile-time type on the right of the equals sign.

In this case, the type on the right is also `Set<String>`, so this line compiles.
{{ 3 }}
Now the variable on the left does not match the variable on the right. 

The compiler checks this by determining if the right side is the same as or a subclass of the class on the left. The type on the right is `String`, which inherits from `Object`, not `Set<String>` or a subclass.
