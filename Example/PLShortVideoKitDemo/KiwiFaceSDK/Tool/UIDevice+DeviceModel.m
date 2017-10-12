//
//  UIDevice+DeviceModel.m
//  Unity-iPhone
//
//  Created by jacoy on 16/9/30.
//
//

#import "UIDevice+DeviceModel.h"
#import <sys/utsname.h>

NSString *const Device_Simulator = @"Simulator";
NSString *const Device_iPod1 = @"iPod1";
NSString *const Device_iPod2 = @"iPod2";
NSString *const Device_iPod3 = @"iPod3";
NSString *const Device_iPod4 = @"iPod4";
NSString *const Device_iPod5 = @"iPod5";
NSString *const Device_iPad2 = @"iPad2";
NSString *const Device_iPad3 = @"iPad3";
NSString *const Device_iPad4 = @"iPad4";
NSString *const Device_iPhone4 = @"iPhone 4";
NSString *const Device_iPhone4S = @"iPhone 4S";
NSString *const Device_iPhone5 = @"iPhone 5";
NSString *const Device_iPhone5S = @"iPhone 5S";
NSString *const Device_iPhone5C = @"iPhone 5C";
NSString *const Device_iPadMini1 = @"iPad Mini 1";
NSString *const Device_iPadMini2 = @"iPad Mini 2";
NSString *const Device_iPadMini3 = @"iPad Mini 3";
NSString *const Device_iPadAir1 = @"iPad Air 1";
NSString *const Device_iPadAir2 = @"iPad Mini 3";
NSString *const Device_iPhone6 = @"iPhone 6";
NSString *const Device_iPhone6plus = @"iPhone 6 Plus";
NSString *const Device_iPhone6S = @"iPhone 6S";
NSString *const Device_iPhone6Splus = @"iPhone 6S Plus";
NSString *const Device_iPhone7 = @"iPhone 7";
NSString *const Device_iPhone7plus = @"iPhone 7 Plus";

NSString *const Device_Unrecognized = @"?unrecognized?";

@implementation UIDevice (DeviceModel)

- (NSString *)deviceModel {

    struct utsname systemInfo;

    uname(&systemInfo);

    NSString *code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];

    static NSDictionary *deviceNamesByCode = nil;

    if (!deviceNamesByCode) {

        deviceNamesByCode = @{
                @"i386": Device_Simulator,
                @"x86_64": Device_Simulator,
                @"iPod1,1": Device_iPod1,
                @"iPod2,1": Device_iPod2,
                @"iPod3,1": Device_iPod3,
                @"iPod4,1": Device_iPod4,
                @"iPod5,1": Device_iPod5,
                @"iPad2,1": Device_iPad2,
                @"iPad2,2": Device_iPad2,
                @"iPad2,3": Device_iPad2,
                @"iPad2,4": Device_iPad2,
                @"iPad2,5": Device_iPadMini1,
                @"iPad2,6": Device_iPadMini1,
                @"iPad2,7": Device_iPadMini1,
                @"iPhone3,1": Device_iPhone4,
                @"iPhone3,2": Device_iPhone4,
                @"iPhone3,3": Device_iPhone4,
                @"iPhone4,1": Device_iPhone4S,
                @"iPhone5,1": Device_iPhone5,
                @"iPhone5,2": Device_iPhone5,
                @"iPhone5,3": Device_iPhone5C,
                @"iPhone5,4": Device_iPhone5C,
                @"iPad3,1": Device_iPad3,
                @"iPad3,2": Device_iPad3,
                @"iPad3,3": Device_iPad3,
                @"iPad3,4": Device_iPad4,
                @"iPad3,5": Device_iPad4,
                @"iPad3,6": Device_iPad4,
                @"iPhone6,1": Device_iPhone5S,
                @"iPhone6,2": Device_iPhone5S,
                @"iPad4,1": Device_iPadAir1,
                @"iPad4,2": Device_iPadAir2,
                @"iPad4,4": Device_iPadMini2,
                @"iPad4,5": Device_iPadMini2,
                @"iPad4,6": Device_iPadMini2,
                @"iPad4,7": Device_iPadMini3,
                @"iPad4,8": Device_iPadMini3,
                @"iPad4,9": Device_iPadMini3,
                @"iPhone7,1": Device_iPhone6plus,
                @"iPhone7,2": Device_iPhone6,
                @"iPhone8,1": Device_iPhone6S,
                @"iPhone8,2": Device_iPhone6Splus,
                @"iPhone9,1": Device_iPhone7,
                @"iPhone9,2": Device_iPhone7plus
        };
    }

    NSString *deviceName = [deviceNamesByCode objectForKey:code];
    if (deviceName) {
        return deviceName;
    }

    return Device_Unrecognized;
}

@end
