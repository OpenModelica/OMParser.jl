#= Build script for the OpenModelica parser. Currently it is for windows only. =#
@info "Building OpenModelicaParser A Modelica Parser in Julia"
import ZipFile
import Tar
import Inflate

function extractTar(libraryString; URL)
  @info "Downloading Linux so file..."
  HTTP.download(URL, PATH_TO_EXT)
  println(pwd())
  cd(PATH_TO_EXT)
  println(pwd())
  foreach(readdir()) do f
    println("\nObject: ", f)
  end
  @info "Decompressing archive.."
  local res = Inflate.inflate_gzip(string(libraryString, ".tar.gz"))
  local tarName = string(libraryString, ".tar")
  write(tarName, res)
  @info "Done. .tar created."
  @info "...Extracting the files in the tar..."
  @info "----------------------------------------"
  try
    rm("shared", recursive=true)
  catch #= Silence on failure =#
  end
  dir = Tar.extract(tarName, "shared")
  @info dir
  @info "----------------------------------------"
  @info "Download external shared libraries done!"
  foreach(readdir()) do f
    @info "\nObject: " f
  end
  @info "----------------------------------------"
end

using HTTP
#=Extern path=#
PATH_TO_EXT = realpath("$(pwd())/../lib/ext")


@static if v"1.10.0" < VERSION
  throw("precompilation is currently only supported for Julia version 1.10 or greater. For prior versions of Julia please download and extract the libraries available at https://github.com/OpenModelica/OMParser.jl/releases")
end

@static if Sys.iswindows()
  #= Download shared libraries (DLLS for Windows)=#
  extractTar("windows-latest-library";
             URL="https://github.com/OpenModelica/OMParser.jl/releases/download/Latest-windows-latest/windows-latest-library.tar.gz")
elseif Sys.islinux()
  extractTar("ubuntu-latest-library";
             URL="https://github.com/OpenModelica/OMParser.jl/releases/download/Latest-ubuntu-latest/ubuntu-latest-library.tar.gz")
elseif Sys.isapple()
  extractTar("macos-latest-library";
             URL="https://github.com/OpenModelica/OMParser.jl/releases/download/Latest-macos-latest/macos-latest-library.tar.gz")
else#= Throw error for other variants =#
  @error "Non Linux/Windows systems are currently not supported"
  throw("Unsupported system error")
end
