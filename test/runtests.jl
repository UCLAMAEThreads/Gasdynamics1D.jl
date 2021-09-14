using Gasdynamics1D
using Test
using Literate

const GROUP = get(ENV, "GROUP", "All")

#ENV["GKSwstype"] = "nul" # removes GKS warnings during plotting
ENV["GKSwstype"] = "100"


notebookdir = "../notebook"
docdir = "../docs/src/manual"
litdir = "./literate"

if GROUP == "All" || GROUP == "Basics"
  include("properties.jl")
end

if GROUP == "All" || GROUP == "Notebooks"
  for (root, dirs, files) in walkdir(litdir)
    for file in files
      #endswith(file,".jl") && startswith(file,"5") && Literate.notebook(joinpath(root, file),notebookdir)
      endswith(file,".jl") && Literate.notebook(joinpath(root, file),notebookdir)
    end
  end
end

if GROUP == "Documentation"
  for (root, dirs, files) in walkdir(litdir)
    for file in files
      endswith(file,".jl") && Literate.markdown(joinpath(root, file),docdir)
    end
  end
end
