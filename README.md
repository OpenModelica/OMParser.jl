# OMParser.jl

A parser for Modelica in Julia based on the OpenModelica parser.

== Build the parser library

MinGW/Linux/Mac
````
# need to have julia and julia-config.jl script in the path, maybe we can check for this via configure
$ export PATH=$PATH:/path/to/julia/bin:/path/to/julia/share/julia/
$ cd OMParser.jl/lib/parser
$ autoconf
$ ./configure 
$ make
````
The library will be built in OMParser.jl/lib/build/



