# 数据中台课程数据准备

## 数据准备
课程实验部分采用的是2015年1月3日至2015年1月7日的哈尔滨市的出租车数据，包含采集于来自于5天内13000+辆出租车的超100万条路径数据。

## Requirements
- Julia >= 1.0
- Python >= 3.6

## Dataset Preparation
### Package Installation
```bash
julia -e 'using Pkg; Pkg.add("HDF5"); Pkg.add("CSV"); Pkg.add("DataFrames"); Pkg.add("Distances"); Pkg.add("StatsBase"); Pkg.add("JSON"); Pkg.add("Lazy"); Pkg.add("JLD2"); Pkg.add("ArgParse"); Pkg.add("FileIO")'
```
### Map matching
```bash
cd Data_platform/julia
julia -p 6 mapmatch.jl --inputpath ../data/h5path --outputpath ../data/jldpath
```
where `6` is the number of cpu cores available in your machine.