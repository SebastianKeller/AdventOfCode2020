const std = @import("std");

const input = @embedFile("input.txt");
const N = 25;

pub fn main() !void {
    var tokenizer = std.mem.tokenize(input, "\n");

    var numbers: [N]usize = [_]usize{0} ** N;

    var i: usize = 0;
    while (i < N) : (i += 1) {
        numbers[i] = try std.fmt.parseInt(usize, tokenizer.next().?, 10);
    }

    while (tokenizer.next()) |line| : (i += 1) {
        var n = try std.fmt.parseInt(usize, line, 10);

        var found = false;
        var j: usize = 0;
        var k: usize = 0;

        blk: while (j < N) : ({
            j += 1;
            k = 0;
        }) {
            const a = numbers[j];

            while (k < N) : (k += 1) {
                const b = numbers[N - k - 1];
                if (a + b == n) {
                    found = true;
                    break :blk;
                }
            }
        }

        if (found == false) {
            std.debug.print("{}\n", .{n});
            break;
        }

        numbers[i % N] = n;
    }
}
