const std = @import("std");
const rl = @import("raylib");

const Body = struct {
    pos: rl.Vector2,
    vel: rl.Vector2,
    mass: f32,
};

pub fn main() !void {

    // window properties
    rl.initWindow(800, 600, "Awesome Window");
    defer rl.closeWindow();
    rl.setTargetFPS(9999);

    //physics
    const gravity: f32 = 1.0;
    // const dt: f32 = 0.016;

    const force: f32 = ((gravity) / (10 * 10));
    std.debug.print("the force between the objects is: {}", .{force});

    // bodies
    const bodies = [3]Body{
        // body 1
        Body{
            .pos = rl.Vector2{ .x = 300, .y = 300 },
            .vel = rl.Vector2{ .x = 0, .y = 0.5 },
            .mass = 1.0,
        },

        // body 2
        Body{
            .pos = rl.Vector2{ .x = 500, .y = 300 },
            .vel = rl.Vector2{ .x = 0, .y = -0.5 },
            .mass = 1.0,
        },

        Body{
            .pos = rl.Vector2{ .x = 400, .y = 300 },
            .vel = rl.Vector2{ .x = 0, .y = 0 },
            .mass = 1.0,
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
            rl.drawCircle(@as(i32, @intFromFloat(body.pos.x)), @as(i32, @intFromFloat(body.pos.y)), 10, rl.Color.white);
        }
    }
}
