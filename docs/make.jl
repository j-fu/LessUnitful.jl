using Documenter, LessUnitful

function mkdocs()
    DocMeta.setdocmeta!(LessUnitful, :DocTestSetup, :(using LessUnitful); recursive=true)
    makedocs(sitename="LessUnitful.jl",
             modules = [LessUnitful],
             clean = false, 
             doctest = true,
             authors = "J. Fuhrmann",
             repo="https://github.com/j-fu/LessUnitful.jl",
             pages=[
                 "Home"=>"index.md"
             ])
    if !isinteractive()
        deploydocs(repo = "github.com/j-fu/LessUnitful.jl.git", devbranch = "main")
    end

end

mkdocs()

