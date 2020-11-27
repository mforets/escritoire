### Optional threads

```julia
macro maybe_threaded(ex)
    if Threads.nthreads() == 1
        return esc(ex)
    else
        return esc(:(Threads.@threads $ex))
    end
end
```

Seen on SO: https://stackoverflow.com/questions/58580436/how-to-make-use-of-threads-optional-in-a-julia-function

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
