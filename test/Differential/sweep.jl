#=
Compare the parser with OMParser 0.2's ANTLR/C parser on many files.

  OMPARSER_REFERENCE_LIB=<libomparse-julia of OMParser 0.2.4> \
    julia --project=<env with OMParser and Absyn> sweep.jl <out.tsv> <root> [<root> ...]

Every `.mo` file under the roots is parsed by both parsers (MetaModelica grammar for files
under a `metamodelica` directory or the OMCompiler sources, Modelica otherwise). Each line of
`out.tsv` is `status<TAB>gram<TAB>file<TAB>detail`, status one of same, diff, bothfail, oldfail,
newfail. Lines are flushed one by one, so a crash leaves the files done so far; files already in
`out.tsv` are skipped when it is run again.
=#

include(joinpath(@__DIR__, "absynDiff.jl"))

"""
    grammarOf(file::String)::Int

The grammar a file is parsed with: 2 (MetaModelica) for the OMCompiler sources and the
metamodelica tests, 1 otherwise.
"""
function grammarOf(file::String)::Int
  return (occursin("/metamodelica/", file) || occursin("/OMCompiler/Compiler/", file) ||
          occursin("/MetaModelica/", file)) ? 2 : 1
end

function main(args::Vector{String})
  local out::String = args[1]
  local done::Set{String} = Set{String}()
  if isfile(out)
    for line::String in eachline(out)
      local parts::Vector{SubString{String}} = split(line, '\t')
      length(parts) >= 3 && push!(done, String(parts[3]))
    end
  end
  local files::Vector{String} = String[]
  for root::String in args[2:end]
    if isfile(root)
      push!(files, root)
      continue
    end
    for (dir, _, names) in walkdir(root)
      for name::String in names
        endswith(name, ".mo") && push!(files, joinpath(dir, name))
      end
    end
  end
  sort!(files)
  local counts::Dict{Symbol, Int} = Dict{Symbol, Int}()
  open(out, "a") do io
    for file::String in files
      file in done && continue
      local gram::Int = grammarOf(file)
      local (status::Symbol, detail::Any) = compareParsers(file; gram = gram)
      counts[status] = get(counts, status, 0) + 1
      local text::String = detail === nothing ? "" : replace(string(detail), '\n' => " | ", '\t' => ' ')
      println(io, status, '\t', gram, '\t', file, '\t', first(text, 400))
      flush(io)
    end
  end
  println(counts)
end

main(ARGS)
