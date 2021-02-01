## Boolean negation

In Python, we can do

```
if not foo(x)
  ...
```
In Julia,

```
if !(foo(x))
  ...
```

although we can ommit the parentheses,

```julia
if !foo(x)
  ...
```
Write a macro that lets one use Python-style boolean negation.

```julia
macro not(ex)
         :(!($(esc(ex))))
       end
@not (macro with 1 method)

julia> if @not false
         println(true)
       end
true
```
Seen on: Zulip.
