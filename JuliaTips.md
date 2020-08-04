### Bypass an inner constructor

```
julia> struct Foo{dim}
           Foo{dim}() where {dim} = dim isa Int ? new{dim}() : error("don't do that")
       end

julia> Foo{1}()
Foo{1}()

julia> Foo{1.0}()
ERROR: don't do that

julia> macro new(T, args...)
           (esc ∘ Expr)(:new, T, args...)
       end
@new (macro with 1 method)

julia> @new Foo{1}
Foo{1}()

julia> @new Foo{1.0}
Foo{1.0}()
```

Seen on slack.
