const std = @import("std");

const Op = enum {
    nop,
    acc,
    jmp,

    fn parse(slice: []const u8) Op {
        if (std.mem.eql(u8, slice, "nop")) return .nop;
        if (std.mem.eql(u8, slice, "acc")) return .acc;
        if (std.mem.eql(u8, slice, "jmp")) return .jmp;
        @panic(":(");
    }
};

const Instruction = struct {
    op: Op,
    value: i32,
};

fn parseInstruction(arr: *std.ArrayList(Instruction)) !void {
    const input = @embedFile("input.txt");
    //        \\nop +0
    //        \\acc +1
    //        \\jmp +4
    //        \\acc +3
    //        \\jmp -3
    //        \\acc -99
    //        \\acc +1
    //        \\jmp -4
    //        \\acc +6
    //    ;

    var tokenizer = std.mem.tokenize(input, "\n +");
    while (tokenizer.next()) |opName| {
        const op = Op.parse(opName);
        const value = try std.fmt.parseInt(i32, tokenizer.next().?, 10);
        try arr.append(Instruction{ .op = op, .value = value });
    }
}

pub fn main() !void {
    var instructions = std.ArrayList(Instruction).init(std.testing.allocator);
    try parseInstruction(&instructions);

    var guards = try std.ArrayList(bool).initCapacity(std.testing.allocator, instructions.items.len);
    guards.appendNTimesAssumeCapacity(false, instructions.items.len);

    var acc: i32 = 0;
    var i: usize = 0;
    while (guards.items[i] == false) {
        guards.items[i] = true;
        const instruction = instructions.items[i];
        // std.debug.print("Acc: {}, In: {} {}\n", .{ acc, instruction.op, instruction.value });
        switch (instruction.op) {
            .nop => i += 1,
            .acc => {
                acc += instruction.value;
                i += 1;
            },
            .jmp => i = @intCast(usize, (@intCast(i32, i) + instruction.value)),
        }
    }
    std.debug.print("{}\n", .{acc});
}
