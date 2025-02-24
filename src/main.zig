const std = @import("std");
const rl = @import("raylib");
const phys = @import("physics.zig");

const Star = struct {
    pos: rl.Vector2,
    color: rl.Color,
};

pub fn main() !void {
    const num_stars: i32 = 1000;
    var stars: [num_stars]Star = undefined;
    var i: usize = 0;
    while (i < num_stars) : (i += 1) {
        stars[i] = Star{
            .pos = rl.Vector2{
                .x = std.crypto.random.float(f32) * @as(f32, @floatFromInt(phys.init.screenWidth)),
                .y = std.crypto.random.float(f32) * @as(f32, @floatFromInt(phys.init.screenHeight)),
            },
            .color = rl.Color.white,
        };
    }

    rl.initWindow(phys.init.screenWidth, phys.init.screenHeight, "Orbital Revolution");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);
        rl.drawFPS(10, 10);

        // math
        const deltaX = phys.math.dx(phys.planetConstants.moon.pos.x, phys.planetConstants.earth.pos.x);
        const deltaY = phys.math.dy(phys.planetConstants.moon.pos.y, phys.planetConstants.earth.pos.y);
        const dist = phys.math.distance(deltaX, deltaY);

        const force = phys.math.forceMagnitude(phys.constants.gravity, phys.planetConstants.earth.mass, phys.planetConstants.moon.mass, dist);

        const forceX = -force * deltaX / dist;
        const forceY = -force * deltaY / dist;

        const dt: f32 = 1.0;
        const ax = forceX / phys.planetConstants.moon.mass;
        const ay = forceY / phys.planetConstants.moon.mass;

        // movement
        phys.planetConstants.moon.vel = rl.Vector2{
            .x = phys.planetConstants.moon.vel.x + ax * dt,
            .y = phys.planetConstants.moon.vel.y + ay * dt,
        };
        phys.planetConstants.moon.pos = rl.Vector2{
            .x = phys.planetConstants.moon.pos.x + phys.planetConstants.moon.vel.x * dt,
            .y = phys.planetConstants.moon.pos.y + phys.planetConstants.moon.vel.y * dt,
        };

        // gen stars
        for (stars) |star| {
            rl.drawPixel(@intFromFloat(star.pos.x), @intFromFloat(star.pos.y), star.color);
        }

        // gen planets
        rl.drawCircle(@intFromFloat(phys.planetConstants.earth.pos.x), @intFromFloat(phys.planetConstants.earth.pos.y), phys.planetConstants.earth.radius, phys.planetConstants.earth.color);
        rl.drawCircle(@intFromFloat(phys.planetConstants.moon.pos.x), @intFromFloat(phys.planetConstants.moon.pos.y), phys.planetConstants.moon.radius, phys.planetConstants.moon.color);

        // print position with 3 decimal places
        std.debug.print("Orbiting Body Position: x={d:.3}, y={d:.3}\n", .{ phys.planetConstants.moon.pos.x, phys.planetConstants.moon.pos.y });
    }
}
