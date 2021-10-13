# This file is part of Intersections.jl
export merge, merge2

function merge2(A, B, output=eltype(A)[])
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

function merge(L, findpos::Function=doublingsearch; output=eltype(A)[])
    P = ones(Int, length(L))
    N = length.(L)
    n = length(n)
    _max = first(first(L))
    c = 0

    while true
        @inbounds for i in eachindex(P)
            P[i] = findpos(L[i], _max, P[i])
            P[i] > N[i] && return output
            pval = L[i][P[i]]
            if pval == _max
                c += 1
                if c == n
                    push!(output, pval)
                    c = 0
                    P[i] += 1
                    P[i] > N[i] && return output
                    _max = L[i][P[i]]
                end
            else
                c = 0
                _max = pval
            end
        end
    end

    output
end