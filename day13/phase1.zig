const std = @import("std");
const input = @embedFile("input.txt");

fn parseLineIds(line: []const u8, allocator: *std.mem.Allocator) !std.ArrayList(u64) {
    var arr = std.ArrayList(u64).init(allocator);
    var tokenizer = std.mem.tokenize(line, ",");
    while (tokenizer.next()) |slice| {
        const id = std.fmt.parseInt(u64, slice, 10) catch continue;
        try arr.append(id);
    }

    return arr;
}

pub fn main() void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = &arena.allocator;

    var tokenizer = std.mem.tokenize(input, "\n");
    const departure = std.fmt.parseInt(u64, tokenizer.next().?, 10) catch unreachable;
    var lineIds = parseLineIds(tokenizer.next().?, allocator) catch unreachable;

    var time = departure;
    while(true) : (time+=1) {
        for(lineIds.items) |id| {
            if(time % id == 0) {
                const wait = time - departure;
                const result = wait * id;
                std.debug.print("{}\n", .{result});
                return;
            }
        }
    }
}
