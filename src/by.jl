# This file is part of Intersections.jl
export baezayates, baezayatesfun, baezayates!

"""
    baezayates(A, B, findpos=binarysearch)
    baezayates!(output, A, B, findpos=binarysearch)
    baezayatesfun(onmatch::Function, A, a_sp, a_ep, B, b_sp, b_ep, findpos)

Computes the intersection between first and second ordered lists using the Baeza-Yates algorithm [cite].
The intersection is stored in `output`.
"""
function baezayates(A, B, findpos::Function=binarysearch)
    output = Int64[]
    baezayates!(output, A, B)
end

function baezayates!(output, A, B, findpos::Function=binarysearch)
    if length(A) > 0 && length(B) > 0
        baezayatesfun(A, B, findpos) do A_, i, B_, j
            push!(output, A[i])
        end
    end

    output
end

function baezayatesfun(onmatch::Function, A, B, findpos::Function=binarysearch)
    baezayatesfun(onmatch, A, 1, length(A), B, 1, length(B), findpos) 
end

function baezayatesfun(onmatch::Function, A, a_sp, a_ep, B, b_sp, b_ep, findpos::Function)
    (a_ep < a_sp || b_ep < b_sp) && return 0
    #@show ((a_sp, a_ep), (b_sp, b_ep))
    imedian = ceil(Int, (a_ep + a_sp) / 2)
    median = _get_key(A, imedian)
    medpos = min(findpos(B, median, b_sp), b_ep) ## our findpos returns n + 1 when median is larger than B[end]
    matches = median === _get_key(B, medpos)
    
    count = baezayatesfun(onmatch, A, a_sp, imedian - 1, B, b_sp, medpos - matches, findpos)
    if matches
        count += 1
        onmatch(A, imedian, B, medpos)
    end

    count + baezayatesfun(onmatch, A, imedian+1, a_ep, B, medpos+matches, b_ep, findpos)
end
