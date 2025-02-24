const std = @import("std");
const rl = @import("raylib");

//width: i32, height: i32, title: [*:0]const u8

pub const init = struct {
    pub const screenWidth = 800;
    pub const screenHeight = 600;
};

pub const constants = struct {
    pub const massEarth: f32 = 1000.0;
    pub const massMoon: f32 = 10.0;
    pub const gravity: f32 = 6.67e-1;
    pub const radius: f32 = 100.0;
    pub const orbitRadius: f32 = radius * 2;
};

pub const body = struct {
    pos: rl.Vector2,
    vel: rl.Vector2,
    mass: f32,
    radius: f32,
    color: rl.Color,
};

pub const planetConstants = struct {
    pub var earth = body{
        .pos = .{
            .x = init.screenWidth / 2,
            .y = init.screenHeight / 2,
        },
        .vel = .{
            .x = 0.0,
            .y = 0.0,
        },
        .mass = constants.massEarth,
        .radius = constants.radius,
        .color = rl.Color.dark_blue,
    };

    pub var moon = body{
        .pos = .{
            .x = init.screenWidth / 4,
            .y = init.screenHeight / 2,
        },
        .vel = .{
            .x = 0.0,
            .y = math.orbitalVelocity(constants.gravity, constants.massEarth, constants.orbitRadius),
        },
        .mass = constants.massMoon,
        .radius = constants.radius / 10,
        .color = rl.Color.gray,
    };
};

pub const math: type = struct {
    pub fn orbitalVelocity(gravity: f32, centralMass: f32, orbitRadius: f32) f32 {
        return @sqrt((gravity * centralMass) / orbitRadius);
    }

    pub fn dx(x_pos_1: f32, x_pos_2: f32) f32 {
        return x_pos_1 - x_pos_2;
    }

    pub fn dy(y_pos_1: f32, y_pos_2: f32) f32 {
        return y_pos_1 - y_pos_2;
    }

    pub fn distance(delta_x: f32, delta_y: f32) f32 {
        return @sqrt(delta_x * delta_x + delta_y * delta_y);
    }

    pub fn forceMagnitude(gravity: f32, bodyMass1: f32, bodyMass2: f32, dist: f32) f32 {
        return (gravity * bodyMass1 * bodyMass2) / (dist * dist);
    }
};
