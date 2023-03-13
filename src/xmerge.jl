# This file is part of Intersections.jl
export xmergefun, xmerge!, xmerge

"""
    xmergefun(onmatch::Function, L, P; t::Int=1)
    xmerge!(output, L, P=ones(Int32, length(L_)); t::Int=1)
    xmerge(L, P=ones(Int32, length(L_)); t::Int=1)

Solves t-threshold set operation using other algorithms choosing among them by given `t`

# Arguments:
- `onmatch`: callback function `onmatch(L, P, m)`, where `m` is the size of the set; `P` contains alignment-indices on `L`
- `output`: vector like to store the t-threshold set
- `L`: the list of posting lists to be merged. The posting lists are left untouched but the container is modified.
- `P`: indices of the current merging-state (idem to `L`)
- `t`: the threshold, i.e., `t=1` (union) ... `t=|L|` performs intersection)

Simple wrapper around other specific operations depending on `t` value
"""
function xmergefun(onmatch::Function, L::AbstractVector, P::AbstractVector; t::Int=1)
    n = length(L)
    t = convert(Int, t == 0 ? n : (t < 0 ? n - t : t))
    t = min(t, n)

    if t == n  # intersection
        bkfun(onmatch, L, P)
    elseif t <= 2
        umergefun(onmatch, L, P; t)
    else
        bktfun(onmatch, L, P; t)
    end
end

function xmerge!(output, L_::AbstractVector, P_::AbstractVector=ones(Int32, length(L_)); t::Int=1)
    xmergefun(L_, P_; t) do L, P, m
        @inbounds push!(output, _get_key(L[1], P[1]))
    end
 
    output
end

function xmerge(L::AbstractVector, P::AbstractVector=ones(Int32, length(L)); t::Int=1)
    output = Int64[]
    xmerge!(output, L, P; t)
end
