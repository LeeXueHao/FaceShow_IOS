//
//  ResourceDownloadMethodOneView.h
//  FaceShowApp
//
//  Created by SRT on 2018/9/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResourceDownloadMethodOneView : UIView

- (instancetype)initWithSourceUrl:(NSString *)sourceURL;
@property (nonatomic, copy) void(^copyBlock)(void);
@end

