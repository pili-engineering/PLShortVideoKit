//
//  UIDevice+DeviceModel.h
//  Unity-iPhone
//
//  Created by jacoy on 16/9/30.
//
//

#import <UIKit/UIKit.h>


extern NSString *const Device_Simulator;
extern NSString *const Device_iPod1;
extern NSString *const Device_iPod2;
extern NSString *const Device_iPod3;
extern NSString *const Device_iPod4;
extern NSString *const Device_iPod5;
extern NSString *const Device_iPad2;
extern NSString *const Device_iPad3;
extern NSString *const Device_iPad4;
extern NSString *const Device_iPhone4;
extern NSString *const Device_iPhone4S;
extern NSString *const Device_iPhone5;
extern NSString *const Device_iPhone5S;
extern NSString *const Device_iPhone5C;
extern NSString *const Device_iPadMini1;
extern NSString *const Device_iPadMini2;
extern NSString *const Device_iPadMini3;
extern NSString *const Device_iPadAir1;
extern NSString *const Device_iPadAir2;
extern NSString *const Device_iPhone6;
extern NSString *const Device_iPhone6plus;
extern NSString *const Device_iPhone6S;
extern NSString *const Device_iPhone6Splus;
extern NSString *const Device_iPhone7;
extern NSString *const Device_iPhone7plus;
extern NSString *const Device_Unrecognized;

@interface UIDevice (DeviceModel)

- (NSString *)deviceModel;

@end
