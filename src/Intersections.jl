# This file is part of Intersections.jl

module Intersections
@inline _get_key(arr::T, i) where T = @inbounds arr[i]

@inline function _swap_items!(arr::T, i, j) where T
    @inbounds tmp = arr[i]
    @inbounds arr[i] = arr[j]
    @inbounds arr[j] = tmp
end

include("search.jl")
include("by.jl")
include("merge.jl")
include("imerge.jl")
include("svs.jl")
include("bk.jl")
include("bkt.jl")

end
