#= Build script for the OpenModelica parser. =#
@info "Building OpenModelicaParser A Modelica Parser in Julia"
import ZipFile
import Tar
import Inflate
import Pkg
pkgs = Pkg.installed()

if ! ("MetaModelica" in keys(pkgs))
  Pkg.add(Pkg.PackageSpec(url="https://github.com/OpenModelica/MetaModelica.jl.git", rev="master"))
end
if ! ("Absyn" in keys(pkgs))
  Pkg.add(Pkg.PackageSpec(url="https://github.com/OpenModelica/Absyn.jl.git", rev="master"))
  Pkg.develop(Pkg.PackageSpec(url="https://github.com/OpenModelica/Absyn.jl.git", rev="master"))
end

function extractTar(libraryString; URL)
  @info "Downloading shared library from: $URL"
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

#= Determine Julia version for library selection =#
const JULIA_MAJOR_MINOR = "$(VERSION.major).$(VERSION.minor)"
@info "Detected Julia version: $JULIA_MAJOR_MINOR"

@static if v"1.10.0" > VERSION
  throw("Building OMParser with precompiled shared libraries is currently only supported for Julia version 1.10 or greater. For prior versions of Julia please download and extract the libraries available at https://github.com/OpenModelica/OMParser.jl/releases or build the libraries in the lib subdirectory.")
end

#= Construct platform and Julia version specific library names =#
function getLibraryURL(os_name::String)
  local lib_name = "$(os_name)-julia-$(JULIA_MAJOR_MINOR)-library"
  local release_tag = "Latest-$(os_name)-julia-$(JULIA_MAJOR_MINOR)"
  local url = "https://github.com/OpenModelica/OMParser.jl/releases/download/$(release_tag)/$(lib_name).tar.gz"
  return (lib_name, url)
end

@static if Sys.iswindows()
  #= Download the shared libraries (DLLS for Windows) =#
  local (lib_name, url) = getLibraryURL("windows-latest")
  extractTar(lib_name; URL=url)
elseif Sys.islinux()
  local (lib_name, url) = getLibraryURL("ubuntu-latest")
  extractTar(lib_name; URL=url)
elseif Sys.isapple()
  local (lib_name, url) = getLibraryURL("macos-latest")
  extractTar(lib_name; URL=url)
else
  @error "Non Linux/Windows/macOS systems are currently not supported"
  throw("Unsupported system error")
end
