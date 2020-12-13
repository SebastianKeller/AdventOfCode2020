const std = @import("std");

const TestCase = struct {
    min: usize,
    max: usize,
    char: u8,
    input: []const u8,

    fn init(line: []const u8) !TestCase {
        var start: usize = 0;
        var len: usize = 0;

        var t: TestCase = undefined;

        const idxDash = std.mem.indexOf(u8, line, "-") orelse unreachable;
        t.min = try std.fmt.parseInt(usize, line[0..idxDash], 10);

        const idxSpace = std.mem.indexOfPos(u8, line, idxDash, " ") orelse unreachable;
        t.max = try std.fmt.parseInt(usize, line[idxDash + 1 .. idxSpace], 10);

        t.char = line[idxSpace + 1];
        t.input = line[idxSpace + 4 ..];
        //std.debug.print("{}-{} {c}: '{}'\n", .{t.min, t.max, t.char, t.input});

        return t;
    }

    fn check(this: TestCase) bool {
        var slice: [1]u8 = .{this.char};
        const count = std.mem.count(u8, this.input, &slice);
        return count >= this.min and count <= this.max;
    }
};

fn checkTest(input: []const u8) bool {
    const t = TestCase.init(input) catch unreachable;
    return t.check();
}

pub fn main() void {
    const input = @embedFile("input.txt");
    var tokenizer = std.mem.tokenize(input, "\n");

    var numPassed: usize = 0;
    while (tokenizer.next()) |line| {
        if (checkTest(line)) {
            numPassed += 1;
        }
    }
    std.debug.print("Passed: {}\n", .{numPassed});
}
