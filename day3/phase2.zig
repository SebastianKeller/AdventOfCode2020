const std = @import("std");

const Grid = struct {
    const Height = 323;
    const Width = 31;

    data: [Height][Width]bool,

    fn init(input: []const u8) Grid {
        var g = Grid{ .data = undefined };

        var row: usize = 0;
        var column: usize = 0;
        for (input) |c| {
            switch (c) {
                '.' => {
                    g.data[row][column] = false;
                    column += 1;
                },
                '#' => {
                    g.data[row][column] = true;
                    column += 1;
                },
                '\n' => {
                    row += 1;
                    column = 0;
                },
                else => unreachable,
            }
        }
        return g;
    }

    fn at(self: Grid, row: usize, column: usize) bool {
        var c = column % Width;
        //std.debug.print("Checking: {}, {} => {}\n", .{ row, column, self.data[row][c] });
        return self.data[row][c];
    }
};

pub fn main() void {
    const grid = Grid.init(@embedFile("input.txt"));

    // right, down
    const slopes: [5][2]usize = [5][2]usize{
        .{ 1, 1 },
        .{ 3, 1 },
        .{ 5, 1 },
        .{ 7, 1 },
        .{ 1, 2 },
    };

    var results : [5]usize = undefined;
    var threads: [5]*std.Thread = undefined;

    var i: usize = 0;
    while (i < 5) : (i += 1) {
        var context = CalcTreesContext{
            .slope = slopes[i],
            .grid = &grid,
            .result = &results[i],
        };

        results[i] = 0;
        threads[i] = std.Thread.spawn(context, calcTrees) catch unreachable;
    }

    i = 0;
    while (i < 5) : (i += 1) {
        threads[i].wait();
    }

    std.debug.print("{}\n", .{results[0] * results[1] * results[2] * results[3] * results[4]});
}

const CalcTreesContext = struct {
    slope: [2]usize,
    grid: *const Grid,
    result: *usize,
};

fn calcTrees(context: CalcTreesContext) void {
    var row: usize = 0;
    var column: usize = 0;
    var treeCount: usize = 0;
    while (row < Grid.Height) {
        const isTree = context.grid.at(row, column);
        if (isTree)
            treeCount += 1;

        column += context.slope[0];
        row += context.slope[1];
    }
    context.result.* = treeCount;
}
