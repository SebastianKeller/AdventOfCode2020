const std = @import("std");

const input = @embedFile("input.txt");
const N = 1000;
const PreambleLen = 25;

// const input =
//     \\35
//     \\20
//     \\15
//     \\25
//     \\47
//     \\40
//     \\62
//     \\55
//     \\65
//     \\95
//     \\102
//     \\117
//     \\150
//     \\182
//     \\127
//     \\219
//     \\299
//     \\277
//     \\309
//     \\576
// ;
// const N = 20;
// const PreambleLen = 5;

fn parseInput() ![N]usize {
    var tokenizer = std.mem.tokenize(input, "\n");
    var buffer: [N]usize = undefined;

    var i: usize = 0;
    while (i < N) : (i += 1) {
        buffer[i] = try std.fmt.parseInt(usize, tokenizer.next().?, 10);
    }
    return buffer;
}

fn resultPhase1(numbers: []const usize) usize {
    var i: usize = PreambleLen;

    blk: while (i < numbers.len) : (i += 1) {
        const n = numbers[i];

        const low = i - PreambleLen;
        const high = i;

        var j: usize = low;
        var k: usize = low + 1;

        while (j <= high) : ({
            j += 1;
            k = low + 1;
        }) {
            const a = numbers[j];

            while (k < high) : (k += 1) {
                if (j == k) continue;

                const b = numbers[k];
                if (a + b == n) {
                    continue :blk;
                }
            }
        }

        return n;
    }

    @panic(":(");
}

pub fn main() !void {
    const numbers = try parseInput();
    const target = resultPhase1(numbers[0..]);

    var i: usize = 0;
    var j: usize = i + 1;
    var acc: usize = numbers[i];
    blk: while (i < numbers.len) : ({
        i += 1;
        j = i + 1;
        acc = numbers[i];
    }) {
        while (j < numbers.len) : (j += 1) {
            acc += numbers[j];
            if (acc > target) continue :blk;

            if (acc == target) {
                std.debug.print("{}\n", .{findEncryptionWeaknes(numbers[i .. j + 1])});
                return;
            }
        }
    }
}

fn findEncryptionWeaknes(slice: []const usize) usize {
    const min = std.mem.min(usize, slice);
    const max = std.mem.max(usize, slice);
    return min + max;
}
