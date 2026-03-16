const std = @import("std");
const cpu = @import("parts/cpu.zig");
const gpu = @import("parts/gpu.zig");
const battery = @import("parts/battery.zig");
pub fn main() void {
    cpu.message();
    battery.message();
    gpu.message();
    std.debug.print("Hello {s}!", .{"world"});
}
