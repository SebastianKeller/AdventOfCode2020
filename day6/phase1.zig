const std = @import("std");

pub fn main() !void {
    const input = @embedFile("input.txt");

    var questions = [_]u1{0} ** 26;
    var sum: usize = 0;

    var splitted = std.mem.split(input, "\n");
    while (splitted.next()) |slice| {
        if (slice.len == 0) {
            for (questions) |q| {
                sum += q;
            }
            std.mem.set(u1, questions[0..], 0);
            continue;
        }

        for (slice) |c| {
            questions[c - 'a'] = 1;
        }
    }

    for (questions) |q| {
        sum += q;
    }
    std.debug.print("{}\n", .{sum});
}
