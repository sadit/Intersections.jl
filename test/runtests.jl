using Intersections
using Test, JET, Random
Random.seed!(0)

@testset "Search" begin
    for i in 1:1000
        L = sort!(unique(rand(1:1000, i)))
        v = rand(L)
        p = findfirst(x -> x == v, L)

        for salgo in (binarysearch, doublingsearch, doublingsearchrev, seqsearch, seqsearchrev)
            pos = salgo(L, v)
            i == 1 && @test_call salgo(L, v)
            @test p == pos #&& error("gold:$p != found:$pos; L=$L, searching for: $v")
        end

        v = 0
        for salgo in (binarysearch, doublingsearch, doublingsearchrev, seqsearch, seqsearchrev)
            i == 1 && @test_call salgo(L, v)
            @test 1 == salgo(L, v)
        end

        v = 2000
        for salgo in (binarysearch, doublingsearch, doublingsearchrev, seqsearch, seqsearchrev)
            i == 1 && @test_call salgo(L, v)
            @test length(L)+1 == salgo(L, v)
        end

    end
end

@testset "SVS" begin
    @test [1, 3, 5] == svs([[1, 2, 3, 4, 5], [1, 3, 5]])
    @test_call svs([[1, 2, 3, 4, 5], [1, 3, 5]])
    
    for ialgo2 in [baezayates, imerge2]
        n = 300
        for i in 1:n
            L = [sort!(unique(rand(1:n, i))) for j in 1:3]
            I = sort(intersect(L...))
            #@info (i, I, ialgo2)
            Lc = copy(L)
            S = svs(Lc, ialgo2)
            i == 1 && @test_call svs(Lc, ialgo2)
            @test I == S
        end
    end
end


@testset "BK" begin
    LIST = [[1, 2, 3, 4, 5, 6], [1, 3, 5]]
    @test [1, 3, 5] == bk(copy(LIST))
    @test_call bk!(Int[], copy(LIST), binarysearch)
    @test_call bk!(Int[], copy(LIST), doublingsearch)
    @test_call bk!(Int[], copy(LIST), doublingsearchrev)

    for salgo in [binarysearch, doublingsearch, doublingsearchrev]
        n = 300
        for i in 1:n
            L = [sort!(unique(rand(1:n, i))) for j in 1:3]
            I = sort(intersect(L...))
            Lc = copy(L)
            S = bk!(Int[], Lc, salgo)
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
        S = umerge!(Int[], L)
        i == 1 && @test_call umerge!(Int[], L)
        @test I == S
    end
end
