const std = @import("std");
const rl = @import("raylib");

const Body = struct {
    pos: rl.Vector2,
    vel: rl.Vector2,
    mass: f32,
    radius: f32,
    color: rl.Color,
};

pub fn main() !void {

    // window properties
    rl.initWindow(800, 600, "Awesome Window");
    defer rl.closeWindow();
    rl.setTargetFPS(9999);

    // bodies
    const bodies = [3]Body{
        // body 1
        Body{
            .pos = rl.Vector2{ .x = 200, .y = 600 / 2 },
            .vel = rl.Vector2{ .x = 0, .y = 0.5 },
            .mass = 1.0,
            .color = rl.Color.red,
            .radius = 10.0,
        },

        // body 2
        Body{
            .pos = rl.Vector2{ .x = 800 / 2, .y = 600 / 2 },
            .vel = rl.Vector2{ .x = 0, .y = -0.5 },
            .mass = 1.0,
            .color = rl.Color.green,
            .radius = 100.0,
        },

        Body{
            .pos = rl.Vector2{ .x = 600, .y = 600 / 2 },
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
        for (bodies) |body| {
            // draw circles, layour for drawCircle() is (centerX: i32, centerY: i32, radius: f32, color: Color) so use @ for type coercion to convert from f32 to i32
            rl.drawCircle(@intFromFloat(body.pos.x), @intFromFloat(body.pos.y), body.radius, body.color);
        }
    }
}
