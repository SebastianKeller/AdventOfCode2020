const std = @import("std");

// x, y movements
const dirs = [8][2]i32{
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
const Seats = [NumRows][NumColumns]Seat;

const State = struct {
    seats: Seats,
    numOccupied: usize,
};

fn fillSeats(seats: *Seats) void {
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

fn calcNewSeatForSeat(row: usize, column: usize, seats: Seats) Seat {
    const seat = seats[row][column];
    if (seat == .Floor)
        return .Floor;

    const occupiedNeighbors = countOccupiedNeighbors(row, column, seats);

    if (seat == .Empty and occupiedNeighbors == 0) {
        return .Occupied;
    } else if (seat == .Occupied and occupiedNeighbors >= 5) {
        return .Empty;
    } else {
        return seat;
    }
}

fn countOccupiedNeighbors(row: usize, column: usize, seats: Seats) usize {
    var n: usize = 0;

    inline for (dirs) |dir| {
        var r = @intCast(i32, row);
        var c = @intCast(i32, column);

        while (true) {
            r += dir[1];
            c += dir[0];

            if (r >= 0 and r < NumRows and c >= 0 and c < NumColumns) {
                const s = seats[@intCast(usize, r)][@intCast(usize, c)];
                if (s == .Occupied) n += 1;
                if (s == .Floor) continue;
            }
            break;
        }
    }
    return n;
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
