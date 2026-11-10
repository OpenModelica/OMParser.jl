# Tests of OMParser

`runtests.jl` runs them (`Pkg.test("OMParser")`).

## `msl.mo`: the Modelica Standard Library, under its own license

`msl.mo` is test data. It is not part of OMParser and not under OMParser's license (GPL version 3
or OSMC-PL, [../LICENSE.md](../LICENSE.md)): it is the Modelica Standard Library, licensed by the
Modelica Association under the **Modelica License 2**. What follows repeats what the file states;
the license text inside the file is what counts.

### What the file is
One file with three top-level classes, in the repository since 2021-12-06 (commit baad14c), 12 MB,
172 396 lines, CRLF line ends:

| Class | Its description in the file | Version annotation |
|---|---|---|
| `package ModelicaServices` | "ModelicaServices (OpenModelica implementation) - Models and functions used in the Modelica Standard Library requiring a tool specific implementation" | 3.2.1, build 2, 2013-08-14 |
| `operator record Complex` | "Complex number with overloaded operators" | 3.2.1, build 2, 2013-08-14 |
| `package Modelica` | "Modelica Standard Library - Version 3.2.1 (Build 4)" | 3.2.1, build 4, 2013-08-14, modified 2015-09-30 |

How the file was produced is not recorded in the repository. Its form (the three classes in one
file, printed in a tool's layout, ModelicaServices in its OpenModelica implementation) is that of a
library saved with OpenModelica.

### What the file says about its license
- `package Modelica`, the end of its documentation: "Licensed by the Modelica Association under the
  Modelica License 2", "Copyright © 1998-2015, ABB, AIT, T. Bödrich, DLR, Dassault Systèmes AB,
  Fraunhofer, A. Haumer, ITI, C. Kral, Modelon, TU Hamburg-Harburg, Politecnico di Milano, XRG
  Simulation." and "This Modelica package is free software and the use is completely at your own
  risk; it can be redistributed and/or modified under the terms of the Modelica License 2. For
  license conditions (including the disclaimer of warranty) see
  Modelica.UsersGuide.ModelicaLicense2 or visit https://www.modelica.org/licenses/ModelicaLicense2."
- `package ModelicaServices`, the end of its documentation: "Licensed by DLR and Dassault Systèmes
  AB under the Modelica License 2", "Copyright © 2009-2015, DLR and Dassault Systèmes AB.", with
  the same paragraph on redistribution.
- `operator record Complex` has no license statement of its own in the file.
- Sublibraries name further copyright holders in their documentation (for example "Modelica
  Association and Fraunhofer-Gesellschaft", "Modelica Association and Anton Haumer").
- The licensor, as given in `Modelica.UsersGuide.ModelicaLicense2`: Modelica Association (Ideella
  Föreningar 822003-8858 in Linköping), c/o PELAB, IDA, Linköpings Universitet, S-58183 Linköping,
  Sweden, Board@Modelica.org, https://www.Modelica.org.
- "Modelica® is a registered trademark of the Modelica Association."

### Where the license text is
The whole Modelica License 2 is in the file: the documentation of the classes
`Modelica.UsersGuide.ModelicaLicense2` and `ModelicaServices.UsersGuide.ModelicaLicense2`. The
license asks for a verbatim copy of itself in every copy of the work (its section 2c), which is why
it is pointed out here; its section 4 is about the name of a modified library.

That class excepts three groups of C sources from the Modelica License 2
(`Modelica/Resources/C-Sources/win32_dirent.*`, `ModelicaMatIO.*`, `ModelicaStandardTables.*`).
They are not in this repository: `msl.mo` holds Modelica source only.

### What the tests do with it
The file is read and parsed, nothing else: it is not changed, and no part of it is copied into
OMParser's sources.
- `runtests.jl`, "Standard Library": the whole file through `parseFile`.
- `mslExampleTests.jl`: its example models written in a Julia file (below).

## The example models in a Julia file
`mslExampleTests.jl` takes every example model of the library (a class that extends
`Modelica.Icons.Example`: 278 of them, 18 718 lines, the largest 492), writes it as
`Modelica"""..."""` and as `@Modelica """..."""`, has Julia's parser read the literal and expands
the macro. All of them, in under a second: parsing the 278 texts takes 0.03 s.

- **Both forms give the class of the library**, for all 278: the same tree, the `SourceInfo`s
  included (the file and the lines of the library), compared field by field.
- **177 models are written as they are in the library**, in both forms.
- **101 models have quotes escaped inside strings** (`\"`, 959 of them, all in the HTML of
  documentation strings). Each is written with two backslashes (`\\"`), in both forms: Julia takes
  one. Pasted unchanged, every one of the 101 is a `ParseError` when the macro is expanded (Julia
  ends the Modelica string at the quote), in both forms: never a different tree.
- No example model has a dollar sign, another backslash or three quotes in a row, the places where
  the two forms are written differently: for these models the text is the same in both.
- Line ends are line feeds: Julia's parser reads every line end of a string literal as one, also
  in a file with CRLF line ends (the test reads `msl.mo` that way).

| Library | Example models | Written as in the library | Largest (lines) |
|---|---:|---:|---|
| Blocks | 12 | 0 | `Blocks.Examples.BusUsage` (140) |
| ComplexBlocks | 1 | 1 | `ComplexBlocks.Examples.TestConversionBlock` (24) |
| Electrical | 97 | 82 | `Electrical.Spice3.Examples.Spice3BenchmarkFourBitBinaryAdder` (492) |
| Fluid | 23 | 6 | `Fluid.Examples.AST_BatchPlant.BatchPlant_StandardWater` (256) |
| Magnetic | 19 | 3 | `Magnetic.FundamentalWave.Examples.BasicMachines.SMEE_Generator_MultiPhase` (170) |
| Math | 1 | 1 | `Math.Nonlinear.Examples.quadratureLobatto3` (22) |
| Mechanics | 65 | 34 | `Mechanics.MultiBody.Examples.Elementary.PointGravityWithPointMasses2` (151) |
| Media | 41 | 39 | `Media.Examples.PsychrometricData` (83) |
| StateGraph | 7 | 4 | `StateGraph.Examples.ExecutionPaths` (120) |
| Thermal | 11 | 7 | `Thermal.FluidHeatFlow.Examples.ParallelCooling` (141) |
| Utilities | 1 | 0 | `Utilities.Examples.readRealParameterModel` (18) |
| **All** | **278** | **177** | |

The counts are checked by the test. A search of the text for the extends clause
(`extends Modelica.Icons.Example;`, `extends Icons.Example;`) finds 281 lines: three of them are in
a documentation string and in two comments, not in the tree.
