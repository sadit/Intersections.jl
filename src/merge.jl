# This file is part of Intersections.jl
export merge2

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
