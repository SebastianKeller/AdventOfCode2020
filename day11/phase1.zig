const std = @import("std");

// x, y movements
const dirs = .{
    .{ -1, -1 }, //top left
    .{ 0, -1 }, //above
    .{ 1, -1 }, //top right
    .{ 1, 0 }, // right
    .{ 1, 1 }, // right below
    .{ 0, 1 }, // below
    .{ -1, 1 }, // left below
    .{ -1, 0 }, // left
};

const Seat = enum {
    Empty, Occupied, Floor
};

const NumRows = 98;
const NumColumns = 98;

const State = struct {
    seats: [NumRows][NumColumns]Seat,
    numOccupied: usize,
};

fn fillSeats(seats: *[98][98]Seat) void {
    const data = @embedFile("seats.txt");
    var row: usize = 0;
    var column: usize = 0;
    for (data) |char| {
        switch (char) {
            'L' => {
                seats[row][column] = .Empty;
                column += 1;
            },
            '#' => {
                seats[row][column] = .Occupied;
                column += 1;
            },
            '.' => {
                seats[row][column] = .Floor;
                column += 1;
            },
            '\n' => {
                row += 1;
                column = 0;
            },
            else => {
                std.debug.print("{}", .{char});
                @panic("unrecognized character in input!");
            },
        }
    }
}

fn calcNewSeatForSeat(row: usize, column: usize, seats: [98][98]Seat) Seat {
    const seat = seats[row][column];
    if (seat == .Floor)
        return .Floor;

    var occupiedNeighbors: usize = 0;
    inline for (dirs) |dir| {
        const x = @intCast(i32, @intCast(i32, row) + dir[0]);
        const y = @intCast(i32, @intCast(i32, column) + dir[1]);

        // bounds check
        if (x >= 0 and x < 98 and y >= 0 and y < 98) {
            if (seats[@intCast(usize, x)][@intCast(usize, y)] == .Occupied)
                occupiedNeighbors += 1;
        }
    }

    if (seat == .Empty and occupiedNeighbors == 0) {
        return .Occupied;
    } else if (seat == .Occupied and occupiedNeighbors >= 4) {
        return .Empty;
    } else {
        return seat;
    }
}

pub fn main() void {
    var state: State = .{
        .seats = undefined,
        .numOccupied = 0,
    };
    fillSeats(&state.seats);

    while (true) {
        var currentState: State = .{
            .seats = state.seats,
            .numOccupied = 0,
        };

        var row: usize = 0;
        while (row < NumRows) {
            var column: usize = 0;
            while (column < NumColumns) {
                const newSeat = calcNewSeatForSeat(row, column, state.seats);

                currentState.seats[row][column] = newSeat;
                if (newSeat == .Occupied) {
                    currentState.numOccupied += 1;
                }

                column += 1;
            }

            row += 1;
        }

        if (state.numOccupied == currentState.numOccupied)
            break;

        state = currentState;
    }

    std.debug.print("{} occupied seats!\n", .{state.numOccupied});
}
