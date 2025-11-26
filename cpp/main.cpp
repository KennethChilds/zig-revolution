#include <iostream>
#include <vector>
#include <cmath>
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

struct Planet
{
    raylib::Vector2 pos;
    raylib::Vector2 vel;
    double radius;
    double mass;
    raylib::Color color;

    void drawPlanet()
    {
        DrawCircle(pos.x, pos.y, radius, color);
    }
};

namespace Math
{
    double orbitalVelocity(double gravity, double centralMass, double orbitRadius)
    {
        return std::sqrt((gravity * centralMass) / orbitRadius);
    }

    double dx(double xPos1, double xPos2)
    {
        return xPos1 - xPos2;
    }

    double dy(double yPos1, double yPos2)
    {
        return yPos1 - yPos2;
    }

    double distance(double dx, double dy)
    {
        return std::sqrt(dx * dx + dy * dy);
    }

    double forceMagnitude(double gravity, double bodyMass1, double bodyMass2, double distance)
    {
        return (gravity * bodyMass1 * bodyMass2) / (distance * distance);
    }
};


int main() {
    // math constants
    constexpr double massEarth = 1000.0;
    constexpr double massMoon = 10.0;
    constexpr double gravity = 6.67e-1;
    const double orbitRadius = 200.0;

    // assign planet attributes
    Planet earth{
        {screenWidth/2.0f, screenHeight/2.0f},
        {0, 0},
        100.0,
        massEarth,
        BLUE
    };
    
    Planet moon{
        {screenWidth/4.0f, screenHeight/2.0f},
        {0, static_cast<float>(Math::orbitalVelocity(gravity, massEarth, orbitRadius))},
        10.0,
        massMoon,
        GRAY
    };

    // Initialize window
    raylib::Window window(screenWidth, screenHeight, "Orbital Revolution Simulation");
    SetTargetFPS(60);

    // assign each star in stars x/y pos and color
    int numStars = 1500;
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
        // math calculations
        double dx = Math::dx(moon.pos.x, earth.pos.x);
        double dy = Math::dy(moon.pos.y, earth.pos.y);
        double dist = Math::distance(dx, dy);

        double force = Math::forceMagnitude(
            gravity,
            massEarth,
            massMoon,
            dist
        );

        double forceX = -force * dx / dist;
        double forceY = -force * dy / dist;

        constexpr double dt = 1.0;

        double ax = forceX / massMoon;
        double ay = forceY / massMoon;

        //update
        moon.vel.x += ax *dt;
        moon.vel.y += ay * dt;

        moon.pos.x += moon.vel.x * dt;
        moon.pos.y += moon.vel.y * dt;

        // Draw
        BeginDrawing();
        ClearBackground(BLACK);
        DrawFPS(10, 10);

        drawStars(stars);
        earth.drawPlanet();
        moon.drawPlanet();
        
        // text coordinates
        std::cout << "Orbiting Body Position: " << "x = " << moon.pos.x << " y = " << moon.pos.y << std::endl;

        EndDrawing();
    }

    // Close window
    CloseWindow();

    return 0;
}