const std = @import("std");
const linux = std.os.linux;
const posix = std.posix;
pub const cpu_fields = struct {
    user: u64,
    nice: u64,
    system: u64,
    idle: u64,
    iowait: u64,
    irq: u64,
    softirq: u64,
    steal: u64,
};
pub fn parse_u64(s: []const u8) u64 {
    return std.fmt.parseInt(u64, s, 10) catch 0;
}
pub fn get_usage() !f32 {
    const fd = try posix.open("/proc/stat", .{}, 0);
    defer posix.close(fd);

    var buffer: [4056]u8 = undefined;
    const n = try posix.read(fd, &buffer);
    if (n >= buffer.len) return error.BufferTooSmall;

    const line = buffer[0..n];
    if (!std.mem.startsWith(u8, line, "cpu")) return error.InvalidFormat;
    var pos: usize = 3;

    var fields: cpu_fields = undefined;
    inline for (std.meta.fields(cpu_fields)) |f| {
        // skip spaces
        while (pos < n and buffer[pos] == ' ') : (pos += 1) {}
        // find end of token
        const start = pos;
        while (pos < n and buffer[pos] != ' ' and buffer[pos] != '\n') : (pos += 1) {}
        @field(fields, f.name) = parse_u64(buffer[start..pos]);
        pos += 1; // skip the delimiter
    }

    const total: f32 = @floatFromInt(fields.user + fields.nice + fields.system + fields.idle +
        fields.iowait + fields.irq + fields.softirq + fields.steal);
    const idle: f32 = @floatFromInt(fields.idle + fields.iowait);

    if (total == 0.0) return 0.0;
    const raw = ((total-idle) / total) * 100.0;

    const rounded =@round(raw*100.0) / 100.0;
    return rounded;
}



pub fn get_temp() !f32 {
    const fd = try posix.open("/sys/class/hwmon/hwmon4/temp1_input", .{}, 0);
    defer posix.close(fd);

    var buffer: [512]u8 = undefined;
    const n = try posix.read(fd, &buffer);
    if (n >= buffer.len) return error.BufferTooSmall;
    const slice = std.mem.trim(u8,buffer[0..n],&std.ascii.whitespace);

    const milidegrees = try std.fmt.parseInt(i32,slice,10);

    const degrees = @as(f32,@floatFromInt(milidegrees)) / 1000.0;
    const rounded = @round(degrees*100.0) / 100.0;
    return rounded;
}
















