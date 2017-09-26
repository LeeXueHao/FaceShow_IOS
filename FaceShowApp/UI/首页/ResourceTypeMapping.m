//
//  ResourceTypeMapping.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ResourceTypeMapping.h"

@implementation ResourceTypeMapping
+ (NSString *)resourceTypeWithString:(NSString *)typeString {
    NSDictionary *mappingDic = @{
                                 @"word":@"word",
                                 @"doc":@"word",
                                 @"docx":@"word",
                                 
                                 @"xls":@"excel",
                                 @"xlsx":@"excel",
                                 @"excel":@"excel",
                                 
                                 @"ppt":@"ppt",
                                 @"pptx":@"ppt",

                                 @"pdf":@"pdf",
                                 
                                 @"text":@"txt",
                                 @"txt":@"txt",
                                 
                                 @"video":@"video",
                                 @"mp4":@"video",
                                 @"m3u8":@"video",
                                 
                                 @"audio":@"audio",
                                 @"mp3":@"audio",
                                 
                                 @"image":@"image",
                                 @"jpg":@"image",
                                 @"jpeg":@"image",
                                 @"gif":@"image",
                                 @"png":@"image",
                                 };
    NSString *type = [mappingDic valueForKey:typeString];
    if (type) {
        return type;
    }
    return @"unknown";
}
@end
