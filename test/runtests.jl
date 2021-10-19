using Intersections
using Test
using Random
Random.seed!(0)

@testset "SVS" begin
    @test [1, 3, 5] == svs([[1, 2, 3, 4, 5], [1, 3, 5]])
    
    for ialgo2 in [baezayates, imerge2]
        n = 300
        for i in 1:n
            L = [sort!(unique(rand(1:n, i))) for j in 1:3]
            I = sort(intersect(L...))
            #@info (i, I, ialgo2)
            S = svs(copy(L), ialgo2)
            @test I == S
        end
    end
end


@testset "BK" begin
    @test [1, 3, 5] == bk([[1, 2, 3, 4, 5], [1, 3, 5]])

    for salgo in [binarysearch, doublingsearch]
        n = 300
        for i in 1:n
            L = [sort!(unique(rand(1:n, i))) for j in 1:3]
            I = sort(intersect(L...))
            #@info (i, I, bk, salgo)
            S = bk(L, Int[], salgo)
            @test I == S
        end
    end
end



@testset "Merge/Union" begin
    @test [1, 2, 3, 4, 5, 6, 7] == umerge([[1, 2, 3, 4, 5, 6], [1, 3, 5, 7]])
    n = 500
    for i in 1:n
        L = [sort!(unique(rand(1:n, i))) for j in 1:5]
        I = sort(union(L...))
        #@info (i, I, bk, salgo)
        S = umerge(L, Int[])
        @test I == S
    end
end