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
    umerge(L, output=eltype(L[1])[], P=nothing; t=1)
    umerge(onmatch::Function, L, P=nothing; t::Int=1)

Merges posting lists in `L` and saves the union in `output`.
The method accepts a callback function `onmatch` that is called whenever an object occurs in at least `t` posting lists.

# Arguments:
- `L`: The array of posting lists, the array can be destroyed in the process.
- `P`: The array of current positions in posting lists, i.e., initial state as an array of ones of size ``|L|``.

# Keyword arguments
- `t`: A positive treshold (number of occurrences) to push or apply the callback function, i.e., ``t=1`` means for union.

# About the callback function

The callback signature is `onmatch(L, P, m)` where:

- `L` is an array of postings lists, the same of the input but maybe sorted and perhaps some lists could be removed by the process.
- `P` a list of indices of the current position of `L`, e.g., `L[i][P[i]]` to obtain the current position of i-th list.
- `m` the number of occurences of the current element pointed by `P`. Note that all `L[i][P[i]]` are the same for `1 ≤ i ≤ m` (it is an alignment position).

"""
function umerge(L_, output=eltype(L_[1])[], P=nothing; t::Int=1)
    umerge(L_, P; t) do L, P, m
        @inbounds m >= t && push!(output, _get_key(L[1], P[1]))
    end
 
    output
end

function umerge(onmatch::Function, L, P=nothing; t::Int=1)
    P = P === nothing ? ones(Int32, length(L)) : P
    _sort!(P, L)  # sort!(L, by=first)
    usize = 0

    @inbounds while true
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
        
        if m >= t
            onmatch(L, P, m)
            usize += 1
        end

        for i in 1:m
            P[i] += 1
        end
    end

    usize
end
