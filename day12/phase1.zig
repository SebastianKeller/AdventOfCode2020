const std = @import("std");

const North = 0;
const East = 90;
const South = 180;
const West = 270;

const State = struct {
    dir: i32,
    x: i32,
    y: i32,

    pub fn format(
        value: @This(),
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        return std.fmt.format(writer, "(x: {}, y: {}, dir: {})", .{ value.x, value.y, value.dir });
    }
};

inline fn move(state: *State, dir: i32, value: i32) void {
    switch (dir) {
        North => state.y += value,
        East => state.x += value,
        South => state.y -= value,
        West => state.x -= value,
        else => {
            std.debug.print("{}\n", .{state.dir});
            unreachable;
        },
    }
}

fn process(state: *State, action: u8, value: i32) void {
    //std.debug.print("{c}{}, {} => ", .{ action, value, state });
    switch (action) {
        'N' => {
            move(state, North, value);
        },
        'E' => {
            move(state, East, value);
        },
        'S' => {
            move(state, South, value);
        },
        'W' => {
            move(state, West, value);
        },
        'F' => {
            move(state, state.dir, value);
        },
        'R' => {
            state.dir += value;
            state.dir = @mod(state.dir, 360);
        },
        'L' => {
            state.dir -= value;
            state.dir = @mod(state.dir, 360);
        },

        else => unreachable,
    }

    //std.debug.print("{}\n", .{state});
}

pub fn main() void {
    var tokenizer = std.mem.tokenize(@embedFile("input.txt"), "\n");

    var state = State{
        .dir = East,
        .x = 0,
        .y = 0,
    };

    while (tokenizer.next()) |line| {
        var action = line[0];
        var value = std.fmt.parseInt(i32, line[1..], 10) catch unreachable;

        process(&state, action, value);
    }

    var x = std.math.absInt(state.x) catch unreachable;
    var y = std.math.absInt(state.y) catch unreachable;
    std.debug.print("{}\n", .{x + y});
}
