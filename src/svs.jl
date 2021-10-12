# This file is part of Intersections.jl
export svs

"""
    svs(postinglists)

Computes the intersection of the ordered lists in `postinglists`
"""
function svs(postinglists)
    sort!(postinglists, by=p->length(p), rev=true)
    curr = baezayates(pop!(postinglists), pop!(postinglists))

    if length(postinglists) > 0
        let prev = similar(curr)

            while length(postinglists) > 0
                empty!(prev)
                prev, curr = curr, baezayates(curr, pop!(postinglists); output=prev)
            end
        end
    end

    curr
end