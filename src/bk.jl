# This file is part of Intersections.jl
export bk

function bk(L, output=eltype(L[1])[], findpos::Function=doublingsearch)
    P = ones(Int, length(L))
    n = length(L)
    _max = _get_key(L[1], 1)
    c = 0

    while true
        @inbounds for i in eachindex(P)
            P[i] = findpos(L[i], _max, P[i])
            P[i] > length(L[i]) && return output
            pval = _get_key(L[i], P[i])
            if pval == _max
                c += 1
                if c == n
                    push!(output, pval)
                    c = 0
                    P[i] += 1
                    P[i] > length(L[i]) && return output
                    _max = _get_key(L[i], P[i])
                end
            else
                c = 0
                _max = pval
            end
        end
    end

    output
end