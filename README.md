# Orbital Revolution Simulation in Zig

## Project Summary

This Zig and CPP project implements a basic orbital revolution simulation with [raylib-zig bindings](https://github.com/Not-Nik/raylib-zig) and the [raylib-cpp bindings](https://github.com/RobLoach/raylib-cpp), respectively.

## Orbital Revolution

The simulation models objects moving in circular orbits, a fundamental concept in celestial mechanics. Key aspects of the implementation include:

### Representation

An orbital revolution is represented by:
- Position (x, y coordinates)
- Angular velocity (rate of rotation)
- Radius of orbit
- Current angle

## Usage

To run the zig project, use the following command:
```sh
git clone https://github.com/KennethChilds/zig-revolution.git
cd zig-revolution
zig build run
```

To run the cpp project:
```sh
cd cpp
g++ main.cpp -o main -IC:\raylib\raylib\src -LC:\raylib\raylib\src -lraylib -lopengl32 -lgdi32 -lwinmm -lkernel32 -w; ./main
```

If your `raylib` install is not in the `C:` drive, change the command as necessary.

Play around with values and watch what happens!
