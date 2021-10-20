# This file is part of Intersections.jl
export umerge

"""
    _remove_empty!(P, L)

Inplace removal of empty lists
"""
function _remove_empty!(P, L)
    j = 1
    n = length(P)
    @inbounds for i in 1:n
        # @show (i, j, P[i] <= length(L[i]), P[i], length(L[i]))
        if P[i] <= length(L[i])
            if i != j
                P[j] = P[i]
                L[j] = L[i]
            end
            j += 1
        end
    end
    # @show j n P L
    
    while length(P) >= j
        pop!(P); pop!(L)
    end
end

"""
    _sort!(P, L)

Adaptive bubble sort, efficient than other approaches because we expect a few sets and almost sorted
"""
function _sort!(P::Vector{IType}, L) where {IType<:Integer}
    s = 1
    n = length(P)
    
    while s > 0
        s = 0
        for i in 1:n-1
            @inbounds if _get_key(L[i], P[i]) > _get_key(L[i+1], P[i+1])
                _swap_items!(P, i, i+1)
                _swap_items!(L, i, i+1)
                s += 1
            end
        end
    end
end


"""
    umerge(L, output=eltype(L[1])[])
    umerge(onmatch::Function, L, t=1)

Merges posting lists in `L` and saves the union in `output`.
If the method accepts `onmatch` function; this is a callback function
that is called whenever an object occurs in at least `t` posting lists.
"""
function umerge(L_, output=eltype(L_[1])[])
    umerge(L_, 1) do L, P, m
        push!(output, _get_key(L[1], P[1]))
    end
    output
end

function umerge(onmatch::Function, L, t=1)
    sort!(L, by=first)
    P = ones(Int, length(L))
    while true
        _remove_empty!(P, L)
        t > length(L) && break
        n = length(P)
        n == 0 && break
        n > 1 && _sort!(P, L)
        val = _get_key(L[1], P[1])
        m = 1
        @inbounds for i in 2:n
            if _get_key(L[i], P[i]) == val
                m += 1
            else
                break
            end
        end
        
        m >= t && onmatch(L, P, m)
        for i in 1:m
            P[i] += 1
        end
    end
end
