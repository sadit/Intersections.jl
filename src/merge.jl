# This file is part of Intersections.jl
export imerge2, umerge

# intersection merge
function imerge2(A, B, output=eltype(A)[])
    i = j = 1
    n, m = length(A), length(B)

    @inbounds while i <= n && j <= m
        c = cmp(A[i], B[j])
        if c == 0
            push!(output, A[i])
            i += 1
            j += 1
        elseif c < 0
            i += 1
        else
            j += 1
        end
    end

    output
end

### union merge
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

function _sort!(P, L)
    s = 1
    n = length(P)
    while s > 0
        s = 0
        for i in 1:n-1
            if L[i][P[i]] > L[i+1][P[i+1]]
                P[i], P[i+1] = P[i+1], P[i]
                L[i], L[i+1] = L[i+1], L[i]
                s += 1
            end
        end
    end
end

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