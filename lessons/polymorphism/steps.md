#step hide: [e], append: true
## Inheritance at compile time in Java
In order for your Java code to compile, it has to pass the compiler's type checks. First, let's look at how this is checked when a variable is assigned via the `=` operator.


#step { spotlight: [a] }
Keeping in mind the types given, will this statement compile?


#step { pass: [a] }
Whenever something in Java is assigned to a variable, the variable's type must match the thing it is being assigned to.

This statement is valid, because the type `String` given to the variable matches the type `String` given to the string literal.


#step { spotlight: [b, c] }
What about this line? `Object` isn't the same as `String`. How does the compiler handle this?


#step { pass: [b, c] }
The compiler has no issue with this, because `String` inherits from `Object`. In other words, a `String` is an `Object`, and so the statement is valid.


#step { spotlight: [b, d]}
How will the compiler process this line, keeping in mind that `strAsObj` is defined as `"string b"`?


#step { fail: [b, d] }
This line fails! The compiler doesn't care that `strAsObj` has a value of `"string b"`.

We gave `strAsObj` the static type `Object`, and when checking types at compile time **only the static types are considered**. So the compiler compares `String` to `Object`, and finds that `Object` does not inherit from `String`.
