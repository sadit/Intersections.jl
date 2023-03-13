# This file is part of Intersections.jl
export svs

"""
    svs(postinglists, intersect2=baezayates!)

Computes the intersection of the ordered lists in `postinglists` using a
small vs small strategy. Accepts an intersection algorithm of two sets.
"""
function svs!(curr, prev, postinglists, intersect2=baezayates!)
    sort!(postinglists, by=length, rev=true)
    intersect2(curr, pop!(postinglists), pop!(postinglists))
    sizehint!(prev, length(curr)) 

    while length(postinglists) > 0
        empty!(prev)
        prev, curr = curr, intersect2(prev, curr, pop!(postinglists))
    end

    curr
end

function svs(postinglists, intersect2=baezayates!)
    curr = Int64[]
    prev = Int64[]

    svs!(curr, prev, postinglists, intersect2)
end
