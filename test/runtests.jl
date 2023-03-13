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

randset(n, m) = [sort!(unique(rand(1:n, 100))) for j in 1:m]

@testset "SVS" begin
    @test [1, 3, 5] == svs([[1, 2, 3, 4, 5], [1, 3, 5]])
    @test_call svs([[1, 2, 3, 4, 5], [1, 3, 5]])
    
    for ialgo2 in [baezayates!, imerge2!]
        n = 300
        for i in 1:n
            L = randset(n, 3)
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
    @test [1, 3, 5] == bkt(copy(LIST))
    @test_call bk!(Int[], copy(LIST), binarysearch)
    @test_call bk!(Int[], copy(LIST), doublingsearch)
    @test_call bk!(Int[], copy(LIST), doublingsearchrev)
    @test_call bkt!(Int[], copy(LIST))

    for salgo in [binarysearch, doublingsearch, doublingsearchrev]
        n = 300
        for i in 1:n
            L = randset(n, 3)
            I = sort(intersect(L...))
            Lc = copy(L)
            S = bk!(Int[], Lc, salgo)
            @test I == S
        end
    end
end


@testset "Merge/Union" begin
    @test [1, 2, 3, 4, 5, 6, 7] == umerge([[1, 2, 3, 4, 5, 6], [1, 3, 5, 7]])
    @test [1, 2, 3, 4, 5, 6, 7] == bkt([[1, 2, 3, 4, 5, 6], [1, 3, 5, 7]]; t=1)
    n = 300
    for i in 1:n
        L = randset(n, 5)
        I = sort(union(L...))
        #@info (i, I, bk, salgo)
        i == 1 && @test_call umerge!(Int[], L)
        i == 1 && @test_call bkt!(Int[], L)
        S = umerge!(Int[], copy(L))
        @test I == S
        S = bkt!(Int[], L; t=1)
        @test I == S
    end
end

@testset "threshold" begin
    @test [1, 2, 3, 4, 5, 6, 7] == umerge([[1, 2, 3, 4, 5, 6], [1, 3, 7], [1, 6]]; t=1)
    @test [1, 3, 6] == umerge([[1, 2, 3, 4, 5, 6], [1, 3, 7], [1, 6]]; t=2)
    @test [1] == umerge([[1, 2, 3, 4, 5, 6], [1, 3, 7], [1, 6]]; t=3)
    @test_call umerge([[1, 2, 3, 4, 5, 6], [1, 3, 7], [1, 6]]; t=3)
    
    @test [1, 2, 3, 4, 5, 6, 7] == bkt([[1, 2, 3, 4, 5, 6], [1, 3, 7], [1, 6]], binarysearch; t=1)
    @test [1, 3, 6] == bkt([[1, 2, 3, 4, 5, 6], [1, 3, 7], [1, 6]]; t=2)
    @test [1] == bkt([[1, 2, 3, 4, 5, 6], [1, 3, 7], [1, 6]]; t=3)
    @test_call bkt([[1, 2, 3, 4, 5, 6], [1, 3, 7], [1, 6]]; t=3)
    
    n = 3
    for i in n:n
        L = randset(n, 5)
        for t in 1:length(L)
            @test umerge!(Int[], copy(L); t) == bkt!(Int[], copy(L); t)
        end
    end
end

