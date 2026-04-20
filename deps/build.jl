#= Build script for the OpenModelica parser. =#
@info "Building OpenModelicaParser A Modelica Parser in Julia"

import HTTP
import Inflate
import Pkg
import Tar
import ZipFile

const PACKAGE_ROOT = normpath(joinpath(@__DIR__, ".."))
const PATH_TO_EXT = mkpath(joinpath(PACKAGE_ROOT, "lib", "ext"))
const BUILD_LIB_DIR = joinpath(PACKAGE_ROOT, "lib", "build", "lib")
const SHARED_LIB_DIR = joinpath(PACKAGE_ROOT, "lib", "ext", "shared")
const JULIA_MAJOR_MINOR = "$(VERSION.major).$(VERSION.minor)"

function installed_package_names()
  names = Set{String}()
  for (_, dep) in Pkg.dependencies()
    dep.name === nothing || push!(names, dep.name)
  end
  names
end

pkgs = installed_package_names()

if !("MetaModelica" in pkgs)
  Pkg.add(Pkg.PackageSpec(url = "https://github.com/OpenModelica/MetaModelica.jl.git", rev = "master"))
end
if !("Absyn" in pkgs)
  Pkg.add(Pkg.PackageSpec(url = "https://github.com/OpenModelica/Absyn.jl.git", rev = "master"))
end

@info "Detected Julia version: $JULIA_MAJOR_MINOR"

@static if v"1.10.0" > VERSION
  throw("Building OMParser with precompiled shared libraries is currently only supported for Julia version 1.10 or greater. For prior versions of Julia please download and extract the libraries available at https://github.com/OpenModelica/OMParser.jl/releases or build the libraries in the lib subdirectory.")
end

function parser_library_names()
  if Sys.islinux()
    return ("libomparse-julia.so", "libomantlr3.so")
  elseif Sys.iswindows()
    return ("libomparse-julia.dll", "libomantlr3.dll")
  else
    return ("libomparse-julia.dylib", "libomantlr3.dylib")
  end
end

function has_parser_library(dir::String)::Bool
  isdir(dir) || return false
  names = parser_library_names()
  for (root, _, files) in walkdir(dir)
    any(name -> name in files, names) && return true
  end
  return false
end

function unzip_into(zip_path::String, dest_dir::String)
  reader = ZipFile.Reader(zip_path)
  try
    for entry in reader.files
      if endswith(entry.name, "/")
        mkpath(joinpath(dest_dir, entry.name))
        continue
      end
      out_path = joinpath(dest_dir, entry.name)
      mkpath(dirname(out_path))
      open(out_path, "w") do io
        write(io, read(entry))
      end
    end
  finally
    close(reader)
  end
end

function fetch_release_archive(library_name::String, url::String)
  zip_path = joinpath(PATH_TO_EXT, string(library_name, ".zip"))
  @info "Downloading shared library from: $url"
  HTTP.download(url, zip_path)

  shared_dir = joinpath(PATH_TO_EXT, "shared")
  isdir(shared_dir) && rm(shared_dir; recursive = true, force = true)
  mkpath(shared_dir)

  @info "Unzipping $zip_path into $shared_dir"
  unzip_into(zip_path, shared_dir)

  # macOS and Windows release assets wrap the real library tree in an inner
  # tar.gz (produced by actions/upload-artifact in manual.yml). Linux assets
  # carry the library file directly. Detect and unpack the nested archive.
  nested = filter(f -> isfile(joinpath(shared_dir, f)) && endswith(f, ".tar.gz"),
                  readdir(shared_dir))
  if length(nested) == 1
    nested_path = joinpath(shared_dir, nested[1])
    staged_path = joinpath(PATH_TO_EXT, nested[1])
    mv(nested_path, staged_path; force = true)
    rm(shared_dir; recursive = true, force = true)

    @info "Extracting nested archive $staged_path"
    tar_bytes = Inflate.inflate_gzip(read(staged_path))
    tar_path = replace(staged_path, r"\.gz$" => "")
    write(tar_path, tar_bytes)
    Tar.extract(tar_path, shared_dir)
    rm(staged_path; force = true)
    rm(tar_path; force = true)
  elseif length(nested) > 1
    throw("Unexpected release archive layout: multiple nested tarballs $(nested)")
  end

  @info "Download external shared libraries done."
end

function get_library_url(os_name::String)
  library_name = "parser-library-$(os_name)-julia-$(JULIA_MAJOR_MINOR)"
  release_tag = "Latest-$(os_name)-julia-$(JULIA_MAJOR_MINOR)"
  url = "https://github.com/OpenModelica/OMParser.jl/releases/download/$(release_tag)/$(library_name).zip"
  return library_name, url
end

if has_parser_library(BUILD_LIB_DIR)
  @info "Using locally built parser library from $BUILD_LIB_DIR"
elseif has_parser_library(SHARED_LIB_DIR)
  @info "Using previously downloaded parser library from $SHARED_LIB_DIR"
else
  if Sys.iswindows()
    library_name, url = get_library_url("windows-latest")
  elseif Sys.islinux()
    library_name, url = get_library_url("ubuntu-latest")
  elseif Sys.isapple()
    library_name, url = get_library_url("macos-latest")
  else
    throw("Unsupported system error: only Linux, macOS and Windows are supported")
  end

  fetch_release_archive(library_name, url)

  has_parser_library(SHARED_LIB_DIR) ||
    throw("OMParser build finished without producing a parser library under $(SHARED_LIB_DIR)")
end
