const std = @import("std");

const Bag = struct {
    name: []const u8,
    contains: [4]?*Bag,

    fn init(
        name: []const u8,
    ) Bag {
        return Bag{ .name = name, .contains = [_]?*Bag{null} ** 4 };
    }
};

fn parseBagName(tokenizer: *std.mem.TokenIterator) []const u8 {
    const firstPart = tokenizer.next().?;
    const secondPart = tokenizer.next().?;

    const len = firstPart.len + secondPart.len + 1;
    const start = tokenizer.index - len;
    const name = tokenizer.buffer[start .. start + len];

    // discard 'bag(s)'
    _ = tokenizer.next();
    return name;
}

fn parseContains(tokenizer: *std.mem.TokenIterator) ?struct { num: usize, name: []const u8 } {
    const n = tokenizer.next() orelse return null;
    if (std.mem.eql(u8, n, "no"))
        return null;

    const num = std.fmt.parseInt(u8, n, 10) catch unreachable;
    const result = .{ .num = num, .name = parseBagName(tokenizer) };
    return result;
}

fn getOrCreateBag(
    name: []const u8,
    hashMap: *std.StringHashMap(*Bag),
    allocator: *std.mem.Allocator,
) *Bag {
    var result = hashMap.getOrPut(name) catch unreachable;
    if (result.found_existing)
        return result.entry.value;

    var bag = allocator.create(Bag) catch unreachable;
    bag.* = Bag.init(name);

    result.entry.value = bag;
    return bag;
}

fn parseBag(
    line: []const u8,
    hashMap: *std.StringHashMap(*Bag),
    allocator: *std.mem.Allocator,
) *Bag {
    var tokenizer = std.mem.tokenize(line, "  ,.");

    var name = parseBagName(&tokenizer);
    var bag = getOrCreateBag(name, hashMap, allocator);

    // skip contain
    _ = tokenizer.next();

    var i: usize = 0;
    while (parseContains(&tokenizer)) |v| : (i += 1) {
        const c = getOrCreateBag(v.name, hashMap, allocator);
        bag.contains[i] = c;
    }

    return bag;
}

fn containsBag(haystack: *const Bag, needle: *const Bag) bool {
    for (haystack.contains) |c| {
        if (c) |bag| {
            if (bag == needle)
                return true;

            if (containsBag(bag, needle))
                return true;
        }
    }
    return false;
}

fn parseInput(hashMap: *std.StringHashMap(*Bag), allocator: *std.mem.Allocator) void {
    const input = @embedFile("input.txt");
    var lineTokenizer = std.mem.tokenize(input, "\n");
    while (lineTokenizer.next()) |line| {
        _ = parseBag(line, hashMap, allocator);
    }
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var hashMap = std.StringHashMap(*Bag).init(allocator);
    parseInput(&hashMap, allocator);

    const target = hashMap.get("shiny gold").?;

    var counter: usize = 0;
    var iterator = hashMap.iterator();
    while (iterator.next()) |entry| {
        if (containsBag(entry.value, target)) {
            counter += 1;
        }
    }
    std.debug.print("{}\n", .{counter});
}
