using AbstractGSBPs
using Documenter

DocMeta.setdocmeta!(AbstractGSBPs, :DocTestSetup, :(using AbstractGSBPs); recursive=true)

makedocs(;
    modules=[AbstractGSBPs],
    authors="Iván Gutiérrez",
    repo="https://github.com/igutierrezm/AbstractGSBPs.jl/blob/{commit}{path}#{line}",
    sitename="AbstractGSBPs.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://igutierrezm.github.io/AbstractGSBPs.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Installation" => "installation.md",
        "Getting Started" => "starting.md",
        "API Reference" => "api.md",
    ],
)

deploydocs(;
    repo="github.com/igutierrezm/AbstractGSBPs.jl",
    devbranch="main",
)
