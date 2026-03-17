const std = @import("std");
const cpu = @import("parts/cpu.zig");
const gpu = @import("parts/gpu.zig");
const battery = @import("parts/battery.zig");
const notify = @import("notify.zig");
pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var cpu_usage: f32 = undefined;
    var cpu_temp: f32 = undefined;
    var battery_percentage:f32 = undefined;
    var cmd: []const []const u8 = undefined;
    while (true) {
        cpu_usage = try cpu.get_usage();
        cpu_temp = try cpu.get_temp();
        battery_percentage = try battery.get_percentage();
        std.debug.print("CPU Usage : {d}\nCPU Temp : {d}\nBattery Level : {d}\n", .{cpu_usage,cpu_temp,battery_percentage});

        std.posix.nanosleep(1, 1000);
        break;
    }
    const msg = try std.fmt.allocPrint(allocator, "--text=CPU Usage : {d}%\nCPU Temp:{d}\n", .{cpu_usage,cpu_temp});
    defer allocator.free(msg);
    // cmd = &[_][]const u8{ "notify-send", "Info", msg };
    cmd = &[_][]const u8{ "zenity", "--warning", msg };
    try notify.send(allocator, cmd);
    const status = try battery.get_status();
    switch (status) {
        .charging => std.debug.print("Plugged in, charging\n", .{}),
        .discharging => std.debug.print("On battery power\n", .{}),
        .full => std.debug.print("Fully charged\n", .{}),
        .unknown => std.debug.print("Can't determine status\n", .{}),
    }
}
