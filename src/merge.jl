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
    # @info "_sort!"
    while s > 0
        s = 0
        for i in 1:n-1
            @inbounds if L[i][P[i]] > L[i+1][P[i+1]]
                _swap_items(P, i, i+1)
                _swap_items(L, i, i+1)
                s += 1
            end
        end
    end
end

function _swap_items(arr::T, i, j) where T
    tmp = arr[i]
    arr[i] = arr[j]
    arr[j] = tmp
end

"""
    umerge(L, output=eltype(L[1])[])

Merges posting lists in `L` and saves the union in `output`
"""
function umerge(L, output=eltype(L[1])[])
    sort!(L, by=first)
    P = ones(Int, length(L))
    while true
        _remove_empty!(P, L)
        n = length(P)
        n == 0 && break
        n > 1 && _sort!(P, L)
        # @info [L[i][P[i]] for i in eachindex(P)]        
        val = L[1][P[1]]
        push!(output, val)
        P[1] += 1

        @inbounds for i in 2:n
            if L[i][P[i]] == val
                P[i] += 1
            else
                break
            end
        end
    end

    output
end
