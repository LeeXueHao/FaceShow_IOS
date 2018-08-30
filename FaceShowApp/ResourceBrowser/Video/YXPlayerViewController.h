//
//  YXPlayerViewController.h
//  YanXiuApp
//
//  Created by Lei Cai on 5/26/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"
#import "YXPlayProgressDelegate.h"
#import "YXBrowserExitDelegate.h"

@interface YXPlayerDefinition : NSObject
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *url;
@end


@interface YXPlayerViewController : BaseViewController
@property (nonatomic, assign) CGFloat preProgress;
//@property (nonatomic, strong) NSString *timeWatched; // 已播放时长，用于视频

@property (nonatomic, assign) BOOL bIsLocalFile;
@property (nonatomic, strong) NSString *videoUrl;

@property (nonatomic, weak) id<YXPlayProgressDelegate> delegate;

@property (nonatomic, strong) NSArray *definitionArray;
@property (nonatomic, strong) YXPlayerDefinition *defaultDefinition;// 不需要再设置，播放器内部会记录

@property (nonatomic, assign) BOOL isPreRecord;
@property (nonatomic, copy) void(^deleteHandle)(UIButton *item);

@property (nonatomic, weak) id<YXBrowserExitDelegate> exitDelegate;

@end
