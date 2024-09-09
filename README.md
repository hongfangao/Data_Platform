# Data Preparation for the Project of Data Platform course in DaSE ECNU
## Data Introduction
The dataset contains 1 million+ trips collected by 1,3000+ taxi cabs during 5 days (2015.1.3-2015.1.7) and are stored as `.h5` files. Each h5 file contains `n` trips of the day. For each trip, it has three fields `lon` (longitude), `lat` (latitude), `tms` (timestamp). You can read the `h5` file using the `readtripsh5` function in Julia.
## Requirements
- Julia >= 1.0
- Python >= 3.6
## Package Installation
The required packages for julia can be installed by executing the following command:
```bash
julia -e 'using Pkg; Pkg.add("HDF5"); Pkg.add("CSV"); Pkg.add("DataFrames"); Pkg.add("Distances"); Pkg.add("StatsBase"); Pkg.add("JSON"); Pkg.add("Lazy"); Pkg.add("JLD2"); Pkg.add("ArgParse"); Pkg.add("FileIO")'
```
## Dataset Preparation
### Traffic Dataset
```bash
git clone https://github.com/hongfangao/Data_Platform.git
cd Data_Platform
mkdir -p data/h5path data/jldpath
```
Download the [dataset](https://pan.quark.cn/s/b30e6b7cd379) and put the extracted *.h5 files into `Data_Platform/data/h5path.`

(If the download link is not available, please contact me.)
### Map of Harbin
The map of Harbin has been implemented using [OSM](https://www.openstreetmap.org) on the cloud server. You can use the [Dbeaver](https://mirrors.nju.edu.cn/github-release/dbeaver/dbeaver/) for access and visualization of the PGSQL database. 

### Map matching
```bash
cd Data_platform/julia
```
Modify the map matching server in `trip.jl`, line `197`.

Modify the `localhost` to the IP address of map matching server.
It should be
```julia
clientside = connect("IP_address", 1234)
```


Then execute the following commands:
```bash
julia -p 6 mapmatch.jl --inputpath ../data/h5path --outputpath ../data/jldpath
```
where `6` is the number of cpu cores available in your machine. The map matching results are stored in `Data_Platform/data/jldpath`.

Once the map matching process is finished, you should get 5 `jld2` files.
(`trips_150103.jld2` to `trips_150107.jld2`).
## References:
[Learning Travel Time Distributions with Deep Generative Model](http://www.ntu.edu.sg/home/lixiucheng/pdfs/www19-deepgtt.pdf) (**WWW-19**)

[Barefoot for China Cities](https://github.com/boathit/barefoot)

[Open Street Map](https://www.openstreetmap.org)
## Notes:
- The overall map matching process may take very long time, please be patient.
- The cloud server IP will be provided in the class.
- Database IP, Database Name, user and password will be provided in the class.
- **DO NOT** use ECNU campus network while connecting to the database and mapmatching server.