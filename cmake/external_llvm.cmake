# ******************************************************************************
# Copyright 2017-2020 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ******************************************************************************

# Try to find system or user provide Clang first and use it if available
# Clang Config does not support version so find LLVM first
# To install Clang 9 system wide On Ubuntu 18.04
# sudo apt-get install clang-9 libclang-9-dev
# For user installed clang, provide path to LLVMConfig.cmake by passing
# -DCMAKE_PREFIX_PATH=<path to dir with LLVMConfig.cmake>
# When you configure CMake
find_package(LLVM 9 CONFIG)
if(LLVM_FOUND)
    find_package(Clang CONFIG
        HINTS ${LLVM_DIR}/../lib/cmake/clang ${LLVM_DIR}/../clang NO_DEFAULT_PATH)
endif()

if(NOT Clang_FOUND)
    set(LLVM_PROJECT_ROOT ${EXTERNAL_PROJECTS_ROOT}/llvm-project)
    set(LLVM_INSTALL_ROOT ${EXTERNAL_PROJECTS_ROOT}/llvm)

    configure_file(${CMAKE_SOURCE_DIR}/cmake/llvm_fetch.cmake.in ${LLVM_PROJECT_ROOT}/CMakeLists.txt @ONLY)

    execute_process(COMMAND "${CMAKE_COMMAND}" -G "${CMAKE_GENERATOR}"
        -DCMAKE_GENERATOR_PLATFORM:STRING=${CMAKE_GENERATOR_PLATFORM}
        -DCMAKE_GENERATOR_TOOLSET:STRING=${CMAKE_GENERATOR_TOOLSET}
        .
        WORKING_DIRECTORY "${LLVM_PROJECT_ROOT}")

    # clone and build llvm
    include(ProcessorCount)
    ProcessorCount(N)
    if(("${CMAKE_GENERATOR}" STREQUAL "Unix Makefiles") AND (NOT N EQUAL 0))
        execute_process(COMMAND "${CMAKE_COMMAND}" --build . -- -j${N}
            WORKING_DIRECTORY "${LLVM_PROJECT_ROOT}")
    else()
        execute_process(COMMAND "${CMAKE_COMMAND}" --build .
            WORKING_DIRECTORY "${LLVM_PROJECT_ROOT}")
    endif()

    message(STATUS "LLVM_INSTALL_ROOT: ${LLVM_INSTALL_ROOT}")
    find_package(Clang REQUIRED CONFIG
        HINTS ${LLVM_INSTALL_ROOT}/lib/cmake/clang NO_DEFAULT_PATH)
endif()

message(STATUS "CLANG_CMAKE_DIR: ${CLANG_CMAKE_DIR}")
message(STATUS "CLANG_INCLUDE_DIRS: ${CLANG_INCLUDE_DIRS}")
message(STATUS "LLVM_INCLUDE_DIRS: ${LLVM_INCLUDE_DIRS}")

add_library(libllvm INTERFACE)
target_include_directories(libllvm INTERFACE ${CLANG_INCLUDE_DIRS} ${LLVM_INCLUDE_DIR})
target_link_libraries(libllvm INTERFACE clangHandleCXX clangHandleLLVM)
