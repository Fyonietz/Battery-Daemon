const std = @import("std");
const posix = std.posix;

pub const BatteryStatus = enum{
    charging,
    discharging,
    full,
    unknown
};

pub fn get_status() !BatteryStatus {
    const fd = try posix.open("/sys/class/power_supply/BAT0/status", .{}, 0);
    defer posix.close(fd);

    var buffer: [20]u8 = undefined;
    const n = try posix.read(fd, &buffer);
    if (n >= buffer.len) return error.BufferTooSmall;
    const slice = std.mem.trim(u8,buffer[0..n],&std.ascii.whitespace);
    if(std.mem.eql(u8,slice,"Charging")) return .charging;
    if(std.mem.eql(u8,slice,"Discharging")) return .discharging;
    if(std.mem.eql(u8,slice,"Full")) return .full;

    return .unknown;
}
