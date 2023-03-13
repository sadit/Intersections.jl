# This file is part of Intersections.jl

export bkt, bkt!, bktfun

"""
    bktfun(onmatch::Function, L, findpos::Function=doublingsearch; t::Int=length(L))
    bktfun(onmatch::Function, L, P, findpos::Function; t::Int=length(L))
    bkt!(output, L, findpos::Function=doublingsearch; t::Int=length(L)))
    bkt(L, findpos::Function=doublingsearch; t::Int=length(L))

Barybay & Kenyon t-thresholds 

The method accepting `onmatch` calls `onmatch(L, P)` where `L` are the input lists (in some functions this could be a permutation of the input), and `P` and array of
indices where each match occurred in `L[i]`.

"""
function bktfun(onmatch::Function, L, findpos::Function=doublingsearch; t::Int=length(L))
    P = ones(Int, length(L))
    bktfun(onmatch, L, P, findpos; t)
end

function show_list_state(L, P, nick)
    println(stderr, "====== $nick ===")
    println(stderr, "L: $L")
    println(stderr, "P: $P")
    for i in eachindex(L)
        if P[i] > length(L[i])
            println(stderr, "@ $i> beyond list frontier P[i] = $(P[i]), |L[i]| = $(length(L[i]))")
        else
            println(stderr, "@ $i> L[] = $(L[i][P[i]]) -- P[] = $(P[i])")
        end
    end
end

function bktfun(onmatch::Function, L, P, findpos::Function; t::Int=length(L))
    usize = 0  # number of onmatch calls

    @inbounds while length(L) > 0
        _remove_empty!(L, P)
        n = length(L)
        (n == 0 || t > n) && break
        _sort!(L, P)
        s = _get_key(L[1], P[1])
        if t > 1
            e = _get_key(L[t], P[t])
            if s != e
                for i in 1:t-1
                    P[i] = findpos(L[i], e, P[i])
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
        usize += 1

        for i in 1:m
            P[i] += 1
        end
        
        # show_list_state(L, P, "END t=$t")
    end

    usize
end

function bkt!(output, L, findpos::Function=doublingsearch; t::Int=length(L))
    bktfun(L, findpos; t) do L_, P, m
        push!(output, _get_key(L_[1], P[1]))
    end

    output
end

function bkt(L, findpos::Function=doublingsearch; t::Int=length(L))
    output = Int64[] 
    bkt!(output, L, findpos; t)
end
