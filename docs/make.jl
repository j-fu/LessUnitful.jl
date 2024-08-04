using Documenter, LessUnitful

function mkdocs()
    DocMeta.setdocmeta!(LessUnitful, :DocTestSetup, :(using LessUnitful, Unitful,  LessUnitful.MoreUnitful); recursive=true)
    makedocs(sitename="LessUnitful.jl",
             modules = [LessUnitful, LessUnitful.MoreUnitful],
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

