const std = @import("std");
const cpu = @import("parts/cpu.zig");
const gpu = @import("parts/gpu.zig");
const battery = @import("parts/battery.zig");
const notify = @import("notify.zig");
pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var cpu_usage: f32 = undefined;
    var cmd :[]const []const u8= undefined;
    while (true) {
        cpu_usage = try cpu.get_usage();

        std.debug.print("CPU Usage : {d}\n", .{cpu_usage});

        std.posix.nanosleep(1, 1000);
        break;
    }
    const msg = try std.fmt.allocPrint(allocator, "CPU Usage:{d:}%", .{cpu_usage});
    defer allocator.free(msg);
     cmd = &[_][]const u8{ "notify-send", "Info", msg };
    try notify.send(allocator, cmd);
}
