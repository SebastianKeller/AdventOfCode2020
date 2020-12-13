const std = @import("std");
const input = @embedFile("input.txt");

const Bus = struct {
    id: i64,
    offset: i64,
};

fn parseBusses(bus: []const u8, allocator: *std.mem.Allocator) !std.ArrayList(Bus) {
    var arr = std.ArrayList(Bus).init(allocator);
    var tokenizer = std.mem.tokenize(bus, ",");

    var idx: i64 = 0;
    while (tokenizer.next()) |slice| {
        defer idx += 1;

        const id = std.fmt.parseInt(i64, slice, 10) catch continue;
        try arr.append(Bus{ .id = id, .offset = idx });
    }

    return arr;
}

pub fn main() void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = &arena.allocator;
    defer arena.deinit();

    var tokenizer = std.mem.tokenize(input, "\n");

    // departure time is no longer relevant
    _ = tokenizer.next().?;

    var busses = parseBusses(tokenizer.next().?, allocator) catch unreachable;

    var time: i64 = 0;
    var step: i64 = busses.items[0].id;
    var offset: ?i64 = null;

    for (busses.items[1..]) |bus| {
        offset = null;
        while (true) {
            if (@mod(time + bus.offset, bus.id) == 0) {
                if (offset) |o| {
                    step = time - o;
                    break;
                } else {
                    offset = time;
                }
            }
            time += step;
        }
    }
    std.debug.print("{}\n", .{offset});
}
