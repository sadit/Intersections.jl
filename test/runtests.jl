using Intersections
using Test
using Random
Random.seed!(0)

@testset "Intersections.jl" begin
    @test [1, 3, 5] == svs([[1, 2, 3, 4, 5], [1, 3, 5]])

    for ialgo2 in [baezayates, merge2]
        for i in 1:200
            L = [sort!(unique(rand(10:100, i))) for j in 1:3]
            I = sort(intersect(L...))
            @info (i, I, ialgo2)
            S = svs(copy(L), ialgo2)
            @test I == S
        end
    end
end
