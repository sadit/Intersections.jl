# This file is part of Intersections.jl
export baezayates

"""
    baezayates(A, B, output=eltype(A)[], findpos=binarysearch)

Computes the intersection between first and second ordered lists using the Baeza-Yates algorithm [cite].
The intersection is stored in `output`.
"""
function baezayates(A, B, output=eltype(A)[], findpos=binarysearch)
    length(A) > 0 && length(B) > 0 && baezayates(A, 1, length(A), B, 1, length(B), output, findpos)
    output
end

function baezayates(A, a_sp, a_ep, B, b_sp, b_ep, output, findpos)
    (a_ep < a_sp || b_ep < b_sp) && return output
    #@show ((a_sp, a_ep), (b_sp, b_ep))
    imedian = ceil(Int, (a_ep + a_sp) / 2)
    median = _get_key(A, imedian)
    medpos = min(findpos(B, median, b_sp), b_ep) ## our findpos returns n + 1 when median is larger than B[end]
    matches = median === _get_key(B, medpos)
    #@show ("---", (a_sp, imedian-1), (b_sp, medpos-matches))
    #@show ("+++", (imedian+1, a_ep), (medpos+matches, b_ep))
    #a_ep != length(A) && exit(1)
    
    baezayates(A, a_sp, imedian - 1, B, b_sp, medpos - matches, output, findpos)
    matches && push!(output, median)
    baezayates(A, imedian+1, a_ep, B, medpos+matches, b_ep, output, findpos)

    output
end
