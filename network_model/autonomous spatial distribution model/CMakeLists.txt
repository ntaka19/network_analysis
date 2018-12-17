cmake_minimum_required(VERSION 3.8)
project(autonomous_spatial_distribution_model)

set(CMAKE_CXX_STANDARD 11)

set(SOURCE_FILES
        addNode/addNode.cpp
        addNode/addNode.h
        heatmap/heatmap_cluster.cpp
        heatmap/ClusterElm.h
        random/getrand.cpp
        random/getrand.h
        main.cpp
        node.h
        scatter.sh)

add_executable(autonomous_spatial_distribution_model ${SOURCE_FILES})