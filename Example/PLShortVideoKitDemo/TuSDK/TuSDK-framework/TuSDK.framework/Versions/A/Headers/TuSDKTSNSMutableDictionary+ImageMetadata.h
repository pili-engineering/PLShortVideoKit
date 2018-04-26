//
//  TuSDKTSNSMutableDictionary+ImageMetadata.h
//  TuSDK
//
//  Created by Gustavo Ambrozio on 28/2/11.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

/**
 *  图片meta信息帮助类
 */
@interface NSMutableDictionary (TuSDKTSImageMetadataCategory)

- (id)initWithImageSampleBuffer:(CMSampleBufferRef) imageDataSampleBuffer;

/*
 Be careful with this method: because it uses blocks, there's no guarantee that your
 imageMetadata dictionary will be populated when this code runs. In some testing I've
 done it sometimes runs the code inside the block even before the [library autorelease]
 is executed. But the first time you run this, the code inside the block will only run
 on another cycle of the apps main loop. So, if you need to use this info right away,
 it's better to schedule a method on the run queue for later with:

 [self performSelectorOnMainThread: withObject: waitUntilDone:NO];
 */
- (id)initWithInfoFromImagePicker:(NSDictionary *)info;

/*
 Be careful with this method: because it uses blocks, there's no guarantee that your
 imageMetadata dictionary will be populated when this code runs. In some testing I've
 done it sometimes runs the code inside the block even before the [library autorelease]
 is executed. But the first time you run this, the code inside the block will only run
 on another cycle of the apps main loop. So, if you need to use this info right away,
 it's better to schedule a method on the run queue for later with:

 [self performSelectorOnMainThread: withObject: waitUntilDone:NO];
 */
- (id)initFromAssetURL:(NSURL*)assetURL;

- (void)lsqSetUserComment:(NSString*)comment;
- (void)lsqSetDateOriginal:(NSDate *)date;
- (void)lsqSetDateDigitized:(NSDate *)date;
- (void)lsqSetMake:(NSString*)make model:(NSString*)model software:(NSString*)software;
- (void)lsqSetDescription:(NSString*)description;
- (void)lsqSetKeywords:(NSString*)keywords;
- (void)lsqSetImageOrientation:(UIImageOrientation)orientation;
- (void)lsqSetDigitalZoom:(CGFloat)zoom;
- (void)lsqSetHeading:(CLHeading*)heading;

@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, assign) CLLocationDirection trueHeading;

@end
