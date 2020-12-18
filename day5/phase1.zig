const std = @import("std");

const BSP = struct {
    min: usize,
    max: usize,

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

    var tokenizer = std.mem.tokenize(input, "\n");
    var maxId: usize = 0;
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
        if (id > maxId)
            maxId = id;
    }

    std.debug.print("id: {}\n", .{maxId});
}
