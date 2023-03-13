# This file is part of Intersections.jl
export umerge!, umergefun, umerge, mergefun

"""
    _remove_empty!(L, P)

Inplace removal of empty lists
"""
function _remove_empty!(L, P)
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
    _sort!(L, P)

Adaptive bubble sort, efficient than other approaches because we expect a few sets and almost sorted
"""
function _sort!(L, P::Vector)
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
     umerge!(output, L_, P_=ones(Int32, length(L_)); t::Int=1)
     umerge(L, P=ones(Int32, length(L)); t::Int=1)
     umergefun(onmatch::Function, L, P = ones(Int32, length(L)); t::Int=1)

Merges posting lists in `L` and saves the union in `output`.
If the method accepts a callback function `onmatch` that is called whenever an object occurs in at least `t` posting lists.

# Arguments:
- `L`: The array of posting lists, the array can be destroyed in the process.
- `P`: The array of current positions in posting lists, i.e., initial state as an array of ones of size ``|L|``.

# Keyword arguments
- `t`: Computes t-thresholds, i.e., t from 1 (union) to |L| (intersection) of posting lists in `L` using `findpos` storing the result set in `output`.

# About the callback function

The callback signature is `onmatch(L, P, m)` where:

- `L` is an array of postings lists, the same of the input but maybe sorted and perhaps some lists could be removed by the process.
- `P` a list of indices of the current position of `L`, e.g., `L[i][P[i]]` to obtain the current position of i-th list.
- `m` the number of occurences of the current element pointed by `P`. Note that all `L[i][P[i]]` are the same for `1 ≤ i ≤ m` (it is an alignment position).

"""
function umerge!(output, L_, P_=ones(Int32, length(L_)); t::Int=1)
    umergefun(L_, P_; t) do L, P, m
        @inbounds push!(output, _get_key(L[1], P[1]))
    end
 
    output
end

function umerge(L, P=ones(Int32, length(L)); t::Int=1)
    output = Int64[]
    umerge!(output, L, P; t)
end

function umergefun(onmatch::Function, L, P = ones(Int32, length(L)); t::Int=1)
    _sort!(L, P)  # sort!(L, by=first)
    usize = 0

    @inbounds while true
        _remove_empty!(L, P)
        n = length(L)
        (n == 0 || t > n) && break
        _sort!(L, P)
        s = _get_key(L[1], P[1])

        if t > 1
            e = _get_key(L[t], P[t])

            if s != e
                for i in 1:t-1
                    P[i] += 1
                end

                continue
            end
        end

        m = t
        while m < n 
            s == _get_key(L[m+1], P[m+1]) || break
            m += 1
        end
 
        onmatch(L, P, m)
        for i in 1:m 
            P[i] += 1
        end

        usize += 1
    end

    usize
end


"""
    mergefun(onmatch::Function, L, P; t::Int=1)

Simple wrapper around other specific operations depending on `t` value
"""
function mergefun(onmatch::Function, L, P; t::Int=1)
    n = length(L)
    t = convert(Int, t == 0 ? n : (t < 0 ? n - t : t))
    t = min(t, n)

    if t == n  # intersection
        bkfun(onmatch, L, P; t=n)
    elseif t <= 2
        umergefun(onmatch, L, P; t)
    else
        bktfun(onmatch, L, P; t)
    end
end
