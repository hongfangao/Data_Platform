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

### Map Database

<!-- Follow the steps below for access and visualization of the PGSQL database with [Dbeaver](https://mirrors.nju.edu.cn/github-release/dbeaver/dbeaver/). -->
<!-- The map of Harbin has been implemented using [OSM](https://www.openstreetmap.org) on the cloud server. You can use the [Dbeaver](https://mirrors.nju.edu.cn/github-release/dbeaver/dbeaver/) for access and visualization of the PGSQL database.  -->

<!-- 1. Install prerequisites (Inside Docker).

    - Docker Engine (version 1.6 or higher, see [https://docs.docker.com/installation/ubuntulinux/](https://docs.docker.com/installation/ubuntulinux/))
    - [osmosis](https://wiki.openstreetmap.org/wiki/Osmosis/Installation)
    - java  -->
  
   
   You can choose one for the docker image.
   #### Method1: Build your own docker
   - Install prerequisites.
     - Docker Engine (version 1.6 or higher, see https://docs.docker.com/installation/ubuntulinux/)
     - java
   - Download the map data and extract the city data
      ```bash
      git clone https://github.com/hujilin1229/barefoot.git
      cd barefoot
      ```
   - Pull any Postgres+Postgis image
      ```bash
      docker pull docker.io/kartoza/postgis:18-3.6--v2026.03.24
      docker run -it --name harbin_map --restart=always -e POSTGRES_USER=osmuser -e POSTGRES_PASSWORD=pass -p 5432:5432 -v ${PWD}/map/:/mnt/map  -d kartoza/postgis:18-3.6--v2026.03.24
      ```
   - Import OSM Data (in the container).
     ```bash
     service postgresql start
     su - postgres -c "psql harbin"
     su - postgres -c "psql -d harbin -U postgres -f /mnt/map/backup.sql"
     ```
   #### Method2: Pull from existing image
   1. Pull docker and run container
   
      **For x86/amd64 Users**
      ```bash
      git clone git@github.com:hujilin1229/barefoot.git
      cd barefoot
      docker pull garygb/barefoot_map
      docker run -it -p 5432:5432 --name="harbin-map" -v ${PWD}/map/:/mnt/map garygb/barefoot_map:latest
      ```
   
      **For MacOS Arm Users:**   
      ```bash 
      git clone git@github.com:hujilin1229/barefoot.git
      cd barefoot
      docker pull hujilin1229/barefoot_map
      docker run -it -p 5432:5432 --name="harbin-map" -v ${PWD}/map/:/mnt/map hujilin1229/barefoot_map:latest
      ```


<!-- 3. Create Docker container.

    ``` bash
    docker run -it -p 5432:5432 --name="harbin-map" -v ${PWD}/map/:/mnt/map hujilin1229/barefoot_map:latest
    ``` -->
   1. To detach the interactive shell from a running container without stopping it, use the escape sequence Ctrl-p + Ctrl-q.
   If we want to attach it again, we can do:
      ```bash
      docker attach <container id>
      ```

   2. Make sure the container is running ("up").
      ```bash
      docker ps -a
      ...
      ```

   3. We can restart the created container (if it is stopped)
      ```bash
      docker start --interactive harbin-map
      service postgresql start
      ```
      
   <!-- **Comment line 21 in ../barefoot_map/map/Dockerfile**
   ``` bash
   service postgresql start
   ``` -->
   <!-- bash /mnt/map/osm/import.sh

    To detach the interactive shell from a running container without stopping it, use the escape sequence Ctrl-p + Ctrl-q.

    If we want to attach it again, we can do

    ```bash
    docker attach <container id>
    ``` -->

<!-- 1. Make sure the container is running ("up").

    ``` bash
    docker ps -a
    ...
    ``` -->


<!-- ### Map of Harbin

Import the map of harbin using the ``harbin_map.sql`` in this repo, with encoding = ``UTF-8``. -->


### Map matching

**(Recommended) If you want to build your own mapmatching server, please follow the steps blow to build a mapmatching server:**

**Requirements**:

- docker >= 1.6
- java 21
- osmosis (`apt-get install osmosis`)
- maven (`apt-get install maven`)

**Steps**:

Assume you have already prepared the docker in aforementioned steps, all the steps are executed inside docker.
<!-- 1. download the barefoot repo and upload the map file
   ```bash
   git clone https://github.com/boathit/barefoot.git
   cd barefoot/map/osm
   ```
2. upload the `harbin.osm.pbf` to `barefoot/map/osm`
3. rename the `barefoot` directory to `barefoot_map`
4. clone the modified codes in **another** directory
   ```bash
   git clone https://github.com/hujilin1229/barefoot.git
   cd barefoot
   cp -rf ./map ../barefoot_map/
   cp -rf ./src ../barefoot_map/
   ```
5. modify the dockerfile in barefoot_map
   ```bash
   cd ../barefoot_map/map
   ```
   **Comment line 21 in `../barefoot_map/map/Dockerfile`**

6. build the docker  
   ```bash
   cd barefoot_map
   docker build -t imap ./map
   ```
7. create the docker container
   ```bash
   docker run -it -p 5432:5432 --name="harbin-map" -v ${PWD}/map/:/mnt/map imap
   ```
8. Import the osm extract inside the container
   ```bash
   bash /mnt/map/osm/import.sh
   ```    
   To detach the interactive shell from a running container without stopping it, use the escape sequence `Ctrl-p` + `Ctrl-q`, to attach it again use `docker attach harbin-map`. -->
1. In the barefoot_map directory:
   Package Barefoot JAR. (Includes dependencies and executable main class.)
   ```bash
   mvn package --DskipTests
   ```
   **NOTE: We test the overall process under MacOS, for Windows users, the command may be different.**
2. Start server with standard configuration for map server and map matching, and option for 'mapmatchjson' output format.
   ```bash
   java -jar target/barefoot-0.1.5-matcher-jar-with-dependencies.jar --mapmatchjson config/server.properties config/harbin.properties
   ```
   Note: In case of 'parse errors', use the following Java options: 
   ```-Duser.language=en -Duser.country=US``` and the format **MUST** be 'mapmatchjson' or there'll be information loss.


<!-- #### (Not Available Any More) If you want to implement the mapmatching process with the provided server, please follow the following steps only: -->
3. Start map matching

   ```bash
   git clone https://github.com/hongfangao/Data_Platform.git
   cd Data_platform/julia
   ```
   Modify the map matching server in `trip.jl`, line `202`.

   **Please use `localhost` as we do not provide map matching server any more.**

   Modify the `localhost` to the IP address of map matching server (if you are doing mapmatching with your own server, do not change the `localhost`).
   It should be
   ```julia
   clientside = connect("IP_address", 1234)
   ```
   Then execute the following commands:
   ```bash
   julia -p 1 mapmatch.jl --inputpath ../data/h5path --outputpath ../data/jldpath
   ```
   where `1` is the number of cpu cores available in your machine. The map matching results are stored in `Data_Platform/data/jldpath`.

   Once the map matching process is finished, you should get 5 `jld2` files.
   (`trips_150103.jld2` to `trips_150107.jld2`).

   The 5 `.jld2` files contains the following information:

   - input roads and points
   - mapping results of input points
   - additional points during mapmatching and additional information (road fractions, geo location, direction)

## References:
[Learning Travel Time Distributions with Deep Generative Model](http://www.ntu.edu.sg/home/lixiucheng/pdfs/www19-deepgtt.pdf) (**WWW-19**)

[Barefoot for China Cities](https://github.com/boathit/barefoot)

[Open Street Map](https://www.openstreetmap.org)
## Notes:
- The overall map matching process may take very long time, please be patient.
<!-- - The cloud server IP will be provided in the class. -->
<!-- - Database IP, Database Name, user and password will be provided in the class. -->
- You may encounter connection problems if you use the provided server, as long as you can get the jld outputs, that's OK.
- **If encountering any problems while map matching and building matching server, feel free to contact me via wechat or github issues.**