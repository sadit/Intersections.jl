# This file is part of Intersections.jl
export svs

"""
    svs(postinglists, intersect2=baezayates)

Computes the intersection of the ordered lists in `postinglists` using a
small vs small strategy. Accepts an intersection algorithm of two sets.
"""
function svs(postinglists, intersect2=baezayates)
    sort!(postinglists, by=length, rev=true)
    curr = intersect2(pop!(postinglists), pop!(postinglists))

    if length(postinglists) > 0
        let prev = similar(curr)

            while length(postinglists) > 0
                empty!(prev)
                prev, curr = curr, intersect2(curr, pop!(postinglists), prev)
            end
        end
    end

    curr
end