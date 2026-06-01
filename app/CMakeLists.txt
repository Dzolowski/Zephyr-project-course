cmake_minimum_required(VERSION 3.20.0)

find_package(Zephyr REQUIRED)
project(zephyr_in_prod)

target_sources(app PRIVATE src/main.c)
