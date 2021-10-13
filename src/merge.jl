# This file is part of Intersections.jl
export merge


function merge(onmatch::Function, A, B)
    i = j = 1
    n, m = length(A), length(B)

    @inbounds while i <= n && j <= m
        c = cmp(A[i], B[j])
        if c == 0
            i += 1
            j += 1
            onmatch(A[i])
        elseif c < 0
            i += 1
        else
            j += 1
        end
    end
end
