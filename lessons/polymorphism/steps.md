{ code-anchor: "//~" }
# { step: 1, hide: [e] }
## Inheritance at compile time in Java
In order for your Java code to compile, it has to pass the compiler's type checks. First, let's look at how this is checked when a variable is assigned via the `=` operator. 

# { step: 2, pass: [a] }
Whenever something in Java is assigned to a variable, the variable's type must match the thing it is being assigned to.

This statement is valid, because the type `String` given to the variable matches the type `String` given to the string literal.
# { step: 3a, spotlight: [b, c] }
What about this line? `Object` isn't the same as `String`. How does the compiler handle this?
# { step: 3b, pass: [b, c] }
The compiler has no issue with this, because `String` inherits from `Object`. In other words, a `String` is an `Object`, and so the statement is valid.

# { step: 3c, spotlight: [b, c]}
How will the compiler process this line, keeping in mind that `strAsObj` is defined as `"string b"`?
# {step: 4, fail: [b, d]}
This line fails! Even though `strAsObj` has a value of type `String`, we gave it the type `Object` on the line above. **This is a really important concept!** 
