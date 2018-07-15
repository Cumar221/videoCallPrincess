//
//  AVAssetExportSession+OverlapVideos.h
//  videoCallPrincess
//
//  Created by Colter Conway on 2/16/18.
//  Copyright © 2018 Colter Conway. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAssetExportSession (Exporter)
+ (AVAssetExportSession *) overlapVideos:(NSURL *)firstUrl
                               secondUrl:(NSURL *)secondUrl
                          isPortraitMode:(BOOL) isPortraitMode
                        exportedFilename:(NSString *)filename;
@end
