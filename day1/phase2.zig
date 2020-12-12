const std = @import("std");

const input = @embedFile("input.txt");

fn parseInput() [200]u64 {
    var n: [200]u64 = undefined;

    var t = std.mem.tokenize(input, "\n");
    var idx: usize = 0;
    while (t.next()) |line| {
        const i = std.fmt.parseInt(u64, line, 10) catch unreachable;
        n[idx] = i;
        idx += 1;
    }
    return n;
}

pub fn main() void {
    const numbers = parseInput();

    var i: usize = 0;
    while (i < 200) : (i += 1) {
        var j: usize = 0;
        while (j < 200) : (j += 1) {
            var k: usize = 0;
            while (k < 200) : (k += 1) {
                const a = numbers[i];
                const b = numbers[j];
                const c = numbers[k];

                if ((a + b + c) == 2020) {
                    std.debug.print("{} * {} * {} = {}\n", .{ a, b, c, a * b * c });
                    return;
                }
            }
        }
    }
}
