//
//  ResourceDisplayViewController.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"

@interface ResourceDisplayViewController : BaseViewController
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL needDownload;
@property (nonatomic, assign) BOOL naviBarHidden;

@property (nonatomic, strong) UIImage *backNormalImage;
@property (nonatomic, strong) UIImage *backHighlightImage;

@property (nonatomic, strong) NSString *downloadUrl;
@property (nonatomic, strong) NSString *resourceId;
- (void)reloadWebview;
@end
