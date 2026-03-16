const std = @import("std");

pub fn send(gpa:std.mem.Allocator,cmd:[]const []const u8)!void{
    var child = std.process.Child.init(cmd,gpa);

    try child.spawn();
}
