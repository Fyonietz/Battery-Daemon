const std = @import("std");
const cpu = @import("parts/cpu.zig");
const gpu = @import("parts/gpu.zig");
const battery = @import("parts/battery.zig");
pub fn main() !void {
    const cpu_usage=  try cpu.get();

    std.debug.print("CPU Usage {d}\n", .{cpu_usage});
    battery.message();
    gpu.message();
    std.debug.print("Hello {s}!", .{"world"});
}
