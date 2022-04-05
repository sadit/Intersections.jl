```@meta
CurrentModule = Intersections
```

# Intersections.jl

Intersections.jl is a library for computing intersections for sets represented as sorted lists. It also implements some union algorithms.

- `bk`: (Barbay & Kenyon-Mathieu) algorithm, for $k$ sets
- `baezayates`: (Baeza-Yates) intersection algorithm, for two sets
- `svs`: small vs small strategy for $k$ sets, it follows a parametric approach on the 2-set intersection problem.
- `imerge2`: Intersection using a merge-like algorithm for two sets
- `umerge`: union algorithm based on merge, for $k$ sets

Some algorithms are also parametric on the accepted search algorithm. In particular, this package also provides a few search algorithms

- `binarysearch`: typical bounded binary search 
- `doublingsearch`: unbounded search (galloping) (expects the insertion position near to starting point)
- `doublingsearchrev`: idem. but galloping from right to left (expects the insertion position be close to the end position)
- `seqsearch`: sequential search
- `seqsearchrev`: reverse sequential search

In particular, `bk` and `umerge` can be used along with callbacks to avoid storing output sets.

[TODO] Add proper references
