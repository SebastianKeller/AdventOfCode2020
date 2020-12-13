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
        var r = row % Height;
        var c = column % Width;
        //std.debug.print("Checking: {}, {} => {}\n", .{ row, column, self.data[r][c] });
        return self.data[r][c];
    }
};

pub fn main() void {
    const grid = Grid.init(@embedFile("input.txt"));

    const dx: usize = 3;
    const dy: usize = 1;

    var row: usize = 0;
    var column: usize = 0;
    var treeCount: usize = 0;
    while (row <= Grid.Height) {
        const isTree = grid.at(row, column);
        if (isTree)
            treeCount += 1;

        column += dx;
        row += dy;
    }
    std.debug.print("{}\n", .{treeCount});
}
