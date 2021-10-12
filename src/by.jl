# This file is part of Intersections.jl
export baezayates

"""
    baezayates(A, B; output=Vector{eltype(A)}(undef, 0), findpos=binarysearch)

Computes the intersection between first and second ordered lists using the Baeza-Yates algorithm [cite].
The intersection is stored in `output`.
"""
function baezayates(A, B, output, findpos)
    m = length(A)
    n = length(B)
    if m == 0 || n == 0
        return output
    end
    imedian = ceil(Int, m / 2)
    median = A[imedian]
    pos = min(findpos(B, median), n) ## our findpos returns n + 1 when median is larger than B[end]
    pos_matches = pos > 0 && median === B[pos]
    _A = @view A[1:imedian-1]
    left_pos = pos_matches ? pos - 1 : pos
    _B = @view B[1:left_pos]

    length(_A) > 0 && length(_B) > 0 && baezayates(_A, _B, output, findpos)

    if pos == 0
        pos += 1
    elseif median === B[pos]
        push!(output, B[pos])
        pos += 1
    end

    _A = @view A[imedian+1:m]
    _B = @view B[pos:n]
    # @show (imedian, pos, m, n, _A, _B, length(_A), length(_B))
    length(_A) > 0 && length(_B) > 0 && baezayates(_A, _B, output, findpos)

    output
end

baezayates(A, B; output=Vector{eltype(A)}(undef, 0), findpos=binarysearch) = baezayates(A, B, output, binarysearch)