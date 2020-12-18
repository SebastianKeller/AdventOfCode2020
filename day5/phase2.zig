const std = @import("std");

const BSP = struct {
    min: u16,
    max: u16,

    fn takeUpper(self: *BSP) void {
        var mid = self.min + (self.max - self.min) / 2;
        self.min = mid + 1;
    }

    fn takeLower(self: *BSP) void {
        var mid = self.min + (self.max - self.min) / 2;
        self.max = mid;
    }
};

pub fn main() !void {
    const input = @embedFile("input.txt"); //"FBFBBFFRLR";

    var array = std.ArrayList(u16).init(std.heap.page_allocator);

    var tokenizer = std.mem.tokenize(input, "\n");
    while (tokenizer.next()) |line| {
        var rows = BSP{ .min = 0, .max = 127 };
        var columns = BSP{ .min = 0, .max = 7 };

        for (line) |c| {
            switch (c) {
                'F' => rows.takeLower(),
                'B' => rows.takeUpper(),
                'R' => columns.takeUpper(),
                'L' => columns.takeLower(),
                else => @panic(":("),
            }
        }

        const id = rows.min * 8 + columns.min;
        try array.append(id);
    }

    std.sort.sort(u16, array.items, {}, comptime std.sort.asc(u16));
    var prev: u16 = 0;
    for (array.items) |v| {
        if (v - prev == 2) {
            std.debug.print("id: {}\n", .{v - 1});
            break;
        }
        prev = v;
    }
}
