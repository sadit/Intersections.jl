# This file is part of Intersections.jl
export imerge2, imerge2!, imerge2fun

"""
    imerge2fun(onmatch::Function, A, B)
    imerge2!(output, A, B)
    imerge2(A, B)

Computes the intersection of `A` and `B` (sorted arrays), using a merge-like algorithm, and stores it in `output` or calls `onmatch(A, i, B, j)` on every match. 
"""
function imerge2fun(onmatch::Function, A, B)
    i = j = 1
    n, m = length(A), length(B)
    count = 0
    @inbounds while i <= n && j <= m
        a = _get_key(A, i)
        b = _get_key(B, j)
        c = cmp(a, b)
        if c == 0
            onmatch(A, i, B, j)
            count += 1
            i += 1
            j += 1
        elseif c < 0
            i += 1
        else
            j += 1
        end
    end

    count
end

function imerge2!(output, A, B)
    imerge2fun(A, B) do A, i, B, j
        push!(output, A[i])
    end

    output
end

function imerge2(A, B)
    output = Int64[]
    imerge2!(output, A, B)
end

