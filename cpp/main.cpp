#include <iostream>
#include <vector>
#include "raylib-cpp/include/raylib-cpp.hpp"

int screenWidth = 800;
int screenHeight = 600;

struct Star
{
    raylib::Vector2 pos;
    raylib::Color color;
};


void drawStars(std::vector<Star>& stars)
{
    for (Star& star : stars) {
        DrawPixel(
            star.pos.x,
            star.pos.y,
            star.color
        );
    }
}

void drawPlanets()
{
    DrawCircle(screenHeight/2, screenWidth/2, 10.0, BLUE);
    DrawCircle(screenHeight/2, screenWidth/3, 5.0, GRAY);
}

int main() {

    // Initialize window
    raylib::Window window(screenWidth, screenHeight, "Orbital Revolution Simulation");
    SetTargetFPS(60);


    // assign each star in stars x/y pos and color
    int numStars = 1000;
    std::vector<Star> stars(numStars);

    for (int i = 0; i < numStars; i++) {
        stars[i].pos = raylib::Vector2(
            static_cast<float>(GetRandomValue(0, screenWidth)),
            static_cast<float>(GetRandomValue(0, screenHeight))
        );
        stars[i].color = raylib::Color::White();
    }

    // Main game loop
    while (!WindowShouldClose()) {
        // Update

        // Draw
        BeginDrawing();
        drawStars(stars);
        drawPlanets();
        ClearBackground(BLACK);
        EndDrawing();
    }

    // Close window
    CloseWindow();

    return 0;
}