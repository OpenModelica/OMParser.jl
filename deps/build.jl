#= Build script for the OpenModelica parser. =#
@info "Building OpenModelicaParser A Modelica Parser in Julia"

import Inflate
import Pkg
import Tar
import ZipFile
using HTTP

const PACKAGE_ROOT = normpath(joinpath(@__DIR__, ".."))
const PATH_TO_EXT = joinpath(PACKAGE_ROOT, "lib", "ext")
const BUILD_LIB_ROOT = joinpath(PACKAGE_ROOT, "lib", "build", "lib")
const PARSER_ROOT = joinpath(PACKAGE_ROOT, "lib", "parser")
const JULIA_MAJOR_MINOR = "$(VERSION.major).$(VERSION.minor)"

function parser_library_match(file_name::AbstractString)
    if Sys.islinux()
        return occursin("libomparse-julia.so", file_name)
    elseif Sys.iswindows()
        return occursin("libomparse-julia.dll", file_name)
    else
        return occursin("libomparse-julia.dylib", file_name)
    end
end

function locate_parser_library(root::AbstractString)
    isdir(root) || return nothing
    for (directory, _, files) in walkdir(root)
        for file in files
            parser_library_match(file) && return joinpath(directory, file)
        end
    end
    return nothing
end

function check_local_build_exists()
    local_lib = locate_parser_library(BUILD_LIB_ROOT)
    if !isnothing(local_lib)
        @info "Local build already exists, skipping release download" local_lib
        return true
    end
    return false
end

function release_asset_candidates(os_name::String)
    release_tag = "Latest-$(os_name)-julia-$(JULIA_MAJOR_MINOR)"
    current_name = "parser-library-$(os_name)-julia-$(JULIA_MAJOR_MINOR).zip"
    legacy_name = "$(os_name)-julia-$(JULIA_MAJOR_MINOR)-library.tar.gz"
    return [
        (
            current_name,
            "https://github.com/OpenModelica/OMParser.jl/releases/download/$(release_tag)/$(current_name)",
        ),
        (
            legacy_name,
            "https://github.com/OpenModelica/OMParser.jl/releases/download/$(release_tag)/$(legacy_name)",
        ),
    ]
end

function clear_shared_dir!()
    shared_dir = joinpath(PATH_TO_EXT, "shared")
    isdir(shared_dir) && rm(shared_dir; recursive = true, force = true)
    return shared_dir
end

function extract_tarball!(archive_path::AbstractString)
    mkpath(PATH_TO_EXT)
    tar_name = replace(basename(archive_path), r"\.tar\.gz$" => ".tar")
    tar_path = joinpath(PATH_TO_EXT, tar_name)
    @info "Decompressing tarball" archive_path
    write(tar_path, Inflate.inflate_gzip(archive_path))
    shared_dir = clear_shared_dir!()
    @info "Extracting parser library" tar_path shared_dir
    Tar.extract(tar_path, shared_dir)
    isfile(tar_path) && rm(tar_path; force = true)
    return shared_dir
end

function extract_zip_release!(archive_path::AbstractString)
    mkpath(PATH_TO_EXT)
    tarball_path = nothing
    archive = ZipFile.Reader(archive_path)
    try
        for file in archive.files
            destination = joinpath(PATH_TO_EXT, basename(file.name))
            open(destination, "w") do io
                write(io, read(file))
            end
            endswith(file.name, ".tar.gz") && (tarball_path = destination)
        end
    finally
        close(archive)
    end
    isnothing(tarball_path) &&
        error("OMParser release archive did not contain a .tar.gz parser library")
    shared_dir = extract_tarball!(tarball_path)
    isfile(tarball_path) && rm(tarball_path; force = true)
    return shared_dir
end

function extract_release_archive!(archive_path::AbstractString)
    if endswith(archive_path, ".zip")
        return extract_zip_release!(archive_path)
    elseif endswith(archive_path, ".tar.gz")
        return extract_tarball!(archive_path)
    end
    error("Unsupported OMParser release asset format: $(basename(archive_path))")
end

function download_release_archive!(os_name::String)
    mkpath(PATH_TO_EXT)
    for (asset_name, url) in release_asset_candidates(os_name)
        archive_path = joinpath(PATH_TO_EXT, asset_name)
        isfile(archive_path) && rm(archive_path; force = true)
        try
            @info "Downloading parser library release asset" url
            HTTP.download(url, archive_path)
            return archive_path
        catch err
            isfile(archive_path) && rm(archive_path; force = true)
            @warn "Failed to download OMParser release asset" asset_name url error =
                sprint(showerror, err)
        end
    end
    error(
        "Could not download a compatible OMParser release asset for " *
        "$(os_name) and Julia $(JULIA_MAJOR_MINOR).",
    )
end

function build_from_source!()
    Sys.iswindows() &&
        error("Automatic source build fallback is not supported on Windows.")
    @info "Falling back to documented local source build" parser_root = PARSER_ROOT
    cd(PARSER_ROOT) do
        run(`autoconf`)
        run(`./configure`)
        run(`make`)
    end
    check_local_build_exists() ||
        error("OMParser source build completed but no parser library was produced.")
    return nothing
end

function build_or_download_parser_library!()
    check_local_build_exists() && return nothing

    if VERSION < v"1.10.0"
        @info "Julia < 1.10 detected, skipping release asset download and building locally"
        build_from_source!()
        return nothing
    end

    os_name = if Sys.iswindows()
        "windows-latest"
    elseif Sys.islinux()
        "ubuntu-latest"
    elseif Sys.isapple()
        "macos-latest"
    else
        error("Unsupported system error")
    end

    try
        archive_path = download_release_archive!(os_name)
        extract_release_archive!(archive_path)
        isfile(archive_path) && rm(archive_path; force = true)
    catch err
        @warn "Release asset bootstrap failed, trying local source build" error =
            sprint(showerror, err)
        build_from_source!()
    end

    locate_parser_library(joinpath(PATH_TO_EXT, "shared")) !== nothing && return nothing
    check_local_build_exists() && return nothing
    error("Could not locate an OMParser shared library after build/bootstrap.")
end

build_or_download_parser_library!()
