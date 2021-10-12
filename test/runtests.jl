using Intersections
using Test
using Random
Random.seed!(0)

@testset "Intersections.jl" begin
    @test [1, 3, 5] == svs([[1, 2, 3, 4, 5], [1, 3, 5]])

    for i in 1:100
        L = [sort!(unique(rand(10:100, i))) for j in 1:3]
        I = intersect(L...)
        # @info L I
        S = svs(copy(L))
        @test I == S
    end
end
