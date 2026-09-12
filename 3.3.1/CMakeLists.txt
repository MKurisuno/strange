
cmake_minimum_required(VERSION 4.2.3)

#コンパイラーの設定
set(CMAKE_C_COMPILER "/usr/bin/clang-22" )
set(CMAKE_CXX_COMPILER "/usr/bin/clang++-22")

project(game331 CXX)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# C++ Modules の依存関係スキャンを無効化
# CMAKE_CXX_SCAN_FOR_MODULES を add_executable() より前に設定すること
set(CMAKE_CXX_SCAN_FOR_MODULES OFF)

#Set ${SOURCES} 
set (SOURCES
  Actor.cpp
  Component.cpp
  Game.cpp
  InputComponent.cpp
  Main.cpp
  Math.cpp
  MoveComponent.cpp
  Ship.cpp
  SpriteComponent.cpp
  CircleComponent.cpp
  Asteroid.cpp
  Random.cpp
)




find_package(SDL2 REQUIRED)
if (SDL2_FOUND)
  message ( "-#-#- SDL2 is found -#-#-" )
  message ("    SDL2_Include = ${SDL2_INCLUDE_DIRS} ")
  message ("    SDL2_Lib     = ${SDL2_LIBRARIES}")
endif()

find_package(SDL2_image REQUIRED)
if (SDL2_image_FOUND)
  message ( "-#-#- SDL2_image is found -#-#-" )
endif()


#add_library

ADD_EXECUTABLE(${PROJECT_NAME}  ${SOURCES})
target_compile_options(${PROJECT_NAME} PRIVATE -Wall -O2 -g )
target_link_libraries(${PROJECT_NAME} PRIVATE  SDL2::SDL2 SDL2_image::SDL2_image)


