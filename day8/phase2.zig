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

    var changedInstructionPos: usize = 0;
    var changedInstruction: Instruction = instructions.items[0];

    while (!run(instructions.items, guards.items, &acc)) {
        // reset values
        std.mem.set(bool, guards.items, false);
        acc = 0;
        instructions.items[changedInstructionPos] = changedInstruction;

        // find next instruction to change
        changedInstructionPos += 1;
        while (true) : (changedInstructionPos += 1) {
            const i = &instructions.items[changedInstructionPos];

            if (i.op == .nop) {
                changedInstruction = i.*;
                i.op = .jmp;
                break;
            } else if (i.op == .jmp) {
                changedInstruction = i.*;
                i.op = .nop;
                break;
            }
        }
    }

    std.debug.print("{}\n", .{acc});
}

fn run(instructions: []const Instruction, guards: []bool, acc: *i32) bool {
    var localAcc: i32 = 0;
    var retVal = true;

    var i: usize = 0;
    while (true) {
        if (i >= guards.len) {
            break;
        }
        if (guards[i] == true) {
            retVal = false;
            break;
        }

        guards[i] = true;
        const instruction = instructions[i];
        // std.debug.print("Acc: {}, In: {} {}\n", .{ acc, instruction.op, instruction.value });

        switch (instruction.op) {
            .nop => i += 1,
            .acc => {
                localAcc += instruction.value;
                i += 1;
            },
            .jmp => {
                const newIdx = @intCast(i32, i) + instruction.value;
                if (newIdx < 0) {
                    retVal = false;
                    break;
                }

                i = @intCast(usize, newIdx);
            },
        }
    }
    acc.* = localAcc;
    return retVal;
}
