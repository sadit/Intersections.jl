# This file is part of Intersections.jl

export bk, bk!, bkfun

"""
    bkfun(onmatch::Function, L, findpos::Function=doublingsearch)
    bkfun(onmatch::Function, L, P, findpos::Function)
    bk!(output, L, findpos::Function=doublingsearch)
    bk(L, findpos::Function=doublingsearch)

Intersection

The method accepting `onmatch` calls `onmatch(L, P)` where `L` are the input lists (in some functions this could be a permutation of the input), and `P` and array of
indices where each match occurred in `L[i]`.

"""
function bkfun(onmatch::Function, L, findpos::Function=doublingsearch)
    P = ones(Int, length(L))
    bkfun(onmatch, L, P, findpos)
end

function bkfun(onmatch::Function, L, P, findpos::Function=doublingsearch)
    n = length(L)
    _max = _get_key(L[1], 1)
    c = 0
    isize = 0  # number of onmatch calls

    while true
        @inbounds for i in eachindex(P)
            P[i] = findpos(L[i], _max, P[i])
            P[i] > length(L[i]) && return
            pval = _get_key(L[i], P[i])
            if pval == _max
                c += 1
                if c == n
                    onmatch(L, P, c)
                    isize += 1
                    c = 0
                    P[i] += 1
                    P[i] > length(L[i]) && return
                    _max = _get_key(L[i], P[i])
                end
            else
                c = 0
                _max = pval
            end
        end
    end

    isize
end

function bk!(output, L, findpos::Function=doublingsearch)
    bkfun(L, findpos) do L_, P, m
        push!(output, _get_key(L_[1], P[1]))
    end

    output
end

function bk(L, findpos::Function=doublingsearch)
    output = Int64[] 
    bk!(output, L, findpos)
end
