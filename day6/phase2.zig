const std = @import("std");

pub fn main() !void {
    const input = @embedFile("input.txt");

    var questions = [_]u8{0} ** 26;
    var groupSize: usize = 0;
    var sum: usize = 0;

    var splitted = std.mem.split(input, "\n");
    while (splitted.next()) |slice| {
        if (slice.len == 0) {
            for (questions) |q| {
                sum += @boolToInt(q == groupSize);
            }
            std.mem.set(u8, questions[0..], 0);
            groupSize = 0;
            continue;
        }

        groupSize += 1;
        for (slice) |c| {
            questions[c - 'a'] += 1;
        }
    }

    if (groupSize > 0) {
        for (questions) |q| {
            sum += @boolToInt(q == groupSize);
        }
    }

    std.debug.print("{}\n", .{sum});
}
