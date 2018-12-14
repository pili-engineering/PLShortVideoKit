//
//  Unpacker.h
//  EasyAR3D
//
//  Created by Qinsi on 9/21/16.
//
//

#import <Foundation/Foundation.h>

@interface Unpacker : NSObject

+ (void)unpackPath:(NSString *) src to:(NSString *) dst force:(bool) force
completionHandler:(void (^)(NSError *err)) completionHandler
   progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler;

@end
