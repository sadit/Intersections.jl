using Documenter, Intersections

makedocs(;
    modules=[Intersections],
    authors="Eric S. Tellez",
    repo="https://github.com/sadit/Intersections.jl/blob/{commit}{path}#L{line}",
    sitename="Intersections.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", nothing) == "true",
        canonical="https://sadit.github.io/Intersections.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "API" => "api.md"
    ],
)

deploydocs(;
    repo="github.com/sadit/Intersections.jl",
    devbranch=nothing,
    branch = "gh-pages",
    versions = ["stable" => "v^", "v#.#.#", "dev" => "dev"]
)
