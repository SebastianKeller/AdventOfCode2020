const std = @import("std");

const Field = enum {
    cid = 0,
    byr,
    ecl,
    eyr,
    hcl,
    hgt,
    iyr,
    pid,

    fn parse(input: []const u8) Field {
        if (std.mem.eql(u8, input, "ecl")) return .ecl;
        if (std.mem.eql(u8, input, "pid")) return .pid;
        if (std.mem.eql(u8, input, "eyr")) return .eyr;
        if (std.mem.eql(u8, input, "hcl")) return .hcl;
        if (std.mem.eql(u8, input, "byr")) return .byr;
        if (std.mem.eql(u8, input, "iyr")) return .iyr;
        if (std.mem.eql(u8, input, "cid")) return .cid;
        if (std.mem.eql(u8, input, "hgt")) return .hgt;
        unreachable;
    }
};

pub fn main() void {
    var input = @embedFile("input.txt");
    //        \\ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
    //        \\byr:1937 iyr:2017 cid:147 hgt:183cm
    //        \\
    //        \\iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
    //        \\hcl:#cfa07d byr:1929
    //        \\
    //        \\hcl:#ae17e1 iyr:2013
    //        \\eyr:2024
    //        \\ecl:brn pid:760753108 byr:1931
    //        \\hgt:179cm
    //        \\
    //        \\hcl:#cfa07d eyr:2025 pid:166559648
    //        \\iyr:2011 ecl:brn hgt:59in
    //    ;
    var numValidPassports: usize = 0;

    var attributes: [8]?[]const u8 = undefined;
    for (attributes) |*f| f.* = null;

    var linesIterator = std.mem.split(input, "\n");
    while (linesIterator.next()) |line| {
        //std.debug.print("'{}'\n", .{line});
        if (line.len == 0) {
            //validate attributes
            var isValid = true;
            for (attributes) |value, idx| {
                if (value == null and idx != 0) {
                    isValid = false;
                    break;
                }
            }
            if (isValid)
                numValidPassports += 1;

            //Reset
            for (attributes) |*f| f.* = null;
            continue;
        }

        var attributesIterator = std.mem.tokenize(line, " ");
        while (attributesIterator.next()) |attribute| {
            var name = attribute[0..3];
            var value = attribute[4..];
            var field = Field.parse(name);
            attributes[@enumToInt(field)] = value;
        }
    }

    std.debug.print("Valid passports: {}\n", .{numValidPassports});
}
