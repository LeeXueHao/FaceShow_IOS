//
//  DoHomeworkViewController.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
@class GetHomeworkRequestItem_homework;
@class GetHomeworkRequestItem_userHomework;
@class ImageAttachment;
extern NSString *kHomeworkFinishedNotification;

@interface DoHomeworkViewController : BaseViewController
@property (nonatomic, strong) NSMutableArray<ImageAttachment *> *imageArray;
@property(nonatomic, strong) GetHomeworkRequestItem_homework *homework;
@property(nonatomic, strong) GetHomeworkRequestItem_userHomework *userHomework;
@end
