//
//  HomeworkAttachmentView.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/8/28.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetHomeworkRequest.h"

@interface HomeworkAttachmentView : UIView
@property (nonatomic, strong) void(^deleteAction)(HomeworkAttachmentView *attachment);
@property (nonatomic, strong) void(^previewAction)(HomeworkAttachmentView *attachment);
@property (nonatomic, strong) GetHomeworkRequestItem_attachmentInfo *data;
@property (nonatomic, assign) BOOL canDelete;
@end
