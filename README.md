# OMParser.jl

A parser for Modelica in Julia based on the OpenModelica parser.

== Build the parser library

MinGW/Linux/Mac
````
cd OMParser.jl/lib
# need to have julia and julia-config.jl script in the path
$ export PATH=$PATH:/path/to/julia/bin:/path/to/julia/share/julia/
$ autoconf
$ ./configure 
$ make
````
The library will be built in OMParser.jl/lib/build/



