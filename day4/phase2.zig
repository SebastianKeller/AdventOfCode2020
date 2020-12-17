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

fn validateByr(value: ?[]const u8) bool {
    if (value) |slice| {
        const i = std.fmt.parseInt(i32, slice, 10) catch return false;
        return i >= 1920 and i <= 2002;
    }
    return false;
}

fn validateIyr(value: ?[]const u8) bool {
    if (value) |slice| {
        const i = std.fmt.parseInt(i32, slice, 10) catch return false;
        return i >= 2010 and i <= 2020;
    }
    return false;
}

fn validateEyr(value: ?[]const u8) bool {
    if (value) |slice| {
        const i = std.fmt.parseInt(i32, slice, 10) catch return false;
        return i >= 2020 and i <= 2030;
    }
    return false;
}

fn validateHgt(value: ?[]const u8) bool {
    if (value) |slice| {
        var numberLen: usize = 0;
        for (slice) |c| {
            if (std.ascii.isDigit(c)) {
                numberLen += 1;
            } else {
                break;
            }
        }

        const i = std.fmt.parseInt(i32, slice[0..numberLen], 10) catch return false;
        const unit = slice[numberLen..];
        if (std.mem.eql(u8, unit, "cm")) {
            return i >= 150 and i <= 193;
        } else if (std.mem.eql(u8, unit, "in")) {
            return i >= 59 and i <= 76;
        } else {
            return false;
        }
    }
    return false;
}

fn validateHcl(value: ?[]const u8) bool {
    if (value) |slice| {
        if (slice[0] != '#') return false;
        for (slice[1..]) |c| {
            if (!std.ascii.isAlNum(c))
                return false;
        }
        return true;
    }
    return false;
}

fn validateEcl(value: ?[]const u8) bool {
    if (value) |slice| {
        if (std.mem.eql(u8, slice, "amb")) return true;
        if (std.mem.eql(u8, slice, "blu")) return true;
        if (std.mem.eql(u8, slice, "brn")) return true;
        if (std.mem.eql(u8, slice, "gry")) return true;
        if (std.mem.eql(u8, slice, "grn")) return true;
        if (std.mem.eql(u8, slice, "hzl")) return true;
        if (std.mem.eql(u8, slice, "oth")) return true;
        return false;
    }
    return false;
}

fn validatePid(value: ?[]const u8) bool {
    if (value) |slice| {
        if (slice.len != 9) return false;
        for (slice) |c| {
            if (!std.ascii.isDigit(c))
                return false;
        }
        return true;
    }
    return false;
}

fn validate(field: Field, value: ?[]const u8) bool {
    return switch (field) {
        .cid => true,
        .byr => validateByr(value),
        .iyr => validateIyr(value),
        .eyr => validateEyr(value),
        .hgt => validateHgt(value),
        .hcl => validateHcl(value),
        .ecl => validateEcl(value),
        .pid => validatePid(value),
    };
}

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
        if (line.len == 0) {
            //validate attributes
            var isValid = true;
            for (attributes) |value, idx| {
                if (!validate(@intToEnum(Field, @intCast(u3, idx)), value)) {
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
