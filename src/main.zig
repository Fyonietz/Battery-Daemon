const std = @import("std");
const cpu = @import("parts/cpu.zig");
const gpu = @import("parts/gpu.zig");
const battery = @import("parts/battery.zig");
const notify = @import("notify.zig");

pub const Warnings = struct{
    high_temp:bool = false,
    low_battery:bool = false,
};

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var Warning = Warnings{};
    var cpu_usage: f32 = undefined;
    var cpu_temp: f32 = undefined;
    var battery_percentage:i32 = undefined;
    var status:battery.BatteryStatus = undefined;
    var msg:[]u8 = undefined;
    var cmd: []const []const u8 = undefined;
    while (true) {
        cpu_usage = try cpu.get_usage();
        cpu_temp = try cpu.get_temp();
        battery_percentage = try battery.get_percentage();
        status = try battery.get_status();
        std.debug.print("CPU Usage : {d}\nCPU Temp : {d}\nBattery Level : {d}\n", .{cpu_usage,cpu_temp,battery_percentage});
        
        //Condition When Charging and Reach High Temp
        if(status == .charging and cpu_temp > 50.0 ){
            if(!Warning.high_temp){
            msg = try std.fmt.allocPrint(allocator,"--text=High Temperature\nDischarge Now!",.{});        
            defer allocator.free(msg);
            cmd = &[_][]const u8{ "zenity", "--warning", msg };
            try notify.send(allocator, cmd);
            Warning.high_temp = true;
            }
        }else{
            Warning.high_temp = false;
        }

        //Condition When Discharging Battery Goes to 20%
        if(status == .discharging and battery_percentage < 20){
            if(!Warning.low_battery){
            cmd = &[_][]const u8{ "notify-send", "Battery-Daemon", "Low Battery Please Charge!" };
            try notify.send(allocator, cmd);
            Warning.low_battery = true;   
            }
        }else{
            Warning.low_battery= false;
        }
        std.posix.nanosleep(1,0);
    }
}
