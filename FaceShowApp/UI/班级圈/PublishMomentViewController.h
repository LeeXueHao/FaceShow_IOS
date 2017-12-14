//
//  PostMomentViewController.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "ClassMomentPublishRequest.h"
@interface PublishMomentViewController : BaseViewController
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, copy) void(^publishMomentDataBlock)(ClassMomentListRequestItem_Data_Moment *moment);
@end
