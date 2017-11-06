//
//  SPARPackage.m
//  EasyAR3D
//
//  Created by Qinsi on 9/21/16.
//
//

#import "SPARPackage.h"
#import "Downloader.h"
#import "Unpacker.h"
#import "SPARUtil.h"

@interface SPARPackage()

@property (nonatomic, strong) NSString *packageURL;

/**
 存放url和url对应的本地文件的全路径
 */
@property (nonatomic, strong) NSMutableDictionary *fileMap;
@end

@implementation SPARPackage

static NSString *kManifest = @"manifest.json";
static NSString *kPackage = @"package";
static NSString *kKeyURL = @"url";


/**
 静态方法：构造函数
 */
+ (SPARPackage *)SPARPackageFromDict:(NSDictionary *)dict {
    NSString *packageURL = dict[kKeyURL];
    SPARPackage *res = [[SPARPackage alloc] initWithURL:packageURL];
    return res;
}

/**
 返回字典，key是url，value是packageURL
 */
- (NSDictionary *)toDict {
    return @{
             kKeyURL: self.packageURL,
             };
}

/**
 构造函数
  */
- (instancetype)initWithURL:(NSString *)url {
    self = [super init];
    if (self) {
        self.packageURL = url;
        self.fileMap = [NSMutableDictionary new];
        [self createFilesMap];
    }
    return self;
}

/**
 返回 packageURL 属性值
 */
- (NSString *)getPackageURL {
    return self.packageURL;
}

/**
 返回Support目录下package/packageURL/zip的全路径
 */
- (NSString *)getDownloadPath {
    return [[self getUnpackPath] stringByAppendingPathExtension:@"zip"];
}

/**
 返回Support目录下package/packageURL的全路径
 */
- (NSString *)getUnpackPath {
    NSString *downloadPath = [Downloader getDownloadPath:[Downloader packagesPath]];
    NSString *localName = [Downloader getLocalNameForURL:self.packageURL];
    return [downloadPath stringByAppendingPathComponent:localName];
}


/**
 返回Support目录下package/packageURL/fileName的全路径

 @param fileName - 文件名
 @return 在Support/package/packageURL下某一个文件的路径
 */
- (NSString *)getFileLocalPath:(NSString *)fileName {
    return [[self getUnpackPath] stringByAppendingPathComponent:fileName];
}

/**
 返回Support目录下 package/packageURL/manifest.json 文件并遵守文件协议的全路径
 */
- (NSString *)getManifestURL {
    return [@"file://" stringByAppendingString:[self getFileLocalPath:kManifest]];
}


/**
 返回JOSN字典:先找到Support目录下 package/packageURL/manifest.json 文件，将json文件序列化成manifest字典
 */
- (NSDictionary *)getPackageManifest {
    NSString *manifestPath = [self getFileLocalPath:kManifest];
    NSData *data = [NSData dataWithContentsOfFile:manifestPath];
    if (!data) return nil;
    NSError *error;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
    }
    return res;
}


/**
 创建文件名和URL相对应的map；将manifest.json下package对应的字典以url为key，value为对应文件全路径，赋值给self.fileMap
 */
- (void)createFilesMap {
    NSDictionary *manifest = [self getPackageManifest];
    if (!manifest) return;
    NSDictionary *urlMap = [manifest objectForKey:kPackage];
    for (NSString *url in urlMap) {
        NSString *fileName = [urlMap objectForKey:url];
        NSString *localPath = [self getFileLocalPath:fileName];
        [self.fileMap setObject:localPath forKey:url];
    }
    NSString *manifestPath = [self getFileLocalPath:kManifest];
    [self.fileMap setObject:manifestPath forKey:[self getManifestURL]];
}



/**
 从fileMap取出URL相对应的文件路径
 
 @param url - url索引
 @return 文件路径：package/packageURL/下的文件路径
 */
- (NSString *)getLocalPathForURL:(NSString *)url {
    return [self.fileMap objectForKey:url];
}



/**
 将通过packageURL下载的文件，放到下载目录下的package/packageURL/zip的路径下

 @param force - 是否强制下载
 @param completeHandler - 下载出错或者在解压完成时调用，可以拿到出错信息，完成后可以进行loadManifest操作
 @param progressHandler - 可以拿到下载进度，设置UI的进度
 */
- (void)deploy:(bool) force completionHandler:(void (^)(NSError *error)) completeHandler
progressHandler:(void (^)(NSString * taskName, float progress)) progressHandler {
    Downloader *dl = [Downloader new];
    NSString *downloadPath = [self getDownloadPath];
    [dl download:self.packageURL to:downloadPath force:force completionHandler:^(NSError *err) {
        if (err) {
            completeHandler(err);
            return;
        }
        NSString *unpackPath = [self getUnpackPath];
        [Unpacker unpackPath:downloadPath to:unpackPath force:YES completionHandler:^(NSError *err) {
            if (!err) {
                [self createFilesMap];
            }
            completeHandler(err);
        } progressHandler:progressHandler];
    } progressHandler:progressHandler];
}


/**
 删除文件
 */
- (void)destroy {
    [SPARUtil deleteQuietly:[self getDownloadPath]];
    [SPARUtil deleteQuietly:[self getUnpackPath]];
}

@end
