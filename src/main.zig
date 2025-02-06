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

    rl.initWindow(screenWidth, screenHeight, "Awesome Window");
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
    const bodies = [3]Body{
        // body 1
        Body{
            .pos = rl.Vector2{ .x = 200, .y = screenHeight / 2 },
            .vel = rl.Vector2{ .x = 0, .y = 0.5 },
            .mass = 1.0,
            .color = rl.Color.red,
            .radius = 10.0,
        },

        // body 2
        Body{
            .pos = rl.Vector2{ .x = screenWidth / 2, .y = screenHeight / 2 },
            .vel = rl.Vector2{ .x = 0, .y = -0.5 },
            .mass = 1.0,
            .color = rl.Color.green,
            .radius = 100.0,
        },

        Body{
            .pos = rl.Vector2{ .x = 600, .y = screenHeight / 2 },
            .vel = rl.Vector2{ .x = 0, .y = 0 },
            .mass = 1.0,
            .color = rl.Color.blue,
            .radius = 10.0,
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

        // physics constants
        //const gravity: comptime_float = 1.0;

        for (stars) |star| {
            rl.drawPixel(@intFromFloat(star.pos.x), @intFromFloat(star.pos.y), star.color);
        }

        for (bodies) |body| {
            //const gravitational_force: comptime_float = (gravity) * (body.mass * body.mass) / (std.math.pow(distance, 2));
            // draw circles, layout for drawCircle() is (centerX: i32, centerY: i32, radius: f32, color: Color) so use @ for type coercion to convert from f32 to i32
            rl.drawCircle(@intFromFloat(body.pos.x), @intFromFloat(body.pos.y), body.radius, body.color);
        }
    }
}
