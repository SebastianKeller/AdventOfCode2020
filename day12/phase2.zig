const std = @import("std");

const North = 0;
const East = 90;
const South = 180;
const West = 270;

const Pos = struct {
    x: i32, y: i32
};

const State = struct {
    dir: i32,
    waypoint: Pos,
    ship: Pos,

    pub fn format(
        value: @This(),
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        return std.fmt.format(
            writer,
            "(wp: ({}, {}) ship: ({}/{}), dir: {})",
            .{
                value.waypoint.x,
                value.waypoint.y,
                value.ship.x,
                value.ship.y,
                value.dir,
            },
        );
    }
};

inline fn moveWaypoint(pos: *Pos, dir: i32, value: i32) void {
    switch (dir) {
        North => pos.y += value,
        East => pos.x += value,
        South => pos.y -= value,
        West => pos.x -= value,
        else => {
            std.debug.print("{}\n", .{dir});
            unreachable;
        },
    }
}

inline fn rotatePos(pos: *Pos, clockwise: bool, value: i32) void {
    const bak = pos.*;

    if (clockwise) {
        switch (value) {
            90 => {
                pos.x = bak.y;
                pos.y = -bak.x;
            },
            180 => {
                pos.x = -bak.x;
                pos.y = -bak.y;
            },
            270 => {
                pos.x = -bak.y;
                pos.y = bak.x;
            },
            else => {
                std.debug.print("unsupported rotation '{}'", .{value});
                @panic("unsupported rotation");
            },
        }
    } else {
        switch (value) {
            90 => {
                pos.x = -bak.y;
                pos.y = bak.x;
            },
            180 => {
                pos.x = -bak.x;
                pos.y = -bak.y;
            },
            270 => {
                pos.x = bak.y;
                pos.y = -bak.x;
            },
            else => {
                std.debug.print("unsupported rotation '{}'", .{value});
                @panic("unsupported rotation");
            },
        }
    }
}

fn process(state: *State, action: u8, value: i32) void {
    //std.debug.print("{c}{}, {} => ", .{ action, value, state });
    switch (action) {
        'N' => {
            moveWaypoint(&state.waypoint, North, value);
        },
        'E' => {
            moveWaypoint(&state.waypoint, East, value);
        },
        'S' => {
            moveWaypoint(&state.waypoint, South, value);
        },
        'W' => {
            moveWaypoint(&state.waypoint, West, value);
        },
        'F' => {
            state.ship.x += state.waypoint.x * value;
            state.ship.y += state.waypoint.y * value;
        },
        'R' => {
            rotatePos(&state.waypoint, true, value);
        },
        'L' => {
            rotatePos(&state.waypoint, false, value);
        },

        else => unreachable,
    }

    std.debug.print("{}\n", .{state});
}

pub fn main() void {
    var tokenizer = std.mem.tokenize(@embedFile("input.txt"), "\n");

    var state = State{
        .dir = East,
        .waypoint = .{ .x = 10, .y = 1 },
        .ship = .{ .x = 0, .y = 0 },
    };

    while (tokenizer.next()) |line| {
        var action = line[0];
        var value = std.fmt.parseInt(i32, line[1..], 10) catch unreachable;

        process(&state, action, value);
    }

    var x = std.math.absInt(state.ship.x) catch unreachable;
    var y = std.math.absInt(state.ship.y) catch unreachable;
    std.debug.print("{}\n", .{x + y});
}
