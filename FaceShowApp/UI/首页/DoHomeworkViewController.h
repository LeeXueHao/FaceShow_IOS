//
//  DoHomeworkViewController.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "ClassMomentPublishRequest.h"

@interface DoHomeworkViewController : BaseViewController
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, copy) void(^submitHomeworkBlock)(ClassMomentListRequestItem_Data_Moment *moment);
@end
