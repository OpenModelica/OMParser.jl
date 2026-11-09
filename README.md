# OMParser.jl

A Modelica parser written in Julia. It reads Modelica (and MetaModelica, ParModelica, Optimica and
PDEModelica) into `Absyn` trees, the abstract syntax of the OpenModelica compiler, which
[OMFrontend.jl](https://github.com/OpenModelica/OMFrontend.jl) instantiates. Pure Julia: nothing to
build.

## Install
OMParser is in the OpenModelica registry:
```julia
import Pkg
Pkg.Registry.add(Pkg.RegistrySpec(url = "https://github.com/OpenModelica/OpenModelicaRegistry.git"))
Pkg.add("OMParser")
```

## Use
```julia
import OMParser
program = OMParser.parseFile("HelloWorld.mo")
program = OMParser.parseString("model M Real x; equation x = 1; end M;", "M.mo")
```
`parseFile(fileName, acceptedGram = 1, languageStandard = 9999)` and `parseString(contents,
fileName = "<default>", acceptedGram = 1, languageStandard = 1000)` return an `Absyn.Program`.
`acceptedGram`: 1 Modelica, 2 MetaModelica, 3 ParModelica, 4 Optimica, 5 PDEModelica.
`languageStandard`: 10, 20, 30, 31, 32, 33, 34, 35 (1.x to 3.5), 1000 (latest), 9999 (experimental).

A syntax error throws an `OMParser.ParseError` with the file, line and column:
```
M.mo:2:9: Expected ';' after the element but found 'equation' on line 3
    Real x
          ^
```

## How it works
A lexer (`src/Lexer.jl`) and a recursive-descent parser (`src/Parser.jl`) with one function per rule
of omc's grammar (`OMCompiler/Parser/Modelica.g` in the OpenModelica repository). The trees are the
ones omc's ANTLR parser builds, source positions and comments included: `test/Differential`
compares the two (OMParser 0.2, the ANTLR/C parser, loaded from its library) over directory trees,
and they agree on the Modelica Standard Library, the OpenModelica testsuite, the OpenModelica
compiler's MetaModelica sources and the Buildings library.

## License
See [LICENSE.md](LICENSE.md).
