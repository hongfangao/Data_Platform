using JLD2, FileIO, ArgParse

args = let s = ArgParseSettings()
    @add_arg_table s begin
        "--inputpath"
            arg_type=String
            default="/home/xiucheng/data-backup/bigtable/2015-taxi/data/h5path"
        "--outputpath"
            arg_type=String
            default="/home/xiucheng/data-backup/bigtable/2015-taxi/data/jldpath"
    end
    parse_args(s; as_symbols=true)
end

@everywhere include("Trip.jl")

function attachroads!(trips::Vector{Trip})
    """
    Attaching the roads field for each trip.
    """
    println("matching trips...")
    @time results = pmap(trip2roads, trips)
    for i = 1:length(results)
        trips[i].roads = results[i]
    end
    trips
end


function attachdetails!(trips::Vector{Trip})
    """
    Attaching the road, frac and time for each trip.
    """
    println("matching trips...")
    @time results = pmap(trip2detailtrips, trips)
    for i = 1:length(results)
        trips[i].roads = results[i][1]
        trips[i].time = results[i][2]
        trips[i].frac = results[i][3]
        trips[i].route = results[i][4]
        trips[i].route_heading = results[i][5]
        trips[i].route_geom = results[i][6]
    end
    trips
end
        


function h5f2jld(h5path::String, jldpath::String)
    """
    Attaching road id to the trajectories in h5file and then save them into
    jldfile.
    """
    function h5f2jld(h5file::String)
        println("reading trips from $(basename(h5file))...")
        trips = readtripsh5(h5file)
        trips = filter(isvalidtrip, trips)
        attachroads!(trips)
        jldfile = basename(h5file) |> splitext |> first |> x->"$x.jld2"
        save(joinpath(jldpath, jldfile), "trips", trips)
    end

    fnames = filter(x -> endswith(x, ".h5"), readdir(h5path))
    fnames = map(x -> joinpath(h5path, x), fnames)
    for fname in fnames
        h5f2jld(fname)
    end
end

function h5f2jldDetails(h5path::String, jldpath::String)
    """
    Attaching road id to the trajectories in h5file and then save them into
    jldfile.
    """
    function h5f2jldDetails(h5file::String)
        println("reading trips from $(basename(h5file))...")
        trips = readtripsh5(h5file)
        trips = filter(isvalidtrip, trips)
        attachdetails!(trips)
        jldfile = basename(h5file) |> splitext |> first |> x->"$x.jld2"
        save(joinpath(jldpath, jldfile), "trips", trips)
    end

    fnames = filter(x -> endswith(x, ".h5"), readdir(h5path))
    fnames = map(x -> joinpath(h5path, x), fnames)
    for fname in fnames
        h5f2jldDetails(fname)
    end
end  



isdir(args[:inputpath]) || error("Invalid inputpath: $(s[:inputpath])")
isdir(args[:outputpath]) || error("Invalid outputpath: $(s[:outputpath])")
h5f2jldDetails(args[:inputpath], args[:outputpath])
