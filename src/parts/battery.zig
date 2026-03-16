const std = @import("std");

pub fn message() void {
    std.debug.print("from {s}\n",.{"battery"});
}
