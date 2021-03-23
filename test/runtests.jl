using Gasdynamics1D
using Test
using Literate

outputdir = "../notebook"
litdir = "./literate"

for (root, dirs, files) in walkdir(litdir)
    if splitpath(root)[end] == "assets"
        for file in files
            cp(joinpath(root, file),joinpath(outputdir,file),force=true)
        end
    end
end


for (root, dirs, files) in walkdir(litdir)
    for file in files
        endswith(file,".jl") && Literate.notebook(joinpath(root, file),outputdir)
    end
end
