const std = @import("std");
const rl = @import("raylib");

const Body = struct {
    pos: rl.Vector2,
    vel: rl.Vector2,
    mass: f32,
    radius: f32,
    color: rl.Color,
};

const Star = struct {
    pos: rl.Vector2,
    color: rl.Color,
};

pub fn main() !void {

    // window properties
    const screenWidth: i32 = 800;
    const screenHeight: i32 = 600;

    rl.initWindow(screenWidth, screenHeight, "Orbital Revolution");
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    const num_stars: i32 = 1000;
    var stars: [num_stars]Star = undefined;
    var i: usize = 0;
    while (i < num_stars) : (i += 1) {
        stars[i] = Star{
            .pos = rl.Vector2{
                .x = std.crypto.random.float(f32) * @as(f32, @floatFromInt(screenWidth)),
                .y = std.crypto.random.float(f32) * @as(f32, @floatFromInt(screenHeight)),
            },
            .color = rl.Color.white,
        };
    }

    // initial conditions of celestial bodies
    const gravity: f32 = 6.67e-1; // Our gravitational constant
    const central_mass: f32 = 100.0;
    const radius: f32 = 100.0;
    const orbit_radius: f32 = radius * 2; // Distance from center to orbiting body

    // Calculate the required velocity for circular orbit: v = sqrt(G * M / r)
    const orbital_velocity = @sqrt((gravity * central_mass) / orbit_radius);

    var bodies = [_]Body{
        // body 1 (orbiting body)
        Body{
            .pos = rl.Vector2{
                .x = screenWidth / 4,
                .y = screenHeight / 2,
            },
            .vel = rl.Vector2{
                .x = 0,
                .y = orbital_velocity,
            },
            .mass = 1.0,
            .color = rl.Color.dark_gray,
            .radius = radius / 10,
        },

        // body 2 (central body)
        Body{
            .pos = rl.Vector2{ .x = screenWidth / 2, .y = screenHeight / 2 },
            .vel = rl.Vector2{ .x = 0, .y = 0 },
            .mass = central_mass,
            .color = rl.Color.dark_blue,
            .radius = radius,
        },
    };

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);
        rl.drawFPS(
            10,
            10,
        );

        // Calculate forces between bodies[0] and bodies[1]
        const dx = bodies[1].pos.x - bodies[0].pos.x;
        const dy = bodies[1].pos.y - bodies[0].pos.y;
        const distance = rl.math.vector2Distance(bodies[0].pos, bodies[1].pos);
        const force_magnitude = (gravity * bodies[0].mass * bodies[1].mass) / (distance * distance);

        // Calculate force components
        const force_x = force_magnitude * dx / distance;
        const force_y = force_magnitude * dy / distance;

        const dt: f32 = 10.0;

        // Calculate acceleration components
        const ax = force_x / bodies[0].mass;
        const ay = force_y / bodies[0].mass;

        // Update velocity and position
        bodies[0].vel = rl.Vector2{
            .x = bodies[0].vel.x + ax * dt,
            .y = bodies[0].vel.y + ay * dt,
        };
        bodies[0].pos = rl.Vector2{
            .x = bodies[0].pos.x + bodies[0].vel.x * dt,
            .y = bodies[0].pos.y + bodies[0].vel.y * dt,
        };

        for (stars) |star| {
            rl.drawPixel(@intFromFloat(star.pos.x), @intFromFloat(star.pos.y), star.color);
        }

        for (bodies) |body| {
            // draw circles, layout for drawCircle() is (centerX: i32, centerY: i32, radius: f32, color: Color) so use @ for type coercion to convert from f32 to i32
            rl.drawCircle(@intFromFloat(body.pos.x), @intFromFloat(body.pos.y), body.radius, body.color);
        }

        std.debug.print("Orbiting Body Position: x={d:.3}, y={d:.3}\n", .{ bodies[0].pos.x, bodies[0].pos.y });
    }
}
