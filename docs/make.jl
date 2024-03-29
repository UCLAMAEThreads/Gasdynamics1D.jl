using Documenter, Gasdynamics1D

#ENV["GKSwstype"] = "nul" # removes GKS warnings during plotting
ENV["GKSwstype"] = "100" # removes GKS warnings during plotting


makedocs(
    sitename = "Gasdynamics1D.jl",
    doctest = true,
    clean = true,
    pages = [
        "Home" => "index.md",
        "Manual" => ["manual/0-BasicGasDynamics.md",
                     "manual/1-IsentropicGasDynamics.md",
                     "manual/2-ConvergingDivergingNozzle.md",
                     "manual/3-NormalShocks.md",
                     "manual/4-FannoFlow.md",
                     "manual/5-RayleighFlow.md",
                     "manual/functions.md"
                     ]
        #"Internals" => [ "internals/properties.md"]
    ],
    #format = Documenter.HTML(assets = ["assets/custom.css"])
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true",
        mathengine = MathJax(Dict(
            :TeX => Dict(
                :equationNumbers => Dict(:autoNumber => "AMS"),
                :Macros => Dict()
            )
        ))
    ),
    #assets = ["assets/custom.css"],
    #strict = true
)


#if "DOCUMENTER_KEY" in keys(ENV)
deploydocs(
     repo = "github.com/UCLAMAEThreads/Gasdynamics1D.jl.git",
     target = "build",
     devbranch = "main",
     deps = nothing,
     make = nothing
     #versions = "v^"
)
#end
