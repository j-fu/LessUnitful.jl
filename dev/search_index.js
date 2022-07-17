var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"using Markdown\nMarkdown.parse(\"\"\"\n$(read(\"../../README.md\",String))\n\"\"\")","category":"page"},{"location":"#Notations","page":"Home","title":"Notations","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"The package provides tools to access Unitful.jl to define floating point constants for units like cm, kPa, mV etc. called unit factors. These unit factors relate units to their corresponding products of powers of  unitful preferred units in the sense of Unitful.jl. ","category":"page"},{"location":"","page":"Home","title":"Home","text":"By default the unitful preferred units are synonymous with the SI base units. By calling Unitful.preferunits these reference values can be changed.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Example: Unit: kN to representation in powers of SI base units: 1000cdot kgcdot mcdot s^-2  to unit factor: 1000.0","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> using LessUnitful\n\njulia> @unitfactors kN\n1000.0","category":"page"},{"location":"","page":"Home","title":"Home","text":"The unit factor  of a quantity like  5cm, 10kPa, 3mV is its numerical value  after conversion to products of powers of unitful preferred units.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Example: Quantity: 3kN to representation in powers of SI base units: 3000cdot kgcdot mcdot s^-2  to unit factor: 3000.0","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> using LessUnitful\n\njulia> ufac\"3kN\"\n3000.0","category":"page"},{"location":"","page":"Home","title":"Home","text":"The unitfactor represents the numerical value of a unit/quatity expressed in preferred units:","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> using LessUnitful, Unitful\n\njulia> unitfactor(u\"cm\")==Unitful.ustrip(Unitful.upreferred(u\"1.0cm\"))\ntrue","category":"page"},{"location":"","page":"Home","title":"Home","text":"Reciprocally, one can make a number \"unitful\", assuming it corresponds to one of the preferred units. Assume x represents an unit factor  of a quantity with respect to the corresponding products of powers of unitful preferred units. Create this quantity and convert it to  unit: ","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> using LessUnitful, Unitful\n\njulia> unitful(0.03,u\"cm\")==u\"cm\"(Unitful.float(0.03*Unitful.upreferred(u\"cm\")))\ntrue","category":"page"},{"location":"","page":"Home","title":"Home","text":"Providing these unit factors allows a \"unitless\" workflow with physical data which is characterized by the following aspects:","category":"page"},{"location":"","page":"Home","title":"Home","text":"All calculations are done in numerical values corresponding to unitful preferred units (SI base units by default)\nData input can be performed in at least two different ways:\nDeclare @unitfactors cm and enter e.g. length=10*cm\nEnter \"unitful\" length=10u\"cm\" and actually provide unitfactor(length) to the \"unitless\" code \nData output can go as follows - assume result p is a pressure:\nDeclare @unitfactors kPa and do println(\"p= \",p/kPa,\"kPa\")\nAlternatively, do println(p|> u\"kPa\")","category":"page"},{"location":"#Obtaining-unit-factors","page":"Home","title":"Obtaining unit factors","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"unitfactor\n@ufac_str\n@unitfactors","category":"page"},{"location":"#LessUnitful.unitfactor","page":"Home","title":"LessUnitful.unitfactor","text":"unitfactor(quantity)\n\nCalculate the unit factor of a quantity.\n\nExample:\n\njulia> unitfactor(u\"1mV\")\n0.001\njulia> u\"1mV\"|> unitfactor\n0.001\n\nCompare this with the corresponding calculations with Unitful values:\n\njulia> u\"1mV\" |> u\"V\" |> float\n0.001 V\n\nSee unitful for the reciprocal operation:\n\njulia> u\"1cm\" |> unitfactor |> u\"cm\"\n1.0 cm\n\n\n\n\n\n","category":"function"},{"location":"#LessUnitful.@ufac_str","page":"Home","title":"LessUnitful.@ufac_str","text":"@ufac_str\n\nString macro for calculating the unit factor of a quantity, see also unitfactor.\n\nExample:\n\njulia> ufac\"1mV\"\n0.001\n\n\n\n\n\n","category":"macro"},{"location":"#LessUnitful.@unitfactors","page":"Home","title":"LessUnitful.@unitfactors","text":"@unitfactors\n\nDeclare unit factors of units as global constants.\n\nExample\n\njulia> @unitfactors cm;\n\njulia> 3cm\n0.03\n\nWe can declare multiple unit factors at once:\n\n@unitfactors mm cm km A V\n\njulia> @unitfactors cm mm;\n\njulia> cm+mm\n0.011\n\nCompare this with the corresponding calculations with Unitful values:\n\njulia> u\"1cm\"+u\"1mm\"|> float\n0.011 m\n\n\n\n\n\n","category":"macro"},{"location":"#Creating-unitful-values","page":"Home","title":"Creating unitful values","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"For convenience, lessUnitful re-exports @u_str from  Unitful.jl.","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> using LessUnitful\n\njulia> u\"1.0mV\"\n1.0 mV","category":"page"},{"location":"","page":"Home","title":"Home","text":"unitful\nunitful(x,unit)","category":"page"},{"location":"#LessUnitful.unitful","page":"Home","title":"LessUnitful.unitful","text":"(unit)(x::Real)\n\nMake number x \"unitful\" by calling unitful.\n\nExample\n\njulia> u\"kPa\"(200)\n0.2 kPa\n\njulia> 200 |> u\"kPa\"\n0.2 kPa\n\nThis may be convenient when printing with units: Instead of \n\n@unitfactors μA mA;\nx = 15mA\nprintln(x/μA,\" μA\")\n# output\n15000.0 μA\n\none can use \n\n@unitfactors  μA mA\nx = 15mA\nprintln(x|>u\"μA\")  \n# output\n15000.0 μA\n\nSee unitfactor for the reciprocal operation:\n\njulia>  0.05|> u\"cm\" |> unitfactor\n0.05\n\n\n\n\n\n","category":"function"},{"location":"#LessUnitful.unitful-Tuple{Any, Any}","page":"Home","title":"LessUnitful.unitful","text":"unitful(x,unit)\n\nMake number x \"unitful\". \n\nExample\n\njulia> unitful(200,u\"kPa\")\n0.2 kPa\n\n\n\n\n\n","category":"method"},{"location":"#Physical-constants","page":"Home","title":"Physical constants","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"@phconstants","category":"page"},{"location":"#LessUnitful.@phconstants","page":"Home","title":"LessUnitful.@phconstants","text":"@phconstants\n\nDeclare numerical values of physical constants as unit factors with respect to  unitful preferred units as constants.  The information is obtained from PhysicalConstants.CODATA2018\n\nExample:\n\njulia> @phconstants N_A\n6.02214076e23\n\nThis is equivalent to\n\nconst N_A = ustrip(upreferred(PhysicalConstants.CODATA2018.N_A))\n\nand we can \"declare\" multiple constants\n\n@phconstants AvogadroConstant c_0\n\n\n\n\n\n","category":"macro"}]
}
