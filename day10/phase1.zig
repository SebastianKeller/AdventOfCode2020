const std = @import("std");

const input = @embedFile("input.txt");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var array = std.ArrayList(u32).init(&arena.allocator);

    var tokenizer = std.mem.tokenize(input, "\n");
    while (tokenizer.next()) |line| {
        const n = try std.fmt.parseInt(u32, line, 10);
        try array.append(n);
    }

    std.sort.sort(u32, array.items, {}, comptime std.sort.asc(u32));

    var counters: [3]usize = [_]usize{@as(usize, 0)} ** 3;
    var currentJolts: usize = 0;

    var i: usize = 0;
    while (i < array.items.len) : (i += 1) {
        const n = array.items[i];
        const d = n - currentJolts;
        if (d > 0 and d <= 3) {
            // std.debug.print(
            //     "{d:3}: CurrentJolts: {d:3}, Jolts: {d:3}, Diff: {}\n",
            //     .{ i, currentJolts, n, d },
            // );
            currentJolts = n;
            counters[d - 1] += 1;
        }
    }

    // add the counter for the +3 connection to our device
    counters[2] += 1;

    std.debug.print("Result: {}\n", .{counters[0] * counters[2]});
}
